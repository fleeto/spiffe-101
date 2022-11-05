#!/bin/sh
echo "Spire server's coming.."
spire-server run -config conf/spire-server.conf > tmp/logs/spire-server.log 2>&1 &

sleep 2

echo "Exporting trust bundle.."
POS="tmp/certs/bundle.crt"
spire-server bundle show \
  -socketPath tmp/socks/spire-server.sock > "$POS"
echo "Trust Bundle had been save to $POS"
