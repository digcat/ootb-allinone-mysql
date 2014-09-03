
class share-war{

	file { "/var/lib/tomcat7/webapps/share.war":
	    source => "/tmp/web-server/webapps/share.war",
	    require => Exec["unzip-alfresco-ce"],
	}

}
