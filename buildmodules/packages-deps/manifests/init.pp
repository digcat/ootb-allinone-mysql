class packages-deps{

    exec{ "apt-get update":
        path => "/usr/bin",
    }

	package{ "git": 
		ensure => present,
        require => Exec["apt-get update"],
	}

	package{ "unzip": 
        require => Exec["apt-get update"],
		ensure => present,
	}

	package{ "maven": 
        require => Exec["apt-get update"],
		ensure => present,
	}

	package{ "default-jdk":
        require => Exec["apt-get update"],
		ensure => present,
	}

}
