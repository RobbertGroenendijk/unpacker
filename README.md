# Unpacker

Unpacker is a bash script that allows users to easily copy large amounts of files structured in folders and their subfolders to be copied to a single folder location. 

## Installation

To install make sure you a bin directory in your user directory.

```console
mkdir $HOME/.bin
```

if you do not yet have a .bashrc and/or .bash_profile file

```console
touch .bashrc
touch .bash_profile
```

Add the following path to .bashrc (and/or) .bash_profile. This is to include your new .bin directory as a source for bash executables.

```bash
export PATH="$HOME/.bin:$PATH"
```

Now copy the script to the .bin directory in your home folder and change permissions to executable.

```console
chmod u+x $HOME/.bin/unpacker
```

## Usage

To use type;

```console
unpacker
```

and the script will guide you through the process.