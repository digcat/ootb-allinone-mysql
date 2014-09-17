
class package-deps {
	#$chromedriver_url="http://chromedriver.storage.googleapis.com/2.10/chromedriver_linux64.zip"


	exec { "apt-get update":
		path => "/usr/bin",
	}


	package { "git":
		ensure => present,
		require => Exec["apt-get update"],
	}

	package { "firefox":
		ensure => present,
		require => Exec["apt-get update"],
	}


	package { "chromium-chromedriver":
		ensure => present,
		require => Exec["apt-get update"],
	}

	package { "chromium-browser":
		ensure => present,
		require => Exec["apt-get update"],
	}	


	package { "unzip":
	    	ensure => present,
		require => Exec["apt-get update"],
	}

	package { "npm":
	    	ensure => present,
		require => Exec["apt-get update"],
	}

	package { "nodejs":
	    	ensure => present,
		require => Exec["apt-get update"],
	}
	package { "nodejs-legacy": # needed for nightwatch?
	    	ensure => present,
		require => Exec["apt-get update"],
	}

	exec{ "install selenium-webdriver":
		require => [ Package["npm"], ],
		path => "/usr/bin",
		command => "npm install selenium-webdriver",
	}

	package { "openjdk-7-jre":
	    	ensure => present,
		require => Exec["apt-get update"],
	}

	package { "xvfb":
	    	ensure => present,
		require => Exec["apt-get update"],
	}

}
