.PHONY: create-vm provision-vm start-vm stop-vm delete-vm info-vm

VM_NAME=jammy-asterisk
OS_VERSION=jammy
CPU=2
MEMORY=2G
DISK=10G
ANSIBLE_PLAYBOOK=playbook.yaml
CLOUD_CONFIG=runtime/cloud-config.yaml
INVENTORY_FILE=runtime/hosts.ini

create-vm:
	@if [ -z "$(network)" ]; then \
		echo "Error: network is not set. Use 'make create network=<network_interface>'"; \
		exit 1; \
	fi
	@echo "Creating the VM..."
	@multipass launch $(OS_VERSION) --name $(VM_NAME) --cpus $(CPU) --memory $(MEMORY) --disk $(DISK) --cloud-init $(CLOUD_CONFIG) --network=$(network)
	@echo "VM created successfully. Please update $(INVENTORY_FILE) manually if needed."

provision-vm:
	@echo "Provisioning the VM with Ansible..."
	@ansible-playbook -i $(INVENTORY_FILE) $(ANSIBLE_PLAYBOOK) --limit multipass -vv --ask-become-pass

provision:
	@echo "Provisioning the VM with Ansible..."
	@ansible-playbook -i $(INVENTORY_FILE) $(ANSIBLE_PLAYBOOK) -vv --ask-become-pass

start-vm:
	@echo "Starting the VM..."
	@multipass start $(VM_NAME)

stop-vm:
	@echo "Stopping the VM..."
	@multipass stop $(VM_NAME)

delete-vm:
	@echo "Deleting the VM..."
	@multipass delete $(VM_NAME)
	@multipass purge
	@echo "VM deleted and resources purged."

info-vm:
	@echo "Getting information about the VM..."
	@multipass info $(VM_NAME)
