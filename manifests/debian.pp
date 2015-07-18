#
class java::debian (
  $package,
  $source,
  $distribution, # jdk or jre
  $release, # e.g. java7, java8
  $version, # present, latest
  ){

  # Needed for update-java-alternatives
  package { 'java-common':
    ensure => present,
    before => Class['java::config'],
  }

  anchor { 'java::repo:': }
  case $source {
    'webupd8team' :{
     case $::operatingsystem {
        debian: {
          include apt
          apt::source { 'webupd8team-java':
            location    => 'http://ppa.launchpad.net/webupd8team/java/ubuntu',
            release     => $::lsbdistcodename,
            repos       => 'main',
            key         => '7B2C3B0889BF5709A105D03AC2518248EEA14886',
            key_server  => 'keyserver.ubuntu.com',
            include_src => true,
            require     => Anchor['java::repo:']
          }
        }

        ubuntu: {
          include apt
          apt::ppa { 'ppa:webupd8team/java':
            require  => Anchor['java::repo:']
          }
        }

        default: {
          notice "Unsupported operatingsystem ${::operatingsystem}"
        }
      }

      file { '/tmp/java.preseed':
        content => template('java/preseed.erb'),
        mode   => '0600',
        backup => false,
        before => Anchor['java::repo:']
      }

      exec { 'apt-get_update':
        command     => '/usr/bin/apt-get update',
        refreshonly => true,
        require     => Anchor['java::repo:']
      }

      ensure_resource('package', ["oracle-${release}-${distribution}", "oracle-${release}-set-default"],
        {'ensure' => $version, 'require' => Exec['apt-get_update']}
      )
    }
    default: {}
  }
}