#### Variables ####

export ROOT_DIR ?= $(PWD)
export GNBSIM_ROOT_DIR ?= $(ROOT_DIR)

export ANSIBLE_NAME ?= ansible-gnbsim
export HOSTS_INI_FILE ?= hosts.ini

export EXTRA_VARS ?= ""

#### Start Ansible docker ####

ansible:
	export ANSIBLE_NAME=$(ANSIBLE_NAME); \
	sh $(GNBSIM_ROOT_DIR)/scripts/ansible ssh-agent bash

#### a. Private keys (for ssh and git) ####

list-keys:
	ssh-add -l

# add-keys:
# 	ssh-add <your key>

#### b. Debugging ####
gnbsim-pingall:
	ansible-playbook -i $(HOSTS_INI_FILE) $(GNBSIM_ROOT_DIR)/pingall.yml \
		--extra-vars "ROOT_DIR=$(ROOT_DIR)" --extra-vars $(EXTRA_VARS)

#### e. Provision docker ####
gnbsim-docker-install:
	ansible-playbook -i $(HOSTS_INI_FILE) $(GNBSIM_ROOT_DIR)/docker.yml --tags install \
		--extra-vars "ROOT_DIR=$(ROOT_DIR)" --extra-vars $(EXTRA_VARS)
gnbsim-docker-uninstall:
	ansible-playbook -i $(HOSTS_INI_FILE) $(GNBSIM_ROOT_DIR)/docker.yml --tags uninstall \
		--extra-vars "ROOT_DIR=$(ROOT_DIR)" --extra-vars $(EXTRA_VARS)