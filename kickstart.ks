text

network --bootproto=dhcp --device=link --activate

clearpart --all --initlabel --disklabel=gpt
reqpart --add-boot
partition / --grow --fstype=ext4 --ondisk=vda
partition /opt/local-path-provisioner --grow --fstype=ext4 --ondisk=vdb


ostreecontainer --url ghcr.io/lollo03/k0s-bootc:latest


timezone --utc Europe/Rome

rootpw --lock
