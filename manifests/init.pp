class hubot (
  $adapter          = $hubot::params::options['adapter'],
  $adapter_config   = {},
  $install_dir      = $hubot::params::options['install_dir'],
  $git_source       = $hubot::params::options['git_source'],
  $git_branch       = $hubot::params::options['git_branch'],
  $daemon_user      = $hubot::params::options['daemon_user'],
  $daemon_pass      = undef,
  $vagrant_hubot    = false,
  $environment      = undef,
) inherits hubot::params {
  include stdlib

  anchor { 'hutbot::begin': }
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
    daemon_pass      => $daemon_pass,
    vagrant_hubot    => $vagrant_hubot,
    environment      => $environment,
  }
  ~> class { 'hubot::service': }
  -> anchor { 'hubot::end': }
}
