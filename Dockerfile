FROM nfcore/base:1.12.1
LABEL authors="Dai Cheng Xin, Yasset Perez-Riverol, Julianus Pfeuffer" \
      description="Docker image containing all software requirements for the nf-core/proteomicstmt pipeline"

# Install the conda environment
COPY environment.yml /
RUN conda install mamba -c conda-forge
RUN mamba env create --quiet -f /environment.yml && mamba clean -a

# Add conda installation dir to PATH (instead of doing 'conda activate')
ENV PATH /opt/conda/envs/nf-core-proteomicstmt-1.0dev/bin:$PATH

# OpenMS Adapters need the raw jars of Java-based bioconda tools in the PATH. Not the wrappers that conda creates.
RUN cp $(find /opt/conda/envs/nf-core-proteomicstmt-*/share/msgf_plus-*/MSGFPlus.jar -maxdepth 0) $(find /opt/conda/envs/nf-core-proteomicstmt-*/bin/ -maxdepth 0)
RUN cp $(find /opt/conda/envs/nf-core-proteomicstmt-*/share/luciphor2-*/luciphor2.jar -maxdepth 0) $(find /opt/conda/envs/nf-core-proteomicstmt-*/bin/ -maxdepth 0)

# Dump the details of the installed packages to a file for posterity
RUN conda env export --name nf-core-proteomicstmt-1.0dev > nf-core-proteomicstmt-1.0dev.yml

# Instruct R processes to use these empty files instead of clashing with a local version
RUN touch .Rprofile
RUN touch .Renviron
