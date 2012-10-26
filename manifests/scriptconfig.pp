class hubot::scriptconfig(
  $install_dir,
  $managescripts     = true,
  $managedeps        = true,
  $scriptdir_symlink = undef,
) {

  $scriptdir = "${install_dir}/scripts"

  file { '/usr/local/sbin/rebuild-hubot-scripts.rb':
    ensure  => present,
    mode    => '0755',
    owner   => 0,
    group   => 0,
    content => template('hubot/rebuild-hubot-scripts.rb.erb'),
  }

  if $managescripts {
    file { $scriptdir:
      ensure  => directory,
      purge   => true,
      recurse => true,
    }
  }
  elsif $scriptdir_symlink {
    file { $scriptdir:
      ensure => symlink,
      target => $scriptdir_symlink,
      force  => true,
    }
  }

  if $managescripts or $scriptdir_symlink {
    # Main hubot configuration file
    file { "${install_dir}/package.json":
      ensure  => file,
      content => template('hubot/package.json.erb'),
      notify  => Class['hubot::package'],
    }
  }
}
