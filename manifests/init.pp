class runit( $ensure = present ) {

  package { runit: ensure => $ensure }

  user { 'svlogd':
    ensure     => present,
    home       => '/nonexistent',
    managehome => false,
    shell      => '/bin/false',
  }

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
