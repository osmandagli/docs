# Grafana Alert

A cronjob fails to complete its job for more than 1 hour
~~~
sum by (cronjob) (time() - kube_cronjob_next_schedule_time > 3600)
~~~

Selects the nodes that uses %70 of its cpu
~~~
(sum by (instance) (avg by (mode, instance) (rate(node_cpu_seconds_total{mode!="idle"}[2m])))) > 0.7
~~~

Selects the pods that crashloopbackoffs three times
~~~
increase(kube_pod_container_status_restarts_total[10m]) > 3
~~~

JVM memory usage more than %80
~~~
round( 100 * sum by (pod)(jvm_memory_used_bytes) / sum by (pod) (jvm_memory_max_bytes)) > 80
~~~

If pod ir not running or completed sent an alert
~~~
sum by (namespace, pod) (kube_pod_status_phase{phase=~"Pending|Unknown|Failed"}) > 0
~~~

If a pod restarts 4 time in 4 hour sent an alert
~~~
increase(kube_pod_container_status_restarts_total[240m]) > 5
~~~

If pv is stuck at failed or pending status sent an alert
~~~
kube_persistentvolume_status_phase{phase=~"Failed|Pending", job="kube-state-metrics"} > 0
~~~

If pv is stuck at pending status sent an alert
~~~
kube_persistentvolumeclaim_status_phase{phase="Pending"} == 1
~~~


