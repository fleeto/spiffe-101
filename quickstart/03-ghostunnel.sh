#!/bin/sh
echo "Creating entry for ghostunnel"
spire-server entry create \
    -selector unix:path:/usr/local/bin/ghostunnel \
    -socketPath socks/spire-server.sock \
    -spiffeID spiffe://spiffe.dom/ghost \
    -parentID spiffe://spiffe.dom/server-node

echo "Ghostunnel's listening on port 9099.."
ghostunnel server \
    --use-workload-api-addr "unix://$(pwd)/socks/server-side-agent.sock" \
    --listen=0.0.0.0:9099 \
    --target=localhost:80 \
    --allow-uri=spiffe://spiffe.dom/curl > logs/ghostunnel.log 2>&1 &
