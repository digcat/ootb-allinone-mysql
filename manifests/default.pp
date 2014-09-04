
$db_root_password = "strongpassword"

$alfresco_db_name = "alfrescodb"
$alfresco_db_user = "alfrescouser"
$alfresco_db_pass = "userpassword"
$alfresco_db_host = "localhost"
$alfresco_db_port = "3306"

# Username of alfresco user in unix system (not used right now, tomcat7 user is owner)
#$alfresco_sys_user = "alfrescosys"

$alfresco_ce_filename = "alfresco-community-4.2.f.zip"
$alfresco_ce_url = "http://dl.alfresco.com/release/community/4.2.f-build-00012/${alfresco_ce_filename}"

# where alf_data lives; the webapps are in /var/lib/tomcat7/webapps
$alfresco_base_dir = "/opt/alfrescobase"

#########################################################################################

# hack so we can save things in the vagrant folder and not have
# to download them multiple times during development... notably
# the alfresco CE zip will go here. In a non vagrant setup we will
# just end up with a /vagrant folder with these files in
file {"/vagrant":
	ensure => "directory",
}


exec { "apt-get update":
	path => "/usr/bin",
}



class { '::mysql::server':
	  root_password    => $db_root_password,
	  #override_options => $override_options,
}

mysql::db { "$alfresco_db_name":
	user     => "${alfresco_db_user}",
	password => "${alfresco_db_pass}",
	host     => "${alfresco_db_host}",
	grant    => ['ALL'],
}


class { '::mysql::bindings':
	java_enable => 1,
}

# these are provided by the install-puppet-modules.sh script
include '::mysql::server'
include 'postfix'

# these are provided in source form in this project
include "keystore"
include "swftools"
include 'alfresco-common' # for now this is the allinone
#include 'alfresco-war'
#include 'share-war'



