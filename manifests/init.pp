# Public: Install Hazel.dmg to /Applications.
#
# Examples
#
#    include hazel
class hazel {
  include wget

  $pref_pane_dir = "/Users/${::luser}/Library/PreferencePanes"
  $pref_pane_name = "Hazel.prefPane"
  $install_dir = "/tmp"
  $dmg = "Hazel-3.0.16.dmg"

  exec { 'hazel-download':
    cwd => $install_dir,
    command => "wget https://s3.amazonaws.com/Noodlesoft/${dmg}",
    creates => "${install_dir}/${dmg}"
  }

  exec { 'hazel-mount':
    cwd => $install_dir,
    command => "yes | hdiutil mount Hazel-3.0.16.dmg > /dev/null",
    require => Exec['hazel-download']
  }

  exec { 'hazel-install':
    command => "cp -R /Volumes/Hazel/${$pref_pane_name} ${pref_pane_dir}/",
    creates => "${pref_pane_dir}/${pref_pane_name}",
    require => Exec["hazel-mount"],
  }

  exec { 'hazel-unmount':
    command => "hdiutil unmount /Volumes/Hazel/"
  }
  Exec['hazel-install'] -> Exec['hazel-unmount']
}
