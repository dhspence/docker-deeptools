FROM ubuntu:xenial
MAINTAINER David Spencer <dspencer@wustl.edu>

LABEL Basic image with conda and deeptools

ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH

RUN cd /tmp && \
    mkdir -p $CONDA_DIR && \
    curl -s https://repo.continuum.io/miniconda/Miniconda3-4.3.21-Linux-x86_64.sh -o miniconda.sh && \
    /bin/bash miniconda.sh -f -b -p $CONDA_DIR && \
    rm miniconda.sh && \
    $CONDA_DIR/bin/conda config --system --add channels conda-forge && \
    $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
    conda clean -tipsy

# Install Python 3 packages available through pip 
RUN conda install --yes 'pip' && \
    conda clean -tipsy && \
    #dependencies sometimes get weird - installing each on it's own line seems to help
    pip install numpy==1.13.0 && \ 
    pip install scipy==0.19.0 && \
    pip install cruzdb==0.5.6 && \
    pip install cython==0.25.2 && \
    pip install pyensembl==1.1.0 && \
    pip install pyfaidx==0.4.9.2 && \
    pip install pybedtools==0.7.10 && \
    pip install cyvcf2==0.7.4 && \
    pip install intervaltree_bio==1.0.1 && \
    pip install pandas==0.20.2 && \
    pip install scipy==0.19.0 && \
    pip install pysam==0.11.2.2 && \
    pip install seaborn==0.7.1 && \
    pip install scikit-learn==0.18.2

# Install Python 2 
RUN conda create --quiet --yes -p $CONDA_DIR/envs/python2 python=2.7 'pip' && \
    conda clean -tipsy && \
    /bin/bash -c "source activate python2 && \
    #dependencies sometimes get weird - installing each on it's own line seems to help
    pip install numpy==1.13.0 && \ 
    pip install scipy==0.19.0 && \
    pip install cruzdb==0.5.6 && \
    pip install cython==0.25.2 && \
    pip install pyensembl==1.1.0 && \
    pip install pyfaidx==0.4.9.2 && \
    pip install pybedtools==0.7.10 && \
    pip install cyvcf2==0.7.4 && \
    pip install intervaltree_bio==1.0.1 && \
    pip install pandas==0.20.2 && \
    pip install scipy==0.19.0 && \
    pip install pysam==0.11.2.2 && \
    pip install seaborn==0.7.1 && \
    pip install scikit-learn==0.18.2 && \
    source deactivate"

# needed for MGI data mounts
RUN apt-get update && apt-get install -y libnss-sss && apt-get clean all

#set timezone to CDT
RUN ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime
#LSF: Java bug that need to change the /etc/timezone.
#     The above /etc/localtime is not enough.
RUN echo "America/Chicago" > /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

# some other utils
RUN apt-get update && apt-get install -y --no-install-recommends gawk openssh-client grep evince && apt-get clean all

RUN conda install -c bioconda deeptools
