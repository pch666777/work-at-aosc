# 修改 enp2s0 网卡名称，以及 0000:02:00.0 网卡pcie地址
# 网卡名称通过`ip a`命令查看，pci地址通过`dpdk-devbind.py --status`获取
ifconfig enp2s0 down
modprobe vfio-pci
bash -c 'echo 1 > /sys/module/vfio/parameters/enable_unsafe_noiommu_mode'
dpdk-devbind.py --unbind 0000:02:00.0
dpdk-devbind.py --bind=vfio-pci 0000:02:00.0
dpdk-devbind.py --status
