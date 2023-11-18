# Creating Cluster with kubeadm (Ubuntu)

Install required tools
~~~
sudo apt update && apt-get -y upgrade
sudo apt install -y curl wget net-tools gnupg2 software-properties-common apt-transport-https ca-certificates
~~~

Disable and close firewall
~~~
sudo systemctl stop ufw
sudo systemctl disable ufw
~~~

Disable swap, and delete the swap line in the /etc/fstab
~~~
sudo swapoff -a
sudo vi /etc/fstab
~~~

~~~
sudo tee /etc/modules-load.d/k8s.conf <<EOF
overlay
br_netfilter
EOF
~~~

To install these modules to running systems
~~~
sudo modprobe overlay
sudo modprobe br_netfilter
~~~

Copy the network config for kubernetes
~~~
sudo vi /etc/sysctl.d/k8s.conf
~~~
~~~
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward=1
net.ipv4.tcp_max_syn_backlog=40000
net.core.somaxconn=40000
net.core.wmem_default=8388608
net.core.rmem_default=8388608
net.ipv4.tcp_sack=1
net.ipv4.tcp_window_scaling=1
net.ipv4.tcp_fin_timeout=15
net.ipv4.tcp_keepalive_intvl=30
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_moderate_rcvbuf=1
net.core.rmem_max=134217728
net.core.wmem_max=134217728
net.ipv4.tcp_mem=134217728 134217728 134217728
net.ipv4.tcp_rmem=4096 277750 134217728
net.ipv4.tcp_wmem=4096 277750 134217728
net.core.netdev_max_backlog=300000
~~~

To apply all the config we have changed.
~~~
sudo sysctl --system
sudo lsmod | grep br_netfilter
sudo apt update
~~~
Add docker repo for containerd
~~~
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
~~~

Install containerd
~~~
sudo apt install -y containerd.io
~~~

Configure containerd
~~~
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
~~~

Restart and start containerd
~~~
sudo systemctl restart containerd
sudo systemctl enable containerd
systemctl status containerd
~~~


Creating kubernetes repo list
~~~
curl -fsSL  https://packages.cloud.google.com/apt/doc/apt-key.gpg|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/k8s.gpg
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
~~~

Install kubernetes cluster packages and stop them getting auto updates
~~~
sudo apt -y install kubelet=1.24.10-00 kubeadm=1.24.10-00 kubectl=1.24.10-00
sudo apt-mark hold kubelet kubeadm kubectl
~~~


~~~
sudo apt -y install kubelet=1.26.0-00 kubeadm=1.26.0-00 kubectl=1.26.0-00
sudo apt-mark hold kubelet kubeadm kubectl
~~~

Check if kubelet and kubeadm is installed correctly
~~~
kubectl version --client && kubeadm version
~~~

~~~
#Master sunucu kurulumu
sudo kubeadm init --service-cidr "10.95.0.0/12" --pod-network-cidr "10.244.0.0/16" --upload-certs
~~~

To make master nodes worker
~~~
#All masters
kubectl  taint nodes --all node-role.kubernetes.io/master:NoSchedule-
kubectl taint nodes --all node-role.kubernetes.io/control-plane:NoSchedule-

#One specific master
kubectl taint nodes MASTERNODENAME node-role.kubernetes.io/master:NoSchedule-
kubectl taint nodes MASTERNODENAME node-role.kubernetes.io/control-plane:NoSchedule-
~~~

To take worker duty bak from master
~~~
#All masters
kubectl taint nodes --all node-role.kubernetes.io/master:NoSchedule
kubectl taint nodes --all node-role.kubernetes.io/control-plane:NoSchedule

#One specific master
kubectl taint nodes MASTERNODENAME node-role.kubernetes.io/master:NoSchedule
kubectl taint nodes MASTERNODENAME node-role.kubernetes.io/control-plane:NoSchedule
~~~

To join a worker node, apply this command in a master node and print the output of this command to 
~~~
sudo kubeadm token create --print-join-command
~~~

Install calico networking
~~~
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.3/manifests/tigera-operator.yaml
~~~

flannel networking
~~~
kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml
~~~

Install nerdctl
~~~
wget https://github.com/containerd/nerdctl/releases/download/v1.7.0/nerdctl-1.7.0-linux-amd64.tar.gz
tar Cxzvf /usr/local nerdctl-1.7.0-linux-amd64.tar.gz
~~~



