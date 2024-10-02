#!/usr/bin/env bash

rm /run/systemd/system/nix-daemon.service.d/proxy-override.conf
systemctl daemon-reload
systemctl restart nix-daemon
