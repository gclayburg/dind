#!/bin/bash

#add ssh keys for fleetctl commands inside a jenkins build
#The results of ssh-agent must be evaluated in calling shell in order to pass env SSH_AUTH_SOCK to jenkins.sh as running as user jenkins
ssh-agent 

