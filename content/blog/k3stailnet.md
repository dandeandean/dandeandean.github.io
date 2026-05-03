+++
title = "K3s over Tailnet"
description = "Home Away From Home Lab"
sort_by = "date"
paginate_by = 5
insert_anchor_links = "right"
date = "2026-03-02"
+++
# K3s over Tailnet

I set my home lab is set up with K3s.
This is great, but I'd like to access it from not just inside my dungeon.

To make this happen, I set up the network with [Tailscale](https://tailscale.com/).
With a NixOS, this is dirt-simple:
```nix
{ lib, config, ... }: {
  options = { tailscale.enable = lib.mkEnableOption "Enable Tailscale"; };
  config = { services.tailscale.enable = config.tailscale.enable; };
}
```

I added the Tailnet IP to the  `~/.kube/config`.
```yaml
apiVersion: v1
clusters:
- cluster:
    server: https://<Tailnet IP>:6443
  name: default
```

`kubectl get nodes`...
```bash
Unable to connect to the server: tls: failed to verify certificate: x509: certificate is valid for <Internal IP>
not <Tailnet IP>
```
D:
Lets make sure we can actually reach the nodes over the Tailnet...
```bash

$ k get nodes --insecure-skip-tls-verify
NAME       STATUS   ROLES                       AGE   VERSION
leonardo   Ready    <none>                      9d    v1.34.1+k3s1
raphael    Ready    <none>                      20d   v1.32.4+k3s1
splinter   Ready    control-plane,etcd,master   95d   v1.32.7+k3s1
```

Yeah seems like we can.

After a bit more reading, it looks like we need to [rotate the cert for the new IP](https://docs.k3s.io/cli/certificate#rotating-client-and-server-certificates)
Luckily there's nothing important running on this cluster!

Let's just restart the master node... And nothing.

---
After a bit more digging, this issue looks promising [Remote Kubectl](https://github.com/k3s-io/k3s/issues/1381)

We need to edit the `k3s-serving` secret in the `kube-system` to include the new Tailnet IP of the master node.
```yaml 
kind: Secret
metadata:
  annotations:
    listener.cattle.io/cn-<Internal IP>: 10.0.0.10
    listener.cattle.io/cn-<Tailnet IP>: 10.43.0.1
```

After modifying the cluster secret and `k3s regenerate certificates`, we are back in business.
```bash
$ k get nodes
NAME        STATUS   ROLES                       AGE    VERSION
donatello   Ready    <none>                      8d     v1.32.4+k3s1
leonardo    Ready    <none>                      30d    v1.34.1+k3s1
raphael     Ready    <none>                      41d    v1.32.4+k3s1
splinter    Ready    control-plane,etcd,master   116d   v1.32.7+k3s1
```

---
## Future Me
Is this reproducible? Probably not.
Since the certs are already generated for the master node, I didn't feel like going through the exercise of completely bootstrapping the cluster again to test a reproducible setup with the new IP.
To test this, we could add the following to the cluster settings.
```nix
if config.isK3sNode.isServer then [ "-tls-san=${hostTailIP}" ] else [ ];
```
