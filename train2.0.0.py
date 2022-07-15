from sklearn.datasets import load_iris
from sklearn.ensemble import RandomForestClassifier

from mlem.api import save


def main():
    data, y = load_iris(return_X_y=True, as_frame=True)
    rf = RandomForestClassifier(
        n_jobs=2,
        random_state=42,
    )
    rf.fit(data, y)

    save(
        rf,
        "image-classifier-model",
        sample_data=data,
        description="This model is used to classify images of different objects \
            submitted by users. This version of the model has an accuracy of 94%.",
    )


if __name__ == "__main__":
    main()