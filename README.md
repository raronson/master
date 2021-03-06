master
======

```
A master builder.
```

![master](http://vignette3.wikia.nocookie.net/lego/images/9/97/VitruviusTheAwesome.jpg/revision/latest?cb=20131123165335)

Concepts
--------

### master

`master` provides a uniform interface to building projects.

`master` is a configuration file definition for defining builds and
referencing a runner.

`master` is a command line interface for building a project, reading
the master configuration, grabbing the runner, setting up the build
environment, and then executing the runner with the environment.

### runners

Any executable. It accepts no arguments, but has access to
environment variables for this build.

### builds

Basically a build is a name, and a collection of environment variables
for the build.

### `master.toml` configuration

A complete example:

```
[master]
   version = 1
   runner = "s3://ambiata-dist/master-haskell/$OS/$ARCH/master-haskell-ab12f1"
   sha1 = "abc123def"

[global]
   PUBLISH_BUCKET = "ambiata-dist"

[build.master]
   PUBLISH = "true"
   HADDOCK = "true"

[build.branches]
   PUBLISH = "false"

   [build.branches.master]
      runner = "s3://ambiata-dist/master-haskell/$OS/$ARCH/haskell-cabal-ab12f1"
      sha1 = "abc123def"

```

The `version` attribute is mandatory. It is to allow non-backwards compatible
changes to the format without breaking older projects.

The `runner` attribute is mandatory, either at the top-level or on each build
level. The `runner` can still be overridden by a `build` even if specified at
the top level.
It is able to exploit the `$OS` and `$ARCH` variables for platform specific requests.

The `sha1` is to specify the sha1 of the runner. It is optional but really
should be set. If this is set, master will cache your runner, if it is not
set your colleagues will probably not like you.

The global variables section is optional, and globals can be overridden locally
in each build subsection.

Each `build.*` sub-section, defines a build name `*` and specifies a series
of environment variables. Each subkey to be passed to the `runner` must
 be a string in capitals.


Implementation
--------------

The first cut should be extremely basic. It should:
 - parse the config.
 - download the runner.
 - check the sha.
 - execute the runner with the environment variables for the specific build set.
