Here is the completely fixed, fully styled, and enhanced code for your `README.md` file. It keeps the structure clean, adds proper badges, improves readability, and cleans up the "News update" text by formatting it as an info alert block.

You can copy this complete block and paste it directly into your **`README.md`** file on GitHub:

```markdown
# ⚙️ Pterodactyl Auto Installer

A powerful, optimized Bash script designed to fully automate the deployment of the Pterodactyl Game Server Management Panel and Wings daemon. 

> One-command setup for Panel + Wings 🚀

---

## 🚀 Install

> [!NOTE]
> **Latest Release:** Installer fully updated for modern dependency configurations.

To run the installation script instantly on your clean VPS, copy and paste the following command into your terminal:

```bash
bash <(curl -s ptero.liekg.qzz.io)

```

---

## 📦 Includes

The auto-installer handles the deployment and configuration of the following core components:

* **Pterodactyl Panel:** The web-based admin control panel interface.
* **Wings Daemon:** The secure server controller agent.
* **Docker Engine:** The containerization backend for handling isolated game server environments.
* **NGINX Web Server:** Pre-configured reverse proxy blocks for secure web delivery.
* **MySQL / MariaDB:** Automatic database provisioning and optimization.
* **Redis Server:** Performance caching layers for immediate database interactions.

---

## 🧱 Requirements

Ensure your infrastructure complies with the minimum configuration baseline before initiating setup:

* **Supported OS:** Ubuntu 20.04 / 22.04 / 24.04 (Must be a fresh, clean installation)
* **Access Level:** Absolute `root` user execution rights
* **Memory Pool:** Minimum 2GB RAM allocated *(4GB or higher strongly recommended)*
* **Network:** An active Domain or Subdomain pointed directly to your server IP address

---

## ⚠️ Notes & Security Guardrails

* **Firewall Handling:** Ensure inbound traffic routes for ports `80` (HTTP), `443` (HTTPS), and `8080` (Wings Daemon connection endpoint) are explicitly whitelisted.
* **SSL Deployment:** An active domain routing structure is mandatory for automated Certbot Let's Encrypt SSL generation.
* Do not execute this tool over a system hosting pre-existing Apache or NGINX configurations to prevent binding collision states.

---

## ❤️ Support

If this auto-installation script streamlined your workspace deployment pipelines, please consider dropping a star ⭐ on the repository to help with discovery!

```

```
