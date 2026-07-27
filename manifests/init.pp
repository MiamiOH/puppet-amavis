# @summary Installs and manages Amavis.
#
# Installs the appropriate Amavis package for the operating system,
# optionally installs SpamAssassin, and ensures the Amavis service
# is running.
#
# @param package_ensure
#   Desired state of the Amavis package.
#
# @param spamassassin
#   Whether to install the SpamAssassin package.
#
# @param spamassassin_ensure
#   Desired state of the SpamAssassin package.
#
class amavis (
  String  $package_ensure      = 'latest',
  Boolean $spamassassin        = true,
  String  $spamassassin_ensure = 'latest',
) {
  $package_name = $facts['os']['family'] ? {
    'RedHat' => 'amavis',
    'Debian' => 'amavisd-new',
    default  => 'amavisd-new',
  }

  package { $package_name:
    ensure => $package_ensure,
    alias  => 'amavis',
    before => Exec['amavis'],
  }

  if $spamassassin {
    package { 'spamassassin':
      ensure  => $spamassassin_ensure,
      require => Package['amavis'],
      before  => Exec['amavis'],
    }
  }

  exec { 'amavis':
    command     => 'echo "amavis packages are installed"',
    path        => ['/usr/sbin', '/bin', '/usr/bin', '/sbin'],
    logoutput   => true,
    refreshonly => true,
  }

  service { 'amavisd':
    ensure  => running,
    require => Exec['amavis'],
  }
}
