class addons-content-stores {

	# addons are built by the addonbuilder VM


	# copy the amps into place, before running "apply-addons" to embed them in the wars
	file { "${alfresco_base_dir}/amps/org.alfresco.hackathon.content-stores.repo-0.0.1.0-SNAPSHOT.amp":
		source => "/vagrant/addons-built/content-stores/org.alfresco.hackathon.content-stores.repo-0.0.1.0-SNAPSHOT.amp",
		ensure => present,
		before => Exec["apply-addons"],
	}
	file { "${alfresco_base_dir}/amps_share/org.alfresco.hackathon.content-stores.share-0.0.1.0-SNAPSHOT.amp":
		source => "/vagrant/addons-built/content-stores/org.alfresco.hackathon.content-stores.share-0.0.1.0-SNAPSHOT.amp",
		ensure => present,	
		before => Exec["apply-addons"],
	}
}
