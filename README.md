ootb-allinone-mysql
===================

Do not use this yet! It will not produce a working system at this time.

* There are 2 VMs to be run using vagrant, “addonbuilder” and “alfresco”.
* To get started, you should run “vagrant up addonbuilder” which will create addon packages
  in ./addons-built/
    * If it gets interrupted, you can restart with “vagrant provision addonbuilder” if the
      VM is already running
    * When first running any maven build for a plugin, as usual this is very slow, but there is a settings.xml file which gets
      installed prior to maven running which redirects the m2 repository folder to /vagrant/cache-m2, which should make later builds
      much quicker. 
* Once the addons are built you can proceed to build the alfresco server
    * Start by importing dependencies by running ‘install-puppet-modules.sh’
    * Next run ‘vagrant up alfresco’
    * If by some miracle things are working you may be able to log in at http://localhost:3080/share

What to modify

* The configuration is going in the default puppet file which is in manifests/default.pp
    * The variables at the start of the file are used in alfresco-global.properties and in /etc/default/tomcat7

Things to know

* Alfresco <s>runs under the ubuntu managed package ‘tomcat7’</s> used to run under the ubuntu
  managed package and so all the files are in their previous locations... TODO: make this location configurable
    * Therefore the wars are found under /var/lib/tomcat7/webapps
    * And logging is in <s>/var/log/tomcat7</s> /var/lib/tomcat7/logs
    * Apart from alfresco.log and share.log which are in /var/lib/tomcat7 for now
* Right now most of the provisioning code is in alfresco-common, alfresco-war and share-war really aren’t doing anything useful
* The “trusty64” box I use I got from http://vagrantbox.es: 
    * this I think: https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box
* Currently search is set to ‘’’lucene’’’
