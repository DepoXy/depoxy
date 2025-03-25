DepoXy 🍯 Developer Experience Orchestrator
===========================================

## DESCRIPTION

  DepoXy Development Environment Orchestrator

## WHAT IS

  This is essentially my dot-files repo — mostly `~/.bashrc` and
  `~/.config` files — but also the [`myrepos`][myrepos] config I
  use to clone and manage all the open source projects I use (sorta
  like how you might use Ansible, Puppet, Chef, etc., but far more
  simply).

  A main goal of this project is to make it easy to combine separate
  public config (what you'll find in this repo) and private config
  (what you won't find because it's private). The latter is kept in
  the "DepoXy Client", a separate repo created by the Archetype that
  lets me easily maintain custom, unpublished, private config that's
  still integrated with this project.

  - For instance, the `~/.bashrc` files in this repo will look for
    and automatically load private `~/.bashrc` files found in the
    client. Same for [Hammerspoon](https://www.hammerspoon.org/)
    config, `~/.gitconfig` files, etc.

  Another project goal is to automate as much as possible, and to
  capture everything in config. The initial deploy and subsequent
  config changes should be repeatable across hosts so you can
  maintain the same environment on multiple machines and not
  have to worry about things falling out of sync, and it should
  be trivial to keep hosts up to date.

## SEE ALSO

  - DepoXy Development Environment Orchestrator (this project)

    https://github.com/DepoXy/depoxy#🍯

  - DepoXy Archetype environment boilerplate

    https://github.com/DepoXy/depoxy-archetype#🏹

  plus hundreds more projects DepoXy installs...

## RELATED ARTICLES

  - *Developer experience: what is it and why should you care? | The GitHub Blog*

    https://github.blog/2023-06-08-developer-experience-what-is-it-and-why-should-you-care/

## SIMILAR PROJECTS

  Obviously you'll find tons of dot-file repos on GitHub and elsewhere (10s of thousands? 100s?).

  Below are just a few of the notable ones I've found and cared to mention here.

  - Prolific Neovim streamer `@linkarzu`'s publishes their dot-files
    and a video demonstrating how they deploy them:

    https://github.com/linkarzu/dotfiles-latest

    https://www.youtube.com/@linkarzu

    https://linkarzu.com/posts/2024-macos-workflow/clone-dotfiles/

  - *chezmoi* — *Manage your dotfiles across multiple diverse machines, securely.*

    https://www.chezmoi.io/

    https://www.chezmoi.io/comparison-table/

    - On a related note, while DepoXy relies on
    [Password Store][Password Store] aka `pass`, *chezmoi* works with [`gopass`][gopass],
    another terminal-based password manager solution.

[Password Store]: https://www.passwordstore.org/

[gopass]: https://www.gopass.pw/

## AUTHOR

Copyright (c) 2015-2025 Landon Bouma &lt;depoxy@tallybark.com&gt;

This software is released under the MIT license (see `LICENSE` file for more)

## REPORTING BUGS

&lt;https://github.com/DepoXy/depoxy/issues&gt;

[myrepos]: https://myrepos.branchable.com/

