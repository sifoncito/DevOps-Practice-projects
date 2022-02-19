#wget http://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img
qemu-img convert -f qcow2 -O raw focal-server-cloudimg-amd64.img focal-server-cloudimg-amd64.raw
qemu-img create -b focal-server-cloudimg-amd64.img -f qcow2 -F qcow2 hal9000.img 10G

echo " instance-id: ubuntu-server
local-hostname: ubuntu-server" >> meta-data

echo "#cloud-config

users:
  - name: sumit
    passwd: $6$exDY1mhS4KUYCE/2$zmn9ToZwTKLhCw.b4/b.ZRTIZM30JZ4QrOQ2aOXJ8yk96xpcCof0kxKwuX1kqLG/ygbJ1f8wxED22bTL4F46P0 
    ssh_authorized_keys:
      - ssh-rsa sh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4e0nzxM18X7jxyR7M87KPBihX3SG2AGueJFW1rZ+rJR7Wf/0c7P85ICAkI0EgeaTF30hP/r+3lQ9umIhsLIhEH6eM57UNub9V/k5cnQDWb/oP9mSrnKD3IlQQs5LDWnx48pdegzw/bts1P2tNV3We+la98BPspH8QiHaDaqW2Gd6pEzlRHk/6ttFSfRq175X/Z+FanNdnoyMjnBHo3xGKymE6G+HDusHz6KlrD9/X2Z7R5A1EYl3mfKYT0Zxti6tboMfiYiaaqLcLe43W34RlZIBuay+JGYKTh58IchrI87AswA+JVLbP4a8Q+d4claho7eKmzTu/u8PbuWna0pvxLPvfuQGFs5AyKUYkoJx5e8B1kQx0yvb6EtArsTRgRhisGXUhFt5TOmb5pxnaDE4sQc94CiwNEXwi1Wvi/0dirAx8xU7JspchZYqZ9U7QyfAilfLJMtfBGmbf24WCfL5/3R2OKH6JFm0mZJkvZqeNoAngV95BQWczRYQ2jsGCc7U= b@desktop 
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: sudo
    shell: /bin/bash
package_upgrade: true
packages:
  - nginx" >> user-data

genisoimage -output cidata.iso -V cidata -r -J user-data meta-data
virt-install --name=hal9000 --ram=2048 --vcpus=1 --import --disk path=hal9000.img,format=qcow2 --disk path=cidata.iso,device=cdrom --os-variant=ubuntu20.04 --network bridge=virbr0,model=virtio --graphics vnc,listen=0.0.0.0 --noautoconsole
