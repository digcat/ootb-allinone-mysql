
class keystore {

	$base = "http://svn.alfresco.com/repos/alfresco-open-mirror/alfresco/HEAD/root/projects/repository/config/alfresco/keystore"

	file { "${alfresco_base_dir}/alf_data/keystore":
		ensure => directory,
		require => File["${alfresco_base_dir}/alf_data"],
		#before => Exec["check_if_download_required"],
		owner => "tomcat7",
	}
	file { "${alfresco_base_dir}/alf_data":
		ensure => directory,
		require => File["${alfresco_base_dir}"],
		owner => "tomcat7",
	}


	# http://projects.puppetlabs.com/projects/1/wiki/Download_File_Recipe_Patterns
	define download_file(
		$site="",
		$cwd="",
		$creates="",
		$require="",
		$user="") {                                                                                         

		exec { $name:                                                                                                                     
			command => "wget ${site}/${name}",    
			path => "/usr/bin",                                                     
			cwd => $cwd,
			creates => "${cwd}/${name}",                                                              
			require => $require,
			user => $user,                                                                                                          
		}

	}

	download_file { [
		"browser.p12",
		"generate_keystores.sh",
		"keystore",
		"keystore-passwords.properties",
		"ssl-keystore-passwords.properties",
		"ssl-truststore-passwords.properties",
		"ssl.keystore",
		"ssl.truststore",
	]:
		site => "$base",
		cwd => "${alfresco_base_dir}/alf_data/keystore",
		creates => "${alfresco_base_dir}/alf_data/keystore/${name}",
		require => [ User["tomcat7"], Exec["check_if_download_required"],  ],
		user => "tomcat7",
	}	


	exec{ "check_if_download_required":
		command => "/bin/true",
		unless => '/usr/bin/test -f ${alfresco_base_dir}/alf_data/keystore/ssl.keystore',
	}

}
