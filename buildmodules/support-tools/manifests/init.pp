class support-tools {

	$url = "https://github.com/Alfresco/alfresco-support-tools.git"


	# get the sources from github
	exec { "clone-support-tools": 
		cwd => "/tmp",
		path => "/bin:/usr/bin",
		require => Package["git"],
		command => "git clone ${url}",
		creates => "/tmp/support-tools",
	}

	exec { "build-support-tools":
		cwd => "/tmp/support-tools/support-tools",
		path => "/bin:/usr/bin",
		require => [ 
			Exec["clone-support-tools"], 
			Package["maven"], 
			Package["default-jdk"], 
		], 
		command => "mvn clean install",
		timeout => 0,	
	}
	
	file { "/vagrant/addons-built/support-tools/support-tools.amp":
		source => "/tmp/support-tools/target/support-tools.amp",
		ensure => present,		
		require => [ 
			File["/vagrant/addons-built/support-tools"], 
			Exec["build-support-tools"], 
		],
	}

	file { "/vagrant/addons-built/support-tools":
		ensure => directory,
		require => File["/vagrant/addons-built"],
	}


}
