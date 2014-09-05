#alfresco-common

class alfresco-common{
	#package { "tomcat7":
	#  ensure => present,
	#  require => Exec["apt-get update"],
	#}

	#user { "${alfresco_sys_user}":
	#	ensure => present,
	#	managehome => true,
	#}


	exec { "retrieve-tomcat7":
		creates => "${download_path}/$filename_tomcat",
		command => "wget $url_tomcat -O ${download_path}/$filename_tomcat",
		path => "/usr/bin",
	}

	exec { "unpack-tomcat7":
		cwd => "/tmp",
		path => "/bin:/usr/bin",
		command => "tar xzf ${download_path}/$filename_tomcat",
		require => Exec["retrieve-tomcat7"],
		unless => "test -f /var/lib/tomcat7/bin/bootstrap.jar",
	}

	file { "/var/lib/tomcat7":
		ensure => directory,
		source => "/tmp/${name_tomcat}",
		require => Exec["unpack-tomcat7"],
		recurse => true,
		owner => "tomcat7",
	}



	# we need an init script, this one is stolen from ubuntu (and may yet need further deps)
	file { "/etc/init.d/tomcat7":
		ensure => present,
		source => "puppet:///modules/alfresco-common/tomcat7-init",		
		before => Service["tomcat7"],
	}


	# TODO share.war is referenced here but it doesn't want to be if we are installing
	# share-war but not alfresco-war. Need to work out how to split them out. Note that
	# it is not possible to reference the tomcat7 service in both alfresco-war and
	# share-war classes in the case that they are both being loaded (i.e. allinone)
	service { "tomcat7":
		ensure  => "running",
		#ensure  => "stopped", # TODO for now I am leaving it stopped so I can watch things start up
		subscribe => [
			File["/var/lib/tomcat7/shared/classes/alfresco-global.properties"],
		],
		require => [
			File["/var/lib/tomcat7"], 
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


			# our global properties specifies /opt/alfresco still even though tomcat is elsewhere,
			File[$alfresco_base_dir],

			Class["::mysql::server"],

			Class["keystore"],
			Class["swftools"],

		
	            	File["/etc/default/tomcat7"],
		],
	}


	file{"/var/lib/tomcat7/shared/lib":
		ensure => directory,
		recurse => true,
		require => [ File["/var/lib/tomcat7"] ],
	}

	file { "/var/lib/tomcat7/conf/catalina.properties":
		source => "puppet:///modules/alfresco-common/catalina.properties",
		ensure => present,
		require => [ File["/var/lib/tomcat7"] ],
		before => Service["tomcat7"],
	}



	file { "${alfresco_base_dir}":
		ensure => directory,
		owner => "tomcat7",
		require => [ 
			User["tomcat7"], 
		],
		before => Service["tomcat7"],
		#before => Class["keystore"],
	}



#	# attempting to use non-versioned link to connector
#	file { "/var/lib/tomcat7/shared/lib/mysql-connector-java.jar":
#		target => "/usr/share/java/mysql-connector-java.jar",
#		ensure => link,
#		
#		# libmysql-java provided by "class { '::mysql::bindings':" in the default.pp, 
#		# needs to go elsewhere TODO
#		require => [ Package["libmysql-java"] ], 
#	}


	# attempting to use non-versioned link to connector
	file { "/var/lib/tomcat7/shared/lib/mysql-connector-java.jar":
		source => "/usr/share/java/mysql-connector-java.jar",
		ensure => present,
		links => follow,
		
		# libmysql-java provided by "class { '::mysql::bindings':" in the default.pp, 
		# needs to go elsewhere TODO
		require => [ Package["libmysql-java"] ], 
		before => Service["tomcat7"],
	}


	# By default the logs go where alfresco starts from, and in this case
	# that is /var/lib/tomcat7, so we need to create the files and give
	# them write access for the tomcat7 user
	#file { "/var/lib/tomcat7":
	#	ensure => directory,
	#}
	file { "/var/lib/tomcat7/alfresco.log":
		ensure => present,
		owner => "tomcat7",
		require => [
			File["/var/lib/tomcat7"],
			User["tomcat7"],
		],
		before => Service["tomcat7"],
	}
	file { "/var/lib/tomcat7/share.log":
		ensure => present,
		owner => "tomcat7",
		require => [
			File["/var/lib/tomcat7"],
			User["tomcat7"],
		],
		before => Service["tomcat7"],
	}
	user { "tomcat7":
		ensure => present,
		before => Service["tomcat7"],
	}





	# the war files and global properties template
	file { "/var/lib/tomcat7/webapps/alfresco.war":
		source => "/tmp/web-server/webapps/alfresco.war",
		require => Exec["unzip-alfresco-ce"],
		before => Service["tomcat7"],
		ensure => present,
	}
	file { "/var/lib/tomcat7/webapps/share.war":
		source => "/tmp/web-server/webapps/share.war",
		require => Exec["unzip-alfresco-ce"],
		before => Service["tomcat7"],
		ensure => present,
	}
	file { "/var/lib/tomcat7/shared/classes/alfresco-global.properties":
		require => File["/var/lib/tomcat7/shared/classes"],
		content => template("alfresco-war/alfresco-global.properties.erb"),
		#before => File["/var/lib/tomcat7"],
		ensure => present,
	}

	file { "/var/lib/tomcat7/shared/classes":
		ensure => directory,
		require => File["/var/lib/tomcat7/shared"],
	}
	file { "/var/lib/tomcat7/shared":
		ensure => directory,
		require => File["/var/lib/tomcat7"],
	}


	# tomcat memory set in here
	file { "/etc/default/tomcat7":
		before => Service["tomcat7"],
		require => File["/var/lib/tomcat7"],
		content => template("alfresco-common/default-tomcat7.erb")
	}



	# http://stackoverflow.com/a/18846683
	# Using "creates" means that this exec is only run if this file does not exist 
	exec { "retrieve-alfresco-ce":
		command => "wget -q ${alfresco_ce_url} -O ${download_path}/${alfresco_ce_filename}	",
		path => "/usr/bin",
		creates => "${download_path}/${alfresco_ce_filename}",
	}



	exec { "unzip-alfresco-ce":
		command => "unzip -o ${download_path}/${alfresco_ce_filename} -d /tmp",
		path => "/usr/bin",
		require => [ 
			Exec["retrieve-alfresco-ce"],
			File["/var/lib/tomcat7"], 
			Package["unzip"], 
		],
	}


	package { "unzip":
		ensure => present,
		require => Exec["apt-get update"],
	}




}
