# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  # config.vm.box_check_update = false
  # config.vm.network "forwarded_port", guest: 22, host: 2222
  # config.vm.network "forwarded_port", guest: 8090, host: 8090

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "invicl", "/kuksa"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    # First update the source and install deps
    apt-get update
    apt-get install -y \
      build-essential \
      can-utils \
      curl \
      dpkg-dev \
      e2fslibs-dev \
      git \
      libaudit-dev \
      libblkid-dev \
      libboost-all-dev \
      libbz2-dev \
      libffi-dev \
      liblzma-dev \
      libmosquitto-dev\
      libncurses5-dev \
      libreadline-dev \
      libsqlite3-dev \
      libssl-dev \
      libxml2-dev \
      libxmlsec1-dev \
      llvm \
      make \
      mosquitto \
      net-tools \
      stow \
      tk-dev \
      wget \
      xz-utils \
      zlib1g-dev \
      zsh \
      linux-headers-$(uname -r)

    # cmake does not fit kuksa requirements (>=3.12)
    # and must be installed via snap
    snap install cmake --classic

    # vcan module is missing in vagrant ubuntu
    cd $HOME
    # First get the linux kernel sources
    # Activate the source repository
    sudo add-apt-repository -s \
      'deb http://archive.ubuntu.com/ubuntu bionic main restricted'
    KERNEL_VERSION=$(uname -r)
    apt-get source linux-source-${KERNEL_VERSION%%-*}
    cd linux-${KERNEL_VERSION%%-*}
    # Compile missing vcan module
    make olddefconfig
    make scripts
    cd drivers/net/can/
    make -C /lib/modules/$(uname -r)/build M=$(pwd) modules
    # Module installation
    install -m 644 vcan.ko /lib/modules/$(uname -r)/kernel/drivers/net/
    # Generate modules.dep and map files (to be found by modprobe)
    depmod
    cd $HOME

    # Load vcan module and bind a virtual can to vcan0
    # https://stackoverflow.com/a/21040212
    modprobe vcan
    ip link add dev vcan0 type vcan
    ip link set up vcan0

    [ -d /kuksa ] || mkdir /kuksa

    # Install bat
    BAT=https://github.com/sharkdp/bat/releases/download/v0.16.0/bat_0.16.0_amd64.deb
    [ -x "$(which bat)" ] || \
      curl -s -L $BAT -o /tmp/bat.deb && \
      dpkg -i /tmp/bat.deb
    #
    #
    # Install vivid
    VIVID=https://github.com/sharkdp/vivid/releases/download/v0.6.0/vivid_0.6.0_amd64.deb
    [ -x "$(which vivid)" ] || \
      curl -s -L $VIVID -o /tmp/vivid.deb && \
      dpkg -i /tmp/vivid.deb


    # Install pyenv
    # and put it profile/global zshenv
    git clone https://github.com/pyenv/pyenv /opt/pyenv
    PYENV_PROFILE=/etc/profile.d/Z99-pyenv.sh
    [ -f  $PYENV_PROFILE ] || \
      echo 'export PATH="/opt/pyenv/bin:$PATH"' >> $PYENV_PROFILE && \
      echo 'export PATH="/opt/pyenv/bin:$PATH"' >> /etc/zsh/zshenv


  SHELL

  config.vm.provision "docker" do |d|
	 d.run "kuksa/kuksa.val",
     args: "-v /kuksa:/config -p 127.0.0.1:8090:8090 -e LOG_LEVEL=ALL"
  end
end
