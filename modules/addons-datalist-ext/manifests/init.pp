class addons-datalist-ext{

	# addons are built by the addonbuilder VM

	file { "${tomcat_home}/webapps/alfresco/WEB-INF/lib/fme-alfresco-extdl-repo-1.2.jar":
		source => "/vagrant/addons-built/datalist-ext/fme-alfresco-extdl-repo-1.2.jar",
		ensure => present,

		before => Exec["apply-addons"],
		require => [ 
			# because these are jars they need to be applied after tomcat is unpacked
			Exec["unpack-tomcat7"], 
			Exec["unpack-alfresco-war"], #TODO Crossdep >.<		
		],
	}
	file { "${tomcat_home}/webapps/share/WEB-INF/lib/fme-alfresco-extdl-share-1.2.jar":
		source => "/vagrant/addons-built/datalist-ext/fme-alfresco-extdl-share-1.2.jar",
		ensure => present,

		before => Exec["apply-addons"],
		require => [ 
			Exec["unpack-tomcat7"], 
			Exec["unpack-share-war"], #TODO Crossdep >.<		
		],
	}

}
