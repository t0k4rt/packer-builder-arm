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
  file_checksum_type    = "sha256"
  file_checksum_url     = "https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2022-04-07/2022-04-04-raspios-bullseye-armhf-lite.img.xz.sha256"
  file_target_extension = "xz"
  file_unarchive_cmd    = ["xz", "-d", "-k", "$ARCHIVE_PATH"]
  file_urls             = ["/home/tok/Code/devops/packer-builder-arm/2022-04-04-raspios-bullseye-armhf-lite.img.xz"]
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
  image_path                   = "pi-baseimage.img"
  image_size                   = "2G"
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
      "touch /boot/ssh", // enable ssh
      // configure wifi
      "echo 'country=FR\nctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev\nupdate_config=1\nnetwork={\nssid=\"Roche Cléandre\"\npsk=\"Estcequilpleut?\"\n}' > /boot/wpa_supplicant.conf", 
      // disable embedded audio and hdmi audio
      "sed -i s/dtparam=audio=on/#dtparam=audio=on/g /boot/config.txt", 
      "sed -i s/dtoverlay=vc4-kms-v3d/dtoverlay=vc4-kms-v3d,audio=off/g /boot/config.txt", 
      // disable bt
      "echo -n 'dtoverlay=disable-bt\n' | cat - /boot/config.txt | tee /boot/config.txt",
      // update packages
      "apt update && apt upgrade -y",
      // install debugging tools 
      "apt install iperf3 iftop", 
      // user router as ntp server
      "echo NTP=bluemamba.lan >> /etc/systemd/timesyncd.conf", 
      // change locale (timedatectl won'ty work since systemd does not work with packer chroot)
      "rm /etc/localtime", 
      "ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime", 
      "rm /etc/timezone", 
      // force disk check at every startup
      "sed -i 's/fsck.repair=yes/fsck.repair=yes fsck.mode=force/g' /boot/cmdline.txt", 
      // disable swap
      "sed -i s/CONF_SWAPSIZE=100/CONF_SWAPSIZE=0/g /etc/dphys-swapfile", 
      // fs tuning
      "sed -i s/noatime/noatime,commit=1800/g /etc/fstab", 
      "echo 'tmpfs /tmp tmpfs defaults,noatime,nosuid,nodev 0 0' >> /etc/fstab", 
      "echo 'tmpfs /var/log tmpfs defaults,noatime,nosuid,size=64M 0 0' >> /etc/fstab", 
      // create future user
      "useradd tok",
      // this usr will be used when userconfig service will be launch at first start 
      "echo tok:unsecurepasswordtochange > /boot/userconf.txt", 
      "mkdir -p /home/tok/.ssh/", 
      "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC58vYqlkc87Wv59C66lUIyIsixZZXWS+mezfRvy7YC6npZH65K9zMmISiym5KZOoOsE1uu5tigUHzMUuDF8ZI/ggk7NqpJ2hq9KRqq6mCPSgbYBByOAPIHkiM/cC5/L4vUmtnTWbdQfF+0aeM3yly7joCeNg03LmVCetLcPQfDexlYFG6jW/f5txO/F1GWq8miYR/5BogIjtwG2t2ZcRjEe3S5TY+3G3O9hG6sZVQFw3khpCA+9hUy64a6FYgZVIWs89sJjoN8aTkFMjdmso/u6Di2I97kQvIg47H6vr+cULlCQNq/LMMjV8hmkmZku1KmIJUgFxH1Vp5VmPuVjq2uutPWI/djhbNtdL+KufRueYLYyAg17b3Ravx3MnRsJS3olywTHCC3L3LsCjZuOXHHfvtiMipC+QzmYwcvSzmT4YA2XfA4hTvo4QijvvsGiGCKGwFcoQZdr8GdZIAE2MuN1y8W7j0sBDeL2x/kVvV8YFE2InTOeJWyLlhWEdlwQ2r42NdiUHqZarIvRjY8XIUu2fZGmrfcXxDIscYN56fruwTd61M+Ttc3ajfInVeCApA8DcCpWTnSGHYvNugrni4cTBmblzY6fIOsGgkvwcnhvZuirjQphPRp+Lp0k+IgWWiDo/IGA4Hzq0vYTgWy+84xA1Yyul2cyeFobpBS5LXb0Q== alexandre@macbook-pro.home' >> /home/tok/.ssh/authorized_keys", 
      "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDHqF237lW3zU6rPIm0XHA4DvdEEG96xCx3MpgmC4AJePPba0DDJDs36oJ0aGoMYYuOlSFKqF/5DKo4HoZusu6teXhhH/Ke1a8+dkpSr1TyG4yRIBo+q2Tg2GpuYCjE87f8cFTk5vmnmOOQudwVoSuSGo/K3JbVJE6RqhxMO94YX7OYmhbzEYj300FVk/FVGexxWolT+iR1CpYEO2DPkoOhZ0i/KyXF8oQWpa46jCREHTOfc6vF+DlAODLRSkEp98gPlPGVhQm0Csj44R5SG94cAOfRXjOQQZ05ONDvCrB+sXvrKR8f9QamHyx7yWlazEkywRoCVELvawvQ9g0D2L2HQ3LklxZKEvqL/0Fu7MpD7Kgk4bEiMij30yJCRUmMFStoFgCztXdIK7mnSfal0zGQOCw7xPfSPTqHeBt4SxkhZLtjUtyURn7XtJyxm7r8q/8ehQYSV0nUSFfBEH2zAe7PkHx9q91ukhWmM497oXGLhKolUUzb+CTCa/CNWPucguYqccMPXRIDoXn/VWd5MjhxnxwrR6jy1Rj+Ho01YRndaA5TGUHAZUuY680GqwF/b9rsIe8J0WE9k9CXhfqzKHguJx+ES6FbQSlaZhXFrIDZW6OaayDrKkZ3ICOcg5Dc4vbOPC6HU0EnA4/aREIgEpmZDMYllOQ0pluPuB0ncWkHRQ== tok@fedora' >> /home/tok/.ssh/authorized_keys", 
      "chown -R tok:tok /home/tok"
    ]
  }

}
