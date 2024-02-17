# Introduction

Constantly while using bash scripts I write, some command halfway through the
script will fail. With `set -euo pipefail`, at least it will cleanly exit rather
than continuing in a broken state. But I often don't want to rerun the entire
script, either because the part that already executed took actions that I don't
want to repeat, or simply the part that already ran took a while and I don't want
to wait for it to run again. So I often find myself copy pasting snippets from
the first part of the script to get all the variables set to what they would be
at the time of the crash, and then copy pasting to run the remainder of the
script. Inspired by Common Lisp, where you enter the debugger on error and have
various options for fixing and resuming your program, I decided to make a really
poor imitation for bash. In the same situations where `set -e` would exit on
error, this will open a menu giving you a few options for fixing the error and
resuming the script without restarting it.

# Installation

``` shell
git clone https://github.com/sczi/bash_error_handler
echo "export BASH_ENV=$PWD/bash_error_handler/hook.sh" >> ~/.bashrc
source ~/.bashrc
```

This should install the error handler menu for scripts that are run from
interactive terminals, without interfering with normal interactive shell usage
or affecting scripts not run from interactive terminals.

# Restart Options

## Retry

This will simply rerun the command that failed (exited with a non-zero status).
Then if it still fails, you'll get the restart menu again, while if it succeeds
then your script will continue where it left off.  For example imagine a script
like:

``` shell
echo Many long and complex actions
# Some command using internet
curl https://httpbin.org/get
echo Many more long and complex actions
```

If the `curl` command fails because our internet was down at the time, we can
just connect our internet, choose `Retry` and the script should continue fine.

![demo](demos/retry.gif)

You can also imagine other situations where `Retry` would be enough to fix the
problem. For example if a needed file was missing or some config file it tries
to load or script it tries to run had a syntax error, then we can fix the file
and hit `Retry` and our shell script will continue where it left off.

## Edit command and retry

This will open the command that failed in EDITOR (or nano if EDITOR is unset).
After you save the file and quit the editor, it will try to run your new command
and continue the script. For example in a recent script, I was downloading
videos, and a couple didn't support the format I was downloading the rest in.
Rather then the script erroring out and having to restart the whole thing, I
could just use `Edit command and retry`, list what formats are available, and
edit the command to download an available format.

``` shell
URL="$1"
echo Many long and complex actions
yt-dlp -f http-540p "$URL"
echo Many more long and complex actions.
```


![demo](demos/edit_and_retry.gif)

## Spawn shell

If you need to take more complicated actions to fix or debug the problem, this
will spawn a subshell with all variables and functions defined as they are at
the time of error in the script. When you exit the subshell, you'll get the
restart menu again.

``` shell
URL="$1"
echo Many long and complex actions
yt-dlp -f http-540p "$URL"
echo Many more long and complex actions.
```

![demo](demos/spawn_shell.gif)

## Continue (ignoring error)

If the error shouldn't be fatal, you can choose this to simply continue the
execution of your script.

``` shell
echo Many long and complex actions
false
echo Many more long and complex actions
```

![demo](demos/continue.gif)

## Abort (exit shell)

If the error is unrecoverable and you want to exit the script, choose this. This
will give you the same effect as `set -e`, exiting at the error.

``` shell
echo Many long and complex actions
false
echo Many more long and complex actions
```

![demo](demos/abort.gif)
Note it exited after false, and the final echo statement never ran.

Demo videos recorded with [VHS](https://github.com/charmbracelet/vhs)
