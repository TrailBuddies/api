FROM ruby:3.1.2

# Setup environment variables
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true
ENV BUNDLE_PATH vendor/bundle
ENV BUNDLE_WITHOUT development:test
ENV PORT 6660
ENV SECRET_KEY_BASE 1

# Change work directory
WORKDIR /app
#COPY . .

# Install Nodejs
#RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
#    apt-get install -y nodejs

# Install Yarn package manager
#RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null && \
#    echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list && \
#    apt-get update -qq && \
#    apt-get install yarn

# Install needed system packages
ARG PACKAGES="postgresql-client nodejs libmagickwand-dev"
RUN apt-get update -qq -y && \
    apt-get install --no-install-recommends -y ${PACKAGES} && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives


# Install Bundler
RUN gem install -N bundler -v 2.3.6

# Install gems from Gemfile
COPY Gemfile* ./
RUN bundle install

# Execute..
EXPOSE ${PORT}
CMD ["bin/rails", "server"]
