# ansible-kube

```bash
kubectl apply -f kubernetes-dashboard-service-np.yaml
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
```
