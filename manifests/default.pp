
# hack so we can save things in the vagrant folder and not have
# to download them loads...
file {"/vagrant":
    ensure => "directory",
}


exec { "apt-get update":
  path => "/usr/bin",
}


package { "unzip":
  ensure => present,
  require => Exec["apt-get update"],
}



package { "tomcat7":
  ensure => present,
  require => Exec["apt-get update"],
}
service { "tomcat7":
  ensure  => "running",
  require => [
	Package["tomcat7"], 
	File["/var/lib/tomcat7/webapps/alfresco.war"],
  	File["/var/lib/tomcat7/webapps/share.war"],
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



file { "/var/lib/tomcat7/webapps/alfresco.war":
    source => "/tmp/web-server/webapps/alfresco.war",
    require => Exec["unzip-alfresco-ce"],
}
file { "/var/lib/tomcat7/webapps/share.war":
    source => "/tmp/web-server/webapps/share.war",
    require => Exec["unzip-alfresco-ce"],
}
file { "/var/lib/tomcat7/shared/classes/alfresco-global-properties":
	source => "/vagrant/alfresco-global.properties",
	require => Package["tomcat7"],
}









