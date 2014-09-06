class addons-datalist-ext{
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


	file { "/var/lib/tomcat7/webapps/alfresco/WEB-INF/lib/fme-alfresco-extdl-repo-1.2.jar":
		source => "/vagrant/addons-built/datalist-ext/fme-alfresco-extdl-repo-1.2.jar",
		ensure => present,
		
		# it doesn't actually need to be before apply-addons, not like the amps, but it will get it
		# in place without a cross-dependency
		before => Exec["apply-addons"],

		require => [ File["/var/lib/tomcat7/webapps/alfresco/WEB-INF/lib"] ],
	}
	file { "/var/lib/tomcat7/webapps/share/WEB-INF/lib/fme-alfresco-extdl-share-1.2.jar":
		source => "/vagrant/addons-built/datalist-ext/fme-alfresco-extdl-share-1.2.jar",
		ensure => present,
		# it doesn't actually need to be before apply-addons, not like the amps, but it will get it
		# in place without a cross-dependency
		before => Exec["apply-addons"],
		require => [ File["/var/lib/tomcat7/webapps/share/WEB-INF/lib"] ],
	}

	############ SAMPLE #3 END ######################################



}
