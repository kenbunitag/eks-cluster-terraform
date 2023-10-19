# Introduction
Argocd is a software that scans a configured git-repo where Kubernetes-Application-Configuration files are stored and applies changes to the kubernetes-cluster. Basically a build-server for kubernetes-apps and their configuration.

Argocd should already be installed when the terraform-example was applied. There are however two manual steps, that must be done to configure the argocd-server.

# 2 Preparations
The first step is to tell argocd how to authenticate to a given git-repository. This is done via a secret:
take a look at the file argocd-repo.yaml. 
```
apiVersion: v1
kind: Secret
metadata:
  name: placid-eks-argocd-test
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  url: ssh://git@github.com/kenbunitag/placid-eks-argocd-test.git
  sshPrivateKey: |
    -----BEGIN RSA PRIVATE KEY-----
  ...
  ...
    -----END RSA PRIVATE KEY-----
  insecure: "false" # Do not perform a host key check for the server. Defaults to "false"
  enableLfs: "false" # Enable git-lfs for this repository. Defaults to "false"
```
Here we give argocd the information that to access the repository "ssh://git@github.com/kenbunitag/placid-eks-argocd-test.git" this private ssh-key shall be used.

This file can be applied with "kubectl apply -f argocd-repo.yaml" into the argocd-namespace.

Second we have to define where it should poll for the configuration data. Take a look at argocd-root.yaml
```
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
name: argocd
namespace: argocd
spec:
destination:
name: ''
namespace: argocd
server: 'https://kubernetes.default.svc'
source:
path: .
repoURL: 'git@github.com:kenbunitag/placid-eks-argocd-test.git'
targetRevision: main
project: default
syncPolicy:
automated:
selfHeal: true
```
Here is the main-repo-url defined as well as the branch it should use (in targetRevision)

Please change the urls and keys for your repository and apply this as well with "kubectl apply -f argocd-root.yaml"

I provided an example for a argocd-github-repository in the directory argocd-repo-example, along with some sample-projects and a first configuration for elastic-stack. Beware: The example-configs, especially the ingress-information should be amended with your subdomain.

So for example in: 3-argocd/argocd-repo-example/sample-projects/echoserver/ingress.yaml
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS":443}]'
  name: echoserver
spec:
  ingressClassName: alb
  tls:
  - hosts:
    - echoserver.eks.kenbun.de
  rules:
  - host: echoserver.eks.kenbun.de
    http:
      paths:
      - path: /
        backend:
          service:
            name: echoserver
            port:
              number: 80
        pathType: Prefix
```
should be changed to use your sub-domain instead of ".eks.kenbun.de"

Login to argocd (use the configured hostname from the terraform-config) with user "admin". The password can be looked up with :
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
The Screen should look like this, if you use the contents argocd-repo-example in your the argocd-ops-repo.

![Argocd](img/argocd-1.png)

Feel free to explore the examples, for example the elastic-cluster:

![](img/argocd-elastic.png)

Or with the node-view:

![](img/argocd-elastic-nodes.png)
