text

network --bootproto=dhcp --device=link --activate

clearpart --all --initlabel --disklabel=gpt
reqpart --add-boot
partition / --grow --fstype=ext4 --ondisk=vda
partition /opt/local-path-provisioner --grow --fstype=ext4 --ondisk=vdb

ostreecontainer --url registry.poul.org/sysadmin/system-images/k0s-bootc:v1.32.1-k0s.0

timezone --utc Europe/Rome

rootpw --lock
