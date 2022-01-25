#!/usr/bin/env bash
set -euo pipefail

amixer set Master toggle
~/.dwm/dwm-status-refresh.sh
