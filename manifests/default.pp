
# hack so we can save things in the vagrant folder and not have
# to download them multiple times during development... notably
# the alfresco CE zip will go here
file {"/vagrant":
    ensure => "directory",
}


exec { "apt-get update":
  path => "/usr/bin",
}


package { "unzip":
  ensure => present,
  require => Exec["apt-get update"],
}

# for convenience, let's have the mysql-client
package { "mysql-client":
  ensure => present,
  require => Exec["apt-get update"],
}


class { '::mysql::server':
  root_password    => 'strongpassword',
  #override_options => $override_options,
  users => {
	  'alfresco@localhost' => {
	    ensure                   => 'present',
	    max_connections_per_hour => '0',
	    max_queries_per_hour     => '0',
	    max_updates_per_hour     => '0',
	    max_user_connections     => '0',
	    # select password("userpassword");
	    password_hash            => "*3D885319D32AF8352A3B6DC864F86159F67911C1",
	  },
	},
  grants => {
	  'alfresco@localhost/alfresco.*' => {
	    ensure     => 'present',
	    options    => ['GRANT'],
	    privileges => ['SELECT', 'INSERT', 'UPDATE', 'DELETE'],
	    table      => 'alfresco.*',
	    user       => 'alfresco@localhost',
	  },
	},
  databases => {
    'alfresco' => {
        ensure  => 'present',
        charset => 'utf8',
    },
  }
}

include '::mysql::server'

include 'postfix'


include 'alfresco-common'
include 'alfresco-war'
include 'share-war'



