class docker::install (
  $docker_shared = $docker::docker_shared, 
  $docker_dir = $docker::docker_dir
) inherits docker {

  contain docker::mounts

  file { "/etc/apt/sources.list.d/docker.list": source => "puppet:///modules/docker/apt_docker.list", }

  File["/etc/apt/sources.list.d/docker.list"] -> Exec["/usr/bin/apt-get update"]
  File["/etc/apt/sources.list.d/docker.list"] ~> Exec["/usr/bin/apt-get update"]

  package { ["docker.io", "docker"]: ensure => purged, }
  
  Mount["/var/lib/docker"] -> Package["docker-engine"]
  
  Package["docker"] -> Package["docker.io"] -> Package["docker-engine"]

  package { [
    "docker-engine",
    "debootstrap",
    "lxc",
    "rinse",
    "btrfs-tools"]:
    ensure  => latest,
    require => Exec["/usr/bin/apt-get update"],
  }




}