#!/bin/bash
# ======================================================
# NVIDIA Container Toolkit Installation Script
# ======================================================
# This script installs the NVIDIA Container Toolkit and
# configures the NVIDIA Docker repository on Ubuntu/Debian.
# ======================================================

echo "=== Updating system and installing dependencies ==="
sudo apt-get update && sudo apt-get install -y --no-install-recommends \
  curl \
  gnupg2

echo "=== Adding NVIDIA Container Toolkit repository ==="
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | \
  sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo sed -i -e '/experimental/ s/^#//g' /etc/apt/sources.list.d/nvidia-container-toolkit.list

echo "=== Updating APT sources ==="
sudo apt-get update

echo "=== Installing NVIDIA Container Toolkit version 1.18.0-1 ==="
export NVIDIA_CONTAINER_TOOLKIT_VERSION=1.18.0-1
sudo apt-get install -y \
  nvidia-container-toolkit=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
  nvidia-container-toolkit-base=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
  libnvidia-container-tools=${NVIDIA_CONTAINER_TOOLKIT_VERSION} \
  libnvidia-container1=${NVIDIA_CONTAINER_TOOLKIT_VERSION}

echo "=== Configuring NVIDIA Docker repository ==="
distribution=$(. /etc/os-release; echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list

echo "=== Final update ==="
sudo apt-get update

echo "Installation complete! You can now install and use nvidia-docker."

supervisorctl reload
