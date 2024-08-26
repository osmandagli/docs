# CKA

### Pre Setup

    export do="--dry-run=client -o yaml"
    export now="--grace-period=0 --force"

vim

    set tabstop=2
    set expandtab
    set shiftwidth=2

### kubectl commands 

To get all contexts names
```
kubectl config get-contexts -o name
```

To get current context
```
kubectl config current-context
```

To scale up or down
```
kubectl -n default scale sts <sts_name> --replicas=2 
```

To sort by
```
kubectl get pods -A --sor-by='.metadata.creationTimestamp'
```

To get api resources names which are namespaced

    kubectl api-resources --namespaced -o name



### Taint and Tolerations

```
tolerations:
  - key: node-role.kubernetes.io/control-plane
    effect: NoSchedule
    operator: Exists
nodeSelector:
  node-role.kubernetes.io/control-plane: ""
```

### Liveness and Readiness Probe


```
livenesProbe:
  exec:
    command:
      - 'true'
readinessProbe:
  exec:
    command:
      - 'wget -T2 -O- http://service-am-i-ready:80'
```

### PV and PVC

PV

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: my-pv
spec:
  storageClassName: ""
  capacity:
    storage: 50Mi
  accessModes:
  - ReadWriteOnce
  hostPath:
    path: "/Volumes/Data"
```

PCV

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
  namespace: default
spec:
  storageClassName: ""
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 50Mi
```

In Pod Definition yaml

```
spec:
  container:
  - name: test
    image: nginx:alpine
    volumeMounts:
    - name: my-pvc
      mountPath: /tmp/my-pvc
  volumes:
  - name: my-pvc
    persistentVolumeClaim:
      claimName: my-pvc
```

### RBAC

Create Service Account

```
kubectl create sa process
```

Create Role

```
kubeclt create role --verb=create,delete,list --resource=cm,secrets,pods --namespace default
```

Create Role Binding

```
kubectl create rolebinding --serviceaccount=default:process --role=process process
```

Test Service Account

```
kubectl auth can-i create secrets --as system:serviceaccount:default:process
```

### DaemondSet

To create daemon set run 

```
kubectl create deploy nginx --image=nginx:alpine --dry-run=client -o yaml > nginx.yaml
```

Then delete strategy and replicas part and change kind to DaemonSet

```
apiVersion: apps/v1
kind: DaemonSet # Changed
metadata:
  creationTimestamp: null
  labels:
    app: nginx
  name: nginx
spec:
#  replicas: 1 # Deleted
  selector:
    matchLabels:
      app: nginx
#  strategy: {} # Deleted
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: nginx
    spec:
      containers:
      - image: nginx:alpine
        name: nginx
        resources: {}
status: {}
```

### Multi Container

```
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: multi-container
  name: multi-container
spec:
  replicas: 1
  selector:
    matchLabels:
      app: multi-container
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: multi-container
    spec:
      containers:
      - image: nginx:alpine
        name: c1
        resources: {}
        volumeMounts:
        - name: common
          mountPath: /vol
      - image: busybox
        name: c2
        command: ["sh", "-c", "while true; do date >> /vol/date.log; sleep 1; done"]
        volumeMounts:
        - name: common
          mountPath: /vol
      - image: busybox
        name: c3
        command: ["sh", "-c", "tail -f /vol/date.log"]
        volumeMounts:
        - name: common
          mountPath: /vol
      volumes:
      - name: common
        emptyDir:
          sizeLimit: 500Mi
```


### Secrets

~~~
k create secret generic secret2 --from-literal user=user1 --from-literal pass=1234
~~~

    k create secret generic secret1 ........

~~~
spec: 
  container:
  - name: c1
    image: nginx:alpine  
    env:
    - name: APP_USER
      valueFrom:
        secretKeyRef:
          name: secret2
          key: user
    - name: APP_PASS
      valueFrom:
        secretKeyRef:
          name: secret2
          key: pass
  volumes:
  - name: secret1
    secret:
      secretName: secret1
~~~

















