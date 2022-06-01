# Ansible role install Zabbix configurations compliance BP

## Install ansible
```bash
python -m venv ansible_venv
./ansible_venv/bin/activate
pip install -r requirements.txt
```

## Run testes
```bash
cd roles/zbx.compliance
molecule create && molecule test
```

## Run local VM test all tags
```bash
ansible-playbook -i inventories/test.yml playbooks/test.yml
```

## Se estiver usando uma pasta tirar a permissão de todos os users para escrever nela
```bash
chmod o-w .
```

## Se a verificação dos host SSH falhar usar a seguinte variavel
```bash
ssh-keygen -f ~/.ssh/known_hosts -R "IP"
export ANSIBLE_HOST_KEY_CHECKING=False
```

## Executar os playbooks

Requirements in ansible master

```bash
libpq-dev
```

## Run Stack in local VMs all tags
```bash
ansible-playbook -i inventories/test.yml playbooks/full_install.yml --vault-password-file ~/O2B/keys/vault.pas
```