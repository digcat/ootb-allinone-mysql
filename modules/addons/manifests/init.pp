
class addons {


	############ SAMPLE #1 ##########################################
	# Applying amps from downloaded zip                             #
	#                                                               #
	# Remember to add require entries in Exec["apply-addons"]       #
	#################################################################
	exec { "retrieve-jsconsole":
		creates => "${download_path}/${filename_jsconsole}",
		command => "wget ${url_jsconsole} -O ${download_path}/${filename_jsconsole}",
		path => "/usr/bin",
		require => File["/tmp/jsconsole"],
	}

	exec { "unpack-jsconsole":
		cwd => "/tmp/jsconsole",
		command => "unzip -o ${download_path}/${filename_jsconsole}",
		require => [ File["/tmp/jsconsole"], Exec["retrieve-jsconsole"], ],
		path => "/usr/bin",
	}

	file { "/tmp/jsconsole":
		ensure => directory,
		before => Exec["unpack-jsconsole"],
	}

	file { "${alfresco_base_dir}/amps/javascript-console-repo-0.5.1.amp": 
		source => "/tmp/jsconsole/4.0.x/javascript-console-repo-0.5.1.amp",
		ensure => present,
		require => Exec["unpack-jsconsole"],
	}
	file { "${alfresco_base_dir}/amps_share/javascript-console-share-0.5.1.amp": 
		source => "/tmp/jsconsole/4.0.x/javascript-console-share-0.5.1.amp",
		ensure => present,
		require => Exec["unpack-jsconsole"],
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

	package{ "git": 
		ensure => present,
	}

	package{ "maven": 
		ensure => present,
	}

	package{ "default-jdk":
		ensure => present,
	}

	exec { "clone-content-stores": 
		cwd => "/tmp",
		path => "/bin:/usr/bin",
		require => Package["git"],
		command => "git clone ${content_stores_git_url}",
		creates => "/tmp/content-stores/pom.xml",
	}

	exec { "build-content-stores":
		cwd => "/tmp/content-stores",
		path => "/bin:/usr/bin",
		require => [ 
			Exec["clone-content-stores"], 
			Package["maven"], 
			Package["default-jdk"], 
			File["/tmp/content-stores/pom.xml"], 
		], 
		command => "mvn install",
		timeout => 0, # this can be a very long running command the first time it runs, let it be		
	}

	# apply the current $alfresco_version to the pom.xml - the erb is found in addons/templates/, not the template
	# path shown here (it's a puppetism)
	file { "/tmp/content-stores/pom.xml":
		ensure => present,
		content => template("addons/content-stores-pom.xml.erb"),
		require => Exec["clone-content-stores"],
		before => Exec["build-content-stores"],
	}



	file { "${alfresco_base_dir}/amps/org.alfresco.hackathon.content-stores.repo-0.0.1.0-SNAPSHOT.amp":
		source => "/tmp/content-stores/repository/target/org.alfresco.hackathon.content-stores.repo-0.0.1.0-SNAPSHOT.amp",
		ensure => present,
		before => Exec["apply-addons"],
	}
	file { "${alfresco_base_dir}/amps_share/org.alfresco.hackathon.content-stores.share-0.0.1.0-SNAPSHOT.amp":
		source => "/tmp/content-stores/share/target/org.alfresco.hackathon.content-stores.share-0.0.1.0-SNAPSHOT.amp",
		ensure => present,	
		before => Exec["apply-addons"],
	}

	############ SAMPLE #2 END ######################################














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
