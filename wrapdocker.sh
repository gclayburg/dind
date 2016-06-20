#!/bin/bash
echo "wrapdocker: arg1 is $1"
echo "wrapdocker: all args: $@"

#Start ssh-agent as user jenkins.  This is done in a separate script so that when ssh-agent
# does a double fork, the ssh-process is still owned by user jenkins and not root
eval $(su -c "/usr/local/bin/start-ssh-agent.sh" jenkins)

export SSH_AUTH_SOCK
export SSH_AGENT_PID
#Add ssh key into SSH_AUTH_SOCK
su -c "ssh-add" jenkins
ssh-add -l
echo "processes running in container before starting jenkins:"
ps -elf

#Defer to jenkins docker image for jenkins.sh start script
su -c "/usr/local/bin/jenkins.sh $@" jenkins 
