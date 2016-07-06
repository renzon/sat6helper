SatelliteQE Dev Environment Playbooks
=====================================

The ansible playbooks to deploy Fedora 23/24 development machine

FIRST
-----

In you fedora machine generate your ssh keys

```bash
$ ssh-keygen
# follow the instructions of the above command (or just enter to everything)
$ cat ~/.ssh/id_rsa.pub
# Select and copy the key printed here
```

add the copied key to [github settings](https://github.com/settings/keys)

Get your own forks
------------------

-  Fork all SatelliteQE repositories to your own github account
    * Go to github and click **fork** button on the following repositories
        * http://github.com/SatelliteQE/robottelo
        * http://github.com/SatelliteQE/robottelo-ci

Run the playbooks
-----------------

### Automatic (easy mode)

```bash
wget -O /tmp/deploy_my_machine.sh https://raw.githubusercontent.com/SatelliteQE/sat6helper/master/dev/playbooks/deploy_my_machine.sh && . /tmp/deploy_my_machine.sh

```

Answer the questions and wait....

### Manual

Clone this repository and access dev/playbooks

```bash
$ git clone https://github.com/SatelliteQE/sat6helper
$ cd sat6helper/dev/playbooks
```

Install dependencies

```bash
sudo dnf update -y
sudo dnf install -y wget unzip python2 python-devel
sudo dnf install -y libffi-devel redhat-rpm-config
sudo dnf install -y openssl-devel yum python-dnf
```

Install Ansible

```bash
wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py
sudo -H python2 /tmp/get-pip.py -U
sudo -H pip install ansible -U
```

Run informing your variables
----------------------------
```bash
$ ansible-playbook -vvv workstation.yml \
  --skip-tags pycharm,vlc,emacs \
  --ask-sudo-pass \
  --extra-vars \
  "projects_folder=~/my_projects \
  git_username=yourusername \
  git_email=you@mail.com \
  git_full_name='Your Name'"

```

Or Configure
---------
Edit **workstation.yml** including your github username and email

Run
---

```bash
ansible-playbook workstation.yml --ask-sudo-pass
```