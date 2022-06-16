#!/bin/bash

terraform_init() {
    echo "[+] Initalizing Terraform"
    terraform init -input=false

    if [ "${?}" -ne 0 ]; then
        echo "[+] Failed to initialize Terraform configuration"
        exit 1
    fi
}
