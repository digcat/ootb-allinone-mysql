#alfresco-common

class alfresco-common{
	package { "tomcat7":
	  ensure => present,
	  require => Exec["apt-get update"],
	}


	# TODO share.war is referenced here but it doesn't want to be if we are installing
	# share-war but not alfresco-war. Need to work out how to split them out. Note that
	# it is not possible to reference the tomcat7 service in both alfresco-war and
	# share-war classes in the case that they are both being loaded (i.e. allinone)
	service { "tomcat7":
	  ensure  => "running",
	  require => [
		Package["tomcat7"], 
	  	File["/var/lib/tomcat7/webapps/share.war"],
		File["/var/lib/tomcat7/webapps/alfresco.war"],
		File["/var/lib/tomcat7/shared/classes/alfresco-global-properties"],
	  ],
	}



	# http://stackoverflow.com/a/18846683
	# Using "creates" means that this exec is only run if this file does not exist 
	exec { "retrieve-alfresco-ce":
	  command => "wget -q http://dl.alfresco.com/release/community/4.2.f-build-00012/alfresco-community-4.2.f.zip -O /vagrant/alfresco-community-4.2.f.zip",
	  path => "/usr/bin",
	  creates => "/vagrant/alfresco-community-4.2.f.zip",
	}



	exec { "unzip-alfresco-ce":
	  command => "unzip -o /vagrant/alfresco-community-4.2.f.zip -d /tmp",
	  path => "/usr/bin",
	  require => [ 
		Exec["retrieve-alfresco-ce"],
		Package["tomcat7"], 
		Package["unzip"], 
	  ],
	}


	package { "unzip":
	  ensure => present,
	  require => Exec["apt-get update"],
	}

}
