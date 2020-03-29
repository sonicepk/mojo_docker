FROM alpine:3.11
MAINTAINER Mojolicious

COPY cpanfile /
    # What should go into this? What's its meaning?
ENV EV_EXTRA_DEFS -DEV_NO_ATFORK

RUN apk update && \
  apk add perl perl-io-socket-ssl perl-dbd-pg perl-dev g++ make wget curl && \
  curl -L https://cpanmin.us | perl - App::cpanminus && \
  cpanm --installdeps . -M https://cpan.metacpan.org && \
  apk del perl-dev g++ make wget curl && \
  rm -rf /root/.cpanm/* /usr/local/share/man/*

# USER daemon
# WORKDIR /
# VOLUME ["/data"]
EXPOSE 3000

CMD ["perl", "-MMojolicious::Lite", "-E", "get '/' =>sub { shift->render(text =>'OK!') }; app->start", "daemon"]

