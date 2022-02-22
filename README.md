# Create cluster

`curl -s -L https://raw.githubusercontent.com/abdennour/meetup-argocd-next-level/master/bootstrap.sh | bash`

# Create sample app

`curl -s -L https://raw.githubusercontent.com/abdennour/meetup-argocd-next-level/master/bootstrap.sh | bash -s app myingress.host.com`

# Create ecosystem

- cert-manager : `sh ecosystem/cert-manager/apply`
- argocd `ecosystem/argocd/helm_apply -f 01-values.yaml`
