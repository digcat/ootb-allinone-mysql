#alfresco-war

class alfresco-war {
	file { "/var/lib/tomcat7/webapps/alfresco.war":
	    source => "/tmp/web-server/webapps/alfresco.war",
	    require => Exec["unzip-alfresco-ce"],
	}

}
