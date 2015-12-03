class emoncms
{


  file {'/var/www/emoncms':
    ensure => directory,
    owner => 'www-data',
    group => 'root',
  }

  file {'/var/lib/phpfiwa':
    ensure => directory,
    owner => 'www-data',
    group => 'root',
  }

  file {'/var/lib/phpfina':
    ensure => directory,
    owner => 'www-data',
    group => 'root',
  }

  file {'/var/lib/phptimeseries':
    ensure => directory,
    owner => 'www-data',
    group => 'root',
  }

  vcsrepo { '/var/www/emoncms':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/emoncms/emoncms.git',
    require => File['/var/www/emoncms'],
  }

  file {'/var/www/emoncms/settings.php':
    ensure => present,
    source => '/var/www/emoncms/default.settings.php',
    require => Vcsrepo['/var/www/emoncms']
  }



  file_line {'emoncms_error_report':
    path => '/var/www/emoncms/settings.php',
    line => '$display_errors = false;',
    match => '.*\$display_errors.*',
    require => File['/var/www/emoncms/settings.php'],
  }

  vcsrepo {'/var/www/emoncms/Modules/raspberrypi':
    ensure => present,
    provider => git,
    source => 'https://github.com/emoncms/raspberrypi.git',
    require => Vcsrepo['/var/www/emoncms'],
  }

  vcsrepo {'/var/www/emoncms/Modules/event':
    ensure => present,
    provider => git,
    source => 'https://github.com/emoncms/event.git',
    require => Vcsrepo['/var/www/emoncms'],
  }

  vcsrepo {'/var/www/emoncms/Modules/openbem':
    ensure => present,
    provider => git,
    source => 'https://github.com/emoncms/openbem.git',
    require => Vcsrepo['/var/www/emoncms'],
  }

  vcsrepo {'/var/www/emoncms/Modules/energy':
    ensure => present,
    provider => git,
    source => 'https://github.com/emoncms/energy.git',
    require => Vcsrepo['/var/www/emoncms'],
  }

  vcsrepo {'/var/www/emoncms/Modules/notify':
    ensure => present,
    provider => git,
    source => 'https://github.com/emoncms/notify.git',
    require => Vcsrepo['/var/www/emoncms'],
  }

  vcsrepo {'/var/www/emoncms/Modules/report':
    ensure => present,
    provider => git,
    source => 'https://github.com/emoncms/report.git',
    require => Vcsrepo['/var/www/emoncms'],
  }

  vcsrepo {'/var/www/emoncms/Modules/packetgen':
    ensure => present,
    provider => git,
    source => 'https://github.com/emoncms/packetgen.git',
    require => Vcsrepo['/var/www/emoncms'],
  }

  vcsrepo {'/var/www/emoncms/Modules/mqtt':
    ensure => present,
    provider => git,
    source => 'https://github.com/elyobelyob/mqtt.git',
    require => Vcsrepo['/var/www/emoncms'],
  }


}
