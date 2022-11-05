#!/bin/sh
echo "Spire server's coming.."
spire-server run -config conf/spire-server.conf > logs/spire-server.log 2>&1 &

sleep 2

echo "Exporting trust bundle.."
POS="/tmp/bundle.crt"
spire-server bundle show \
  -socketPath socks/spire-server.sock > "$POS"
echo "Trust Bundle had been save to $POS"
