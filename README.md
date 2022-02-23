<div align="center">

# asdf-boostrap [![.github/workflows/release.yml](https://github.com/brad-jones/asdf-bootstrap/actions/workflows/release.yml/badge.svg)](https://github.com/brad-jones/asdf-bootstrap/actions/workflows/release.yml)

A bootstrap script that installs a local & isolated version of the
[asdf version manager](https://asdf-vm.com).

</div>

# The Concept

This script has been designed to be dropped into the root of a project and act
as the sole entrypoint into your build automation. Commit a copy of this script
into your repo and manage it as if it was your own.

Somewhat of a holy grail development environment that I have been chasing for
sometime is to be able to simply clone a repo & then execute some script no
matter where I am to set everything up for me.

Apart from some really basic & common tools I want a Zero Install & Zero Config
experience so that I can be a productive developer on day 1 not weeks later after
I have cobbled together all the tools and config I need to dev on a given solution.

The `asdf-bootstrap.sh` script fulfills almost all these goals.

Further reading:

- <https://www.thoughtworks.com/en-au/insights/blog/praise-go-script-part-i>
- <https://www.thoughtworks.com/en-au/insights/blog/praise-go-script-part-ii>

# Dependencies

This script is tested via Github Actions on both `ubuntu-latest` & `macos-latest`
as provided by Github.

_However no guarantees are provided for asdf plugins & the tools that they install._

This script is **not** intended to be used on Windows, apart from via a
[WSL2](https://docs.microsoft.com/en-us/windows/wsl/) installation.

The following basic *nix utilities are assumed to exist.
This script will not work without them.

- `bash`: <https://www.gnu.org/software/bash>
- `awk`: <https://www.gnu.org/software/gawk>
- `cp`: <https://en.wikipedia.org/wiki/Cp_(Unix)>
- `curl`: <https://curl.se>
- `cut`: <https://en.wikipedia.org/wiki/Cut_(Unix)>
- `git`: <https://git-scm.com>
- `grep`: <https://www.gnu.org/software/grep>
- `mkdir`: <https://en.wikipedia.org/wiki/Mkdir>
- `rm`: <https://en.wikipedia.org/wiki/Rm_(Unix)>
- `sed`: <https://www.gnu.org/software/sed>
- `sort`: <https://en.wikipedia.org/wiki/Sort_(Unix)>
- `tar`: <https://www.gnu.org/software/tar>
- `uname`: <https://en.wikipedia.org/wiki/Uname>
- `openssl`: <https://www.openssl.org>
- `base64`: <https://linux.die.net/man/1/base64>

# First time install & setup

_Keep in mind these instructions only need to be followed once by the person that
adds `asdf-bootstrap.sh` into your project, once it's added it then allows the
holy grail git clone & run script workflow to commence._

> If you have never come across [asdf](https://github.com/asdf-vm/asdf),
> I suggest you read their docs and/or use vanilla `asdf` first
> and then come back here.

- Go to <https://github.com/brad-jones/asdf-bootstrap/releases> and download
  the latest version of `asdf-bootstrap.sh`

- Use [`cosign`](https://github.com/sigstore/cosign) to verify the integrity of the script.
  Since this is the entry point into all your tooling, securing the supply chain is taken seriously.
  
  - eg: `COSIGN_EXPERIMENTAL=1 cosign verify-blob --signature asdf-bootstrap.sh.sig asdf-bootstrap.sh`

  - or perform an offline verification _(does not check the [rekor](https://github.com/sigstore/rekor) transparency log)_:  
  `openssl dgst -sha256 -verify asdf-bootstrap.sh.pem -signature <(base64 -d <asdf-bootstrap.sh.sig) asdf-bootstrap.sh`

- Now that you trust the script, give it execute permissions, eg: `chmod +x ./asdf-bootstrap.sh`

- Place the script into the root of your project & rename it to the name of a
  tool that you intend to install with the [asdf version manager](https://asdf-vm.com).
  For example [`task`](https://github.com/go-task/task) is a Make alternative
  written in Go that can act as a centralised entrypoint into all your development
  workflows both locally & in CI environments.

  > So I have a script named `/your/project/task`

- Add the appropriate asdf plugin into your config by adding a line like the
  following to the file: `/your/project/.asdf/.plugin-versions`:

  ```txt
  task https://github.com/particledecay/asdf-task.git c8c826a014c522f6ee38ec5fcffa10d7277e7930
  ```

  > It is space separated, the first column is the name of the plugin,
  > the second column is the git repo clone URL & the third is a commit
  > hash to checkout.
  
  - **Inspired by: <https://github.com/asdf-vm/asdf/issues/240#issuecomment-640777756>**

  - A registry of ASDF plugins can be found here: <https://github.com/asdf-vm/asdf-plugins>

- Now tell `asdf` which version of `task` to install by adding a line to the
  file: `/your/project/.tool-versions`

  ```txt
  task 3.10.0
  ```

  > Again it is space separated, the first column matching the name of the
  > plugin from `.plugin-versions` and the second column being a valid version
  > number for the tool.

- Finally execute `/your/project/task --version` and you should see output
  similar to _(if following along with this example)_:

  ```txt
  ! >>> Installing cosign (internal utility)
  ! -------------------------------------------------------------------------------------------------------------------- !
  downloading: <https://github.com/sigstore/cosign/releases/download/v1.5.2/cosign-linux-amd64>
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                  Dload  Upload   Total   Spent    Left  Speed
  100   657  100   657    0     0   1479      0 --:--:-- --:--:-- --:--:--  1479
  100 84.9M  100 84.9M    0     0  1914k      0  0:00:45  0:00:45 --:--:-- 9797k
  downloading: <https://github.com/sigstore/cosign/releases/download/v1.5.2/cosign-linux-amd64.sig>
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                  Dload  Upload   Total   Spent    Left  Speed
  100   661  100   661    0     0   1291      0 --:--:-- --:--:-- --:--:--  1291
  100    96  100    96    0     0     82      0  0:00:01  0:00:01 --:--:--   243
  downloading: <https://github.com/sigstore/cosign/releases/download/v1.5.2/release-cosign.pub>
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                  Dload  Upload   Total   Spent    Left  Speed
  100   657  100   657    0     0   1239      0 --:--:-- --:--:-- --:--:--  1239
  100   178  100   178    0     0    153      0  0:00:01  0:00:01 --:--:--   300
  performing offline verification of cosign with openssl
  Verified OK
  performing online verification of cosign with cosign
  tlog entry verified with uuid: "76ddca26f03255c6705e8235e1aa3cbf1d49842f6cafdc4a05dcbc162603b8ac" index: 1445588
  Verified OK
  protecting your supply chain with <https://www.sigstore.dev>

  ! >>> Installing hashdir (internal utility)
  ! -------------------------------------------------------------------------------------------------------------------- !
  downloading: <https://github.com/brad-jones/hashdir/releases/download/v1.0.5/hashdir_linux_amd64>
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                  Dload  Upload   Total   Spent    Left  Speed
  100   658  100   658    0     0   1465      0 --:--:-- --:--:-- --:--:--  1465
  100 4415k  100 4415k    0     0  1811k      0  0:00:02  0:00:02 --:--:-- 2527k
  performing online verification of hashdir with cosign
  tlog entry verified with uuid: "2d35dedd2e3f455330ef361adbcc70a08fd0cba312084ce77d57949a1768f8ea" index: 1472184
  Verified OK
  protecting your supply chain with <https://www.sigstore.dev>

  ! >>> Installing ASDF from <https://github.com/asdf-vm/asdf.git>
  ! -------------------------------------------------------------------------------------------------------------------- !
  Cloning into '/home/brad.jones/Projects/Personal/foo/.asdf/v0.9.0'...
  remote: Enumerating objects: 188, done.
  remote: Counting objects: 100% (188/188), done.
  remote: Compressing objects: 100% (165/165), done.
  remote: Total 188 (delta 12), reused 104 (delta 5), pack-reused 0
  Receiving objects: 100% (188/188), 183.07 KiB | 1.49 MiB/s, done.
  Resolving deltas: 100% (12/12), done.

  ! >>> Installing ASDF Plugin for task
  ! -------------------------------------------------------------------------------------------------------------------- !
  Initialized empty Git repository in /home/brad.jones/Projects/Personal/foo/.asdf/v0.9.0/plugins/task/.git/
  remote: Enumerating objects: 13, done.
  remote: Counting objects: 100% (13/13), done.
  remote: Compressing objects: 100% (10/10), done.
  remote: Total 13 (delta 0), reused 8 (delta 0), pack-reused 0
  Unpacking objects: 100% (13/13), 3.63 KiB | 1.82 MiB/s, done.
  From <https://github.com/particledecay/asdf-task>

  - branch            c8c826a014c522f6ee38ec5fcffa10d7277e7930 -> FETCH_HEAD
  HEAD is now at c8c826a Merge pull request #2 from LukeCarrier/use-arm64
  /home/brad.jones/Projects/Personal/foo

  ! >>> Installing task @ 3.10.0
  ! -------------------------------------------------------------------------------------------------------------------- !
  Downloading task version 3.10.0 from <https://github.com/go-task/task/releases/download/v3.10.0/task_linux_amd64.tar.gz>
  Successfully downloaded task_linux_amd64.tar.gz
  Extracting task from tar archive
  Successfully installed task 3.10.0
  locked task @ 3.10.0 to sha512:017e7666f385291b36c1745ec84f0645e1c7de43ce79008e42d8e49be3e92265292e8fc2565ad6e4ab5e860bb87137758ea4b2fe6f92a641de7b27546c8e95ef

  Task version: v3.10.0 (h1:vOAyD9Etsz9ibedBGf1Mu0DpD6V0T1u3VG6Nwh89lDY=)
  ```
  
  _Upon subsequent executions of the script, when everything is up to date,
  you just see the output from your tool as you would expect._

- Finally commit & push `/your/project/task` to your repo & let your team mates
  reap the rewards.
  
  > Also commit the generated `.tool-versions.lock` just like you would any
  > package lock files from `npm`, `yarn`, `go mod`, etc...

# Script Self Update

The script does come with a self update feature which will by default run at
most every 24 hours on any given machine.

Assuming you have made no customizations to the script, apart from it's name,
it will automatically update after interactively asking for permission & using
[`cosign`](https://github.com/sigstore/cosign) to verify it's integrity.

_If you have made customizations you may have to manually perform the update._

> NOTE: This functionality does not do anything about updating the asdf plugins
> or tool versions, thats your responsibility.

# Shims of Shims of Shims...

As outlined, this script will execute the same tool as it's filename.

## How do you call another tool then?

The script will create additional shims scripts under `/your/path/.asdf/bin`.

So to execute some other tool that is not your nominated entrypoint / task runner
tool you can just run it with `.asdf/bin/foo` much like say `node_modules/.bin/foo`.

> HINT: Your nominated entrypoint / task runner tool is running in the context
> of `asdf` so it has the shims under `/your/path/.asdf/${ASDF_VERSION}/shims`
> on it's `$PATH` and so can just execute your other tools by their names in
> the expected way.

# Export Tool Versions to Env Vars

After installing all the tools & just before executing a tool with the same name
as the script _(assuming you have left that functionality as is)_ the script will
export the versions of the tools as environment variables so that the executed tool,
for example a task runner, can use the same versions of those tools when say building
& pulling docker images.

This is about ensuring that `.tool-versions` remains a single source of truth
for the entire solution / project.

Given a `.tool-versions` file like this:

```txt
bats v1.5.0
cosign 1.5.2
gh 2.5.0
jq 1.6
lefthook 0.7.7
nodejs 16.13.2
shellcheck 0.8.0
shfmt 3.4.2
task 3.10.0
```

The following environment variables will be exported:

- `$ASDF_bats_VERSION=v1.5.0`
- `$ASDF_cosign_VERSION=1.5.2`
- `$ASDF_gh_VERSION=2.5.0`
- `$ASDF_jq_VERSION=1.6`
- `$ASDF_lefthook_VERSION=0.7.7`
- `$ASDF_nodejs_VERSION=16.13.2`
- `$ASDF_shellcheck_VERSION=0.8.0`
- `$ASDF_shfmt_VERSION=3.4.2`
- `$ASDF_task_VERSION=3.10.0`

> The general format is: `ASDF_${tool}_VERSION`

# Script Config

The script has sensible defaults out of the box but it does contain many
configurable options & places where you might like to make edits.

**Search for `EDITME` in the script source.**

The default values for the following variables can either be edited permanently
in the script or they can be overridden at runtime by setting the `ASDF_LOCAL_*`
equivalent. _eg: ASDF_LOCAL_VERSION > ASDF_VERSION_

**.DOTENV Support:** is baked in, feel free to add a `/your/path/.env` with
any such overrides or any other environment variable.

> NOTE: All paths are based off of the calculated `ASDF_SCRIPT_DIR`,
> which is just the directory that contains the script. So `/your/path`
> from the example above.

## ASDF_REPO

The git clone URL for the [asdf version manager](https://asdf-vm.com).

Defaults to: `https://github.com/asdf-vm/asdf.git`

## ASDF_VERSION

The version number of the [asdf version manager](https://asdf-vm.com) that will be installed.

ie: a release / git tag from <https://github.com/asdf-vm/asdf/releases>

## ASDF_DIR

The location where the [asdf version manager](https://asdf-vm.com) will be cloned into.

Defaults to: `${ASDF_SCRIPT_DIR}/.asdf/${ASDF_VERSION}`

## ASDF_DATA_DIR

Location where asdf install plugins, shims and installs.

Defaults to: `${ASDF_DIR}`

## ASDF_CONFIG_FILE

The location of an optional `.asdfrc` file.

Defaults to: `${ASDF_SCRIPT_DIR}/.asdf/.asdfrc`

see: <https://asdf-vm.com/manage/configuration.html#home-asdfrc>

## ASDF_PLUGIN_VERSIONS_FILENAME

The location of a `.plugin-versions` file that contains a list of asdf plugins to install.

Format for the file is:

```txt
plugin-name git-clone-url git-commit-hash
```

Defaults to: `${ASDF_SCRIPT_DIR}/.asdf/.plugin-versions`

> Inspired by: <https://github.com/asdf-vm/asdf/issues/240#issuecomment-640777756>

## ASDF_DEFAULT_TOOL_VERSIONS_FILENAME

The location of a `.tool-versions` file that contains a list of tools to install.

Format for the file is:

```txt
plugin-name tool-version
```

Defaults to: `${ASDF_SCRIPT_DIR}/.tool-versions`

## ASDF_TOOL_VERSIONS_LOCKFILE

The location of the `.tool-versions.lock` file that contains a list of checksums
to validate the integrity of installed tools on subsequent installations.

Format for the file is:

```txt
plugin-name tool-version os arch checksum
```

Defaults to: `${ASDF_DEFAULT_TOOL_VERSIONS_FILENAME}.lock`

## ASDF_SPEED_LOCK

If set to `1` _(the default)_, then the `.tool-versions.lock` file will only
be checked upon tool installation. If the tool is already installed & up to
date _(ie: the install folder exists in the correct location.)_ then no hash
checking is performed.

**This has significant startup time improvements.**

But for the particularly security conscious you can set this to anything other
than `1` _(eg: `0`)_ then a hash check will be done for each tool, on every startup.

## ASDF_UTILS_DIR

The location where additional tools that this script depends on are downloaded
to, we use a separate location for these tools in the case that your project
also uses the same tool but at a different version.

Defaults to: `${ASDF_SCRIPT_DIR}/.asdf/utils`

## ASDF_UTIL_COSIGN_VERSION

The version of the [`cosign`](https://github.com/sigstore/cosign) tool that
is used internally by this script.

## ASDF_UTIL_HASHDIR_VERSION

The version of the [`hashdir`](https://github.com/brad-jones/hashdir) tool that
is used internally by this script.

## ASDF_BOOTSTRAP_LATEST_URL

The URL that is used to check for new updates of the script.

Defaults to: `https://github.com/brad-jones/asdf-bootstrap/releases/latest/download/asdf-bootstrap.sh`

## ASDF_BOOTSTRAP_UPDATED_FILENAME

A file that stores a timestamp so that the script can check for an update
at most every `${ASDF_BOOTSTRAP_UPDATED_EXPIRATION_SECONDS}`.

Defaults to: `${ASDF_SCRIPT_DIR}/.asdf/.updated`

## ASDF_BOOTSTRAP_UPDATED_EXPIRATION_SECONDS

How often the script will check for an update in seconds.

Set this to `-1` to disable updates completely.

Defaults to: `86400` _(or 24hrs)_
