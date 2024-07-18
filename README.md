# Jenkins on OpenShift


## Customer jenkins image with plugins
  oc patch node k8s-node-1 -p '{"spec":{"unschedulable":true}}'
  ZDBQNGtEWVQydEtoUTN4YWtpNDIySGdhVXRNbVlHYkV4dG4wNHNuaA


# OpenShift가 id/pass 인증 지원하지 않을 시 Jenkins Service Account에 token 부여

'''
oc describe sa jenkins -n jenkins
# 토큰없음

oc create token jenkins -n jenkins

해당 토큰 값으로 secret 생성
'''
https://docs.openshift.com/container-platform/4.15/nodes/pods/nodes-pods-secrets.html#nodes-pods-secrets-creating-sa_nodes-pods-secrets


# Build Jenkins
```Bash
podman pull registry.redhat.io/ubi8/openjdk-17:1.20

podman build -f gradle-dockerfile.dockerfile -t gradle-jenkins:1.0

podman run -it localhost/gradle-jenkins:1.0 /bin/sh

podman 
```

# 


Failed to pull image "quay.apps.ocp-hub.edwin.home/members/gradle-jenkins:1.0": pinging container registry quay.apps.ocp-hub.edwin.home: Get "https://quay.apps.ocp-hub.edwin.home/v2/": dial tcp: lookup quay.apps.ocp-hub.edwin.home on 192.168.31.10:53: no such host




apiVersion: quay.redhat.com/v1
kind: QuayIntegration
metadata:
  creationTimestamp: "2023-11-21T04:51:33Z"
  generation: 1
  name: quay
  resourceVersion: "33787719"
  uid: 25c03473-5a76-4bcd-a524-2e4588033a4e
spec:
  clusterID: openshift
  credentialsSecret:
    name: quay-edwin
    namespace: openshift-operators
  insecureRegistry: true
  quayHostname: https://quay-registry-quay-quay-enterprise.apps.ocp4-hub.edwin.home
