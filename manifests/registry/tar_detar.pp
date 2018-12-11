define docker::registry::tar_detar () {
  $subdir = $name

  contain docker::registry
  $docker_shared = $docker::registry::docker_shared
  $docker_dir = $docker::registry::docker_dir
  $docker_distribution = $docker::registry::docker_distribution

  exec { "distribution/${subdir}":
    command  => "tar cf - ${subdir} | tar xvf - -C ${docker_distribution}",
    provider => shell,
    cwd      => "${docker_shared}/distribution",
    onlyif   => "/usr/bin/test ! -f ${docker_distribution}/${subdir} -o -L ${docker_distribution}/${subdir}",
  }
  Exec["link distribution"] -> Exec["distribution/${subdir}"]
  Exec["distribution/${subdir}"] -> Exec["/usr/bin/docker build -t clean-distribution ."]

}