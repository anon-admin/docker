define docker::shared_subfiles ($soft_dir) {
  $subfile = $name

  contain docker

  $docker_shared = $docker::docker_shared
  $docker_dir = $docker::docker_dir

  file { "${docker_dir}/${soft_dir}/varlib/${subfile}":
    ensure => link,
    target => "${docker_shared}/${soft_dir}/varlib/${subfile}",
    force  => yes,
    notify => Service["docker"],
  }
  
  File["${docker_shared}/${soft_dir}/varlib"] -> File["${docker_dir}/${soft_dir}/varlib"] -> File["${docker_dir}/${soft_dir}/varlib/${subfile}"
    ]

}
