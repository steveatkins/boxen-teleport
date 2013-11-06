# Public: Install Teleport.zip to /Applications.
#
# Examples
#
#    include teleport
class teleport {
  $pref_pane_dir = "/Users/${::luser}/Library/PreferencePanes"
  $pref_pane_name = "teleport.prefPane"
  $install_dir = "/tmp"
  $zip = "teleport.zip"

  exec { 'teleport-download':
    cwd => $install_dir,
    command => "curl -O http://www.abyssoft.com/software/teleport/downloads/${zip}",
    creates => "${install_dir}/${zip}",
    refreshonly => true,
    subscribe => Exec['teleport-unpack']
  }

  exec { 'teleport-unpack':
    cwd => $install_dir,
    command => "unzip ${zip}",
    refreshonly => true,
    subscribe => Exec["teleport-install"],
    require => Exec["teleport-download"]
  }

  exec { 'teleport-install':
    command => "cp -R /${install_dir}/teleport/${$pref_pane_name} ${pref_pane_dir}/",
    creates => "${pref_pane_dir}/${pref_pane_name}",
    notify => Exec["teleport-cleanup"],
    require => Exec["teleport-unpack"]
  } 

  exec { 'teleport-cleanup':
    cwd => $install_dir,
    command => "rm ${zip}",
    refreshonly => true
  }
}
