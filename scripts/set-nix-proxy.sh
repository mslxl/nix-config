#!/usr/bin/env bash

PROXY=$1

mkdir -p /run/systemd/system/nix-daemon.service.d/
tee /run/systemd/system/nix-daemon.service.d/proxy-override.conf <<EOF
[Service]
Environment="http_proxy=$PROXY"
Environment="https_proxy=$PROXY"
Environment="all_proxy=$PROXY"
EOF
systemctl daemon-reload
systemctl restart nix-daemon
