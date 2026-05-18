# Azure DevOps Lab

Infrastructure-as-Code project provisioning and configuring a Linux VM on Azure using Terraform and Ansible, with a CI/CD pipeline via GitHub Actions.

Built as a hands-on lab to practice cloud infrastructure automation on Azure.

---

## Stack

- **Terraform** — infrastructure provisioning
- **Ansible** — VM configuration and hardening
- **GitHub Actions** — CI/CD pipeline
- **Azure** — cloud provider (France Central)

---

## What it provisions

- Resource Group
- Virtual Network + Subnet
- Network Security Group (SSH, Prometheus, Grafana ports)
- Static Public IP (Standard SKU)
- Network Interface
- Ubuntu 22.04 LTS VM (Standard_B1s)
- Remote Terraform state in Azure Blob Storage

---

## What Ansible configures

- System updates and essential packages
- SSH hardening (root login disabled, password auth disabled)
- UFW firewall rules
- Prometheus — installed as a systemd service
- Grafana — installed and enabled

---

## CI/CD Pipeline

The GitHub Actions workflow triggers on any push or PR that touches `terraform/`:

- **Terraform Format Check** — enforces consistent code style
- **Terraform Init** — initializes with remote backend
- **Terraform Validate** — checks configuration is syntactically valid
- **Terraform Plan** — runs when Azure credentials are available (on merge to main)
- **Terraform Apply** — applies approved plan to Azure

---

## Usage

### Prerequisites
- Azure CLI authenticated (`az login`)
- Terraform >= 1.3
- Ansible

### Deploy

```bash
cd terraform
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

### Configure VM

```bash
cd ansible
ansible-playbook -i inventory.ini playbook.yml
```

### Destroy

```bash
cd terraform
terraform destroy -var-file="terraform.tfvars"
```

---

## Notes

This was built on an Azure for Students subscription, which came with a few real constraints worth documenting:

- **Region policy** — deployment restricted to 5 regions (francecentral, swedencentral, uaenorth, austriaeast, spaincentral). Discovered via `az policy assignment list` and worked around by targeting France Central.
- **Basic SKU public IPs** — quota set to 0. Switched to Standard SKU which is the recommended practice anyway.
- **VM capacity** — B-series VMs unavailable across all allowed regions at time of deployment. Infrastructure (networking, NSG, public IP) was successfully provisioned; VM deployment is configured and ready once quota is available.
- **App registration permissions** — service principal creation blocked, preventing full GitHub Actions integration. Pipeline is structured to run validate/format checks without credentials, and plan/apply when a service principal is available.

These constraints are typical in restricted cloud environments and the workarounds reflect real-world troubleshooting.

---

## Author

Obay — MSc Computer Science student, Széchenyi István University
ENDOFFILE
