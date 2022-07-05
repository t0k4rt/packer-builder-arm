## build
`sudo packer build path-to-hcl-or-json`

Top enable debug, use env var:

`PACKER_LOG=1`


## burn

`sudo dd bs=1M if=path-to-image of=/dev/mmcblk0 status=progress`