
class swftools {
	#$swftools = "http://www.swftools.org/swftools-2013-04-09-1007.tar.gz"

	#exec { "retrieve swftools":
	#	command => "wget -q ${swftools} -O /vagrant/swftools.tar.gz",
	#	path => "/usr/bin",
	#	creates => "/vagrant/swftools.tar.gz",
	#}


	package { "swftools":
		ensure => present,
	}

	

#   sudo apt-get $APTVERBOSITY install make build-essential ccache g++ libgif-dev libjpeg62-dev libfreetype6-dev libpng12-dev libt1-dev
#	package { "build-essential":
#		ensure => present,
#	}
#	package { "ccache":
#		ensure => present,
#	}	
#	package { "g++":
#		ensure => present,
#	}
#	package { "libgif-dev":
#		ensure => present,
#	}
#	package { "libjpeg62-dev":
#		ensure => present,
#	}
#	package { "libfreetype6-dev":
#		ensure => present,
#	}
#	package { "libpng12-dev":
#		ensure => present,
#	}
#	package { "libt1-dev":
#		ensure => present,
#	}

}
