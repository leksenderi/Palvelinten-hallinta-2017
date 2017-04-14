class apache {
	
	#ajaa apt-get updaten
	exec { 'apt-update':
		command => '/usr/bin/apt-get update'
	}
	
	#asentaa apache paketin vasta kun apt-get update on ajettu
	package { apache2:
		require => Exec['apt-update'],
		ensure => 'installed',
		allowcdrom => 'true',
	}
	
	#korvaa apachen vakio html sivuston tekstillä "testing testing"
	file {'/var/www/html/index.html':
		content => "testing testing",
	}
}
