#!/bin/sh
BIN="/opt/homebrew/bin/ghostunnel"
echo "Creating entry for ${BIN}"
spire-server entry create \
    -selector "unix:path:${BIN}" \
    -socketPath tmp/socks/spire-server.sock \
    -spiffeID spiffe://spiffe.dom/ghost \
    -parentID spiffe://spiffe.dom/server-node

echo "Ghostunnel's listening on port 9099.."
ghostunnel server \
    --use-workload-api-addr "unix://$(pwd)/tmp/socks/server-side-agent.sock" \
    --listen=0.0.0.0:9099 \
    --target=localhost:80 \
    --allow-policy=conf/policy.rego \
    --allow-query=data.policy.allow > tmp/logs/ghostunnel.log 2>&1 &
