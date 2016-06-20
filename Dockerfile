FROM jenkins:1.625.2
USER root

# Let's start with some basic stuff.
RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    lxc \
    iptables \
    curl

# Install Docker from Docker Inc. repositories.
RUN echo "hi" && curl -sSL https://get.docker.com/ | sh
    
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
