# @summary Configures Amavis.
#
# Generates the Amavis configuration file from a template and manages
# the Amavis service.
#
# @param final_virus_destiny
#   Action to take when a virus is detected.
#
# @param final_banned_destiny
#   Action to take when banned content is detected.
#
# @param final_spam_destiny
#   Action to take when spam is detected.
#
# @param final_bad_header_destiny
#   Action to take when a message with bad headers is detected.
#
# @param max_servers
#   Maximum number of Amavis server processes.
#
# @param scanning_disabled
#   Whether message scanning is disabled. Defaults to `undef`,
#   which leaves scanning enabled.
#
# @param whitelist
#   Whether whitelisting is enabled. Defaults to `undef`.
#
# @param whitelist_entries
#   List of email addresses or domains to whitelist.
#
class amavis::config (
  Enum['D_PASS', 'D_DISCARD', 'D_BOUNCE', 'D_REJECT'] $final_virus_destiny      = 'D_DISCARD',
  Enum['D_PASS', 'D_DISCARD', 'D_BOUNCE', 'D_REJECT'] $final_banned_destiny     = 'D_BOUNCE',
  Enum['D_PASS', 'D_DISCARD', 'D_BOUNCE', 'D_REJECT'] $final_spam_destiny       = 'D_DISCARD',
  Enum['D_PASS', 'D_DISCARD', 'D_BOUNCE', 'D_REJECT'] $final_bad_header_destiny = 'D_BOUNCE',
  Integer[1]                                          $max_servers              = 2,
  Boolean                                             $scanning_disabled        = false,
  Boolean                                             $whitelist                = false,
  Array[String[1]]                                    $whitelist_entries        = [],
) {
  include amavis

  $real_whitelist = $whitelist_entries.join("','")

  file { '/etc/amavisd/amavisd.conf':
    ensure  => file,
    content => template('amavis/amavisd.conf.erb'),
    notify  => Service['amavisd'],
    require => Exec['amavis'],
  }
}
