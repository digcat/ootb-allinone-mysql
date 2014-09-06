
class addons {

	include "addons-jsconsole"
	include "addons-content-stores"
	#include "datalist-ext"


######################################################################################################

	file { "/var/lib/tomcat7/webapps/alfresco/WEB-INF/lib":
		ensure => directory,
		require => File["/var/lib/tomcat7/webapps/alfresco/WEB-INF"],
	}
	file { "/var/lib/tomcat7/webapps/alfresco/WEB-INF":
		ensure => directory,
		require => File["/var/lib/tomcat7/webapps/alfresco"],
	}
	file { "/var/lib/tomcat7/webapps/alfresco":
		ensure => directory,
		require => File["/var/lib/tomcat7/webapps/"],
	}
	file { "/var/lib/tomcat7/webapps/share/WEB-INF/lib":
		ensure => directory,
		require => File["/var/lib/tomcat7/webapps/share/WEB-INF"],
	}
	file { "/var/lib/tomcat7/webapps/share/WEB-INF":
		ensure => directory,
		require => File["/var/lib/tomcat7/webapps/share"],
	}
	file { "/var/lib/tomcat7/webapps/share":
		ensure => directory,
		require => File["/var/lib/tomcat7/webapps/"],
	}
	file { "/var/lib/tomcat7/webapps":
		ensure => directory,
		require => File["/var/lib/tomcat7"],
	}




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

	file { "${alfresco_base_dir}/bin/apply_amps.sh":
		ensure => present,
		mode => "0755",
		content => template("alfresco-common/apply_amps.sh.erb"),
		require => File["${alfresco_base_dir}/bin"],
	}


	exec { "fix-war-permissions":
		path => "/bin",
		command => "chown tomcat7 /var/lib/tomcat7/webapps/*.war",
	}
}
