class packages-deps{


	package{ "git": 
		ensure => present,
	}

	package{ "unzip": 
		ensure => present,
	}

	package{ "maven": 
		ensure => present,
	}

	package{ "default-jdk":
		ensure => present,
	}

}
