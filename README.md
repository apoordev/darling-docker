# Darling in Docker

This is the source code of the Darling Docker image. This is an experimental feature!

Running desktop software under Docker has inherent challenges. It is up to you to ensure that the container can connect to X11, D-Bus (-> PulseAudio) etc.

## Tutorial

Starting a container:

```
docker run -d --name darling ghcr.io/darlinghq/darling-docker:master
```

Now you have a container named `darling` with `launchd` and various daemons running. You can drop into a shell:

```
docker exec -ti darling shell
```

You can run various commands:

```
docker exec darling shell -c 'uname -a'
```

## Advanced

### Experimental X11

First of all, disable authorization on your X11 session by executing `xhost +`. Keeping the authorization enabled [is trickier](https://stackoverflow.com/a/25280523/479753).

```
docker run -d --name darling1 -e DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix -v /run/dbus:/run/dbus \
    -v docker.pkg.github.com/darlinghq/darling/darling:latest
```

Whether this works or not depends mainly on the compatibility of OpenGL runtimes between the container and the host.

## Technical Notes

Darling uses a virtual chroot environment under `/usr/libexec/darling`:

* If you bind a volume as `/somewhere`, it will be accessible as `/Volumes/SystemRoot/somewhere`.
* If you bind a volume as `/usr/libexec/darling/somewhere`, it will appear as `/somewhere`.

The base system of the image is Debian. Therefore, if you do this, you will drop into a Linux shell, and NOT into the macOS shell:

```
docker exec -ti darling1 /bin/bash
```

macOS Bash lives as `/usr/libexec/darling/bin/bash`. The `shell` command used in above examples is just a convenience shortcut.
