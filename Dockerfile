FROM tensorflow/tensorflow:latest-gpu-py3

ENV DEBIAN_FRONTEND=noninteractive

RUN set -x && \
	apt update && \
	apt install -y tzdata python3-pip && \
	pip3 --no-cache-dir install keras seaborn jupyter jupyterlab scikit-learn imblearn && \
	jupyter notebook --generate-config --allow-root && \
	ipython3 profile create

ENV JUPYTER_CONFIG=/root/.jupyter/jupyter_notebook_config.py \
    IPYTHON_CONFIG=/root/.ipython/profile_default/ipython_config.py
RUN : "generate jupyter config file" && { \
	echo "c.NotebookApp.ip = '0.0.0.0'"; \
	echo "c.NotebookApp.open_browser = False"; \
	} | tee ${JUPYTER_CONFIG}
RUN : "generate ipython config file" && { \
	echo "c.InteractiveShellApp.exec_lines = ["; \
	echo "	'%autoreload 2',"; \
	echo "	'import numpy as np',"; \
	echo "	'import matplotlib.pyplot as plt',"; \
	echo "]"; \
	echo "c.InteractiveShellApp.extensions = ["; \
	echo "	'autoreload',"; \
	echo "]"; \
	} | tee -a ${IPYTHON_CONFIG}

VOLUME /root
WORKDIR /root

CMD ["jupyter", "lab", "--allow-root"]
