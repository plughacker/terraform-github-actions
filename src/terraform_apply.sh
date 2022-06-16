#!/bin/bash

terraform_apply() {
    echo "[+] Applying Terraform"
    terraform init
    terraform apply -auto-approve

    if [ "${?}" -ne 0 ]; then
        echo "[+] Failed to apply Terraform configuration"
        exit 1
    fi
}
