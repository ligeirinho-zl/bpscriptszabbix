Role instalação Zabbix compliance
=========

Role para configurar o server para envio dos dados do zabbix

Requirements
------------


Role Variables
--------------

install_jq: true
scripts_path: /etc/zabbix/scripts
install_zbx_agent: false

Dependencies
------------


Example Playbook
----------------
```yaml
---
- hosts: servers
  roles:
     - { role: zbx.compliance }
```

or
```yaml
---
- hosts: all
  tasks:
    - name: "Include zbx.compliance"
      include_role:
        name: ../roles/zbx.compliance
```