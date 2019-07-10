# docker-signal-desktop

Whisper Systems Signal Desktop in a container.

With more minimal exposure. Only mounts your Signal config, not the entire homedir. If you want to save images off of signal or whatever, you're relatively out of luck. (or just make a "save" folder in ~/.config/Signal/)

## MacOS: Using this image

On MacOS, if you wish to run this image, you need to install `XQuartz` and
`socat`. With `brew` installed, do this:

```
brew cask install xquartz
brew install socat
```

Then you can place this bash snippet in your `~/.bash_profile`:

```sh
signal() {

  local __default_int="$(netstat -rn -f inet | awk '/default/{print $6;exit}')"
  local __my_ip="$(  ifconfig $__default_int inet | awk '/inet/ {print $2}' )"

  killall -0 quartz-wm > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "ERROR: Quartz is not running. Start Quartz and try again."
    exit 1
  fi

  # abuse of subshells to quietly background things is go go go

  ( socat TCP-LISTEN:6001,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &  SOCAT_PGM_PID=$! . ) >/dev/null 2>&1

  ( ( docker run --rm \
    --net host \
    -e XAUTHORITY=/tmp/xauth \
    -e DISPLAY=$__my_ip:1 \
    -v $HOME/.Xauthority:/tmp/xauth \
    -v $HOME/.config/Signal:/home/signal/.config/Signal \
    ${1+"$@"} barn/signal \
    && pkill -f "socat TCP-LISTEN:6001,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"" ) & )

}
```

Now, `signal` should launch the application in the background.

# Reference

- https://signal.org/download/
