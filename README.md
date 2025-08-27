# tn

tn - a tiny note management utility

## Usage

### Specifying your notes directory

You'll need to set an environment variable 'TN_NOTES_DIR', which specifies an
existing directory that will contain all the notes you create.

It is recommended that you add something like the following to your login file:

```bash
export TN_NOTES_DIR="$HOME/Documents/tn/notes"
```

### Specifying the editor

You'll most likely want to use your editor of choice. If you've set the
`EDITOR` environment variable in your shell config already, you're done, `tn`
will use it. Otherwise, set your editor in your `.bashrc` and restart your
shell:

```bash
echo "export EDITOR='nvim'" >> ~/.bashrc
exec bash
```

### Taking your first note

```bash
tn edit my-first-note
```

Then save/quit from your editor.

### Editing notes

Assuming you've already edited and saved a note using `tn edit` with the name
`existing-note-name` you just have to invoke the command again to review or
edit.

```bash
tn edit existing-note-name
```

### Showing notes

If you just want to print the note text to the terminal (like cat would):

```bash
tn show existing-note-name
```

### Listing notes

Want to get a list of notes you've taken?

```bash
tn list
```

The list will be sorted in reverse chronological order, so the most recently
edited notes should be right above your command prompt.

### Removing notes

If you want to get rid of a note?

```bash
tn remove existing-note-name
```

### Getting the location of a note

If you want to get a file path for a note?

```bash
tn file existing-note-name
```

This will print the path of the note to stdout.

## Building locally

The project is written as a lua rock.

```bash
$ git clone <this repo>
$ cd <repo> && luarocks make
```

## Installing via luarocks

You can also install via luarocks directly:

```bash
$ luarocks install tn
```

## Enabling shell completion

### Enabling bash completion

This note taking tool (it's barely a program) has the ability to leverage
command-line completion to speed up references to existing notes. If you have
installed and configured the `bash-completion` package via homebrew, the
following will install a user-specific completion script:

```bash
tn --bash-completion >> ~/.bash_completion
exec bash
```

If you don't have `bash-completion` installed (or you've installed tn
system-wide and wish to enable completion system wide as well) you can
install to the bash_completion.d directory instead:

```bash
tn --bash-completion > $(brew --prefix)/etc/bash_completion.d/tn
exec bash
```

### Enabling fish completion

To enable fish completion, execute the following:

```fish
tn --fish-completion > ~/.config/fish/completions/tn.fish
exec fish
```
