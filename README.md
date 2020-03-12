# Personalitty

Give your terminal a bit of personality by letting it show you its mood!

## Installation

Installation is simple. Copy personalitty.sh somewhere you can find it.

Add this somewhere in your shell rc file (example ``` $HOME/.bashrc ```) so that it runs before your PS1 declaration. 

```
# this is assuming it's located in the $HOME directory
. $HOME/personalitty.sh 
```

You'll need to add the function ```ptty_eval``` to your shell's pre command hook.

 * **bash** ```PROMPT_COMMAND="ptty_eval"```
 * **zsh**  ```precmd() { eval "ptty_eval" }```

## Usage

The 'mood face' is stored in an environment variable called ``` PTTY ```. You can just include it in your shell's PS1 definition or wherever you want the face to be used.

**Example:**
```
PS1="\u@\h \w\n ${PTTY} : "

```

This would yield something equivalent to this as a prompt:
```
username@hostname ~
 ( ^_^) :
```

The face will adjust based on what the return code for the previous run commands were. If a couple had an exit code of 1, it starts getting annoyed. One more and it gets _really_ mad. Probably best to just show by example:

```
username@hostname:~
 ( •_•) perl -e 'exit 1'
username@hostname:~
 ( •_•) perl -e 'exit 1'
username@hostname:~
 (　ﾟДﾟ) perl -e 'exit 1'
username@hostname:~
 (＃ﾟДﾟ) perl -e 'exit 0'
username@hostname:~
 (　ﾟДﾟ) perl -e 'exit 0'
username@hostname:~
 (　ﾟДﾟ) perl -e 'exit 0'
username@hostname:~
 ( •_•) perl -e 'exit 127'
username@hostname:~
 ( •_•) perl -e 'exit 127'
username@hostname:~
 ( •_•) perl -e 'exit 127'
username@hostname:~
 ( O_o) perl -e 'exit 127'
username@hostname:~
 ( O_o) perl -e 'exit 127'
username@hostname:~
 ( O_o) perl -e 'exit 126'
username@hostname:~
 ( °-°) perl -e 'exit 126'
username@hostname:~
 ( °-°) perl -e 'exit 126'
username@hostname:~
 ( -_-) perl -e 'exit 126'
username@hostname:~
 ( T.T) perl -e 'exit 0'
username@hostname:~
 ( -_-) perl -e 'exit 0'
username@hostname:~
 ( -_-) perl -e 'exit 0'
username@hostname:~
 ( •_•) perl -e 'exit 0'
username@hostname:~
 ( ^_^)

```


## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[AGPLV3](https://github.com/raegun2k/personalitty/blob/master/LICENSE)
