class zaizi-alfresco-recommendations {

	$url = "https://github.com/zaizi/alfresco-recommendations.git"


	# get the sources from github
	exec { "clone-alfresco-recommendations": 
		cwd => "/tmp",
		path => "/bin:/usr/bin",
		require => Package["git"],
		command => "git clone ${url}",
		creates => "/tmp/alfresco-recommendations",
	}

	exec { "build-zaizi-mahout-alfresco4":
		cwd => "/tmp/alfresco-recommendations/zaizi-mahout-alfresco4",
		path => "/bin:/usr/bin",
		require => [ 
			Exec["clone-alfresco-recommendations"], 
			Package["maven"], 
			Package["default-jdk"], 
		], 
		command => "mvn clean install",
		timeout => 0,	
	}

	exec { "build-zaizi-recommendations-dashlet-alfresco4":
		cwd => "/tmp/alfresco-recommendations/zaizi-recommendations-dashlet-alfresco4",
		path => "/bin:/usr/bin",
		require => [ 
			Exec["clone-alfresco-recommendations"], 
			Package["maven"], 
			Package["default-jdk"],
			Exec["build-zaizi-mahout-alfresco4"], 
		], 
		command => "mvn clean package",
		timeout => 0, 
	}


	exec { "build-fivestart":
		cwd => "/tmp/alfresco-recommendations/fivestart",
		path => "/bin:/usr/bin",
		require => [ 
			Exec["clone-alfresco-recommendations"], 
			Package["maven"], 
			Package["default-jdk"],
			Exec["build-zaizi-mahout-alfresco4"], 
		], 
		command => "mvn clean package",
		timeout => 0, 
	}


# ./fivestart/fivestart-alfresco-module/target/fivestart_alfresco_module.amp
# ./fivestart/fivestart-share-module/target/fivestart_share_module.amp
	
	file { "/vagrant/addons-built/alfresco-recommendations/fivestart_alfresco_module.amp":
		source => "/tmp/alfresco-recommendations/fivestart/fivestart-alfresco-module/target/fivestart_alfresco_module.amp",
		ensure => present,		
		require => [ 
			File["/vagrant/addons-built/alfresco-recommendations"], 
			Exec["build-fivestart"], 
		],
	}
	file { "/vagrant/addons-built/alfresco-recommendations/fivestart_share_module.amp":
		source => "/tmp/alfresco-recommendations/fivestart/fivestart-share-module/target/fivestart_share_module.amp",
		ensure => present,		
		require => [ 
			File["/vagrant/addons-built/alfresco-recommendations"], 
			Exec["build-fivestart"], 
		],
	}

# ./zaizi-recommendations-dashlet-alfresco4/recommendations-dashlet-repository/target/recommendations-dashlet-repository-1.0.amp
# ./zaizi-recommendations-dashlet-alfresco4/recommendations-dashlet-share/target/recommendations-dashlet-share-1.0.amp

	file { "/vagrant/addons-built/alfresco-recommendations/recommendations-dashlet-repository-1.0.amp":
		source => "/tmp/alfresco-recommendations/zaizi-recommendations-dashlet-alfresco4/recommendations-dashlet-repository/target/recommendations-dashlet-repository-1.0.amp",
		ensure => present,		
		require => [ 
			File["/vagrant/addons-built/alfresco-recommendations"], 
			Exec["build-zaizi-recommendations-dashlet-alfresco4"], 
		],
	}

	file { "/vagrant/addons-built/alfresco-recommendations/recommendations-dashlet-share-1.0.amp":
		source => "/tmp/alfresco-recommendations/zaizi-recommendations-dashlet-alfresco4/recommendations-dashlet-share/target/recommendations-dashlet-share-1.0.amp",
		ensure => present,		
		require => [ 
			File["/vagrant/addons-built/alfresco-recommendations"], 
			Exec["build-zaizi-recommendations-dashlet-alfresco4"], 
		],
	}

	file { "/vagrant/addons-built/alfresco-recommendations":
		ensure => directory,
		require => File["/vagrant/addons-built"],
	}


}
