class docker::service inherits docker {
  service { "docker": ensure => running, }
  Package["docker-engine"] -> Service["docker"]
}