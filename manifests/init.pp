# Public: Install Teleport.zip to /Applications.
#
# Examples
#
#    include teleport
class teleport {
  $pref_pane_dir = "/Users/${::luser}/Library/PreferencePanes"
  $pref_pane_name = "teleport.prefPane"
  $install_dir = $boxen::config::cachedir
  $zip = "teleport.zip"

  # TODO: only run once

  exec { 'teleport-download':
    cwd => $install_dir,
    command => "curl -O http://www.abyssoft.com/software/teleport/downloads/${zip}",
    creates => "${install_dir}/${zip}"
  }

->

  exec { 'teleport-unpack':
    cwd => $install_dir,
    command => "unzip ${zip}"
  }

->

  exec { 'teleport-install':
    command => "cp -R ${install_dir}/teleport/${$pref_pane_name} ${pref_pane_dir}/",
    creates => "${pref_pane_dir}/${pref_pane_name}",
    notify => Exec["teleport-cleanup"]
  }

  exec { 'teleport-cleanup':
    cwd => $install_dir,
    command => "rm -rf teleport __MACOSX",
  }


  # TODO: optionally accept teleport
  # "com.apple.universalaccessAuthWarning" =     {
  #   "/Users/amiel/Library/PreferencePanes/teleport.prefPane/Contents/Resources/teleportd.app" = 1;
  #   "/Users/amiel/Library/PreferencePanes/teleport.prefPane/Contents/Resources/teleportd.app/Contents/MacOS/teleportd" = 1;
  #   "com.abyssoft.teleport" = 1;
  # };
}
