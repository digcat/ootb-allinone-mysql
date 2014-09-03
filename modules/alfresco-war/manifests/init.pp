#alfresco-war

class alfresco-war {
	file { "/var/lib/tomcat7/webapps/alfresco.war":
		source => "/tmp/web-server/webapps/alfresco.war",
		require => Exec["unzip-alfresco-ce"],
	}


	file { "/var/lib/tomcat7/shared/classes/alfresco-global.properties":
		#source => "/vagrant/alfresco-global.properties",
		require => Package["tomcat7"],
		content => template("alfresco-war/alfresco-global.properties.erb"),
	}

}
