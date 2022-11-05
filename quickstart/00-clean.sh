#!/bin/sh

mkdir -p data/spire-server \
    data/client-side-agent \
    data/server-side-agent \
    certs \
    conf \
    logs \
    socks \


echo "Killing processes"
pkill spire-agent
pkill spire-server
pkill ghostunnel

echo "Cleaning data.."
rm -Rf data/spire-server/*
rm -Rf data/client-side-agent/*
rm -Rf data/server-side-agent/*
rm -Rf socks/*

mkdir -p 