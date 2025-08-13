# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# The latest version as installed by the Cygwin Setup program can
# always be found at /etc/defaults/etc/skel/.profile

# Modifying /etc/skel/.profile directly will prevent
# setup from updating it.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# Set Windows user-defined locale for Cygwin
if [ -x /usr/bin/cygpath ]; then
  export LANG=$(locale -uU)
fi

# This file is not read by bash(1) if ~/.bash_profile or ~/.bash_login
# exists.
#
# if running bash
if [ -n "${BASH_VERSION}" ] && [ -f "${HOME}/.bashrc" ]; then
  # include .bashrc if it exists
  source "${HOME}/.bashrc"
else
  # set PATH so it includes user's private bin if it exists
  if [ -d "${HOME}/bin" ] ; then
      PATH="${HOME}/bin:${PATH}"
  fi

  # set PATH so it includes user's private bin if it exists
  if [ -d "${HOME}/.local/bin" ] ; then
      PATH="${HOME}/.local/bin:${PATH}"
  fi

  # set PATH so it includes overlay bin if it exists
  if [ -d "${HOME}/bin.d/overlay" ] ; then
      # NOTE: Use absolute path to avoid security issues with relative paths
      PATH="${HOME}/bin.d/overlay:$PATH"
  fi

  # set PATH so it includes host bin if it exists
  if [ -d "${HOME}/bin.d/host.${HOSTNAME}" ] ; then
      # NOTE: Use absolute path to avoid security issues with relative paths
      PATH="${HOME}/bin.d/host.${HOSTNAME}:$PATH"
  fi
fi

