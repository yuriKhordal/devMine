# Programs

Computer programs for use inside of OpenOS.

## gitpull.lua
A simple command line utility for downloading lua scripts from repositories.

### Usage
```bash
gitpull [url]
gitpull -h [user]/[repo]
```
Opens the repository and searches for `.lua` files and downloads them, retaining names and containing folder, meaning that if the repository has a script inside `scripts/whatever.lua` a `scripts/` directory will be created(if it not yet exists), and the `whatever.lua` script will be downloaded into it.
The `-h` flag allows to only specify the user and repository name, `gitpull -h userName/repository` is equivalent to `gitpull https://api.github.com/repos/userName/repository`.
Running the command without parameters defaults to this repository, and is equivalent to `gitpull https://api.github.com/repos/yuriKhordal/devMine`.
