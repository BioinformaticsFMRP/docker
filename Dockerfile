        libssl-dev \
        openssl \
        libmariadb-client-lgpl-dev \
        gdebi-core \
        libgsl* \
        libgs-dev \
        imagemagick \
        ghostscript
RUN R -e "install.packages('remotes')" \
    &&  installGithub.r zwdzwd/sesameData \
                        zwdzwd/sesame
RUN R -e "install.packages('BiocManager')" \
    &&  installGithub.r  tiagochst/ELMER.data \
                         tiagochst/ELMER \
                         BioinformaticsFMRP/TCGAbiolinksGUI.data \
                         BioinformaticsFMRP/TCGAbiolinksGUI
RUN wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.9.923-amd64.deb
RUN gdebi -n shiny-server-1.5.9.923-amd64.deb
ADD shiny-server /etc/services.d/shiny-server
ADD shiny-server.conf /etc/shiny-server/shiny-server.conf
RUN rm -rf /srv/shiny-server/*
RUN cp -R /usr/local/lib/R/site-library/TCGAbiolinksGUI/app/* /srv/shiny-server/
VOLUME /home/rstudio
EXPOSE 3838
