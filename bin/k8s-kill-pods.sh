kubectl get pods -n $2 --no-headers=true | awk -v regex=$1 '/regex/{print $1}' | xargs kubectl delete -n $2 pod
