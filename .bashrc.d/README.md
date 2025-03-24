# Bash Configuration

This folder contains:

1. marker file to indicate that the ssh-agent should be automatically started

    This is file is optional for the specific device and not comitted.  Create it by running

    ```shell
    touch ~/.bashrc.d/.ssh-agent-autostart-enabled
    ```

1. host-specific configurations (i.e., files starting with `host.`)

    The main [~/.bashrc](../.bashrc) file  is designed to source the one of these that matches `host.${HOSTNAME}`.

1. common configurations that can be sourced by the host-specific configurations

⚠ Only commit/push non-sensitive files to the public repo via `config`.  Sensitive information should either be unversioned or versioned in the "overlay" repo using `config.`.
