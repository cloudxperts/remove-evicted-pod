# This Project is maintained by cloudxperts.guru
FROM centos:7
LABEL maintainer="cloudxperts <cloudxperts.main@gmail.com>"
RUN yum update -y && mkdir -p /root/.kube && touch /root/.kube/config; \
    mkdir -p /opt/evicted_pod/logs; \
	 touch /opt/evicted_pod/logs/podEviction.log
COPY kubernetes.repo /etc/yum.repos.d/kubernetes.repo
RUN yum install -y kubectl --disableexcludes=kubernetes;
WORKDIR /opt
COPY evicted-pod-removal.sh .
VOLUME /opt/evicted_pod
RUN ln -sf /dev/stdout /opt/evicted_pod/logs/podEviction.log
CMD ["sh", "/opt/evicted-pod-removal.sh"]
