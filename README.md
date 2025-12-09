# 📦 k0s bootc

  

This repository contains the recipes to build a **bootable container image** based on **[bootc](https://github.com/containers/bootc)** for **[k0s](https://k0sproject.io/)**, the simple, robust, and certified Kubernetes distribution.

> **Note:** This repository is forked from the [k0s image](https://gitlab.poul.org/sysadmin/system-images/k0s-bootc) built for [POuL](https://poul.org/).

## 📖 What is this?

This project combines **Kubernetes** with **Immutable OS** principles.

**bootc** (Bootable OS Containers) allows you to build and manage bootable operating system images directly from OCI/Docker container images. This innovative approach treats the entire operating system as a container image, enabling atomic updates and rollbacks.

### Why use k0s with bootc?

  * **Atomic Updates:** Update your OS and Kubernetes version in a single transaction.
  * **Immutability:** The OS filesystem is read-only by default, increasing security and stability.
  * **GitOps for the OS:** Manage your node configuration and OS version completely via code and CI/CD.

-----

## 🚀 Quick Start

Follow these steps to build your own bootable k0s image using GitHub Actions.

### 1\. Fork the Repository

Create your own copy of this repository to control the build pipeline.

  * Click the **Fork** button in the top-right corner of this page.

### 2\. Configure Access (SSH Keys)

To access the machine after it boots, you must inject your public SSH key during the build. We do this via GitHub Secrets.

1.  Navigate to your **Forked Repository** \> **Settings** \> **Secrets and variables** \> **Actions**.
2.  Click **New repository secret**.
3.  **Name:** `SSH_AUTHORIZED_KEYS`
4.  **Value:** Paste your public key content (e.g., from `~/.ssh/id_ed25519.pub`).
      * *Example:* `ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH... user@hostname`
      * *Tip:* You can add multiple keys by pasting them one per line.
5.  Click **Add secret**.

### 3\. Review `k0s.yaml`

Modify at least the `spec/api/sans` values

### 4\. Build the Image

The build process is automated via CI/CD.

  * **Trigger:** The build will automatically start when you push to the `main` branch.
  * **Manual Trigger:** Go to the **Actions** tab, select the build workflow, and click **Run workflow**.

-----

## 💿 Deployment / Installation

Once your image is built and stored in your container registry (e.g., GitHub Packages `ghcr.io`), you can install it onto bare metal or a VM.

There are generally two ways to consume this image:

### A. Install via existing Linux (bootc install)

If you are already inside a running Fedora/CentOS Stream system with `bootc` installed:

```bash
# Replace with your image URL
bootc install ghcr.io/YOUR_USERNAME/k0s-bootc:latest
```

### B. Generate a Disk Image

You can configure the pipeline (check `Containerfile` or CI settings) to output a raw disk image (ISO/qcow2) which can be flashed directly to a USB drive or mounted in a VM.

-----

## ⚙️ Customization

You can customize the OS image by modifying the `Containerfile` in this repository. Common customizations include:

  * Adding specific kernel modules.
  * Pre-installing system packages (e.g., `htop`, `vim`).
  * Configuring k0s (`k0s.yaml`).


## 🤖 Disclaimer

> **Note**: The code, templates, and configuration logic in this repository were manually crafted and tested. **Only this README file was generated/enhanced with the assistance of AI.**
