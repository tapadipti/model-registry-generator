#!/bin/bash

set -eu

if [ "$#" -ne 4 ]; then
    echo "\n\nERROR: 
    You must provide the following arguments:
    1. Git account or org name (eg, tapadipti)
    2. Repo name (eg, fashion_mnist)
    3. Git author name (eg, tapadipti)
    4. Git author email (eg, tapadipti@gmail.com)
    Eg, sh gen.sh tapadipti image_models tapadipti tapadipti@gmail.com 
    The repo will be created at https://github.com/GIT_ACC_OR_ORG/REPO_NAME (eg, https://github.com/tapadipti/image_models).
    If this repo already exists, it will be replaced by the new one - so make sure that you don't need the existing one.
    Make sure you have the required access to the Git account.\n\n"
    exit
fi

GIT_ORG=$1
REPO_NAME=$2
GIT_AUTHOR_NAME=$3
GIT_AUTHOR_EMAIL=$4


HERE="$( cd "$(dirname "$0")" ; pwd -P )"
REPO_PATH="$HERE/build/$REPO_NAME"

if [ -d "$REPO_PATH" ]; then
  echo "Repo $REPO_PATH already exists, please remove it first."
  exit 1
fi

TOTAL_TAGS=15
STEP_TIME=100000
BEGIN_TIME=$(( $(date +%s) - ( ${TOTAL_TAGS} * ${STEP_TIME}) ))
export TAG_TIME=${BEGIN_TIME}
export GIT_AUTHOR_DATE=${TAG_TIME}
export GIT_COMMITTER_DATE=${TAG_TIME}
tick(){
  export TAG_TIME=$(( ${TAG_TIME} + ${STEP_TIME} ))
  export GIT_AUTHOR_DATE=${TAG_TIME}
  export GIT_COMMITTER_DATE=${TAG_TIME}
}

export GIT_AUTHOR_NAME="$GIT_AUTHOR_NAME"
export GIT_AUTHOR_EMAIL="$GIT_AUTHOR_EMAIL"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"

mkdir -p $REPO_PATH
pushd $REPO_PATH

# pip install gitpython

git init
cp $HERE/README.md .
git add .
tick
git commit -m "Initialize Git repository"

# git clone https://github.com/tapadipti/image-models.git
# cd image-models
# git pull

mlem init
git add .
tick
git commit -m "MLEM init"


# v1.0.0
cp $HERE/train1.0.0.py train.py
python train.py

gto annotate image-classifier-model --type model --path .mlem/model/image-classifier-model --description 'This model is used to classify images of different objects submitted by users. This version of the model has an accuracy of 92%.' --label 'image classification' --label 'Random Forest' --label sklearn
git add .
tick
git commit -m 'Created first version of image-classifier-model'

git tag -a "image-classifier-model@v1.0.0" -m "Register version v1.0.0"
git tag -a "image-classifier-model#development#1" -m "Promote version v1.0.0 to the development stage"
tick
git tag -a "image-classifier-model#staging#1" -m "Promote version v1.0.0 to the staging stage"
tick
git tag -a "image-classifier-model#production#1" -m "Promote version v1.0.0 to the production stage"
tick

# v1.0.1
cp $HERE/train1.0.1.py train.py
python train.py

gto annotate image-classifier-model --type model --path .mlem/model/image-classifier-model --description 'This model is used to classify images of different objects submitted by users. This version of the model has an accuracy of 92.5%.' --label 'image classification' --label 'Random Forest' --label sklearn
git add .
tick
git commit -m 'Created patch version 1.0.1 of image-classifier-model'

git tag -a "image-classifier-model@v1.0.1" -m "Register version v1.0.1"
git tag -a "image-classifier-model#development#2" -m "Promote version v1.0.1 to the development stage"
tick
git tag -a "image-classifier-model#staging#2" -m "Promote version v1.0.1 to the staging stage"


# v2.0.0
cp $HERE/train2.0.0.py train.py
python train.py

gto annotate image-classifier-model --type model --path .mlem/model/image-classifier-model --description 'This model is used to classify images of different objects submitted by users. This version of the model has an accuracy of 95%.' --label 'image classification' --label 'Random Forest' --label sklearn
git add .
tick
git commit -m 'Created patch version 2.0.0 of image-classifier-model'
tick


# Other models
mkdir models

echo "This is face-detection-yolov5" > models/face-detection-yolov5.h5
gto annotate face-detection-yolov5 --type model --path models/face-detection-yolov5.h5 --description 'This model is used to detect faces in pictures. This version of the model has an accuracy of 91%.' --label images --label 'face detection' --label yolov5
git add .
git commit -m 'Created face detection yolov5 model'
tick

git tag -a "face-detection-yolov5@v3.1.5" -m "Register version v3.1.5"
git tag -a "face-detection-yolov5#staging#1" -m "Promote version v3.1.5 to the staging stage"
git tag -a "face-detection-yolov5#production#1" -m "Promote version v3.1.5 to the production stage"
tick

echo "This is face-detection-rcnn" > models/face-detection-rcnn.h5
gto annotate face-detection-rcnn --type model --path models/face-detection-rcnn.h5 --description 'This model is used to detect faces in pictures. This version of the model has an accuracy of 91%.' --label images --label 'face detection' --label rcnn
git add .
git commit -m 'Created face detection rcnn model'
tick

git tag -a "face-detection-rcnn@v2.3.0" -m "Register version v2.3.0"
git tag -a "face-detection-rcnn#development#1" -m "Promote version v2.3.0 to the development stage"

popd

unset TAG_TIME
unset GIT_AUTHOR_DATE
unset GIT_COMMITTER_DATE
unset GIT_AUTHOR_NAME
unset GIT_AUTHOR_EMAIL
unset GIT_COMMITTER_NAME
unset GIT_COMMITTER_EMAIL

hub delete -y $GIT_ORG/$REPO_NAME || true
cd build/$REPO_NAME
hub create $GIT_ORG/$REPO_NAME -d "Image models" || true
ORIGIN_URL=https://github.com/$GIT_ORG/$REPO_NAME.git
git remote set-url origin $ORIGIN_URL
git branch -M main
git push -u origin main
git push --force origin --tags

cd ../..
rm -fR build





# Other repository
GIT_ORG=$1
REPO_NAME=review-sentiment-analysis
GIT_AUTHOR_NAME=$3
GIT_AUTHOR_EMAIL=$4


HERE="$( cd "$(dirname "$0")" ; pwd -P )"
REPO_PATH="$HERE/build/$REPO_NAME"

if [ -d "$REPO_PATH" ]; then
  echo "Repo $REPO_PATH already exists, please remove it first."
  exit 1
fi

TOTAL_TAGS=15
STEP_TIME=100000
BEGIN_TIME=$(( $(date +%s) - ( ${TOTAL_TAGS} * ${STEP_TIME}) ))
export TAG_TIME=${BEGIN_TIME}
export GIT_AUTHOR_DATE=${TAG_TIME}
export GIT_COMMITTER_DATE=${TAG_TIME}
tick(){
  export TAG_TIME=$(( ${TAG_TIME} + ${STEP_TIME} ))
  export GIT_AUTHOR_DATE=${TAG_TIME}
  export GIT_COMMITTER_DATE=${TAG_TIME}
}

export GIT_AUTHOR_NAME="$GIT_AUTHOR_NAME"
export GIT_AUTHOR_EMAIL="$GIT_AUTHOR_EMAIL"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"

mkdir -p $REPO_PATH
pushd $REPO_PATH

git init
cp $HERE/README.md .
git add .
tick
git commit -m "Initialize Git repository"

mkdir models

echo "This is review-sentiment-analysis" > models/review-sentiment-analysis.h5
gto annotate review-sentiment-analysis --type model --path models/review-sentiment-analysis.h5 --description 'review-sentiment-analysis' --label nlp
git add .
git commit -m 'Created review-sentiment-analysis model'
tick

git tag -a "review-sentiment-analysis@v3.1.5" -m "Register version v3.1.5"
git tag -a "review-sentiment-analysis#staging#1" -m "Promote version v3.1.5 to the staging stage"
git tag -a "review-sentiment-analysis#production#1" -m "Promote version v3.1.5 to the production stage"
tick

popd

unset TAG_TIME
unset GIT_AUTHOR_DATE
unset GIT_COMMITTER_DATE
unset GIT_AUTHOR_NAME
unset GIT_AUTHOR_EMAIL
unset GIT_COMMITTER_NAME
unset GIT_COMMITTER_EMAIL

hub delete -y $GIT_ORG/$REPO_NAME || true
cd build/$REPO_NAME
hub create $GIT_ORG/$REPO_NAME -d "Image models" || true
ORIGIN_URL=https://github.com/$GIT_ORG/$REPO_NAME.git
git remote set-url origin $ORIGIN_URL
git branch -M main
git push -u origin main
git push --force origin --tags

cd ../..
rm -fR build





# Other repository 2
GIT_ORG=$1
REPO_NAME=product-recommendation
GIT_AUTHOR_NAME=$3
GIT_AUTHOR_EMAIL=$4


HERE="$( cd "$(dirname "$0")" ; pwd -P )"
REPO_PATH="$HERE/build/$REPO_NAME"

if [ -d "$REPO_PATH" ]; then
  echo "Repo $REPO_PATH already exists, please remove it first."
  exit 1
fi

TOTAL_TAGS=15
STEP_TIME=100000
BEGIN_TIME=$(( $(date +%s) - ( ${TOTAL_TAGS} * ${STEP_TIME}) ))
export TAG_TIME=${BEGIN_TIME}
export GIT_AUTHOR_DATE=${TAG_TIME}
export GIT_COMMITTER_DATE=${TAG_TIME}
tick(){
  export TAG_TIME=$(( ${TAG_TIME} + ${STEP_TIME} ))
  export GIT_AUTHOR_DATE=${TAG_TIME}
  export GIT_COMMITTER_DATE=${TAG_TIME}
}

export GIT_AUTHOR_NAME="$GIT_AUTHOR_NAME"
export GIT_AUTHOR_EMAIL="$GIT_AUTHOR_EMAIL"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"

mkdir -p $REPO_PATH
pushd $REPO_PATH

git init
cp $HERE/README.md .
git add .
tick
git commit -m "Initialize Git repository"

mkdir models

echo "This is product-recommendation" > models/product-recommendation.h5
gto annotate product-recommendation --type model --path models/product-recommendation.h5 --description 'product-recommendation' --label nlp
git add .
git commit -m 'Created product-recommendation model'
tick

git tag -a "product-recommendation@v6.0.0" -m "Register version v6.0.0"
git tag -a "product-recommendation#staging#1" -m "Promote version v6.0.0 to the staging stage"
git tag -a "product-recommendation#production#1" -m "Promote version v6.0.0 to the production stage"
tick

popd

unset TAG_TIME
unset GIT_AUTHOR_DATE
unset GIT_COMMITTER_DATE
unset GIT_AUTHOR_NAME
unset GIT_AUTHOR_EMAIL
unset GIT_COMMITTER_NAME
unset GIT_COMMITTER_EMAIL

hub delete -y $GIT_ORG/$REPO_NAME || true
cd build/$REPO_NAME
hub create $GIT_ORG/$REPO_NAME -d "Image models" || true
ORIGIN_URL=https://github.com/$GIT_ORG/$REPO_NAME.git
git remote set-url origin $ORIGIN_URL
git branch -M main
git push -u origin main
git push --force origin --tags

cd ../..
rm -fR build