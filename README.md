ootb-allinone-mysql
===================

If you are very lucky you might be able to get the whole thing to run from start to end by 
executing ./fromscratch.sh but please note that when building a maven sdk addon for the first
time there is a long delay while many packages are fetched. You may speed this up by copying the 
contents of your /home/.m2/repository folder into the cache-m2 folder below the folder this README
is contained within. If the cache-m2 folder does not exist, create it.

* There are 2 VMs to be run using vagrant, “addonbuilder” and “alfresco”.
* To get started, you should run “vagrant up addonbuilder” which will create addon packages
  in ./addons-built/
    * You might need to find a "trusty64" box or else change that to "precise64" in your Vagrantfile (see 'Things to know' below) 
      NOTE: I have not been able to use precise64 due to conflict with virtualbox extensions YMMV
    * If it gets interrupted, you can restart with “vagrant provision addonbuilder” if the
      VM is already running
    * When first running any maven build for a plugin, as usual this is very slow, but there is a settings.xml file which gets
      installed prior to maven running which redirects the m2 repository folder to /vagrant/cache-m2, which should make later builds
      much quicker. 
    * Once the addons have been built into ./addons-built you can issue ‘vagrant halt addonbuilder’ to shut down the VM if you think
      you might use it again, or else ‘vagrant destroy addonbuilder’ will halt and delete the VM.
* Once the addons are built you can proceed to build the alfresco server
    * Start by importing puppet dependencies by running ‘install-puppet-modules.sh’
    * Next run ‘vagrant up alfresco’
    * If by some miracle things are working you may be able to log in at http://localhost:3080/share

What to modify

* The configuration is going in the default puppet file which is in manifests/default.pp
    * The variables at the start of the file are used in alfresco-global.properties and in /etc/default/tomcat7
        * alfresco-global.properties: modules/alfresco-war/templates/alfresco-global.properties.erb
        * default/tomcat7: modules/alfresco-common/templates/default-tomcat7.erb
    * and other templates...

Things to know

* You can use ‘vagrant ssh’ to log in to either vagrant-managed vm, i.e. ‘vagrant ssh addonbuilder’ or
  ‘vagrant ssh alfresco’
* Alfresco <s>runs under the ubuntu managed package ‘tomcat7’</s> used to run under the ubuntu
  managed package and so all the files are in their previous locations... TODO: make this location configurable
    * Therefore the wars are found under /var/lib/tomcat7/webapps
    * And logging is in <s>/var/log/tomcat7</s> /var/lib/tomcat7/logs
    * Apart from alfresco.log and share.log which are in /var/lib/tomcat7 for now
* Right now most of the provisioning code is in alfresco-common, alfresco-war and share-war really aren’t doing anything useful
* The “trusty64” box I use I got from http://vagrantbox.es: 
    * this I think: "vagrant box add trusty64 https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
    * alternatively, change to 'precise64' in Vagrantfile (or it may already have changed) and issue "vagrant box add precise64 http://files.vagrantup.com/precise64.box"
* Currently search is set to lucene
* The 'addonbuilder' VM builds 3 addons <s>currently, but the 'alfresco' VM only installs two of them at the moment as one of them
  prevents proper startup (see modules/addons/manifests/init.pp)</s> - TODO: create tests to automatically determine the breaking
  addon and remove it from the build. Currently thinking of selenium for this.
