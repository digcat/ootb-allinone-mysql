class addons-content-stores {
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
}
