ootb-allinone-mysql
===================

Do not use this yet! It will not produce a working system at this time.

* Start by importing dependencies by running ‘install-puppet-modules.sh’
* Next run ‘vagrant up’
* If by some miracle things are working you may be able to log in at http://localhost:3080/share

Things to know

* Alfresco runs under the ubuntu managed package ‘tomcat7’
    * Therefore the wars are found under /var/lib/tomcat7/webapps
    * And logging is in /var/log/tomcat7
    * Apart from alfresco.log and share.log which are in /var/lib/tomcat7 for now
* Right now most of the provisioning code is in alfresco-common, alfresco-war and share-war really aren’t doing anything useful
