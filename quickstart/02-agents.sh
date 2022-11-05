#!/bin/sh

TOKEN=`spire-server token generate -socketPath socks/spire-server.sock -spiffeID spiffe://spiffe.dom/server-node | sed  "s/Token: //"`

echo "Starting server side agent with token $TOKEN"
spire-agent run -config conf/server-side-agent.conf -joinToken "$TOKEN"  > logs/server-side-agent.log 2>&1 &


TOKEN=`spire-server token generate -socketPath socks/spire-server.sock -spiffeID spiffe://spiffe.dom/client-node | sed  "s/Token: //"`
echo "Starting client side agent with token $TOKEN"
spire-agent run -config conf/client-side-agent.conf -joinToken "$TOKEN"  > logs/client-side-agent.log 2>&1 &
