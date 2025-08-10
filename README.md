# Dotfiles

These are my [*dotfiles*](https://en.wikipedia.org/wiki/Configuration_file) so
I can replicate them, share them, and track changes to them. The main/public
project is on [GitHub](https://github.com/drblargeny/dotfiles). If this is not
that project, then this is either one of my "overlay" repositories with
sensitive configurations or someone else's fork.

My approach is to use non-standard names for the Git repo data (e.g.,
`.dotfiles` instead of `.git`, and `.dotfiles-ignore` instead of
`.gitignore`).  This avoids unexpected interactions with other Git projects in
the users `HOME` directory.  However, it requires a few command line options
for `git` to work as expected.  So, this also sets up a `config` alias/command
that replaces the `git` command and necessary options.

The design also recognizes that certain machine deployments will require some
configuration that can't be publicly versioned.  To this end, this supports
installing a supplemental `.dotfiles-overlay` repository alongside the public
one.  This was the "overlay" repository can be protected and hold sensitive
information that can't be added to the public repository.  A `config.`
alias/command is available for maintaining the "overlay" repository.

## Prerequisites

### Required programs

1. bash
1. curl
1. git
1. neovim or vim
1. openssh if using using SSH keys

### Minimal Git Configuration

1. Make sure your local Git identity is configured before you make
    any changes.  This profile expects this via environment
    variables for the Git author/committer details to avoid putting them
    in the [.gitconfig](.gitconfig) file.  You can use the
    `~/.bashrc.d/host.HOST` file to export custom settings for this
    host.

    ```shell
    vim ~/.bashrc.d/host.`hostname`
    ```

    * export [`GIT_AUTHOR_EMAIL`](https://git-scm.com/docs/git#Documentation/git.txt-codeGITAUTHOREMAILcode)=mail@example.org
    * export [`GIT_AUTHOR_NAME`](https://git-scm.com/docs/git#Documentation/git.txt-codeGITAUTHORNAMEcode)='First Last'
    * export [`GIT_COMMITTER_EMAIL`](https://git-scm.com/docs/git#Documentation/git.txt-codeGITCOMMITTEREMAILcode)=mail@example.org
    * export [`GIT_COMMITTER_NAME`](https://git-scm.com/docs/git#Documentation/git.txt-codeGITCOMMITTERNAMEcode)='First Last'

    ```shell
    source ~/.bashrc.d/host.`hostname`
    ```

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

## Installation

### Main/public repo

1. Start a shell in your `HOME` directory

1. Download and run [.dotfiles-bin/bootstrap.sh](.dotfiles-bin/bootstrap.sh)

    1. Download script

        ```shell
        curl -O 'https://raw.githubusercontent.com/drblargeny/dotfiles/main/.dotfiles-bin/bootstrap.sh'
        ```

    2. Make executable

        ```shell
        chmod +x bootstrap.sh
        ```

    3. Run to sync clone/sync files

        * Use HTTPS for remote Git repo

            ```shell
            ./bootstrap.sh 'https://github.com/drblargeny/dotfiles.git'
            ```

        * Use SSH for remote Git repo

            ```shell
            ./bootstrap.sh 'git@github.com:drblargeny/dotfiles.git'
            ```

1. Source the `~/.dotfiles-bin/config-alias.sh` file to enable the `config`
    alias/command, which replaces the `git` command when making versioned
    changes to the dotfiles in your `HOME` directory.

    ```shell
    source ~/.dotfiles-bin/config-alias.sh
    ```

1. Reconcile any differences between your existing files and the files from
    this project.

    * Start with the `~/.bashrc` file to ensure the `config` command is loaded
      when the shell restarts.

    1. Check for differences

        ```shell
        config status
        ```

    1. Reconcile each file

        ```shell
        config difftool FILE
        ```

1. If you started an ssh-agent just for an SSH connection to GitHub, you
    should shutdown the running agent before restarting the shell.

1. Restart your shell to load the new settings and activate the new `config`
    alias/command

1. Commit and push any changes using the `config` alias/command

    ```shell
    config commit
    config push
    ```

### "Overlay" repo

This installs an optional repository for sensitive content that shouldn't be
public.

1. Make sure the main/public repo is installed completely

1. Use the bootstrap.sh script to load that project alongside the main files

    ```shell
    ~/.dotfiles-bin/bootstrap.sh <OVERLAY_URI> .dotfiles-overlay branch
    ```

1. Pop any stashed changes and reconcile any files using the `config.`
   alias/command.

## Configuration

* [Bash](.bashrc.d/README.md)
* [Maven](.m2/README.md)
* [Screen](.screenrc.d/README.md)
* [SSH](.ssh/README.md)

## Additional Resources

1. [GitHub does dotfiles](https://dotfiles.github.io/)
1. [Dotfiles - ArchWiki](https://wiki.archlinux.org/index.php/Dotfiles)
1. [Dotfiles: Best way to store in a bare git repository](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/)
1. [Cross-platform, cross-shell dotfiles](https://github.com/renemarc/dotfiles?tab=readme-ov-file)
1. [dotfiles for Windows, including Developer-minded system defaults](https://github.com/jayharris/dotfiles-windows)
