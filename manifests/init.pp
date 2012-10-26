class hubot (
  $adapter           = $hubot::params::options['adapter'],
  $adapter_config    = {},
  $install_dir       = $hubot::params::options['install_dir'],
  $git_source        = $hubot::params::options['git_source'],
  $git_branch        = $hubot::params::options['git_branch'],
  $daemon_user       = $hubot::params::options['daemon_user'],
  $daemon_pass       = undef,
  $managescripts     = true,
  $managedeps        = true,
  $scriptdir_symlink = undef,
  $environment       = undef,
) inherits hubot::params {
  include stdlib

  anchor { 'hubot::begin': }
  -> class { 'hubot::package':
    install_dir => $install_dir,
    git_source  => $git_source,
    git_branch  => $git_branch,
  }
  -> class { 'hubot::config':
    adapter          => $adapter,
    adapter_config   => $adapter_config,
    install_dir      => $install_dir,
    daemon_user      => $daemon_user,
    environment      => $environment,
  }
  -> class { 'hubot::scriptconfig':
    install_dir       => $install_dir,
    managescripts     => $managescripts,
    scriptdir_symlink => $scriptdir_symlink,
  }
  class { 'hubot::service':
    subscribe => [
      Class['hubot::config'],
      Class['hubot::scriptconfig'],
    ],
  }
  -> anchor { 'hubot::end': }
}
