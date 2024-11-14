# DevZero Self Hosted Charts

## Installation

```bash
helm install dz-data-plane oci://public.ecr.aws/v1i4e1r2/charts/dz-data-plane \
  -n devzero-self-hosted \
  --version 0.1.0 \
  --set vault.approle.secretId=<VAULT_APPROLE_SECRET_ID> \
  --set cedana-helm.cedanaConfig.signozAccessToken=<CEDANA_SIGNOZ_ACCESS_TOKEN> \
  --set cedana-helm.cedanaConfig.cedanaAuthToken=<CEDANA_AUTH_TOKEN>
```

## Configuration

The cluster has a node labeler DaemonSet that labels all nodes with the following labels:

- "node-role.kubernetes.io/devpod-node"=1
- "node-role.kubernetes.io/vcluster-node"=1
- "node-role.kubernetes.io/rook-node"=1

This means that all nodes in the cluster will be able to run Workspaces, Clusters, and Storage.

To separate resources into different node groups, disable the node labeler DaemonSet and label nodes manually:

```bash
--set sysbox.nodeLabeler.enabled=false
```