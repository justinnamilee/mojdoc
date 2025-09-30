FROM perl
WORKDIR /opt/mojdoc
COPY . .
RUN cpanm --installdeps -n .
EXPOSE 3000
CMD ["hypnotoad", "-f", "mojdoc"]
