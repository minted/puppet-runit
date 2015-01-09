define runit::service (
  $user    = nobody,     # the service's user name
  $group   = nogroup,    # the service's group name
  $enable  = true,       # shall the service be linked to /etc/service
  $ensure  = present,    # shall the service be present in /etc/sv

  # start command - one of these three must be declared - it defines the content of the run script /etc/sv/$name/run
  $command = undef,      # the most simple way;  just state command here - it may not daemonize itself,
                         # but rather stay in the foreground;  all output is logged automatically to $logdir/current
                         # this uses a default template which provides logging
  $source  = undef,      # specify a source file on your puppet master
  $content = undef,      # specify the content directly (mostly via 'template')

  # service directory - this is required if you use 'command'
  $rundir  = undef,

  # Extra configuration:
  $source_file = undef,   # shall we source an environment?
  $timeout = 7,           # service restart/stop timeouts (only relevant for 'enabled' services)
) {

  # FixMe: Validate parameters
  # fail("Only one of 'command', 'content', or 'source' parameters is allowed")

  if $command != undef and $rundir == undef {
    fail( "You need to specify 'rundir': That's the directory from which the service will be started.")
  }

  # resource defaults
  File { owner => root, group => root, mode => '0755' }

  $svbase = "/etc/sv/${name}"

  # Directories:
  if $ensure == "absent" {
    file { "${svbase}":
      ensure  => absent,
      recurse => true,
      purge   => true,
      force   => true,
    }
  } else {
    file {
      "${svbase}":          ensure => present;
      "${svbase}/env":      ensure => present;
      "${svbase}/log":      ensure => present;
      "${svbase}/log/main": ensure => present;
    }
  }

  # Scripts:
  file {
    "${svbase}/run":
      ensure  => $ensure,
      source  => $source,
      content => $content ? {
        undef   => template('runit/run.erb'),
        default => $content,
      },
      ;

    "${svbase}/finish":
      ensure  => $ensure,
      content => template('runit/finish.erb'),
      ;

    "${svbase}/log/run":
      ensure  => $ensure,
      content => template('runit/logger_run.erb'),
      ;
  }

  # eventually enabling/disabling the service
  if $enable == true {
    debug( "Service ${name}: ${_ensure_enabled}" )
    runit::service::enabled { $name: ensure => $ensure, timeout => $timeout }
  }

}
