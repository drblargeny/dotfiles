This will house my [*dotfiles*](https://en.wikipedia.org/wiki/Configuration_file) 
so I can replicate them, share them, and track changes to them.

There are many approaches for this:
1. <https://dotfiles.github.io/>
1. <https://wiki.archlinux.org/index.php/Dotfiles>
1. <https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/>

I will start by using the bare repository approach, and I'll try to use 
configuration to vary settings between different machines.  Failing that, I will 
try branches; and ultimately defaulting to using a no-bare repository with 
installation/synch scripts if necessary.

## Installation

1. Setup git (may need to download [.ssh/config](.ssh/config))
1. Navigate to home directory
1. Download and run [.dotfiles-bin/bootstrap.sh](.dotfiles-bin/bootstrap.sh)
    1. `bootstrap.sh <DOTFILES_URI> .dotfiles`
    1. `bootstrap.sh <OVERLAY_URI> .dotfiles-overlay`
        * Use this if you're applying an additional overlay-repository
