# WPWatcher Dockerfile
FROM ruby:alpine

# Install dependencies
RUN apk --update add --virtual build-dependencies ruby-dev build-base \
    && apk --update add curl git python3 py3-setuptools

# Install WPScan latest version
RUN gem install wpscan

# Setup user and group if specified
ARG USER_ID

# Init folder tree
RUN mkdir /wpwatcher && mkdir /wpwatcher/.wpwatcher

# Add only required scripts
COPY setup.py README.md /wpwatcher/
COPY ./wpwatcher/* /wpwatcher/wpwatcher/
WORKDIR /wpwatcher

# Install WPWatcher
RUN python3 ./setup.py install \
    && deluser --remove-home wpwatcher >/dev/null 2>&1 || true \
    && if [ ${USER_ID:-0} -ne 0 ]; then adduser -h /wpwatcher -D -u ${USER_ID} wpwatcher; fi \
    && adduser -h /wpwatcher -D wpwatcher >/dev/null 2>&1 || true \
    && chown -R wpwatcher /wpwatcher

USER wpwatcher

# Run command
ENTRYPOINT ["wpwatcher"]
