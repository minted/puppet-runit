# Define runit::service::env
#
# Defines environment variables for runit services.
#
# == Parameters
#
#   [*namevar/title*]
#     A unique name.
#   [*service*]
#     The name of the runit service for which this variable is to be defined.
#   [*envname*]
#     The name of the environment variable.  Defaults to $title.
#   [*value*]
#     The value of the environment variable.
#
# == Examples
#
#
# == Requires
#
#   runit::service { $service: }
#
define runit::service::env( $service, $envname = $title, $value, $ensure = present ) {

  $envdir = "/etc/sv/${service}/env"

  file { "${envdir}/${envname}":
    ensure  => $ensure,
    content => "${value}\n",
    before  => [Runit::Service::Enabled[$service]],
  }

}
