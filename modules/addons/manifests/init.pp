
class addons {


	exec { "retrieve-jsconsole":
		creates => "${download_path}/${filename_jsconsole}",
		command => "wget ${url_jsconsole} -O ${download_path}/${filename_jsconsole}",
		path => "/usr/bin",
		require => File["/tmp/jsconsole"],
	}

	exec { "unpack-jsconsole":
		cwd => "/tmp/jsconsole",
		command => "unzip ${download_path}/${filename_jsconsole}",
		require => [ File["/tmp/jsconsole"], Exec["retrieve-jsconsole"], ],
		path => "/usr/bin",
	}

	file { "/tmp/jsconsole":
		ensure => directory,
	}
}
