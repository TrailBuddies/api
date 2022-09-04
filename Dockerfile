ARG RUBY_VERSION=3.1.2
ARG NODE_VERSION=16
ARG BUNDLER_VERSION=2.3.9

ARG RAILS_ENV=production
ENV RAILS_ENV=${RAILS_ENV}

ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

ARG BUNDLE_WITHOUT=development:test
ARG BUNDLE_PATH=vendor/bundle
ENV BUNDLE_PATH ${BUNDLE_PATH}
ENV BUNDLE_WITHOUT ${BUNDLE_WITHOUT}

ENV PORT 6660
ENV SECRET_KEY_BASE 1


FROM ruby:${RUBY_VERSION} AS base

WORKDIR /app
COPY . .

SHELL ["/bin/bash", "-c"]

RUN curl https://get.volta.sh | bash

ENV BASH_ENV ~/.bashrc
ENV VOLTA_HOME /root/.volta
ENV PATH $VOLTA_HOME/bin:/usr/local/bin:$PATH

RUN volta install node@${NODE_VERSION} && volta install yarn


FROM base AS build_deps

ARG DEV_PACKAGES="git build-essential libpq-dev wget vim curl gzip xz-utils libsqlite3-dev libmagickwand-dev"
RUN --mount=type=cache,id=dev-apt-cache,sharing=locked,target=/var/cache/apt \
    --mount=type=cache,id=dev-apt-lib,sharing=locked,target=/var/lib/apt \
    apt update -qq && \
    apt upgrade && \
    apt install --no-install-recommends -y ${DEV_PACKAGES} && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives


FROM build_deps AS gems

RUN gem install -N bundler -v ${BUNDLER_VERSION}

COPY Gemfile* ./
RUN bundle install && rm -rf vendor/bundle/ruby/*/cache


FROM build_deps AS node_modules

COPY package*json ./
COPY yarn.* ./

RUN if [ -f "yarn.lock" ]; then \
      yarn install; \
    elif [ -f "package-lock.json" ]; then \
      npm install; \
    else \
        mkdir node_modules; \
    fi


FROM base

ARG PROD_PACKAGES="postgresql-client file vim curl gzip libsqlite3-0 libmagickwand-dev"
RUN --mount=type=cache,id=dev-apt-cache,sharing=locked,target=/var/cache/apt \
    --mount=type=cache,id=dev-apt-lib,sharing=locked,target=/var/lib/apt \
    apt update -qq && \
    apt upgrade && \
    apt install --no-install-recommends -y ${PROD_PACKAGES} && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY --from gems /app /app/
COPY --from node_modules /app/node_modules /app/node_modules/

COPY . .

RUN bin/rails db:setup

CMD bin/rails server
