class emoncms::prereqs
( $mysql_host,
  $mysql_user,
  $mysql_database,
  $mysql_password,
  $mysql_root_password,
  $server_vhost_name,
  $server_vhost_aliases
) {
  # install prereqs
  $prereq_packages = [
      "php5-curl",
      "php5-dev",
      "php5-mcrypt",
      "php5-json",
      "redis-server",
      "build-essential",
      "ufw",
      "php5-redis",
      "libphp-swiftmailer",
      "libapache2-mod-php5",
  ]

  package { $prereq_packages:
    ensure => latest,
  }

  php::pecl::module {'dio':
    use_package => 'false',
    preferred_state => 'beta',
    require => Package[$prereq_packages],
  }

  class {'apache':
    default_vhost => false,
    mpm_module => false,
  }

  class {'apache::mod::prefork':
		startservers => "3",
		minspareservers => "3",
		maxspareservers => "3",
		serverlimit => "30",
		maxclients => "30",
	}

  package { 'php5-mysql':
    ensure => latest,
  }

  package {'php5-fpm':
    ensure => latest,
  }

  service {'php5-fpm':
    ensure => running,
    require => Package['php5-fpm'],
  }

  file {'/etc/php5/fpm/conf.d/20-dio.ini':
    ensure => present,
    content => 'extension=dio.so',
    require => [Package['libapache2-mod-php5'], Package['apache2']]
  }

  file {'/etc/php5/cli/conf.d/20-dio.ini':
    ensure => present,
    content => 'extension=dio.so',
    require => [Package['libapache2-mod-php5'], Package['apache2']]
  }


  file {'/etc/php5/fpm/conf.d/20-redis.ini':
    ensure => present,
    content => 'extension=redis.so',
    require => [Package['libapache2-mod-php5'], Package['apache2']]
  }

  file {'/etc/php5/cli/conf.d/20-redis.ini':
    ensure => present,
    content => 'extension=redis.so',
    require => [Package['libapache2-mod-php5'], Package['apache2']]
  }



  apache::vhost {'$server_vhost_name':
    port => '80',
    docroot => '/var/www/emoncms',
    serveraliases => $server_vhost_aliases,
    override => 'All',

  }

  class {'apache::mod::rewrite': }
  class {'apache::mod::php': }


  file_line {'emoncms_db_server':
    path => '/var/www/emoncms/settings.php',
    line => '$server = "${mysql_host}";',
    match => '.*\$server.*',
    require => File['/var/www/emoncms/settings.php'],
  }

  file_line {'emoncms_db_database':
    path => '/var/www/emoncms/settings.php',
    line => '$database = "${mysql_database}";',
    match => '.*\$database.*',
    require => File['/var/www/emoncms/settings.php'],
  }

  file_line {'emoncms_db_user':
    path => '/var/www/emoncms/settings.php',
    line => '$username = "${mysql_user}r";',
    match => '.*\$username.*',
    require => File['/var/www/emoncms/settings.php'],
  }

  file_line {'emoncms_db_password':
    path => '/var/www/emoncms/settings.php',
    line => '$password = "${mysql_password}";',
    match => '.*\$password.*',
    require => File['/var/www/emoncms/settings.php'],
  }


  class { '::mysql::server':
    root_password           => '${mysql_root_password}',
  }


  mysql::db{'${mysql_database}':
    user => '${mysql_user}',
    password => '${mysql_password}',
    host => '${mysql_host}',
    grant => ['ALL'],
    require => Package['mysql-server']
  }
}
