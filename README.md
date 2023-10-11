Kubernetes Commands
If kubernetes namespace got stuck at terminating state

content_copy
kubectl get namespace "stucked-namespace" -o json \
  | tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/" \
  | kubectl replace --raw /api/v1/namespaces/stucked-namespace/finalize -f -
Add, modify, or remove labels on a resource.

content_copy
kubectl label <resoruce-type> <resource-name> <label-name>=<label-value>
kubectl label pod pod01 app=nginx 
Display resource usage for nodes or pods

content_copy
kubectl top node
Copy file and directories to and from containers

content_copy
kubectl cp <pod-name>:<container-name> <host-path> --> Container to host
kubectl cp <host-path> <pod-name>:<container-name> --> Host to container
HELM
helm install <given_name> <repository-name/chart-name> -n <namespace_to_deploy>
