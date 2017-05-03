class digimoduuli {
	
	exec { 'add-apt-repository -y ppa:webupd8team/brackets' }
	exec { 'apt-update':
		command => '/usr/bin/apt-get update'}
	package { apache2:
		require => Exec['apt-update'],
		ensure => 'installed',
		allowcdrom => 'true',}
	package { brackets }

	file {'/var/www/html/index.html':
		content => "testing testing",
	}
}
