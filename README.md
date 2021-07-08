# remove-evicted-pod
This docker image will run as a Job which will remove the Evicted pods


# run Evicted pod script as container
docker container run -it --name evicted-pod-container -v /user/kube-config:/root/.kube/config cloudxperts/evicted-pod-remove

# run Evicted pod script as daemon

docker container run -d --name evicted-pod-container -v /user/kube-config:/root/.kube/config cloudxperts/evicted-pod-remove

Note: valid kube config needs to be mounted as a volume.

```
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  namespace: pod-eviction-ns
  name: evictedpodremoval-job
  labels:
    name: evictedpodremoval-job-stag
spec:
  schedule: "*/30 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: evictedpodremoval-pod
            image: fareportal.azurecr.io/evicted-pod-remove
            volumeMounts:
            - name: kubesecret
              mountPath: "/root/.kube"
              readOnly: true
          restartPolicy: Never
          imagePullSecrets:
          - name: acr-auth-evictedpod
          volumes:
          - name: kubesecret
            secret:
              secretName: evictedpodremoval-stag-secret
              items:
              - key: config
                path: config
```
