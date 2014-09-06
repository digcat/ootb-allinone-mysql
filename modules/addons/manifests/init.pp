
class addons {


	############ SAMPLE #1 ##########################################
	# Applying amps from downloaded zip                             #
	#                                                               #
	# Remember to add require entries in Exec["apply-addons"]       #
	#################################################################
	#exec { "retrieve-jsconsole":
	#	creates => "${download_path}/${filename_jsconsole}",
	#	command => "wget ${url_jsconsole} -O ${download_path}/${filename_jsconsole}",
	#	path => "/usr/bin",
	#	require => File["/tmp/jsconsole"],
	#}

	#exec { "unpack-jsconsole":
	#	cwd => "/tmp/jsconsole",
	#	command => "unzip -o ${download_path}/${filename_jsconsole}",
	#	require => [ File["/tmp/jsconsole"], Exec["retrieve-jsconsole"], ],
	#	path => "/usr/bin",
	#}

	#file { "/tmp/jsconsole":
	#	ensure => directory,
	#	before => Exec["unpack-jsconsole"],
	#}

	file { "${alfresco_base_dir}/amps/javascript-console-repo-0.5.1.amp": 
		source => "/vagrant/addons-built/jsconsole/javascript-console-repo-0.5.1.amp",
		ensure => present,
		#require => Exec["unpack-jsconsole"],
	}
	file { "${alfresco_base_dir}/amps_share/javascript-console-share-0.5.1.amp": 
		source => "/vagrant/addons-built/jsconsole/javascript-console-share-0.5.1.amp",
		ensure => present,
		#require => Exec["unpack-jsconsole"],
	}

	#file { "${alfresco_base_dir}/bin":
	#	ensure => directory,
	#}

	############ SAMPLE #1 END ######################################





	############ SAMPLE #2 ##########################################
	# Building amps from github source                              #
	#                                                               #
	# This uses the maven sdk so the first time it is run it will   #
	# take some time.                                               #
	#                                                               #
	# Remember to add require entries in Exec["apply-addons"], or   #
	# you can use 'before => Exec["apply-addons"]' instead.         #
	#################################################################

	$content_stores_git_url = "https://github.com/AFaust/content-stores.git"

	#package{ "git": 
	#	ensure => present,
	#}

	#package{ "maven": 
	#	ensure => present,
	#}

	#package{ "default-jdk":
	#	ensure => present,
	#}

	#exec { "clone-content-stores": 
	#	cwd => "/tmp",
	#	path => "/bin:/usr/bin",
	#	require => Package["git"],
	#	command => "git clone ${content_stores_git_url}",
	#	creates => "/tmp/content-stores/pom.xml",
	#}

	#exec { "build-content-stores":
	#	cwd => "/tmp/content-stores",
	#	path => "/bin:/usr/bin",
	#	require => [ 
	#		Exec["clone-content-stores"], 
	#		Package["maven"], 
	#		Package["default-jdk"], 
	#		File["/tmp/content-stores/pom.xml"], 
	#	], 
	#	command => "mvn package",
	#	timeout => 0, # this can be a very long running command the first time it runs, let it be
	##	creates => "${alfresco_base_dir}/amps/org.alfresco.hackathon.content-stores.repo-0.0.1.0-SNAPSHOT.amp",		
	#}

	# apply the current $alfresco_version to the pom.xml - the erb is found in addons/templates/, not the template
	# path shown here (it's a puppetism)
	#file { "/tmp/content-stores/pom.xml":
	#	ensure => present,
	#	content => template("addons/content-stores-pom.xml.erb"),
	#	require => Exec["clone-content-stores"],
	#	before => Exec["build-content-stores"],
	#}



	# copy the amps into place, before running "apply-addons" to embed them in the wars
	file { "${alfresco_base_dir}/amps/org.alfresco.hackathon.content-stores.repo-0.0.1.0-SNAPSHOT.amp":
		source => "/vagrant/addons-built/content-stores/org.alfresco.hackathon.content-stores.repo-0.0.1.0-SNAPSHOT.amp",
		ensure => present,
		before => Exec["apply-addons"],
	}
	file { "${alfresco_base_dir}/amps_share/org.alfresco.hackathon.content-stores.share-0.0.1.0-SNAPSHOT.amp":
		source => "/vagrant/addons-built/content-stores/org.alfresco.hackathon.content-stores.share-0.0.1.0-SNAPSHOT.amp",
		ensure => present,	
		before => Exec["apply-addons"],
	}

	############ SAMPLE #2 END ######################################



#	############ SAMPLE #3 ##########################################
#	# Building jars from github source                              #
#	#                                                               #
#	# Remember to add require entries in Exec["apply-addons"], or   #
#	# you can use 'before => Exec["apply-addons"]' instead.         #
#	#################################################################
#
#
#	$url_datalist_exts = "https://github.com/deas/fme-alfresco-extdl"
#
#	
#	# get the sources from github
#	exec { "clone-datalist-exts": 
#		cwd => "/tmp",
#		path => "/bin:/usr/bin",
#		require => Package["git"],
#		command => "git clone ${url_datalist_exts}",
#		creates => "/tmp/fme-alfresco-extdl/pom.xml",
#	}
#
#	# build the jars
#	exec { "build-datalist-exts":
#		cwd => "/tmp/fme-alfresco-extdl",
#		path => "/bin:/usr/bin",
#		require => [ 
#			Exec["clone-datalist-exts"], 
#			Package["maven"], 
#			Package["default-jdk"], 
#			#File["/tmp/fme-alfresco-extdl/pom.xml"], 
#		], 
#		command => "mvn package",
#		timeout => 0, # this can be a very long running command the first time it runs, let it be		
#	}
#
#
	# copy the jars into place

	file { "/var/lib/tomcat7/webapps/alfresco/WEB-INF/lib":
		ensure => directory,
		require => File["/var/lib/tomcat7/webapps/alfresco/WEB-INF"],
	}
	file { "/var/lib/tomcat7/webapps/alfresco/WEB-INF":
		ensure => directory,
		require => File["/var/lib/tomcat7/webapps/alfresco"],
	}
	file { "/var/lib/tomcat7/webapps/alfresco":
		ensure => directory,
		require => File["/var/lib/tomcat7/webapps/"],
	}
	file { "/var/lib/tomcat7/webapps/share/WEB-INF/lib":
		ensure => directory,
		require => File["/var/lib/tomcat7/webapps/share/WEB-INF"],
	}
	file { "/var/lib/tomcat7/webapps/share/WEB-INF":
		ensure => directory,
		require => File["/var/lib/tomcat7/webapps/share"],
	}
	file { "/var/lib/tomcat7/webapps/share":
		ensure => directory,
		require => File["/var/lib/tomcat7/webapps/"],
	}
	file { "/var/lib/tomcat7/webapps":
		ensure => directory,
		require => File["/var/lib/tomcat7"],
	}

	file { "/var/lib/tomcat7/webapps/alfresco/WEB-INF/lib/fme-alfresco-extdl-repo-1.2.jar":
		source => "/vagrant/addons-built/datalist-ext/fme-alfresco-extdl-repo-1.2.jar",
		ensure => present,
		
		# it doesn't actually need to be before apply-addons, not like the amps, but it will get it
		# in place without a cross-dependency
		before => Exec["apply-addons"],

		require => [ File["/var/lib/tomcat7/webapps/alfresco/WEB-INF/lib"], Exec["build-datalist-exts"], ],
	}
	file { "/var/lib/tomcat7/webapps/share/WEB-INF/lib/fme-alfresco-extdl-share-1.2.jar":
		source => "/vagrant/addons-built/datalist-ext/fme-alfresco-extdl-share-1.2.jar",
		ensure => present,
		# it doesn't actually need to be before apply-addons, not like the amps, but it will get it
		# in place without a cross-dependency
		before => Exec["apply-addons"],
		require => [ File["/var/lib/tomcat7/webapps/share/WEB-INF/lib"], Exec["build-datalist-exts"], ],
	}

	############ SAMPLE #3 END ######################################








	# copy alfresco bin files to the alfresco base dir
	file { "${alfresco_base_dir}/bin":
		ensure => directory,
		recurse => true,
		source => "/tmp/alfresco/bin",
		require => Exec["unzip-alfresco-ce"], # TODO crossdep
	}

	exec { "apply-addons":
		require => [
			File["${alfresco_base_dir}/bin/apply_amps.sh"],
			File["${alfresco_base_dir}/amps/javascript-console-repo-0.5.1.amp"],
			File["${alfresco_base_dir}/amps_share/javascript-console-share-0.5.1.amp"],
		],
		path => "/bin:/usr/bin",
		command => "${alfresco_base_dir}/bin/apply_amps.sh",
		notify => Exec["fix-war-permissions"],
	}

	file { "${alfresco_base_dir}/bin/apply_amps.sh":
		ensure => present,
		mode => "0755",
		content => template("alfresco-common/apply_amps.sh.erb"),
		require => File["${alfresco_base_dir}/bin"],
	}


	exec { "fix-war-permissions":
		path => "/bin",
		command => "chown tomcat7 /var/lib/tomcat7/webapps/*.war",
	}
}
