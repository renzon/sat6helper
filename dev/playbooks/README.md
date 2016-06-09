SatelliteQE Dev Environment Playbooks
=====================================

The ansible playbooks to deploy Fedora 23 development machine

install
--------------

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