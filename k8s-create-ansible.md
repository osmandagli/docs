---
tags: [k8s]
title: Kubernetes Creatation with Ansible
created: '2023-10-14T18:55:24.110Z'
modified: '2023-11-18T13:03:53.856Z'
---

# Kubernetes Creatation with Ansible
~~~
- name: Kubernetes Cluster Deployment
  hosts: all
  become: true
  tasks:
    #- name: update and upgrade
    #  ansible.builtin.apt:
    #    upgrade: yes
    #    update_cache: yes
    - name: install required packages
      ansible.builtin.apt:
       name: 
         - curl 
         - wget
         - net-tools
         - gnupg2
         - software-properties-common 
         - apt-transport-https
         - ca-certificates
    - name: write the modules to be downloaded
      ansible.builtin.shell:
        cmd: echo "overlay\nbr_netfilter" > /etc/modules-load.d/k8s.conf
    - name: install the modules
      ansible.builtin.shell:
       cmd: modprobe overlay && modprobe br_netfilter
    - name: install network config
      ansible.builtin.shell:
       cmd: echo "net.bridge.bridge-nf-call-ip6tables = 1\nnet.bridge.bridge-nf-call-iptables = 1\nnet.ipv4.ip_forward=1\nnet.ipv4.tcp_max_syn_backlog=40000\nnet.core.somaxconn=40000\nnet.core.wmem_default=8388608\nnet.core.rmem_default=8388608\nnet.ipv4.tcp_sack=1\nnet.ipv4.tcp_window_scaling=1\nnet.ipv4.tcp_fin_timeout=15\nnet.ipv4.tcp_keepalive_intvl=30\nnet.ipv4.tcp_tw_reuse=1\nnet.ipv4.tcp_moderate_rcvbuf=1\nnet.core.rmem_max=134217728\nnet.core.wmem_max=134217728\nnet.ipv4.tcp_mem=134217728 134217728 134217728\nnet.ipv4.tcp_rmem=4096 277750 134217728\nnet.ipv4.tcp_wmem=4096 277750 134217728\nnet.core.netdev_max_backlog=300000" > /etc/sysctl.d/k8s.conf && sysctl --system
    - name: update the system
      ansible.builtin.shell:
        cmd: apt update
    - name: Add apt key
      ansible.builtin.shell:
        cmd: curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    - name: add apt repository
      ansible.builtin.apt_repository:
        repo: deb [arch=amd64] https://download.docker.com/linux/ubuntu jammy stable
        state: present
    - name: install containerd
      block:
       - name: install containerd package
         ansible.builtin.apt:
           name: containerd.io
       - name: containerd config
         ansible.builtin.shell:
           cmd: mkdir -p /etc/containerd && containerd config default | sudo tee /etc/containerd/config.toml && sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
       - name: restart containerd service
         ansible.builtin.systemd:
           name: containerd
           state: restarted
       - name: start containerd service
         ansible.builtin.systemd:
           name: containerd
           state: started
    - name: install kubectl kubeadm kubelet
      block:
      - name: add k8s repo to trusted repos
        ansible.builtin.shell: 
          cmd:  curl -fsSL  https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/k8s.gpg
      - name: add repo key
        ansible.builtin.apt_key:
          url: https://packages.cloud.google.com/apt/doc/apt-key.gpg
          state: present
      - name: add k8s-xenial repo to trusted repos
        ansible.builtin.shell:
          cmd: echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
      - name: update repo
        ansible.builtin.apt:
          update_cache: yes
      - name: install packages
        ansible.builtin.apt:
          name:
            - kubectl=1.26.0-00
            - kubeadm=1.26.0-00
            - kubelet=1.26.0-00
      - name: mark-hold kubectl kubeadm kubelet
        ansible.builtin.shell:
          cmd: apt-mark hold kubelet kubeadm kubectl
    - name: kubeadm init
      ansible.builtin.shell:
        cmd: kubeadm init --service-cidr "10.95.0.0/12" --pod-network-cidr "10.244.0.0/16" --upload-certs
~~~
