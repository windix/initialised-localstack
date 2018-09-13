ARG  LOCALSTACK_DOCKER_IMAGE_TAG=latest
FROM localstack/localstack:$LOCALSTACK_DOCKER_IMAGE_TAG

COPY bootstrap /opt/bootstrap/

RUN chmod +x /opt/bootstrap/scripts/init.sh
RUN chmod +x /opt/bootstrap/bootstrap.sh

RUN pip install awscli-local

# Install https://github.com/jwilder/dockerize to /usr/local/bin
ARG DOCKERIZE_VERSION=v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# We run the init script as a health check
# That way the container won't be healthy until it's completed successfully
# Once the init completes we wipe it to prevent it continiously running
HEALTHCHECK --start-period=10s --interval=1s --timeout=3s --retries=30\
  CMD /opt/bootstrap/bootstrap.sh
