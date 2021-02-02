#!/usr/bin/env bash
set -euo pipefail

amixer -qM set Master 2%- umute
~/.dwm/dwm-status-refresh.sh
