#!/bin/sh

asciidoctor-pdf \
-r asciidoctor-kroki \
-a kroki-server-url=http://localhost:8000/ \
-a imagesoutdir=./build \
-a allow-uri-read \
-r asciidoctor-mathematical \
-a mathematical-format=svg \
-a stem \
-r asciidoctor-lists \
-a source-highlighter=rouge \
-a rouge-style=pastie \
-a pdf-themesdir=/usr/share/asciidoc-theme \
-a pdf-theme=custom-theme.yml \
-a pdf-fontsdir="/usr/share/fonts/noto;GEM_FONTS_DIR" \
-a sectnums \
-a sectnumlevels=5 \
-a !chapter-signifier \
-a optimize \
-a env-pdf \
-o build/$(date +%Y-%m-%d_%H-%M).pdf \
"$@"