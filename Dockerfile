FROM jenkins:1.651.3
USER root

# Let's start with some basic stuff.
RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    lxc \
    iptables \
    curl

# Install Docker from Docker Inc. repositories.
#RUN echo "hi" && curl -sSL https://get.docker.com/ | sh

# show what docker version is available in the repo
#RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && mkdir -p /etc/apt/sources.list.d && echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list && apt-get update && apt-cache policy docker-engine

# Install specific docker version to match docker version supplied by coreos.  This is to avoid issues with the docker daemon running on coreos and the docker client bundled inside this docker image
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && mkdir -p /etc/apt/sources.list.d && echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list && apt-get update && apt-get install -y -q docker-engine=1.10.3-0~trusty
    
# Define additional metadata for our image.
VOLUME /var/lib/docker

# Install the magic wrapper.
ADD ./wrapdocker.sh ./start-ssh-agent.sh ./fleetctl ./etcdctl ./jq isTomcatRunning.sh /usr/local/bin/

# add jenkins to docker group which was created by docker install above (gid=999)
# add jenkins user to docker group that coreos uses (gid=233) 
# this allows the jenkins user to use the bind mount /var/run/docker.sock when this container is being run on coreos
RUN usermod -G docker jenkins && \
    groupadd -g 233 docker2 && \
    usermod -G docker2 jenkins

#ENTRYPOINT ["/usr/local/bin/wrapdocker.sh"]
ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/wrapdocker.sh"]
