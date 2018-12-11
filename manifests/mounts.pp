class docker::mounts inherits docker {
  mount { ["/opt/docker","/glfs/docker"]:
    ensure => absent,
  }

  glfs::mounts{ docker_tools: 
    vgname => "DATA",
  }

  glfs::root_dirs{ "docker": 
    dirname => "docker_tools",
  }
  
}