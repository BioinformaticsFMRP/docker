FROM rocker/tidyverse

MAINTAINER "Tiago Chedraoui Silva" tiagochst@usp.br

ADD install.R /tmp/
ADD install_dep.R /tmp/
RUN echo "R_MAX_NUM_DLLS=150" >> /usr/local/lib/R/etc/Renviron


RUN apt-get update -qq && apt-get -y --no-install-recommends install \
        curl \
        libxml2-dev \
        libssl-dev \
        openssl \
        libmariadb-client-lgpl-dev \
        gdebi-core \
        libgsl* \
        libgs-dev \
        imagemagick \
        ghostscript 
RUN wget https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.5.5.872-amd64.deb 
RUN gdebi -n shiny-server-1.5.5.872-amd64.deb
ADD shiny-server /etc/services.d/shiny-server
ADD shiny-server.conf /etc/shiny-server/shiny-server.conf
RUN rm -rf /srv/shiny-server/*
RUN R -f /tmp/install_dep.R
RUN R -f /tmp/install.R
RUN cp -R /usr/local/lib/R/site-library/TCGAbiolinksGUI/app /srv/shiny-server/
VOLUME /home/rstudio
EXPOSE 3838
