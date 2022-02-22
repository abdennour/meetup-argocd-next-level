#!/bin/sh
## @author abdennour

## arg $1 what to bootstrap . Possible values: cluster(default), app

what=${1:-"cluster"};
apphost=${2:-"sample.k8s.tn"};
appnamespace=sample

function install_helm()
{
  echo " > installing helm ..."
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
  chmod 700 get_helm.sh
  ./get_helm.sh
  kubectl config view --raw >~/.kube/config
  echo " > helm installed !"
}

if [ "${what}" = "cluster" ]; then
  echo installing lightweight k8s...
  curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644

  # some luxury
  echo 'source <(kubectl completion bash)' >>~/.bashrc
  echo 'alias k=kubectl' >>~/.bashrc
  echo 'complete -F __start_kubectl k' >>~/.bashrc
  source ~/.bashrc
  sleep 5
  echo "cluster installed !"
  kubectl get nodes

  echo "INSTALL other utils"
  install_helm
fi


if [ "${what}" = "app" ]; then
  kubectl create ns $appnamespace --dry-run=client -o yaml | kubectl apply -f-
  kubectl -n $appnamespace create deployment sample --image=abdennour/sample-app:v1 --port 80  --dry-run=client -o yaml | kubectl apply -f-
  kubectl -n $appnamespace expose deployment sample   --dry-run=client -o yaml | kubectl apply -f-
  kubectl -n $appnamespace apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: sample
spec:
  rules:
  - host: "${apphost}"
    http:
      paths:
      - pathType: Prefix
        path: "/"
        backend:
          service:
            name: sample
            port:
              number: 80

EOF

  echo CONGRATS 🎉 ! Your app is ready. Check http://${apphost} Or inside cluster run: curl -H \"Host: ${apphost}\" http://localhost
fi
