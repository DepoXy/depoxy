#!/bin/sh
# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# CXREF/2023-10-03 00:50: See the actions defined by OMR project config:
#   infusePostRebase
# See also the DepoXy-defined hook called by tig-newtons and git-smart:
#   GIT_POST_REBASE_EXEC

# ========================================================================
# ------------------------------------------------------------------------

# USAGE: Add to mrconfig:
#   [/path/to/eapp-foo]
#   ...
#   infuse = infuse_easy_as_pypi_follower "$@"
#   updateDeps = update_easy_as_pypi_follower
#   upgrade2023 = onboard_easy_as_pypi_follower_2023

# ========================================================================
# ------------------------------------------------------------------------

# Note the comment leaders below: BUILD, IGNOR, BELOW, INFUS, SPLIT.
# - CXREF: See update-defs for these FIVER defs:
#     ~/.kit/py/easy-as-pypi/bin/update-deps

infuse_easy_as_pypi_follower () {
  link_private_exclude "$@"
  link_private_ignore "$@"

  # USYNC: CXREF: This list is SYNCD with:
  #   ~/.kit/py/easy-as-pypi/bin/update-deps

  # SPLIT: "AUTHORS.rst"
  # IGNOR: "bin/"
  # UPDEP: "codecov.yml"
  # UPDEP: "CODE-OF-CONDUCT.rst"
  # UPDEP: "CONTRIBUTING.rst"
  # └→ Uses: "CONTRIBUTING.tmpl"
  # BUILD: ".coverage"
  # BUILD: "dist"
  # UPDEP: "docs/"
  # UPDEP: ".editorconfig"
  # IGNOR: ".git"
  # UPDEP: ".github/"
  # UPDEP: ".gitignore"
  # INFUS: ".gitignore.local"
  # └→ Symlinked by link_private_exclude, above:
  #      ~/.kit/py/.mrinfuse/easy-as-pypi/_git/info/exclude
  # SPLIT: "HISTORY.rst"
  # BUILD: "htmlcov/"
  # INFUS: ".ignore"
  # └→ Symlinked by link_private_ignore, above:
  #      ~/.kit/py/.mrinfuse/easy-as-pypi/.ignore-for-the-masses
  # UPDEP: ".ignore.example"
  # SPLIT: "LICENSE"
  # UPDEP: "Makefile"
  # ↓← INFUS: "Makefile.local" →↓
  symlink_mrinfuse_file "Makefile.local"
  # IGNOR: "Makefile.local.example"
  # └→ ISOFF/2023-06-02: Don't ship the Makefile example. It's available from
  #    the reference project (boilerplate) in unlikely event someone wants it.
  # UPDEP: "Maketasks.sh"
  # BUILD: "poetry.lock"
  # UPDEP: ".pyproject-doc8/"
  # BUILD: ".pyproject-editable/"
  # SPLIT: "pyproject.toml"
  # BUILD: ".pytest_cache/"
  # SPLIT: "README.rst"
  # UPDEP: ".readthedocs.yml"
  # ISOFF:
  #   symlink_mrinfuse_file "release"
  # └→ ISOFF/2023-10-24 16:55: This was circa 2020's original release pipeline,
  #    done developer-side, i.e., from my machine. It's since been replaced by
  #    CI-side (GitHub Actions) scripts that perform essentially the same ops.
  # SPLIT: "src/"
  # SPLIT: "tests/"
  # BUILD: ".tox/"
  # UPDEP: "tox.ini"
  # BUILD: ".venv-doc8/"
  # BUILD: ".venv-docs/"
  # BUILD: ".venv-easy-as-pypi/"
  # UPDEP: ".yamllint"

  # *** docs/ files

  # UPDEP: "docs/authors.rst"
  # UPDEP: "docs/code-of-conduct.rst"
  # UPDEP: "docs/conf.py"
  # UPDEP: "docs/contributing.rst"
  # SPLIT: "docs/<package_name>"*".rst"
  # SPLIT: "docs/history-ci.md"
  # UPDEP: "docs/history.rst"
  # UPDEP: "docs/index.rst"
  # UPDEP: "docs/installation.rst"
  # SPLIT: "docs/license.rst"
  # UPDEP: "docs/make.bat"
  # UPDEP: "docs/Makefile"
  # UPDEP: "docs/modules.rst"
  # UPDEP: "docs/readme.rst"

  # *** .github/ files

  # IGNOR: ".github/README--github-variable-dump--example.rst"
  # UPDEP: ".github/dependabot.yml"
  # IGNOR: ".github/disabled/coverity.yml"
  # UPDEP: ".github/workflows/checks-unspecial.yml"
  # UPDEP: ".github/workflows/checks-versioned.yml"
  # UPDEP: ".github/workflows/checks.yml"
  # UPDEP: ".github/workflows/codeql-analysis.yml"
  # UPDEP: ".github/workflows/coverage-comment-external.yml"
  # UPDEP: ".github/workflows/coverage-comment.yml"
  # UPDEP: ".github/workflows/readthedocs-preview.yml"
  # UPDEP: ".github/workflows/release-github.yml"
  # UPDEP: ".github/workflows/release-pypi.yml"
  # UPDEP: ".github/workflows/release-smoke-test.yml"

  # *** .pyproject-doc8/ files

  # UPDEP: ".pyproject-doc8/README.md"
  # UPDEP: ".pyproject-doc8/pyproject.toml"
  # UPDEP: ".pyproject-doc8/src/__init__.py"
  # UPDEP: ".pyproject-doc8/tests/__init__.py"

  # *** .trustme/ files

  # CXREF: /kit/shoilerplate/trust_me/
  #
  # BUILD: ".trustme/.trustme.kill/"
  # BUILD: ".trustme/.trustme.lock/"
  # BUILD: ".trustme/.trustme.log"
  symlink_mrinfuse_file ".trustme/.trustme.plugin"
  symlink_mrinfuse_file ".trustme/.trustme.sh"
  symlink_mrinfuse_file ".trustme/.trustme.vim"
}

# ========================================================================
# ------------------------------------------------------------------------

update_easy_as_pypi_follower () {
  # CXREF: ~/.kit/py/easy-as-pypi/bin/update-deps
  ${DOPP_KIT:-${HOME}/.kit}/py/easy-as-pypi/bin/update-deps
}

# ========================================================================
# ------------------------------------------------------------------------

onboard_easy_as_pypi_follower_2023 () {
  must_insist_nothing_staged () {
    if ! git_nothing_staged; then
      >&2 echo "ERROR: Please commit or rollback staged changes"

      exit 1
    fi
  }

  git_nothing_staged () {
    git diff --cached --quiet
  }

  git_rm_gentle () {
    local filepath="$1"

    git rm -q -f "${filepath}" 2> /dev/null \
      || true
  }

  # ***

  remove_Makefile_local_example () {
    git_rm_gentle "Makefile.local.example"

    if git_nothing_staged; then
      echo "SKIPD: Makefile.local.example"
    else
      git commit -q -m "Cleanup: Build: Remove unnecessary Makefile.local.example"

      echo "COMIT: ✗ Makefile.local.example"
    fi
  }

  remove_travis_config () {
    git_rm_gentle ".travis.yml"

    if git_nothing_staged; then
      echo "SKIPD: .travis.yml"
    else
      git commit -q -m "Cleanup: Build: Remove obsolete Travis config

- See instead GitHub actions under .github/"

      echo "COMIT: ✗ .travis.yml"
    fi
  }

  commit_pyproject_toml_and_decommission_setup_py () {
    git_rm_gentle ".flake8"
    git_rm_gentle "MANIFEST.in"
    git_rm_gentle "setup.cfg"
    git_rm_gentle "setup.py"
    git_rm_gentle "requirements/dev.pip"
    git_rm_gentle "requirements/docs.pip"
    git_rm_gentle "requirements/release.pip"
    git_rm_gentle "requirements/test.pip"

    git add "pyproject.toml"

    # Check nothing staged, in which there was no work to do; otherwise commit.
    if git_nothing_staged; then
      echo "SKIPD: pyproject.toml et al"
    else
      git commit -q -m "Improve: Build: Update to pyproject.toml"

      echo "COMIT: ↔ pyproject.toml et al"
    fi
  }

  commit_poetry_lock () {
    git add "poetry.lock"

    if git_nothing_staged; then
      echo "SKIPD: poetry.lock"
    else
      git commit -q -m "Insert: poetry.lock"

      echo "COMIT: ✓ poetry.lock"
    fi
  }

  remove_release_symlink () {
    # CXREF: See *ISOFF/2023-10-24 16:55* comment, above.
    # - We no longer use dev-side `release` script, but leverage CI instead.
    [ -h "release" ] \
      && command rm "release" \
      || echo "SKIPD: release"
  }

  mv_trustme_to_subdir_local () {
    command mkdir -p ./.trustme

    command mv ./.trustme.* ./.trustme 2> /dev/null \
      && echo "MOVED: → .trustme/ files" \
      || echo "SKIPD: .trustme/ files"
  }

  mv_trustme_to_subdir_mrinfuse () {
    local project_name="$(basename "${MR_REPO}")"
    local mrinfuse_dir="../.mrinfuse/${project_name}"

    if [ -d "${mrinfuse_dir}" ]; then
      cd "${mrinfuse_dir}"

      command mkdir -p ./.trustme

      git mv ./.trustme.* ./.trustme 2> /dev/null \
        && echo "MOVED: → .mrinfuse/'s .trustme.* files" \
        || echo "ABSNT: .mrinfuse/'s .trustme.* files"

      if git_nothing_staged; then
        echo "SKIPD: .mrinfuse/'s .trustme/ files"
      else
        git commit -q -m "Refactor: Build: Relocate infuse assets under .trustme/"

        echo "COMIT: .mrinfuse/'s .trustme/ files"
      fi
    fi
  }

  # ***

  must_insist_nothing_staged

  # ***

  remove_Makefile_local_example

  remove_travis_config

  commit_pyproject_toml_and_decommission_setup_py

  commit_poetry_lock

  # ***

  remove_release_symlink

  mv_trustme_to_subdir_local

  mv_trustme_to_subdir_mrinfuse
}

# ========================================================================
# ------------------------------------------------------------------------

