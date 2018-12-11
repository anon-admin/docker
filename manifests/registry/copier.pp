define docker::registrycopier () {
  $subfile = $name

  contain docker::registry
  $docker_shared = $docker::registry::docker_shared
  $docker_dir = $docker::registry::docker_dir
  $docker_distribution = $docker::registry::docker_distribution

  file { "${docker_distribution}/${subfile}": source => "${docker_shared}/distribution/${subfile}" }
  File["${docker_distribution}/${subfile}"] -> Exec["/usr/bin/docker build -t clean-distribution ."]

}