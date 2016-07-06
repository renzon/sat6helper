#!/usr/bin/env bash
set -euo pipefail

skip_tags="notag"
github_username="SatelliteQE"
playbooks_repo_name="sat6helper"

repo_zip_package_url="https://github.com/$github_username/$playbooks_repo_name/archive/master.zip"

current_user="$USER"
current_directory=$(pwd)
stty_orig=$(stty -g)

trap "stty '$stty_orig'; stty echo" SIGINT SIGTERM

function read_secret()
{   
    
    # Disable echo.
    stty_orig=$(stty -g)
    stty -echo

    # Set up trap to ensure echo is enabled before exiting if the script
    # is terminated while echo is disabled.
    trap 'stty echo' EXIT

    # run command
    read -p "[sudo] password for $current_user": user_passwd

    # Enable echo.
    stty "$stty_orig"
    stty echo
    trap - EXIT

    # Print a newline because the newline entered by the user after
    # entering the passcode is not echoed. This ensures that the
    # next line of output begins at a new line.
    echo
}

function read_other_data()
{
   # get github data
   read -p "Your github username ex: $current_user:" git_username
   read -p "Your git full name ex: Homer Simpsons:" git_full_name
   read -p "Your github email ex: $current_user@mail.com:" git_email
   read -p "Roles to skip ex: pycharm,git,vlc or just [enter] to install all roles.:" skip_tags

}


function install_ansible_and_other_required_tools(){
    sudo -S <<< "$user_passwd" dnf update -y
    sudo -S <<< "$user_passwd" dnf install -y wget unzip python2 python-devel
    sudo -S <<< "$user_passwd" dnf install -y libffi-devel redhat-rpm-config
    sudo -S <<< "$user_passwd" dnf install -y openssl-devel yum python-dnf

    echo "checking if Python is installed"
    is_python2_pip=$(pip --version | grep 2.7 &> /dev/null && echo 'yes' || echo 'no')
    if [ "$is_python2_pip" = "no" ]; then
      echo "pip to Python2 is not installed. installing now"
      wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py
      sudo -H -S <<< "$user_passwd" python2 /tmp/get-pip.py -U
    fi
    
    echo "checking if ansible is newer version"
    is_ansible_old_version=$(ansible --version | grep " 2." &> /dev/null && echo 'no' || echo 'yes')
    if [ "$is_ansible_old_version" = "yes" ]; then
        echo "upgrading ansible"
        sudo -H -S <<< "$user_passwd" pip install ansible -U
    fi
    
}

function run_playbook(){
    echo "preparing to run the playbook"
    local file_name="$playbooks_repo_name.zip"
    local file_full_output_path="/tmp/deploy_my_machine/$file_name"
    cd /tmp || exit
    sudo -H -S <<< "$user_passwd" rm -rf /tmp/deploy_my_machine 2> /dev/null

    mkdir -p /tmp/deploy_my_machine
    cd /tmp/deploy_my_machine || exit
    echo "downloading repository files"
    wget -O $file_full_output_path "$repo_zip_package_url"

    unzip $playbooks_repo_name
    cd "$playbooks_repo_name-master" || exit

    echo "running playbook"
    cd dev/playbooks
    ansible-playbook workstation.yml \
      --skip-tags ${skip_tags:-notags} \
      --extra-vars \
      "ansible_become_pass=$user_passwd
       git_username=${git_username:-$current_user}
       git_email=${git_email:-$current_user@mail.com}
       git_full_name='${git_full_name:-$current_user}'"
    cd $current_directory
    rm -r /tmp/deploy_my_machine 2> /dev/null 
}


if [[ $EUID -ne 0 ]]; then
    # temporary disable history record
    set +o history
    echo -e "\nStarting Installation" 2>&1
    
    # read current user password
    read_secret

    read_other_data
    
    # install ansible, wget and unzip
    install_ansible_and_other_required_tools

    run_playbook
    
    unset user_passwd
    
    cd $current_directory
    
    # re-enable history record
    set -o history

    exit 0
else
    echo -e "\nPlease not run this with root privilege" 2>&1
    echo -e "Stopping the installation and exiting\n" 2>&1

    exit 1

fi
