#!/bin/bash

terraform_init() {
    echo "[+] Planning Terraform configuration"
    terraform plan -input=false

    if [ "${?}" -ne 0 ]; then
        echo "[+] Failed to plan Terraform configuration"
        exit 1
    fi
}
