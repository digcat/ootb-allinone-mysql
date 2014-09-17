
class selenium {

	$selenium_jar="selenium-server-standalone-2.42.2.jar"

	exec { "retrieve-selenium":
		command => "wget http://selenium-release.storage.googleapis.com/2.42/${selenium_jar}",
		path => "/usr/bin",
		cwd => "/usr/lib/selenium",
		require => File["/usr/lib/selenium"],
		creates => "/usr/lib/selenium/${selenium_jar}",
	}

	file { "/usr/lib/selenium":
		ensure => directory,
	}
	file { "/var/log/selenium":
		ensure => directory,
		mode => "a+w",
	}

	file { "/usr/lib/selenium/${selenium_jar}":
		require => [ File["/usr/lib/selenium"], Exec["retrieve-selenium"], ],	
	}

	file { "/etc/init.d/selenium":
		mode => "+x",
		source => "puppet:///modules/selenium/initd-script",
	}

	service { "selenium":
		#ensure => running,
		ensure => stopped,
		require => [
			File["/usr/lib/selenium/${selenium_jar}"],
			File["/etc/init.d/selenium"],
		],
	}


}
