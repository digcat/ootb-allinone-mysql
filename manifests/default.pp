
# hack so we can save things in the vagrant folder and not have
# to download them loads...
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



package { "tomcat7":
  ensure => present,
  require => Exec["apt-get update"],
}
service { "tomcat7":
  ensure  => "running",
  require => [
	Package["tomcat7"], 
	File["/var/lib/tomcat7/webapps/alfresco.war"],
  	File["/var/lib/tomcat7/webapps/share.war"],
	File["/var/lib/tomcat7/shared/classes/alfresco-global-properties"],
  ],
}


# http://stackoverflow.com/a/18846683
# Using "creates" means that this exec is only run if this file does not exist 
exec { "retrieve-alfresco-ce":
  command => "wget -q http://dl.alfresco.com/release/community/4.2.f-build-00012/alfresco-community-4.2.f.zip -O /vagrant/alfresco-community-4.2.f.zip",
  path => "/usr/bin",
  creates => "/vagrant/alfresco-community-4.2.f.zip",
}



exec { "unzip-alfresco-ce":
  command => "unzip -o /vagrant/alfresco-community-4.2.f.zip -d /tmp",
  path => "/usr/bin",
  require => [ 
	Exec["retrieve-alfresco-ce"],
        Package["tomcat7"], 
	Package["unzip"], 
  ],
}



file { "/var/lib/tomcat7/webapps/alfresco.war":
    source => "/tmp/web-server/webapps/alfresco.war",
    require => Exec["unzip-alfresco-ce"],
}
file { "/var/lib/tomcat7/webapps/share.war":
    source => "/tmp/web-server/webapps/share.war",
    require => Exec["unzip-alfresco-ce"],
}
file { "/var/lib/tomcat7/shared/classes/alfresco-global-properties":
	source => "/vagrant/alfresco-global.properties",
	require => Package["tomcat7"],
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
}

include '::mysql::server'




class { 'postfix':

}
include 'postfix'
