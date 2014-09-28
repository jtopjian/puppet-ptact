class site::profiles::ssh (
  $keys = false,
) {

  if $keys {
    $keys_to_add = $keys
  } else {
    $keys_to_add = hiera_array('ssh::keys', [])
  }

  $keys_to_add.each |$key_info| {
    $key_info.each |$user, $key| {
      ssh_authorized_key { $user:
        user => 'root',
        type => 'ssh-rsa',
        key  => $key,
      }
    }
  }

}
