#!/usr/bin/env sh
#shellcheck shell=sh

set -xe

HOME=/config
export HOME

cd /opt/clrmamepro

# Allow running of native linux binaries
/usr/bin/wine64-stable regedit /C /run_native_applications.reg

# Launch clrmamepro
/usr/bin/wine64-stable /opt/clrmamepro/cmpro64.exe 2>&1 | awk -W Interactive '{print "[clrmamepro] " $0}'
