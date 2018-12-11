class docker::registry::install inherits docker::registry {
  exec { "checkout distribution":
    command  => "git clone https://github.com/docker/distribution.git",
    provider => shell,
    cwd      => "${docker_shared}",
    onlyif   => "/usr/bin/test ! -d ${docker_shared}/distribution",
  }
  Mount["${docker_shared}"] -> Exec["checkout distribution"]

  exec { "update distribution":
    command  => "git pull",
    provider => shell,
    cwd      => "${docker_shared}",
    onlyif   => "/usr/bin/test -d ${docker_shared}/distribution",
  }
  Mount["${docker_shared}"] -> Exec["update distribution"]
  
  Exec["checkout distribution"] -> Exec["update distribution"]
  
  
  exec { "link distribution":
    command  => "for F in \$( find ${docker_shared}/distribution -maxdepth 1 ) ; do ln -sf \$F ; done",
    provider => shell,
    cwd      => "${docker_distribution}",
    onlyif   => "/usr/bin/test ! -f ${docker_distribution}/LICENSE",
  }
  Exec["checkout distribution"] -> Exec["link distribution"]
  Exec["update distribution"] -> Exec["link distribution"]
  File["${docker_shared}/distribution"] -> Exec["link distribution"]
  File["${docker_distribution}"] -> Exec["link distribution"]
  


  docker::registry::tar_detar { [
    "cmd",
    "version",
    "Godeps",
    "configuration",
    "context",
    "health",
    "registry",
    "digest",
    "manifest",
    "notifications",
    "uuid"]:
  }

  docker::registry::copier { ["Makefile", "Dockerfile", "blobs.go", "doc.go", "errors.go", "registry.go"]: }

  file { [
    "${docker_distribution}/src",
    "${docker_distribution}/src/github.com",
    "${docker_distribution}/src/github.com/docker"]:
    ensure => directory,
  }

  file { "${docker_distribution}/src/github.com/docker/distribution":
    ensure => link,
    target => "../../../../distribution",
  }
  File["${docker_distribution}/src/github.com/docker"] -> File["${docker_distribution}/src/github.com/docker/distribution"]

  exec { "link distribution src":
    command  => "for F in ../Godeps/_workspace/src/* ; do ln -s \$F ; done",
    cwd      => "${docker_distribution}/src",
    provider => shell,
    onlyif   => "/usr/bin/test ! -L ${docker_distribution}/src/golang.org",
  }
  File["${docker_distribution}/src/github.com"] -> Exec["link distribution src"]

  exec { "link distribution src/github.com":
    command  => "for F in ../../Godeps/_workspace/src/github.com/* ; do ln -s \$F ; done",
    cwd      => "${docker_distribution}/src/github.com",
    provider => shell,
    onlyif   => "/usr/bin/test ! -L ${docker_distribution}/src/github.com/Sirupsen",
  }
  File["${docker_distribution}/src/github.com/docker"] -> Exec["link distribution src/github.com"]

  exec { "link distribution src/github.com/docker":
    command  => "for F in ../../../Godeps/_workspace/src/github.com/docker/* ; do ln -s \$F ; done",
    cwd      => "${docker_distribution}/src/github.com/docker",
    provider => shell,
    onlyif   => "/usr/bin/test ! -L ${docker_distribution}/src/github.com/docker/docker",
  }
  File["${docker_distribution}/src/github.com/docker/distribution"] -> Exec["link distribution src/github.com/docker"]  
}