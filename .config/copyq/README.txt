CopyQ configuration
===================

Linux
-----

copyq doesn't play well with symbolic links or hard links on linux.

* symbolic link directories aren't recognized as directories * symbolic
link files aren't recognized as files * hard links are replaced with
new files

Conversely, git doesn't version contents of symbolic links the point
outside of the project.

This makes it difficult to version the standard linux configuration
location (~/.config/copyq/) and link it to/from the flatpak configuration
location (~/.var/app/com.github.hluk.copyq/config/copyq/).  If the links
are in the flatpak location, then copyq doesn't recognize them and either
fails to start, ignores the linked file contents, or breaks the link
after a change/save.  If the standard directory is a link to the flatpak
directory, git rejects versioning any file content beyond the link.

TODO: Need to look into using FUSE/bindfs to handle this through userspace
mount points.

Windows
-------

copyq is okay with %APPDATA%\copyq being a Windows junction pointing to
this directory.
