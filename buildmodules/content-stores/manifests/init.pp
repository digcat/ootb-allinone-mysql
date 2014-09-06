
class content-stores{
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
			File["/root/.m2/settings.xml"],
		], 
		command => "mvn package",
		timeout => 0, # this can be a very long running command the first time it runs, let it be
		creates => "/tmp/content-stores/repository/target/org.alfresco.hackathon.content-stores.repo-0.0.1.0-SNAPSHOT.amp",		
	}

	file { "/tmp/content-stores/repository/target/org.alfresco.hackathon.content-stores.repo-0.0.1.0-SNAPSHOT.amp" :
		ensure => present,
		require => Exec["build-content-stores"],
	}
	file { "/tmp/content-stores/share/target/org.alfresco.hackathon.content-stores.share-0.0.1.0-SNAPSHOT.amp" :
		ensure => present,
		require => Exec["build-content-stores"],
	}

	# apply the current $alfresco_version to the pom.xml - the erb is found in content-stores/templates/, not the template
	# path shown here (it's a puppetism)
	file { "/tmp/content-stores/pom.xml":
		ensure => present,
		content => template("content-stores/content-stores-pom.xml.erb"),
		require => Exec["clone-content-stores"],
		before => Exec["build-content-stores"],
	}


	file { "/vagrant/addons-built/content-stores":
		ensure => directory,
		require => File["/vagrant/addons-built"],
	}

	# copy the amps into place, 
	file { "/vagrant/addons-built/content-stores/org.alfresco.hackathon.content-stores.repo-0.0.1.0-SNAPSHOT.amp":
		source => "/tmp/content-stores/repository/target/org.alfresco.hackathon.content-stores.repo-0.0.1.0-SNAPSHOT.amp",
		ensure => present,
		require => [
			Exec["build-content-stores"],
			File["/vagrant/addons-built/content-stores"],
		],
	}
	file { "/vagrant/addons-built/content-stores/org.alfresco.hackathon.content-stores.share-0.0.1.0-SNAPSHOT.amp":
		source => "/tmp/content-stores/share/target/org.alfresco.hackathon.content-stores.share-0.0.1.0-SNAPSHOT.amp",
		ensure => present,	
		require => [
			Exec["build-content-stores"],
			File["/vagrant/addons-built/content-stores"],
		],
	}

	############ SAMPLE #2 END ######################################
}
