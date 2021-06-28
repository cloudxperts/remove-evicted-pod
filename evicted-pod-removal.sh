## This Project is maintained by cloudxperts.guru
## version v1.0.0
## Licence: MIT Licence
#!/bin/bash
export EVICTED_LOG_DIR=/opt/evicted_pod/logs
export EVICTED_REPORT_DIR=/opt/evicted_pod/info

if [ ! -d $EVICTED_LOG_DIR ]
then
    mkdir -p $EVICTED_LOG_DIR
fi
if [ ! -d $EVICTED_REPORT_DIR ]
then
    mkdir -p $EVICTED_REPORT_DIR
fi

export EVICTED_POD_COUNT=`kubectl get pods --all-namespaces | grep -w 'Evicted' | wc -l`
export EVICTED_POD_DELETION_DATE_TIME=$(date +%F_%H%M)
echo "`date` - Running the pod eviction script" >> $EVICTED_LOG_DIR/podEviction_$EVICTED_POD_DELETION_DATE_TIME.log
if [ $EVICTED_POD_COUNT -ge 1 ]
then
    echo "`date` - Number of pods to evict: $EVICTED_POD_COUNT" >> $EVICTED_LOG_DIR/podEviction_$EVICTED_POD_DELETION_DATE_TIME.log
    echo "`date` - Storing the evicted pod information in evicted_pod_${EVICTED_POD_DELETION_DATE_TIME}.csv file" >> $EVICTED_LOG_DIR/podEviction_$EVICTED_POD_DELETION_DATE_TIME.log
    kubectl get pods --all-namespaces | grep -wE 'Evicted|NAMESPACE' | tr -s " " "," > $EVICTED_REPORT_DIR/evicted_pod_${EVICTED_POD_DELETION_DATE_TIME}.csv
    echo "`date` - Removing all the evicted pod from cluster" >> $EVICTED_LOG_DIR/podEviction_$EVICTED_POD_DELETION_DATE_TIME.log
    for namespace in $(kubectl get namespace | grep -w 'Active' | grep -v kube-system | awk '{print $1}')
    do
        EVICTED_POD_COUNT_NAMESPACE=$(kubectl get pods --namespace $namespace | grep -w 'Evicted' | wc -l)
        if [ $EVICTED_POD_COUNT_NAMESPACE -ge 1 ]
        then
                kubectl delete pod --namespace $namespace $(kubectl get pods --namespace $namespace | grep -w 'Evicted' | awk '{print $1}' ) >> $EVICTED_LOG_DIR/podEviction_deleted_$EVICTED_POD_DELETION_DATE_TIME.log
                if [ $? -eq 0 ]
                then
                        echo "`date` - Script executed successfully for $namespace" >> $EVICTED_LOG_DIR/podEviction_$EVICTED_POD_DELETION_DATE_TIME.log
                else
                        echo "`date` - Script executed with error for $namespace." >> $EVICTED_LOG_DIR/podEviction_$EVICTED_POD_DELETION_DATE_TIME.log
                fi
        else
                echo "`date` - No pods are in evicted status for $namespace" >> $EVICTED_LOG_DIR/podEviction_$EVICTED_POD_DELETION_DATE_TIME.log
        fi
    done
else
    echo "`date` - Pods Evicted: $EVICTED_POD_COUNT" >> $EVICTED_LOG_DIR/podEviction_$EVICTED_POD_DELETION_DATE_TIME.log
    echo "`date` - No Action Needed." >> $EVICTED_LOG_DIR/podEviction_$EVICTED_POD_DELETION_DATE_TIME.log
fi

echo "`date` - Completed the script." >> $EVICTED_LOG_DIR/podEviction_$EVICTED_POD_DELETION_DATE_TIME.log

if [ -f $EVICTED_LOG_DIR/podEviction_$EVICTED_POD_DELETION_DATE_TIME.log ]
then
   cp $EVICTED_LOG_DIR/podEviction_$EVICTED_POD_DELETION_DATE_TIME.log $EVICTED_LOG_DIR/podEviction.log
fi