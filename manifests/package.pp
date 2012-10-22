class hubot::package (
  $install_dir,
  $git_source
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
    command => "git clone ${git_source} ${install_dir}",
    creates => $install_dir,
    notify  => Class['hubot::config'],
  }
}
