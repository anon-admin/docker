class docker::git ($docker_shared = $docker::docker_shared, $docker_dir = $docker::docker_dir) inherits docker {
  file { "${docker_shared}/git": ensure => directory, }
  Mount["${docker_shared}"] -> File["${docker_shared}/git"]

  mount { "${docker_shared}/git":
    ensure  => mounted,
    atboot  => False,
    device  => "/var/lib/git",
    fstype  => "none",
    options => "noauto,rw,bind",
    require => [File["${docker_shared}/git"], Package["git"]],
    notify  => Service["nginx", "fcgiwrap"],
  }

}