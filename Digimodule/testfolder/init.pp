class digimoduuli {

        exec { 'add-apt-repository -y ppa:webupd8team/brackets':
                command => '/usr/bin/apt-add-repository'}
        exec { 'apt-update':
                command => '/usr/bin/apt-get update'}
        package { brackets
                require => Exec['add-apt-repository -y ppa:webupd8team/brackets'],
                require => Exec['apt-update'],
                ensure => 'installed',
                allowcdrom => 'true',}
        package { apache2:
                require => Exec['apt-update'],
                ensure => 'installed',
                allowcdrom => 'true',}

        file {'/var/www/html/index.html':
                content => "testing testing",
        }
}
