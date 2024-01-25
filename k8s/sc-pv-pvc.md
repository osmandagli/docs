~~~
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: manual
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
~~~

~~~
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-log
spec:
  accessModes:
  - ReadWriteMany
  hostPath:
    path: /pv/log
    type: DirectoryOrCreate
  persistentVolumeReclaimPolicy: Retain
  capacity:
    storage: 100Mi
~~~

~~~
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-nexus
  namespace: nexus
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 8Gi
~~~
