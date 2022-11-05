#!/bin/sh

pkill spire-agent
pkill spire-server
pkill ghostunnel

set -x

echo "Cleaning data.."
rm -Rf data/spire-server/*
rm -Rf data/client-side-agent/*
rm -Rf data/server-side-agent/*
rm -Rf socks/*

echo "Spire server's coming.."
spire-server run -config conf/spire-server.conf > logs/spire-server.log 2>&1 &
sleep 2


echo "Exporting trust bundle.."
POS="conf/bundle.crt"
spire-server bundle show \
  -socketPath socks/spire-server.sock > "$POS"
echo "Trust Bundle had been save to $POS"

TOKEN=`spire-server token generate -socketPath socks/spire-server.sock -spiffeID spiffe://spiffe.dom/server-node | sed  "s/Token: //"`

echo "Starting server side agent with token $TOKEN"
spire-agent run -config conf/server-side-agent.conf -joinToken "$TOKEN"  > logs/server-side-agent.log 2>&1 &


TOKEN=`spire-server token generate -socketPath socks/spire-server.sock -spiffeID spiffe://spiffe.dom/client-node | sed  "s/Token: //"`
echo "Starting client side agent with token $TOKEN"
spire-agent run -config conf/client-side-agent.conf -joinToken "$TOKEN"  > logs/client-side-agent.log 2>&1 &

sleep 5

echo "Creating entry for ghostunnel"
spire-server entry create \
    -selector unix:path:/usr/local/bin/ghostunnel \
    -socketPath socks/spire-server.sock \
    -spiffeID spiffe://spiffe.dom/ghost \
    -parentID spiffe://spiffe.dom/server-node

echo "Creating entry for client"
spire-server entry create \
    -selector unix:uid:1000 \
    -socketPath socks/spire-server.sock \
    -spiffeID spiffe://spiffe.dom/curl \
    -ttl 600 \
    -parentID spiffe://spiffe.dom/client-node

sleep 5

echo "Ghostunnel's listening on port 9099.."
ghostunnel server \
    --use-workload-api-addr "unix://$(pwd)/socks/server-side-agent.sock" \
    --listen=0.0.0.0:9099 \
    --target=localhost:80 \
    --allow-uri=spiffe://spiffe.dom/curl > logs/ghostunnel.log 2>&1 &

#    --allow-all > logs/ghostunnel.log 2>&1 &

spire-agent api fetch --socketPath socks/client-side-agent.sock -write certs

curl -skI https://127.0.0.1:9099 --cert certs/svid.0.pem --key certs/svid.0.key
