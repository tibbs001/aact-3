FROM library/ruby:3.1-slim as base
MAINTAINER Jim Wood <jimwood@duke.edu>

# Multiple Architecture Binary Support
FROM base as base-amd64
RUN apt-get clean && apt-get update \
 && apt-get install -qq -y --no-install-recommends unzip
j
FROM base as base-arm64
RUN apt-get clean && apt-get update \
 && apt-get install -qq -y --no-install-recommends unzip

FROM base-${TARGETARCH} as deps
RUN apt-get update \
 && apt-get install -qq -y --no-install-recommends \
    build-essential \
    tzdata \
    libxml2-dev \
    libxslt-dev \
    curl \
    gnupg \
    unzip \
    fontconfig \
    libfontconfig1 \
    libxrender1 \
    libxext6 \
    libaio-dev \
    libpq-dev \
    default-libmysqlclient-dev \
    libsqlite3-dev \
    freetds-dev \
    python \
    postgresql-client \
    postgresql-client-common \
    libpq-dev

RUN apt-get install -y postgresql-client postgresql-client-common libpq-dev


# Set Timezone
RUN ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

# Duke Fonts
COPY ./duke_fonts /usr/local/share/fonts
RUN fc-cache /usr/local/share/fonts

# Add Zscaler support for DHTS supported development machines
COPY ZscalerRootCertificate-2048-SHA256.crt /etc/ssl/certs/
RUN openssl rehash

# Setup bundle for easier caching with docker-compose
ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"
RUN gem install bundler

RUN mkdir /app
WORKDIR /app

FROM deps

ONBUILD COPY Gemfile Gemfile.lock ./
ONBUILD RUN  umask 0002 \
     && bundle config set deployment true \
     && bundle install --without development test

ENV RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=1 \
    RAILS_SERVE_STATIC_FILES=1

# Handle OpenShift randomly generated user issues:

# Set a home directory to silence bundler in console warnings
RUN mkdir -p /okd_user_home \
  && chgrp -R 0 /okd_user_home \
  && chmod -R g+rwxs /okd_user_home
ENV HOME=/okd_user_home

# Allow writing to the Rails tmp directory
RUN mkdir -p tmp/pids \
  && mkdir -p tmp/cache \
  && chgrp -R 0 tmp \
  && chmod -R g+rwxs tmp

ADD docker-assets-precompile.sh ./docker-assets-precompile.sh

ONBUILD ADD . .

ONBUILD RUN SKIP_VAULT=true SKIP_VALIDATION=true SECRET_KEY_BASE=fakeassetbuildersecret DATABASE_URL=postgres://postgres:postgres@fakedbserver/fakedb ./docker-assets-precompile.sh

CMD ["bundle","exec","puma","-C","config/puma.rb"]


