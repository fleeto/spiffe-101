#!/bin/sh

./00-clean.sh

set -x

./01-spire-server.sh

./02-spire-agents.sh