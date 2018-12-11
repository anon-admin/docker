# Class: docker
#
# This module manages docker
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class docker inherits conf {
  $docker_shared = "${conf::shared_root}/docker_tools"
  $docker_dir = "${conf::dir_root}/docker_tools"
  
  contain docker::install
  contain docker::config
  contain docker::service
}
