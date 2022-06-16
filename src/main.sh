#!/bin/bash -x

validate_inputs() {
    if [ -z ${INPUT_TF_VERSION} ]; then
        echo "Input tf_version cannot be empty."
        exit 1

    elif [ -z ${INPUT_TF_COMMAND} ]; then
        echo "Input tg_command cannot be empty."
        exit 1

    elif [ -z ${INPUT_TF_WORKING_DIR} ]; then
        echo "Input tg_working_dir cannot be empty."
        exit 1

    elif [ -z ${INPUT_GIT_SSH_KEY} ]; then
        echo "Input git_ssh_key cannot be empty."
        exit 1
    fi

    tfVersion=${INPUT_TF_VERSION}
    tfWorkingDir=${INPUT_TF_WORKING_DIR}
    tfCommand=${INPUT_TG_COMMAND}
    gitSSHKey=${INPUT_GIT_SSH_KEY}
}

download_terraform_binary() {
    echo "[+] Downloading Terraform ${tfVersion}..."

    url="https://releases.hashicorp.com/terraform/${tfVersion}/terraform_${tfVersion}_linux_amd64.zip"

    curl -s -S -L -o /tmp/terraform_${tfVersion} ${url}

    if [ "${?}" -ne 0 ]; then
        echo "[+] Failed to download Terraform ${tfVersion}"
        exit 1
    fi

    echo "[+] Successfully download Terraform ${tfVersion}"

    echo "[+] Unzipping Terraform ${tfVersion}"

    unzip -d /usr/local/bin /tmp/terraform_${tfVersion} &> /dev/null
    if [ "${?}" -ne 0 ]; then
        echo "[+] Failed to unzip Terraform ${tfVersion}"
        exit 1
    fi

    echo "[+] Successfully unzipped Terraform ${tfVersion}"
}

configure_ssh_key() {
    mkdir -p /root/.ssh && chmod 700 /root/.ssh

    if [ "${?}" -ne 0 ]; then
    	echo "[+] Failed to create .ssh folder"
    	exit 1
    fi

    echo "${gitSSHKey}" > /root/.ssh/id_rsa
    if [ "${?}" -ne 0 ]; then
    	echo "[+] Failed to create ssh key"
    	exit 1
    fi


    chown -R root:root /root/.ssh
    chmod 600 /root/.ssh/id_rsa

    ssh-keyscan github.com >> /root/.ssh/known_hosts
}

main() {
    dirName=$(dirname ${0})
    source ${dirName}/terraform_apply.sh
    source ${dirName}/terraform_init.sh
    source ${dirName}/terraform_plan.sh

    echo "[+] Changing directory to ${tfWorkingDir}"
    
    ls -lah

    cd ${tfWorkingDir}

    echo "[+] Listing files..."
    
    ls -lah

    case "${tfCommand}" in
        apply)
            terraform_init
            terraform_apply
            ;;
        init)
            terraform_init
            ;;
        plan)
            terraform_init
            terraform_plan
            ;;
        *)
        echo "[+] terraform command not available"
        exit 1
        ;;
    esac
}

validate_inputs
configure_ssh_key
download_terraform_binary

main "${*}"
