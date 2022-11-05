#!/bin/sh

echo "Cleaning data"
rm -Rf tmp
mkdir -p tmp/data/spire-server \
    tmp/data/client-side-agent \
    tmp/data/server-side-agent \
    tmp/certs \
    tmp/conf \
    tmp/logs \
    tmp/socks

echo "Killing processes"
pkill spire-agent
pkill spire-server
pkill ghostunnel
