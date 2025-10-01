FROM perl:latest
WORKDIR /opt/mojdoc
COPY Makefile.PL .
RUN cpanm --installdeps -n .
COPY . .
RUN prove
EXPOSE 8080
CMD ["hypnotoad", "-f", "mojdoc"]
