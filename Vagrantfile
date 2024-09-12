Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.box.architecture = "amd64"
  config.vm.hostname = "alero-websrv"
  config.vm.box_check_update = false
  config.vm.network "private_network", ip: "192.168.56.10"
  config.vm.network "forwarded_port", guest: 80, host: 8081
  config.vm.synced_folder "themes", "/var/www/wordpress/wp-content/themes"
  config.vm.synced_folder "plugins", "/var/www/wordpress/wp-content/plugins"

  config.vm.provider "virtualbox" do |vb|
    vb.name = "alero-websrv"
    vb.memory = "2048" # 2GB
	vb.cpus = 1
    file_to_disk = "disk01.vmdk"
      unless File.exist?(file_to_disk)
        vb.customize ["createmedium", "disk", "--filename", "disk01.vmdk", "--format", "vmdk", "--size", 1024 * 1]
      end
      vb.customize ["storageattach", "alero-websrv", "--storagectl", "SCSI", "--port", "2", "--device", "0", "--type", "hdd", "--medium", file_to_disk]
  end

  config.vm.provision "shell", path: "./scripts/bootstrap.sh"
  config.vm.provision "file", source: "./etc/nginx/wordpress", destination: "/home/vagrant/wordpress"
  config.vm.provision "shell", path: "./scripts/install.sh"
end
