FROM jenkins
USER root

# Let's start with some basic stuff.
RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    lxc \
    iptables \
    curl
    
# Install Docker from Docker Inc. repositories.
RUN echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list \
  && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9 \
  && apt-get update -qq \
  && apt-get install -qqy lxc-docker-1.3.1

# Define additional metadata for our image.
VOLUME /var/lib/docker

# Install the magic wrapper.
ADD ./wrapdocker.sh ./start-ssh-agent.sh ./fleetctl ./etcdctl ./jq isTomcatRunning.sh /usr/local/bin/

RUN usermod -G docker jenkins
ENTRYPOINT ["/usr/local/bin/wrapdocker.sh"]
