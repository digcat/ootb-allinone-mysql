class nightwatch {

	exec { "retrieve-nightwatch":
		command => "git clone https://github.com/beatfactor/nightwatch",
		require => Package["git"],
		cwd => "/tmp",
		path => "/bin:/usr/bin",
		creates => "/tmp/nightwatch/README.md",
	}


	exec { "install-nightwatch":
		require => Exec["retrieve-nightwatch"],
		path => "/bin:/usr/bin",
		command => "npm install",
		cwd => "/tmp/nightwatch",

	}

	
	exec { "run-nightwatch":
		require => [ Exec["install-nightwatch"], Service["selenium"], ],
		cwd => "/vagrant/tests",
		path => "/bin:/usr/bin",
		command => "/vagrant/tests/nightwatch",
	}

}
