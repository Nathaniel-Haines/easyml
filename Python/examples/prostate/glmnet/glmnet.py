import matplotlib as mpl; mpl.use('TkAgg')
import matplotlib.pyplot as plt
import os
import pandas as pd

from easyml.glmnet import easy_glmnet


# Set matplotlib settings
plt.style.use('ggplot')
os.chdir('./Python/examples/prostate/glmnet')


if __name__ == "__main__":
    # Load data
    prostate = pd.read_table('./prostate.txt')

    # Analyze data
    output = easy_glmnet(prostate, 'lpsa',
                         random_state=1, progress_bar=True, n_core=1,
                         n_samples=100, n_divisions=10, n_iterations=5,
                         alpha=1, n_lambda=200, standardize=False, cut_point=0, max_iter=1e6)

    # Analyze data
    output = easy_glmnet(prostate, 'lpsa',
                         random_state=1, progress_bar=True, n_core=os.cpu_count(),
                         n_samples=100, n_divisions=10, n_iterations=5,
                         alpha=1, n_lambda=200, standardize=False, cut_point=0, max_iter=1e6)
