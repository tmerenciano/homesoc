#!/bin/bash
apt update && apt install -y fish && chsh -s /bin/fish
/bin/fish -c "set -U fish_greeting"
