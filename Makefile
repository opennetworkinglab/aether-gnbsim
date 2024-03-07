#### Variables ####

export ROOT_DIR ?= $(PWD)
export GNBSIM_ROOT_DIR ?= $(ROOT_DIR)

export ANSIBLE_NAME ?= ansible-gnbsim
export HOSTS_INI_FILE ?= hosts.ini

export EXTRA_VARS ?= ""

#### Start Ansible docker ####

gnbsim-ansible:
	export ANSIBLE_NAME=$(ANSIBLE_NAME); \
	sh $(GNBSIM_ROOT_DIR)/scripts/ansible ssh-agent bash

#### a. Debugging ####
gnbsim-pingall:
	ansible-playbook -i $(HOSTS_INI_FILE) $(GNBSIM_ROOT_DIR)/pingall.yml \
		--extra-vars "ROOT_DIR=$(ROOT_DIR)" --extra-vars $(EXTRA_VARS)

#### b. Provision docker ####
gnbsim-docker-install:
	ansible-playbook -i $(HOSTS_INI_FILE) $(GNBSIM_ROOT_DIR)/docker.yml --tags install \
		--extra-vars "ROOT_DIR=$(ROOT_DIR)" --extra-vars $(EXTRA_VARS)
gnbsim-docker-uninstall:
	ansible-playbook -i $(HOSTS_INI_FILE) $(GNBSIM_ROOT_DIR)/docker.yml --tags uninstall \
		--extra-vars "ROOT_DIR=$(ROOT_DIR)" --extra-vars $(EXTRA_VARS)

gnbsim-docker-router-install:
	ansible-playbook -i $(HOSTS_INI_FILE) $(GNBSIM_ROOT_DIR)/router.yml --tags install \
		--extra-vars "ROOT_DIR=$(ROOT_DIR)" --extra-vars $(EXTRA_VARS)
gnbsim-docker-router-uninstall:
	ansible-playbook -i $(HOSTS_INI_FILE) $(GNBSIM_ROOT_DIR)/router.yml --tags uninstall \
		--extra-vars "ROOT_DIR=$(ROOT_DIR)" --extra-vars $(EXTRA_VARS)

gnbsim-docker-start:
	ansible-playbook -i $(HOSTS_INI_FILE) $(GNBSIM_ROOT_DIR)/docker.yml --tags start \
		--extra-vars "ROOT_DIR=$(ROOT_DIR)" --extra-vars $(EXTRA_VARS)
gnbsim-docker-stop:
	ansible-playbook -i $(HOSTS_INI_FILE) $(GNBSIM_ROOT_DIR)/docker.yml --tags stop \
		--extra-vars "ROOT_DIR=$(ROOT_DIR)" --extra-vars $(EXTRA_VARS)

#### c. Provision gnbsim ####
gnbsim-simulator-run:
	ansible-playbook -i $(HOSTS_INI_FILE) $(GNBSIM_ROOT_DIR)/simulator.yml --tags start \
		--extra-vars "ROOT_DIR=$(ROOT_DIR)" --extra-vars $(EXTRA_VARS)


# run gnbsim-docker-install before running setup
gnbsim-install: gnbsim-docker-install gnbsim-docker-router-install gnbsim-docker-start
gnbsim-uninstall:  gnbsim-docker-stop gnbsim-docker-router-uninstall gnbsim-docker-uninstall
gnbsim-reset: gnbsim-docker-stop gnbsim-docker-start
