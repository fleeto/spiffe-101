#!/bin/sh

source 00-clean.sh

set -x

source 01-spire-server.sh

source 02-spire-agents.sh

sleep 5

source 03-ghostunnel.sh

echo "Creating entry for client"
spire-server entry create \
    -selector unix:uid:`id -u` \
    -socketPath tmp/socks/spire-server.sock \
    -spiffeID spiffe://spiffe.dom/curl \
    -ttl 600 \
    -parentID spiffe://spiffe.dom/client-node

sleep 5

spire-agent api fetch --socketPath tmp/socks/client-side-agent.sock -write tmp/certs

curl -skI https://127.0.0.1:9099 --cert tmp/certs/svid.0.pem --key tmp/certs/svid.0.key
