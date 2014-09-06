class datalist-ext {
	############ SAMPLE #3 ##########################################
	# Building jars from github source                              #
	#                                                               #
	# Remember to add require entries in Exec["apply-addons"], or   #
	# you can use 'before => Exec["apply-addons"]' instead.         #
	#################################################################


	$url_datalist_exts = "https://github.com/deas/fme-alfresco-extdl"

	
	# get the sources from github
	exec { "clone-datalist-exts": 
		cwd => "/tmp",
		path => "/bin:/usr/bin",
		require => Package["git"],
		command => "git clone ${url_datalist_exts}",
		creates => "/tmp/fme-alfresco-extdl/pom.xml",
	}

	# build the jars
	exec { "build-datalist-exts":
		cwd => "/tmp/fme-alfresco-extdl",
		path => "/bin:/usr/bin",
		require => [ 
			Exec["clone-datalist-exts"], 
			Package["maven"], 
			Package["default-jdk"], 
		], 
		command => "mvn package",
		timeout => 0, # this can be a very long running command the first time it runs, let it be		
	}

	file { "/vagrant/addons-built/datalist-ext/fme-alfresco-extdl-repo-1.2.jar":
		source => "/tmp/fme-alfresco-extdl/fme-alfresco-extdl-repo/target/fme-alfresco-extdl-repo-1.2.jar",
		ensure => present,
		
		require => [ 
			File["/vagrant/addons-built/datalist-ext"], 
			Exec["build-datalist-exts"], 
		],
	}
	file { "/vagrant/addons-built/datalist-ext/fme-alfresco-extdl-share-1.2.jar":
		source => "/tmp/fme-alfresco-extdl/fme-alfresco-extdl-share/target/fme-alfresco-extdl-share-1.2.jar",
		ensure => present,
		require => [ 
			File["/vagrant/addons-built/datalist-ext"], 
			Exec["build-datalist-exts"], 
		],
	}

	file { "/vagrant/addons-built/datalist-ext":
		ensure => directory,
	}

	############ SAMPLE #3 END ######################################


}
