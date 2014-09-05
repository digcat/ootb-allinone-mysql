
class addons {


	exec { "retrieve-jsconsole":
		creates => "${download_path}/${filename_jsconsole}",
		command => "wget ${url_jsconsole} -O ${download_path}/${filename_jsconsole}",
		path => "/usr/bin",
		require => File["/tmp/jsconsole"],
	}

	exec { "unpack-jsconsole":
		cwd => "/tmp/jsconsole",
		command => "unzip -o ${download_path}/${filename_jsconsole}",
		require => [ File["/tmp/jsconsole"], Exec["retrieve-jsconsole"], ],
		path => "/usr/bin",
	}

	file { "/tmp/jsconsole":
		ensure => directory,
		before => Exec["unpack-jsconsole"],
	}

	file { "${alfresco_base_dir}/amps/javascript-console-repo-0.5.1.amp": 
		source => "/tmp/jsconsole/4.0.x/javascript-console-repo-0.5.1.amp",
		ensure => present,
		require => Exec["unpack-jsconsole"],
	}
	file { "${alfresco_base_dir}/amps_share/javascript-console-share-0.5.1.amp": 
		source => "/tmp/jsconsole/4.0.x/javascript-console-share-0.5.1.amp",
		ensure => present,
		require => Exec["unpack-jsconsole"],
	}

	file { "${alfresco_base_dir}/bin/apply_amps.sh":
		ensure => present,
		mode => "0755",
		content => template("alfresco-common/apply_amps.sh.erb"),
		require => File["${alfresco_base_dir}/bin"],
	}
	#file { "${alfresco_base_dir}/bin":
	#	ensure => directory,
	#}

	# copy alfresco bin files to the alfresco base dir
	file { "${alfresco_base_dir}/bin":
		ensure => directory,
		recurse => true,
		source => "/tmp/alfresco/bin",
		require => Exec["unzip-alfresco-ce"], # TODO crossdep
	}

	exec { "apply-addons":
		require => [
			File["${alfresco_base_dir}/bin/apply_amps.sh"],
			File["${alfresco_base_dir}/amps/javascript-console-repo-0.5.1.amp"],
			File["${alfresco_base_dir}/amps_share/javascript-console-share-0.5.1.amp"],
		],
		path => "/bin:/usr/bin",
		command => "${alfresco_base_dir}/bin/apply_amps.sh",
		notify => Exec["fix-war-permissions"],
	}

	exec { "fix-war-permissions":
		path => "/bin",
		command => "chown tomcat7 /var/lib/tomcat7/webapps/*.war",
	}
}
