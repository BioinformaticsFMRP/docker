FROM bioconductor/release_core2

MAINTAINER "Tiago Chedraoui Silva" tiagochst@usp.br

RUN echo "R_MAX_NUM_DLLS=150" >> /usr/local/lib/R/etc/Renviron

RUN apt-get update -qq && apt-get -y --no-install-recommends install \
        curl \
        libxml2-dev \
        libssl-dev \
        openssl \
        libmariadb-client-lgpl-dev \
        gdebi-core \
        libgsl* \
        libudunits2-dev \
        libgs-dev \
        imagemagick \
        ghostscript
RUN R -e "install.packages('remotes')" \
    &&  installGithub.r zwdzwd/sesameData \
                        zwdzwd/sesame
RUN installGithub.r BioinformaticsFMRP/TCGAbiolinks
RUN installGithub.r tiagochst/ELMER.data \
                          tiagochst/ELMER
RUN installGithub.r  BioinformaticsFMRP/TCGAbiolinksGUI.data \
                           BioinformaticsFMRP/TCGAbiolinksGUI
RUN wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.9.923-amd64.deb
RUN gdebi -n shiny-server-1.5.9.923-amd64.deb
ADD shiny-server /etc/services.d/shiny-server
ADD shiny-server.conf /etc/shiny-server/shiny-server.conf
RUN rm -rf /srv/shiny-server/*
RUN cp -R /usr/local/lib/R/site-library/TCGAbiolinksGUI/app/* /srv/shiny-server/
VOLUME /home/rstudio
EXPOSE 3838
ENV DISABLE_AUTH=true
