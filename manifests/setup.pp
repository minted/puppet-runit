class runit::setup {

  package { 'runit':
    ensure => $ensure,
  }

  user { 'svlogd':
    ensure     => present,
    home       => '/nonexistent',
    managehome => false,
    shell      => '/bin/false',
  }

  File { owner => root, group => root, mode => '0755' }

  if $ensure == present {
    file {
      '/etc/sv':
      ensure => directory,
      ;
      '/etc/service':
      ensure => directory,
      ;
    }
  }

}
