# Use an official lightweight image with dependencies
FROM debian:bullseye

# Set environment variables
ENV KUBECTL_VERSION=v1.27.3
ENV MINIKUBE_VERSION=v1.30.1
ENV HELM_VERSION=v3.13.2

# Install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    apt-transport-https \
    ca-certificates \
    gnupg \
    socat \
    conntrack \
    iproute2 \
    git \
    docker.io \
    && rm -rf /var/lib/apt/lists/*

# Install Minikube
RUN curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64 \
    && install minikube-linux-amd64 /usr/local/bin/minikube \
    && rm minikube-linux-amd64

# Install SOPS
RUN curl -LO https://github.com/getsops/sops/releases/download/v3.9.4/sops-v3.9.4.linux.amd64 \
    && mv sops-v3.9.4.linux.amd64 /usr/local/bin/sops \
    && chmod +x /usr/local/bin/sops
RUN apt install git
# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh \
    && rm get_helm.sh

# Expose Minikube's default ports
EXPOSE 8443 2379 2380 10250 10251 10252

# Command to start Minikube
CMD ["minikube", "start", "--driver=docker"]
