# SSH

Files in `~/.ssh` are generally not tracked.  The exceptions are this file, [`config`](config), and [config.d](#configd).

## config.d

The [config.d](config.d) directory should contain the following:

1. machine-specific configuration in [~/.ssh/config.d/localhost](config.d/localhost)
    * the [~/.ssh/config](config) file always attempts to loads this
    * it isn't automatically tracked in either the public repo or the "overlay" repo, and it generally shouldh't be tracked as it typically contains sensitive information.
1. shared configurations
    * file names should correspond to the focus/topic of the file content
    * these are included by the host-specific files
    * these are automaticlaly tracked only in the public repo
1. "overlay" shared configurations
    * names start with `overlay.`
    * the rest of the file name should correspond to the focus/topic of the file content
    * these are automatically tracked only in the "overlay" repo
