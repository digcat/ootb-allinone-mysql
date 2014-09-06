class addons-jsconsole{

	# addons are built by the addonbuilder VM

	file { "${alfresco_base_dir}/amps/javascript-console-repo-0.5.1.amp": 
		source => "/vagrant/addons-built/jsconsole/javascript-console-repo-0.5.1.amp",
		ensure => present,
		before => Exec["apply-addons"],
	}
	file { "${alfresco_base_dir}/amps_share/javascript-console-share-0.5.1.amp": 
		source => "/vagrant/addons-built/jsconsole/javascript-console-share-0.5.1.amp",
		ensure => present,
		before => Exec["apply-addons"],
	}

	############ SAMPLE #1 END ######################################

}
