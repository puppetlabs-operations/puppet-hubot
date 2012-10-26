class hubot::service inherits hubot::params {

  file { '/etc/init.d/hubot':
    ensure => file,
    owner  => 0,
    group  => 0,
    mode   => '0755',
    source => 'puppet:///modules/hubot/hubot-init',
  }

  service { 'hubot':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => File['/etc/init.d/hubot'],
  }
}
