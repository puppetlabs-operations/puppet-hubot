class hubot::package (
  $install_dir,
  $git_source,
  $git_branch,
) inherits hubot::params {
  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  require ruby::dev

  # User Account for Hubot
  user { $daemon_user:
    ensure     => present,
    comment    => 'Hubot Daemon user',
    home       => "/home/${daemon_user}",
    shell      => '/bin/bash',
    managehome => true,
    password   => $daemon_pass,
  }

  package { $hubot::params::npm_packages:
    ensure   => present,
    provider => 'npm',
  }

  package { "json":
    ensure   => installed,
    provider => gem,
    require  => Class['ruby::dev'],
  }

  class { 'github::known_hosts': } ->
  exec { 'download hubot via git':
    command     => "git clone ${git_source} ${install_dir} -b ${git_branch}",
    creates     => "${install_dir}/bin",
    user        => $hubot::daemon_user,
    group       => $hubot::daemon_user,
    notify      => Class['hubot::config'],
    cwd         => $install_dir,
    environment => "HOME='${install_dir}'",
  }

  # Notification of installation comes from hubot::package
  exec { 'install hubot deps':
    command     => 'npm install',
    cwd         => $install_dir,
    refreshonly => true,
    subscribe   => Exec['download hubot via git'],
  }
}
