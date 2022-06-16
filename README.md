# terraform-github-actions

<hr>

Terraform GitHub Actions allow to execute terraform commands within GitHub Actions.

<hr>

## Usage

Commands available:

- init
- plan
- apply

## Example

```hcl
on: [push]

jobs:
  terraform:
    name: 'Terraform'
    runs-on: ubuntu-latest
    steps:
      - name: Terraform init
        uses: plughacker/terraform-github-actions@v1
        with:
          tf_version: 1.0.6
          tg_command: 'init'
          tg_working_dir: '.'
          git_ssh_key:  ${{ secrets.git_ssh_key }}
```

## Inputs

| Input name     | Description                                         | Required |
|----------------|-----------------------------------------------------|----------|
| tf_version     | The terraform version to install and execute        | Yes      |
| tf_command     | The terraform command to execute                   | Yes      |
| tf_working_dir | The working directory to execute terraform commands| Yes      |
| git_ssh_key    | The SSH Key to clone terraform modules              | NO       |
