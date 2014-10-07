class addons-support-tools {

	# addons are built by the addonbuilder VM


	# copy the amps into place, before running "apply-addons" to embed them in the wars
	file { "${alfresco_base_dir}/amps/support-tools.amp":
		source => "/vagrant/addons-built/support-tools/support-tools.amp",
		ensure => present,
		before => Exec["apply-addons"],
	}
}
