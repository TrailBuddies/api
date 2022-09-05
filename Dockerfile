ARG RUBY_VERSION=3.1.2


FROM ruby:${RUBY_VERSION}

ARG NODE_VERSION=16
ARG BUNDLER_VERSION=2.3.9

ARG RAILS_ENV=production

ARG BUNDLE_WITHOUT=development:test
ARG BUNDLE_PATH=vendor/bundle

ENV RAILS_ENV=${RAILS_ENV}

ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

ENV BUNDLE_PATH ${BUNDLE_PATH}
ENV BUNDLE_WITHOUT ${BUNDLE_WITHOUT}

ENV PORT 6660
ENV SECRET_KEY_BASE 1

WORKDIR /app
COPY . .

SHELL ["/bin/bash", "-c"]

RUN curl https://get.volta.sh | bash

ENV BASH_ENV ~/.bashrc
ENV VOLTA_HOME /root/.volta
ENV PATH $VOLTA_HOME/bin:/usr/local/bin:$PATH

RUN volta install node@${NODE_VERSION} && volta install yarn


ARG DEV_PACKAGES="git build-essential libpq-dev wget vim curl gzip xz-utils libsqlite3-dev libmagickwand-dev"
RUN apt-get update -qq -y && \
    apt-get install --no-install-recommends -y ${DEV_PACKAGES} && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives


RUN gem install -N bundler -v ${BUNDLER_VERSION}

COPY Gemfile* ./
RUN bundle install && rm -rf vendor/bundle/ruby/*/cache


COPY package*json ./
COPY yarn.* ./

RUN if [ -f "yarn.lock" ]; then \
      yarn install; \
    elif [ -f "package-lock.json" ]; then \
      npm install; \
    else \
        mkdir node_modules; \
    fi


ARG PROD_PACKAGES="postgresql-client file vim curl gzip libsqlite3-0 libmagickwand-dev"
RUN apt-get update -qq -y && \
    apt-get install --no-install-recommends -y ${PROD_PACKAGES} && \
    rm-get -rf /var/lib/apt/lists /var/cache/apt/archives

COPY . .

RUN bin/rails db:setup

CMD bin/rails server
