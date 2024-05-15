# Dotfiles

These are my [*dotfiles*](https://en.wikipedia.org/wiki/Configuration_file) 
so I can replicate them, share them, and track changes to them.

## Background

There are many approaches for versioning dotfiles:
1. <https://dotfiles.github.io/>
1. <https://wiki.archlinux.org/index.php/Dotfiles>
1. <https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/>

I will start by using the bare repository approach, and I'll try to use 
configuration to vary settings between different machines.  Failing that, I will 
try branches; and ultimately defaulting to using a no-bare repository with 
installation/synch scripts if necessary.

## Installation

1. Decide if you will clone this project over HTTPS or SSH and ensure you meet
    the necessary requirements.

    * HTTPS - ensure an appropriate credential manager is installed and
        configured.
        [Git Credential Manager](https://github.com/git-ecosystem/git-credential-manager)
        is recommended since it supports multi-factor authentication, but
        requires an instance of the .NET framework to run.

    * SSH - ensure you have a password-protected SSH key configured for GitHub
        and loaded. See
        [Connecting to GitHub with SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
        for more details.

1. Start a shell in your `HOME` directory

1. Download and run [.dotfiles-bin/bootstrap.sh](.dotfiles-bin/bootstrap.sh)

    * HTTPS

        ```shell
        bootstrap.sh 'https://github.com/drblargeny/dotfiles.git'
        ```

    * SSH

        ```shell
        bootstrap.sh 'git@github.com:drblargeny/dotfiles.git'
        ```

1. If you started an ssh-agent just for an SSH connection to GitHub, you
    should shutdown the running agent before restarting the shell.

1. Restart your shell to load the new settings and activate the new `config`
    alias/command

1. The `config` alias/command replaces the `git` command when making versioned
    changes to the dotfiles in your `HOME` directory.

    * ℹ️ Make sure your local Git profile is fully configured before you make
        any changes.  This profile expects that you set these environment
        variables for the Git author/committer details to avoid putting them
        in the [.gitconfig](.gitconfig) file
            * [`GIT_AUTHOR_EMAIL`](https://git-scm.com/docs/git#Documentation/git.txt-codeGITAUTHOREMAILcode)
            * [`GIT_AUTHOR_NAME`](https://git-scm.com/docs/git#Documentation/git.txt-codeGITAUTHORNAMEcode)
            * [`GIT_COMMITTER_EMAIL`](https://git-scm.com/docs/git#Documentation/git.txt-codeGITCOMMITTEREMAILcode)
            * [`GIT_COMMITTER_NAME`](https://git-scm.com/docs/git#Documentation/git.txt-codeGITCOMMITTERNAMEcode)

1. Pop any stashed changes

    ```shell
    config stash pop
    ```

1. Reconcile any differences between your existing files and the files from
    this project.

    1. Check for differences

        ```shell
        config status
        ```

    1. Reconcile each file

        ```shell
        config difftool FILE
        ```

1. Commit and push any changes using the `config` alias/command

    ```shell
    config commit
    config push
    ```

1. If you're applying an additional overlay-repository for sensitive content,
    use the bootstrap.sh script to load that project alongside the main files

    ```shell
    ~/.dotfiles-bin/bootstrap.sh <OVERLAY_URI> .dotfiles-overlay
    ```
