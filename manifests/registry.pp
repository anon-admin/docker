class docker::registry(
  $docker_shared = $docker::docker_shared,
  $docker_dir = $docker::docker_dir
) inherits docker {
  include golang

  
  glfs::root_dirs { "registry": dirname => "docker_tools", }

  $docker_distribution = "${docker_dir}/distribution"

  file { "${docker_distribution}": ensure => directory, }
  



  exec { "/usr/bin/docker build -t clean-distribution .":
    provider => shell,
    unless   => "/bin/grep clean-distribution /var/lib/docker/repositories-aufs",
    cwd      => "${docker_distribution}",
    timeout  => 0,
  }
  Service["docker"] -> Exec["/usr/bin/docker build -t clean-distribution ."]

}