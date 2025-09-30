FROM perl:latest
WORKDIR /opt/mojdoc
COPY Makefile.PL .
RUN cpanm --installdeps -n .
COPY . .
RUN prove
EXPOSE 3000
CMD ["hypnotoad", "-f", "mojdoc"]
