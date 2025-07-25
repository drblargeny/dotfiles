# tmux

1. machine-specific configurations
    * names start with `host.`
    * the rest of the name should be the `HOSTNAME` for which the file will be loaded
    * the [~/.tmux.conf](../.tmux.conf) file loads the file matching `host.${HOSTNAME}.conf`
    * these aren't automatically tracked in either the public repo or the "overlay" repo and must be added with the `--force` option to be tracked.
1. shared configurations
    * file names should correspond to the focus/topic of the file content
    * these are included by the host-specific files
    * these are automatically tracked only in the public repo
1. "overlay" shared configurations
    * names start with `overlay.`
    * the rest of the file name should correspond to the focus/topic of the file content
    * these are automatically tracked only in the "overlay" repo
