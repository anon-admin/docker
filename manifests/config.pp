class docker::config inherits docker {

  file { "${docker_shared}/docker/varlib": ensure => directory, }
  glfs::root_dirs["docker"] -> File["${docker_shared}/docker/varlib"]

  docker::shared_subdirs { [
    "volumes",
    "containers",
    "graph",
    "trust"]:
    soft_dir => "docker",
  }

  docker::shared_subfiles { "linkgraph.db": soft_dir => "docker", }  
}