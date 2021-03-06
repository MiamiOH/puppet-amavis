class amavis::config(
  $final_virus_destiny      = 'D_DISCARD',
  $final_banned_destiny     = 'D_BOUNCE',
  $final_spam_destiny       = 'D_DISCARD',
  $final_bad_header_destiny = 'D_BOUNCE',
  $max_servers              = '2',
  $scanning_disabled        = undef,   # scanning enabled by default
  $whitelist                = undef,   # enable whitelisting
  $whitelist_entries,
) {

  include amavis

  $real_whitelist = join($whitelist_entries,"','")

  file { '/etc/amavisd/amavisd.conf':
    ensure  => present,
    content => template('amavis/amavisd.conf.erb'),
    notify  => Service['amavisd'],
    require => Exec['amavis'],
  }

}
