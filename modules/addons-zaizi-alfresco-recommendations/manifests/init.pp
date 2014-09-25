class addons-zaizi-alfresco-recommendations {

	# addons are built by the addonbuilder VM


	# copy the amps into place, before running "apply-addons" to embed them in the wars
	file { "${alfresco_base_dir}/amps/fivestart_alfresco_module.amp":
		source => "/vagrant/addons-built/alfresco-recommendations/fivestart_alfresco_module.amp",
		ensure => present,
		before => Exec["apply-addons"],
	}
	file { "${alfresco_base_dir}/amps_share/fivestart_share_module.amp":
		source => "/vagrant/addons-built/alfresco-recommendations/fivestart_share_module.amp",
		ensure => present,	
		before => Exec["apply-addons"],
	}
	file { "${alfresco_base_dir}/amps/recommendations-dashlet-repository-1.0.amp":
		source => "/vagrant/addons-built/alfresco-recommendations/recommendations-dashlet-repository-1.0.amp",
		ensure => present,
		before => Exec["apply-addons"],
	}
	file { "${alfresco_base_dir}/amps_share/recommendations-dashlet-share-1.0.amp":
		source => "/vagrant/addons-built/alfresco-recommendations/recommendations-dashlet-share-1.0.amp",
		ensure => present,	
		before => Exec["apply-addons"],
	}
}
