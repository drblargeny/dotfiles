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

What does work is to use a FUSE bindfs mount to map the flatpak directory
onto the standard location.  For example:

bindfs --no-allow-other -o nonempty \
  ~/.var/app/com.github.hluk.copyq/config/copyq \
  ~/.config/copyq

You can add this to your UI session's startup applications so it will load
automatically for your session.

Windows
-------

copyq is okay with %APPDATA%\copyq being a Windows junction pointing to
this directory.
