class hubot::package (
  $install_dir,
  $git_source,
  $git_branch,
) inherits hubot::params {
  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  require ruby::dev

  package { $hubot::params::npm_packages:
    ensure   => present,
    provider => 'npm',
  }
  package { "json":
    ensure   => installed,
    provider => gem,
    require  => Class['ruby::dev'],
  }
  exec { 'download hubot via git':
    command => "git clone ${git_source} ${install_dir} -b ${git_branch}",
    creates => $install_dir,
    user    => $hubot::daemon_user,
    group   => $hubot::daemon_user,
    notify   => Class['hubot::config'],
  }
}
