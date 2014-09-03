#alfresco-common

class alfresco-common{
	package { "tomcat7":
	  ensure => present,
	  require => Exec["apt-get update"],
	}

	#user { "${alfresco_sys_user}":
	#	ensure => present,
	#	managehome => true,
	#}


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
			File["/var/lib/tomcat7/shared/classes/alfresco-global.properties"],
			#User["${alfresco_sys_user}"],

			# By default the logs go where alfresco starts from, and in this case
			# that is /var/lib/tomcat7, so we need to create the files and give
			# them write access for the tomcat7 user
			File["/var/lib/tomcat7/alfresco.log"],
			File["/var/lib/tomcat7/share.log"],

			# this modifies the shared.loader property
			File["/var/lib/tomcat7/conf/catalina.properties"],
			# which relies on the shared/lib folder
			File["/var/lib/tomcat7/shared/lib"],
		],
	}


	file{"/var/lib/tomcat7/shared/lib":
		ensure => directory,
		recurse => true,
	}

	file { "/var/lib/tomcat7/conf/catalina.properties":
		source => "puppet:///modules/alfresco-war/catalina.properties",
		ensure => present,
	}



	# attempting to use non-versioned link to connector
	file { "/var/lib/tomcat7/shared/lib/mysql-connector-java.jar":
		target => "/usr/share/java/mysql-connector-java.jar",
		ensure => link,
		
		# libmysql-java provided by "class { '::mysql::bindings':" in the default.pp, 
		# needs to go elsewhere TODO
		require => [ Package["libmysql-java"] ], 
	}




	# By default the logs go where alfresco starts from, and in this case
	# that is /var/lib/tomcat7, so we need to create the files and give
	# them write access for the tomcat7 user
	file { "/var/lib/tomcat7":
		ensure => directory,
	}
	file { "/var/lib/tomcat7/alfresco.log":
		ensure => present,
		owner => "tomcat7",
		require => [
			File["/var/lib/tomcat7"],
			User["tomcat7"],
		],
	}
	file { "/var/lib/tomcat7/share.log":
		ensure => present,
		owner => "tomcat7",
		require => [
			File["/var/lib/tomcat7"],
			User["tomcat7"],
		],
	}
	user { "tomcat7":
		ensure => present,
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
