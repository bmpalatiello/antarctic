# Set the base image to Ubuntu, use a public image
FROM continuumio/miniconda3 as builder

# File Author / Maintainer
MAINTAINER Thomas Schmelzer "thomas.schmelzer@gmail.com"

COPY . /tmp/antarctic

RUN conda install -y -c conda-forge pandas=0.25.1 requests=2.22.0 && \
    conda clean -y --all && \
    pip install --no-cache-dir -r /tmp/antarctic/requirements.txt && \
    pip install --no-cache-dir /tmp/antarctic && \
    rm -r /tmp/antarctic

#COPY ./antarctic /antarctic/antarctic

#### Here the test-configuration
FROM builder as test

# We install flask here to test some
RUN pip install --no-cache-dir httpretty pytest==4.3.1 pytest-cov pytest-html sphinx

WORKDIR /antarctic

CMD py.test --cov=antarctic  --cov-report html:artifacts/html-coverage --cov-report term --html=artifacts/html-report/report.html test