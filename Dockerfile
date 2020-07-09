FROM bioconductor/bioconductor_docker:latest

MAINTAINER "Tiago Chedraoui Silva" tiagochst@usp.br

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
        curl \
        libxml2-dev \
        libssl-dev \
        libcurl4-openssl-dev \
        libssh2-1-dev \
        zlib1g-dev \
        openssl \
        gdebi-core \
        libgsl* \
        libudunits2-dev \
        libgs-dev \
        imagemagick \
        ghostscript \
        qpdf
        
run R -e "install.packages(c('devtools', 'testthat', 'roxygen2','remotes'))"
run R -e "BiocManager::install(c('zwdzwd/sesameData', 'zwdzwd/sesame', 'BioinformaticsFMRP/TCGAbiolinks'))"
run R -e "BiocManager::install(c('tiagochst/ELMER.data', 'tiagochst/ELMER'))"
run R -e "BiocManager::install(c('BioinformaticsFMRP/TCGAbiolinksGUI.data', 'BioinformaticsFMRP/TCGAbiolinksGUI'))"
 
RUN wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.14.948-amd64.deb
RUN gdebi -n shiny-server-1.5.14.948-amd64.deb
ADD shiny-server /etc/services.d/shiny-server
ADD shiny-server.conf /etc/shiny-server/shiny-server.conf
RUN rm -rf /srv/shiny-server/*
RUN cp -R /usr/local/lib/R/site-library/TCGAbiolinksGUI/app/* /srv/shiny-server/
VOLUME /home/rstudio
EXPOSE 3838
ENV DISABLE_AUTH=true
