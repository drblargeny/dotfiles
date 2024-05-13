Here are my settings.xml and toolchains.xml files.  They are versioned in the
form:

  [settings|toolchains]_[hostname].xml

The expectation is that the settings.xml and toolchains.xml files will be
symlinks to one of the host-specific files.  For example, on the 5NHMND2-PC
host, the files would be linked like this:

  settings.xml → settings_5NHMND2-PC.xml
  toolchains.xml → toolchains_5NHMND2-PC.xml

The reason for doing this is because there's also a settings-security.xml
file, which holds the host-specific secret encryption key that should not be
shared.

See: https://maven.apache.org/guides/mini/guide-encryption.html



Git and Symlinks

Git does not want the .m2 folder to be a symlink.  Example error:

  fatal: pathspec '.m2/settings_5NHMND2-PC.xml' is beyond a symbolic link

So on systems where it needs to be (e.g. Cygwin + git) then either a hard link
or a mount point should be used to work around the limitation.

Example mount command:

  mount 'D:\boltonj\.m2' /home/boltonj/.m2

Additionally, this mount point needs to be setup to be reloaded for the user
automatically.  So use a command like this to generate the appropriate fstab
line and include that in the user-specific /etc/fstab.d folder:

  mount -m | grep $HOME/.m2 > /etc/fstab.d/`whoami`

See: https://cygwin.com/cygwin-ug-net/using.html#mount-table
