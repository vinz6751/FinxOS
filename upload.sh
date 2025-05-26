#!/bin/sh
# FoenixMGR, voir https://github.com/pweingar/FoenixMgr
FNXMGR="python3 $FOENIXMGR/FoenixMgr/fnxmgr.py --port /dev/ttyUSB0"

# Upload en RAM (s'assurer que l'adresse est la même que la ROM dans le script de l'éditeur de lien (finxos.ld)
$FNXMGR --binary finxos.bin --address 0x100000

# Upload les vecteurs de reset: après cela, le processeur redémarre et saute à la "ROM"
$FNXMGR --binary finxos.bin --address 0x000000
