# remove-evicted-pod
This docker image will run as a Job which will remove the Evicted pods


# run Evicted pod script as container
docker container run -it --name evicted-pod-container -v /user/kube-config:/root/.kube/config cloudxperts/evicted-pod-remove

# run Evicted pod script as daemon

docker container run -d --name evicted-pod-container -v /user/kube-config:/root/.kube/config cloudxperts/evicted-pod-remove

Note: valid kube config needs to be mounted as a volume.
