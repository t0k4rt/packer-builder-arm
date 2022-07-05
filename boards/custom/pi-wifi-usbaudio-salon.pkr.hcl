# This file was autogenerated by the 'packer hcl2_upgrade' command. We
# recommend double checking that everything is correct before going forward. We
# also recommend treating this file as disposable. The HCL2 blocks in this
# file can be moved to other files. For example, the variable blocks could be
# moved to their own 'variables.pkr.hcl' file, etc. Those files need to be
# suffixed with '.pkr.hcl' to be visible to Packer. To use multiple files at
# once they also need to be in the same folder. 'packer inspect folder/'
# will describe to you what is in that folder.

# Avoid mixing go templating calls ( for example ```{{ upper(`string`) }}``` )
# and HCL2 calls (for example '${ var.string_value_example }' ). They won't be
# executed together and the outcome will be unknown.

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "arm" "autogenerated_1" {
  file_checksum         = "1ef38077e3e6370bfe190d9b11f0abb8"
  file_checksum_type    = "md5"
  file_target_extension = "img"
  file_urls             = ["/home/tok/Code/devops/packer-builder-arm/pi-baseimage.img"]
  image_build_method    = "reuse"
  image_chroot_env      = ["PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"]
  image_partitions {
    filesystem   = "vfat"
    mountpoint   = "/boot"
    name         = "boot"
    size         = "256M"
    start_sector = "8192"
    type         = "c"
  }
  image_partitions {
    filesystem   = "ext4"
    mountpoint   = "/"
    name         = "root"
    size         = "0"
    start_sector = "532480"
    type         = "83"
  }
  image_path                   = "pi-wifi-usbaudio-salon-b2.img"
  image_size                   = "4G"
  image_type                   = "dos"
  qemu_binary_destination_path = "/usr/bin/qemu-arm-static"
  qemu_binary_source_path      = "/usr/bin/qemu-arm-static"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.arm.autogenerated_1"]

  provisioner "shell" {
    inline = [
      // install snapclient with dependencies
      "apt install -y libpulse0 libsoxr0 libopus0 libvorbisidec1 libavahi-client3 alsa-utils avahi-utils", 
      "curl -L https://github.com/badaix/snapcast/releases/download/v0.26.0/snapclient_0.26.0-1_armhf.deb -o ./snapclient.deb", 
      "dpkg -i ./snapclient.deb", 
      "systemctl enable snapclient.service", 
      // set host name
      "echo salon-usbaudio > /etc/hostname"]
  }

}
