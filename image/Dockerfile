FROM docker.io/asciidoctor/docker-asciidoctor:latest

# set timezone of the image
ENV TZ="Europe/Paris"
RUN ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime
RUN echo "$TZ" > /etc/timezone

# extention used to create the list of tables and list of figures
RUN gem install asciidoctor-lists

# extention used to optimize the PDF
RUN apk add --no-cache ghostscript \
    && gem install rghost

# copy the fonts and the theme into /usr/share
ADD resources/fonts/Noto /usr/share/fonts/noto
ADD resources/themes /usr/share/asciidoc-theme

COPY resources/entrypoint.sh /
RUN chmod +x /entrypoint.sh

# the arguments to covert an asciidoctor file into a PDF
ENTRYPOINT [ "/entrypoint.sh" ]

# the default file to be converted
CMD [ "/documents/README.adoc" ]