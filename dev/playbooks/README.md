SatelliteQE Dev Environment Playbooks
=====================================

The ansible playbooks to deploy Fedora 23/24 development machine

install
--------------

### auto

```bash
wget -O /tmp/deploy_my_machine.sh https://raw.githubusercontent.com/SatelliteQE/sat6helper/master/dev/playbooks/deploy_my_machine.sh && . /tmp/deploy_my_machine.sh

```

> Note: if you use auto you'll need to reconfigure github repo origin and upstream remotes.

### manual

Install Ansible

```bash
wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py
sudo -H python2 /tmp/get-pip.py -U
sudo -H pip install ansible
```

Check
------
1. You forked SatelliteQE repositories to your own github account
    * Go to github and click **fork** button on the following repositories
        * SatelliteQE/robottelo
        * SatelliteQE/nailgun
        * SatelliteQE/automation-tools
2. You have your ssh-keys configured to access github from your local machine
    * ```ssh-keygen```  generate a key with defaults, ```cat ~/.ssh/id_rsa.pub``` copy and paste the contents in github (settings/ssh-keys)

Configure
---------
Edit **workstation.yml** including your github username and email

Run
---

```bash
ansible-playbook workstation.yml --ask-sudo-pass
```