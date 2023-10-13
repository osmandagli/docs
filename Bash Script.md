# Bash Scricp Exapmle

~~~
#!/bin/bash

# $1 Deployment Or Statefulset
# $2 Namespace
# $3 NumberOfReplica
# $4 DeploymentName
option="${1}"
export fullName=
case ${option} in

        -d)
                if [ $# -eq 0 ] || [ $# -gt 4 ];
                then
                        echo " Scripti calistirmak icin;"
                        echo "                          scaler -d namespace_adi replica_sayisi deployment_ismi "
                elif [ $# -lt 3 ];
                then
                        echo " En az 3 parametre girin ( -d namespace replica deployment )"
                else
                         > /tmp/names
                        if [ -z "$4" ];
                        then
                                 > /tmp/scaler_rollback
                                export name=$(kubectl get deploy -n $2 -o name| cut -b 17-)
                                for i in $name
                                do
                                        echo "kubectl scale --replicas="$(kubectl get deployment $i -n $2 -o=jsonpath='{.status.replicas}') "deployment/"$i >> /tmp/scaler_rollback
                                done
                                echo "kubectl get deploy -n $2 -o name | xargs -I % kubectl scale % --replicas=$3 -n $2"
                        elif ! [ -z "$1" ] && ! [ -z "$2" ] && ! [ -z "$3"  ] && ! [ -z "$4" ];
                        then
                                echo "kubectl scale --replicas="$(kubectl get deployments $4 -n $2 -o=jsonpath='{.status.replicas}') $4 "-n" $2 > /tmp/scaler_rollback
                                echo "kubectl scale deployment $4 --replicas=$3 -n $2"
                        else
                                echo "quit"
                        fi
                fi
                ;;

        -s)
                if [ $# -eq 0 ] || [ $# -gt 4 ];
                then
                        echo " Scripti calistirmak icin;"
                        echo "                          scaler -s namespace_adi replica_sayisi statefulset_ismi "
                elif [ $# -lt 3 ];
                then
                        echo " En az  3 parametre girin ( -s namespace replica statefulset )"
                else
                        if [ -z "$4" ];
                        then
                                 > /tmp/scaler_rollback
                                export name=$(kubectl get statefulset -n $2 -o name| cut -b 18-)
                                for i in $name
                                do
                                        echo "kubectl scale --replicas="$(kubectl get statefulset $i -n $2 -o=jsonpath='{.status.replicas}') "sts/"$i >> /tmp/scaler_rollback
                                done
                        	echo "kubectl get statefulset -n $2 -o name | xargs -I % kubectl scale % --replicas=$3 -n $2"
                        elif ! [ -z "$1" ] && ! [ -z "$2" ] && ! [ -z "$3"  ] && ! [ -z "$4" ];
                        then
                                echo "kubectl scale --replicas="$(kubectl get statefulset $4 -n $2 -o=jsonpath='{.status.replicas}') $4 "-n" $2 > /tmp/scaler_rollback
                                echo "kubectl scale statefulset $4 --replicas=$3 -n $2"
                        else
                                echo "quit"
                        fi
                fi
                ;;

        *)
                echo "Scripti Kullanmak için;"
                                echo " Deploy scale için:       scaler -d  "
                                echo " Statefulset scale için:  scaler -s  "
                                ;;
esac



~~~
