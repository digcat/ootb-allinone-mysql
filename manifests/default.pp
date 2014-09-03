
$alfresco_db_name = "alfrescodb"
$alfresco_db_user = "alfrescouser"
$alfresco_db_pass = "userpassword"
$alfresco_db_host = "localhost"
$alfresco_db_port = "3306"

#########################################################################################

# hack so we can save things in the vagrant folder and not have
# to download them multiple times during development... notably
# the alfresco CE zip will go here
file {"/vagrant":
    ensure => "directory",
}


exec { "apt-get update":
  path => "/usr/bin",
}



class { '::mysql::server':
  root_password    => 'strongpassword',
  #override_options => $override_options,
}

 mysql::db { "$alfresco_db_name":
      user     => "${alfresco_db_user}",
      password => "${alfresco_db_pass}",
      host     => "${alfresco_db_host}",
      grant    => ['ALL'],
    }


include '::mysql::server'


include 'postfix'

include 'alfresco-common'
include 'alfresco-war'
include 'share-war'



