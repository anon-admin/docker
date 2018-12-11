define docker::shared_subdirs ($soft_dir) {
  $subdir = $name

  $docker_shared = $docker_::docker_shared
  $docker_dir = $docker_::docker_dir

  file { "${docker_shared}/${soft_dir}/varlib/${subdir}": ensure => directory, }
  File["${docker_shared}/${soft_dir}/varlib"] -> File["${docker_shared}/${soft_dir}/varlib/${subdir}"]

  file { "${docker_dir}/${soft_dir}/varlib/${subdir}":
    ensure => link,
    target => "${docker_shared}/${soft_dir}/varlib/${subdir}",
    force  => yes,
    notify => Service["docker"],
  }
  File["${docker_shared}/${soft_dir}/varlib"] -> File["${docker_dir}/${soft_dir}/varlib"] -> File["${docker_dir}/${soft_dir}/varlib/${subdir}"
    ]

}