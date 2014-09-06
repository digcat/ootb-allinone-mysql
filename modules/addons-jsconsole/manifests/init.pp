class addons-jsconsole{

	############ SAMPLE #1 ##########################################
	# Applying amps from downloaded zip                             #
	#                                                               #
	# Remember to add require entries in Exec["apply-addons"]       #
	#################################################################
	#exec { "retrieve-jsconsole":
	#	creates => "${download_path}/${filename_jsconsole}",
	#	command => "wget ${url_jsconsole} -O ${download_path}/${filename_jsconsole}",
	#	path => "/usr/bin",
	#	require => File["/tmp/jsconsole"],
	#}

	#exec { "unpack-jsconsole":
	#	cwd => "/tmp/jsconsole",
	#	command => "unzip -o ${download_path}/${filename_jsconsole}",
	#	require => [ File["/tmp/jsconsole"], Exec["retrieve-jsconsole"], ],
	#	path => "/usr/bin",
	#}

	#file { "/tmp/jsconsole":
	#	ensure => directory,
	#	before => Exec["unpack-jsconsole"],
	#}

	file { "${alfresco_base_dir}/amps/javascript-console-repo-0.5.1.amp": 
		source => "/vagrant/addons-built/jsconsole/javascript-console-repo-0.5.1.amp",
		ensure => present,
		#require => Exec["unpack-jsconsole"],
	}
	file { "${alfresco_base_dir}/amps_share/javascript-console-share-0.5.1.amp": 
		source => "/vagrant/addons-built/jsconsole/javascript-console-share-0.5.1.amp",
		ensure => present,
		#require => Exec["unpack-jsconsole"],
	}

	#file { "${alfresco_base_dir}/bin":
	#	ensure => directory,
	#}

	############ SAMPLE #1 END ######################################

}
