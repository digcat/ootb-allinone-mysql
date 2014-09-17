# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|


  config.vm.box = "trusty64"

  config.vm.define "alfresco" do |alfresco|

    alfresco.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "3072"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]   
    end  

  #config.vm.share_folder('templates', '/tmp/vagrant-puppet/templates', 'templates')

  # sync the /home/vagrant/.m2 folder so that we can accelerate mvn builds during dev
  #config.vm.synced_folder "cache-m2/", "/home/root/.m2"


    alfresco.vm.provision :puppet do |puppet|
      puppet.module_path = ["modules", "extmodules"]
      #puppet.options = ["--templatedir","/tmp/vagrant-puppet/templates", "--verbose", "--debug"]
#     puppet.options = ["--verbose", "--debug"]
    end

    alfresco.vm.network "forwarded_port", guest: 8080, host: 3080

  end

  config.vm.define "alfresco", primary: true
    

  config.vm.define "addonbuilder" do |addonbuilder|
    addonbuilder.vm.provision :puppet do |puppet|
      puppet.module_path = "buildmodules"
      puppet.manifest_file = "buildmodules.pp"
      puppet.options = ["--verbose", "--debug"]
    end
  end
  config.vm.define "addonbuilder", autostart: false


  config.vm.define "tester" do |tester|
    tester.vm.provision :puppet do |puppet|
      puppet.module_path = [ "testmodules", "extmodules"]
      puppet.manifest_file = "testmodules.pp"
    end
    tester.vm.network "forwarded_port", guest: 4444, host: 4444
  end


end
