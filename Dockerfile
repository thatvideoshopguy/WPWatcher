# WPWatcher Dockerfile
FROM ruby:alpine

# Install dependencies: ruby gem, curl, git, Python, setuptools, Sphinx, and pip
RUN apk --update add --virtual build-dependencies ruby-dev build-base \
    && apk --update add curl git python3 py3-setuptools \
    && apk --update add py3-sphinx py3-sphinx-autobuild py3-sphinx_rtd_theme \
    && apk add --no-cache py3-pip

# Install recommonmark using pip (required for Sphinx)
RUN pip install recommonmark

# Install WPScan latest version
RUN gem install wpscan

# Setup user and group if specified
ARG USER_ID

# Delete current user and create the required directories
RUN mkdir /wpwatcher && mkdir /wpwatcher/.wpwatcher

# Add only required scripts
COPY setup.py README.md /wpwatcher/
COPY ./wpwatcher/* /wpwatcher/wpwatcher/

WORKDIR /wpwatcher

# Install WPWatcher and create the user
RUN python3 ./setup.py install \
    && deluser --remove-home wpwatcher >/dev/null 2>&1 || true \
    && if [ ${USER_ID:-0} -ne 0 ]; then adduser -h /wpwatcher -D -u ${USER_ID} wpwatcher; fi \
    && adduser -h /wpwatcher -D wpwatcher >/dev/null 2>&1 || true \
    && chown -R wpwatcher /wpwatcher

USER wpwatcher

# Set entrypoint to a shell for development
ENTRYPOINT ["/bin/sh"]
