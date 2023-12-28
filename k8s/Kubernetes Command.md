# Kubernetes Commands

If Kubernetes namespace got stuck at the terminating state

~~~~
kubectl get namespace "stucked-namespace" -o json \
  | tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/" \
  | kubectl replace --raw /api/v1/namespaces/stucked-namespace/finalize -f -
~~~~

Add, modify, or remove labels on a resource.

~~~~
kubectl label <resoruce-type> <resource-name> <label-name>=<label-value>
kubectl label pod pod01 app=nginx 
~~~~

Display resource usage for nodes or pods

~~~~
kubectl top node
~~~~

Copy files and directories to and from containers pod and host can change places. Example shows copying file pod to host.

~~~~
kubectl cp <pod-name>:<container-name> <host-path> --container=<container-name>
~~~~

To scale all deployments to specific replicas
~~~
k get deploy -n $namespace | grep -v NAME |awk '{print "k scale --replicas=$desired_count deployment/" $1 " -n $namespace"}'
~~~

If the replica count equals 2 scale to 3
~~~
k get deploy -n $namespace | grep -v NAME |awk '{print "k scale --current-replicas=2 --replicas=3 deployment/" $1 " -n $namespace"}'
~~~

Describe all master nodes
~~~
k get nodes | grep control-plane | awk '{print "kubectl describe node",$1}' | sh
~~~

## HELM

To install or upgrade packages
~~~
helm install/upgrade <given_name> <repository-name/chart-name> -n <namespace_to_deploy>
~~~
