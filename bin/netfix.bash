#! /usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

wgint=($(sudo wg show | head -n 1))
wg="${wgint[1]}"
wg-quick down ${wg}

conn=($(nmcli con show --active | tail -n 1 | tr ' ' '\n' | tac |tr '\n' ' '))
connUUID="${conn[2]}"

nmcli con down uuid ${conUUID}
sleep 1
nmcli con up uuid ${connUUID}
sleep 5
wg-quick up ${wg}

