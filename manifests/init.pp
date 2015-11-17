class emoncms {
    # install prereqs
    $prereq_packages = [
        "apache2",
        "mysql-server",
        "mysql-client",
        "php5",
        "libapache2-mod-php5",
        "php5-mysql",
        "php5-curl",
        "php-pear",
        "php5-dev",
        "php5-mcrypt",
        "php5-json",
        "git-core",
        "redis-server",
        "build-essential",
        "ufw",
        "ntp"
    ]

    package { $prereq_packages:
        ensure => latest,
    }


    package {'redis':
        ensure => latest,
        provider => 'pecl',
        require => Package['php-pear'],
    }

    package {'swift/swift':
        ensure => latest,
        provider => 'pecl',
        require => [Package['php-pear'], Exec['swiftchanel']]
    }

    exec { 'swiftchanel':
        command => '/usr/bin/pear channel-discover pear.swiftmailer.org',
        unless => 'pear list-channels | grep swift',
        require => Package['php-pear'],
    }

    package {'channel://pecl.php.net/dio-0.0.6':
        ensure => latest,
        provider => 'pecl',
        require => Package['php-pear'],
    }


    # configure apache



    # configure mysql
    # create mysql database
    # clone emoncms repo
    # profit
}
