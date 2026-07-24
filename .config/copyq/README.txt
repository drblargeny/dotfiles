copyq doesn't play well with symbolic links or hard links.

* symbolic link directories aren't recognized as directories
* symbolic link files aren't recognized as files
* hard links are replaced with new files

This makes it difficult to version the standard linux configuration location
(~/.config/copyq/) and link it to/from the flatpak configuration location
(~/.var/app/com.github.hluk.copyq/config/copyq/).  If the links are in the
flatpak location, then copyq doesn't recognize them and either fails to start,
ignores the linked file contents, or breaks the link after a change/save.  If
the standard directory is a link to the flatpak directory, git rejects
versioning any file content beyond the link.

The only approach that seems to work is to have real directories in both
locations and create a symbolic link for each target file in the standard
location, pointing to the flatpak location. Then git can treat the link as a
file to version the content. Though, this may require some file juggling when
these dotfiles are cloned as files and then need to be transitioned to
symbolic links.
