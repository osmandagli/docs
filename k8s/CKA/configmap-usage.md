apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod1
  name: pod1
spec:
  containers:
  - image: nginx:alpine
    name: pod1
    resources: {}
    env:
    - name: TREE1
      valueFrom:
        configMapKeyRef:
          name: trauerweide
          key: tree
    volumeMounts:
    - name: birke
      mountPath: /etc/birke
  volumes:
  - name: birke
    configMap:
      name: birke
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
