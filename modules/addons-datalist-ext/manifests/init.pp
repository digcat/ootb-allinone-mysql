class addons-datalist-ext{

	# addons are built by the addonbuilder VM

	file { "${tomcat_home}/webapps/alfresco/WEB-INF/lib/fme-alfresco-extdl-repo-1.2.jar":
		source => "/vagrant/addons-built/datalist-ext/fme-alfresco-extdl-repo-1.2.jar",
		ensure => present,

		# because these are jars they need to be precisely between these two Execs
		before => Exec["apply-addons"],
		require => [ Exec["unpack-tomcat7"], ],
	}
	file { "${tomcat_home}/webapps/share/WEB-INF/lib/fme-alfresco-extdl-share-1.2.jar":
		source => "/vagrant/addons-built/datalist-ext/fme-alfresco-extdl-share-1.2.jar",
		ensure => present,

		# because these are jars they need to be precisely between these two Execs
		before => Exec["apply-addons"],
		require => [ Exec["unpack-tomcat7"], ],
	}

}
