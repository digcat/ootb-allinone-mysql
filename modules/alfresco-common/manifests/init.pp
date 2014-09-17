#alfresco-common

class alfresco-common{
	
	


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
		unless => "test -f ${tomcat_home}/bin/bootstrap.jar",
	}


#
# YUK! doing it this way gives me a million tomcat files under puppet's command, it's noisy and ugly
#
#	file { "${tomcat_home}":
#		ensure => directory,
#		source => "/tmp/${name_tomcat}",
#		require => Exec["unpack-tomcat7"],
#		recurse => true,
#		owner => "tomcat7",
#	}


#
# YUM! copy the tomcat files in place with a bit less pomp
#
	exec { "copy tomcat to ${tomcat_home}":
		command => "mkdir -p ${tomcat_home} && cp -r /tmp/${name_tomcat}/* ${tomcat_home} && chown -R tomcat7 ${tomcat_home}",
		path => "/bin:/usr/bin",
		provider => shell,		
		require => User["tomcat7"],
	}


	# we need an init script, this one is stolen from ubuntu (and may yet need further deps)
	file { "/etc/init.d/tomcat7":
		ensure => present,
		#source => "puppet:///modules/alfresco-common/tomcat7-init",		
		content => template("alfresco-common/tomcat7-init.erb"),
		before => Service["tomcat7"],
		mode => "0755",
	}


	# TODO share.war is referenced here but it doesn't want to be if we are installing
	# share-war but not alfresco-war. Need to work out how to split them out. Note that
	# it is not possible to reference the tomcat7 service in both alfresco-war and
	# share-war classes in the case that they are both being loaded (i.e. allinone)
	service { "tomcat7":
		ensure  => "running",
		#ensure  => "stopped", # TODO for now I am leaving it stopped so I can watch things start up
		subscribe => [
			File["${tomcat_home}/shared/classes/alfresco-global.properties"],
			File["${tomcat_home}/webapps/alfresco.war"],
			File["${tomcat_home}/webapps/share.war"],
		],
		require => [
			Exec["copy tomcat to ${tomcat_home}"], 

			# By default the logs go where alfresco starts from, and in this case
			# that is ${tomcat_home}, so we need to create the files and give
			# them write access for the tomcat7 user
			File["${tomcat_home}/alfresco.log"],
			File["${tomcat_home}/share.log"],

			# this modifies the shared.loader property
			File["${tomcat_home}/conf/catalina.properties"],
			# which relies on the shared/lib folder
			File["${tomcat_home}/shared/lib"],


			File[$alfresco_base_dir],

			Class["::mysql::server"],

			Class["keystore"],
			Class["swftools"],

		
	            	File["/etc/default/tomcat7"],

			Exec["apply-addons"],  # TODO CROSSDEP!
		],
	}


	file{"${tomcat_home}/shared/lib":
		ensure => directory,
		recurse => true,
		require => [ Exec["copy tomcat to ${tomcat_home}"] ],
	}

	file { "${tomcat_home}/conf/catalina.properties":
		content => template("alfresco-common/catalina.properties.erb"),
		ensure => present,
		require => [ Exec["copy tomcat to ${tomcat_home}"] ],
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

	# attempting to use non-versioned link to connector
	file { "${tomcat_home}/shared/lib/mysql-connector-java.jar":
		source => "/usr/share/java/mysql-connector-java.jar",
		ensure => present,
		links => follow,
		
		# libmysql-java provided by "class { '::mysql::bindings':" in the default.pp, 
		# needs to go elsewhere TODO
		require => [ Package["libmysql-java"] ], 
		before => Service["tomcat7"],
	}


	# By default the logs go where alfresco starts from, and in this case
	# that is ${tomcat_home}, so we need to create the files and give
	# them write access for the tomcat7 user
	file { "${tomcat_home}/alfresco.log":
		ensure => present,
		owner => "tomcat7",
		require => [
			Exec["copy tomcat to ${tomcat_home}"],
			User["tomcat7"],
		],
		before => Service["tomcat7"],
	}
	file { "${tomcat_home}/share.log":
		ensure => present,
		owner => "tomcat7",
		require => [
			Exec["copy tomcat to ${tomcat_home}"],
			User["tomcat7"],
		],
		before => Service["tomcat7"],
	}
	user { "tomcat7":
		ensure => present,
		before => [ 
			Exec["unpack-alfresco-war"],
			Exec["unpack-share-war"],
			Service["tomcat7"],
		],
	}





	# the war files and global properties template
	file { "${tomcat_home}/webapps/alfresco.war":
		source => "${alfresco_war_loc}/alfresco.war",
		require => Exec["unzip-alfresco-ce"],
		before => Service["tomcat7"],
		ensure => present,
	}
	file { "${tomcat_home}/webapps/share.war":
		source => "${alfresco_war_loc}/share.war",
		require => Exec["unzip-alfresco-ce"],
		before => Service["tomcat7"],
		ensure => present,
	}
	file { "${tomcat_home}/shared/classes/alfresco-global.properties":
		require => File["${tomcat_home}/shared/classes"],
		content => template("alfresco-war/alfresco-global.properties.erb"),
		ensure => present,
	}

	exec { "unpack-alfresco-war": 
		require => [
			File["${tomcat_home}/webapps/alfresco.war"],
		],
		path => "/bin:/usr/bin",
		command => "unzip -o -d ${tomcat_home}/webapps/alfresco ${tomcat_home}/webapps/alfresco.war && chown -R tomcat7 ${tomcat_home}/webapps/alfresco", 
	}
	exec { "unpack-share-war": 
		require => [
			File["${tomcat_home}/webapps/share.war"],
		],
		path => "/bin:/usr/bin",
		command => "unzip -o -d ${tomcat_home}/webapps/share ${tomcat_home}/webapps/share.war && chown -R tomcat7 ${tomcat_home}/webapps/share", 
	}


	file { "${tomcat_home}/shared/classes":
		ensure => directory,
		require => File["${tomcat_home}/shared"],
	}
	file { "${tomcat_home}/shared":
		ensure => directory,
		require => Exec["copy tomcat to ${tomcat_home}"],
	}


	# tomcat memory set in here
	file { "/etc/default/tomcat7":
		before => Service["tomcat7"],
		require => Exec["copy tomcat to ${tomcat_home}"],
		content => template("alfresco-common/default-tomcat7.erb")
	}



	# http://stackoverflow.com/a/18846683
	# Using "creates" means that this exec is only run if this file does not exist 
	exec { "retrieve-alfresco-ce":
		command => "wget -q ${alfresco_ce_url} -O ${download_path}/${alfresco_ce_filename}	",
		path => "/usr/bin",
		creates => "${download_path}/${alfresco_ce_filename}",
	}

	file { "/tmp/alfresco":
		ensure => directory,
	}

	exec { "unzip-alfresco-ce":
		command => "unzip -o ${download_path}/${alfresco_ce_filename} -d /tmp/alfresco",
		path => "/usr/bin",
		require => [ 
			Exec["retrieve-alfresco-ce"],
			Exec["copy tomcat to ${tomcat_home}"], 
			Package["unzip"], 
			File["/tmp/alfresco"],
		],
	}




	file { "${alfresco_base_dir}/amps":
		ensure => directory,
		#before => Exec["unzip-alfresco-ce"], # well really I would prefer it to be before the addons class...
		before => Class["addons"],
	}
	file { "${alfresco_base_dir}/amps_share":
		ensure => directory,
		before => Class["addons"],
	}


	package { "unzip":
		ensure => present,
		require => Exec["apt-get update"],
	}




}
