~~~
echo "kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: manual
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer" > sc-manual.yaml
~~~

~~~
echo "apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-nexus
spec:
  storageClassName: manual
  capacity:
    storage: 8Gi
  accessModes:
  - ReadWriteOnce
  claimRef:
    namespace: nexus
    name: pvc-nexus
  hostPath:
    path: /data/nexus" > pv-nexus.yaml
~~~

~~~
echo "apiVersion: v1
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
      storage: 8Gi" > pvc-nexus.yaml
~~~
