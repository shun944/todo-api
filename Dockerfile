# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.3
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim AS base

FROM base AS build

# For postgresql
# RUN apt-get update && apt-get install -y \
# build-essential \
# libpq-dev \
# libpq5 \
# default-libmysqlclient-dev \
# libgmp-dev

# Rails app lives here
WORKDIR /app

# Bundlerのバージョンを合わせる
RUN gem install bundler -v 2.5.7

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

RUN printenv > /app/env.txt

# Throw-away build stage to reduce size of final image
# FROM base as build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libvips pkg-config libpq-dev libsqlite3-0 libvips curl && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN mkdir -p /usr/local/bundle/ && \
    chown -R root:root /usr/local/bundle && \
    chmod -R 777 /usr/local/bundle/ && \
    bundle _2.5.7_ install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY bin/ /app/bin/
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Final stage for app image
FROM base

# # Install packages needed for deployment
# RUN apt-get update -qq && \
#     apt-get install --no-install-recommends -y curl libsqlite3-0 libvips && \
#     rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
# COPY --from=build /rails /rails
COPY --from=build /app /app

RUN mkdir -p db log storage tmp

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

# Entrypoint prepares the database.
# ENTRYPOINT ["/rails/bin/docker-entrypoint"]
ENTRYPOINT ["/app/bin/docker-entrypoint"]
# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./app/bin/rails", "server"]