# k0s bootc

This repository contains the recipes to build a **bootable container image** based on **bootc** for **k0s**, the simple, robust, and certified Kubernetes distribution.

This repository is forked from the [k0s image](https://gitlab.poul.org/sysadmin/system-images/k0s-bootc) built for [POuL](https://poul.org/).

## What is bootc?

**bootc** (Bootable OS Containers) is a project that allows you to build and manage bootable operating system images directly from OCI/Docker container images. This innovative approach treats the entire operating system as a container image, enabling atomic updates and rollbacks, much like how container images themselves are managed. In essence, your OS becomes versionable and immutable, increasing robustness and predictability.

## Quick Start

To get started building your bootc-based k0s image:

1.  **Fork the repository on GitHub:**
    First, you need to create your own copy of this repository. Click the "**Fork**" button in the top-right corner of this page on GitHub. This will create a copy of the repository under your GitHub account.

2.  **Set up the authorized SSH key in your forked repository:**
    To be able to SSH into the instance once the image is booted, you need to configure the `SSH_AUTHORIZED_KEYS` secret in your forked repository's settings. This variable will contain your public SSH key(s) (one per line).

    How to set the `SSH_AUTHORIZED_KEYS` secret on GitHub:
    *   Navigate to **your forked repository** on GitHub.
    *   Click on the "**Settings**" tab of the repository.
    *   In the left sidebar, go to "**Secrets and variables**" and then click on "**Actions**".
    *   Click the "**New repository secret**" button.
    *   For **Name**, enter exactly `SSH_AUTHORIZED_KEYS`.
    *   For **Value** or **Secret**, paste the content of your public SSH key. This is usually found in `~/.ssh/id_rsa.pub`, `~/.ssh/id_ed25519.pub`, or a similar file with a `.pub` extension in your `~/.ssh/` directory.
        *   Example content: `ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH পিছিয়েAbcDefGhiJklMnoPqRsTuVwXyz1234567890 user@hostname`
        *   If you have multiple keys you want to authorize, paste them one per line.
    *   Click "**Add secret**".

3.  **Start the build:**
    Once the secret is configured in your forked repository, the image build will typically be handled by the CI/CD pipeline (e.g., GitHub Actions) set up in the repository. Usually, a `git push` of your changes (if you've made any to your fork) or a manual workflow dispatch (if configured) will trigger the image construction.
