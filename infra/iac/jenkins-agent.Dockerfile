# Jenkins agent with Docker, Helm, Gradle, and Git
FROM jenkins/inbound-agent:latest-jdk21

USER root

# Install Podman
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg2 lsb-release software-properties-common && \
    apt-get update && \
    apt-get install -y podman

# create sym link to podman work with alias 'docker'
RUN ln -s /usr/bin/podman /usr/bin/docker

# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install Git
RUN apt-get install -y git