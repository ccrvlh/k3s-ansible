setup:
	ansible-playbook main.yml -e operation=setup

reset:
	ansible-playbook main.yml -e operation=reset

cluster:
	ansible-playbook main.yml -e operation=cluster

check:
	ansible-playbook main.yml -e operation=check

reboot:
	ansible-playbook main.yml -e operation=reboot

agent:
	ansible-playbook main.yml -e operation=agent

upgrade:
	ansible-playbook main.yml -e operation=upgrade
