class hubot::config (
  $adapter,
  $adapter_config,
  $daemon_user,
  $install_dir,
  $environment,
  $hubot_opts,
) inherits hubot::params {

  # I'm so sorry.
  create_resources('class', { "hubot::adapter::${adapter}" => $adapter_config })
  include "hubot::adapter::${adapter}"

  file { '/etc/default/hubot':
    ensure  => file,
    owner   => 'hubot', # HACK
    mode    => '0640',
    content => template("hubot/default.erb", "hubot/adapter/${adapter}.erb"),
  }
}
