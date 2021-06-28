# This Project is maintained by cloudxperts.guru
FROM centos:7
LABEL maintainer="CloudXperts.guru <cloudxperts.main@gmail.com>"
RUN yum update -y && mkdir -p /root/.kube && touch /root/.kube/config
WORKDIR /opt
COPY evicted-pod-removal.sh .
VOLUME /opt/evicted_pod
RUN ln -sf /dev/stdout /opt/evicted_pod/logs/podEviction.log
CMD ["sh", "/opt/evicted-pod-remobal.sh"]