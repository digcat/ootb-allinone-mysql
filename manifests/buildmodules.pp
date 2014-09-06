
$alfresco_version = "4.2.f"

$download_path = "/vagrant/files" 

file { "/vagrant/addons-built":	
	ensure => directory,
}
file {"/vagrant/files": 
	ensure => "directory",
}

# the settings in here allow us to cache the m2 repository stuff between vm destruction and rebuild
# by setting the repository root to /vagrant/cache-m2
file { "/root/.m2/settings.xml":
	#source => "puppet:///alfresco-common/mvn-settings.xml",
	source => "/vagrant/modules/alfresco-common/files/mvn-settings.xml",
	require => File["/root/.m2"],
	ensure => present,
}
file { "/root/.m2":
	ensure => directory,
}




# if you need to add packages to help build or deploy your addon, add them 
# in to packages-deps and they will be installed prior to any builds 
stage { 'first':
	before => Stage['main'],
}
class { "packages-deps":
	stage => first,
}
include "packages-deps"



# Include the individual addon manifests here
include "content-stores"
include "jsconsole"
include "datalist-ext"



