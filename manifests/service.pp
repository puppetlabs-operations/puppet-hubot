class hubot::service($daemon_user, $daemon_pass) inherits hubot::params {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { '/etc/init.d/hubot':
    ensure  => file,
    mode    => '0755',
    content => template('hubot/hubot.init.erb')
  }

  file { '/etc/default/hubot':
    ensure  => file,
    mode    => '0755',
    content => template("hubot/adapter/${adapter}.erb"),
  }

  service { $hubot::params::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
