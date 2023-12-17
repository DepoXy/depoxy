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
#     ~/.kit/py/easy-as-pypi/bin/update-faithful

infuse_easy_as_pypi_follower () {
  infuse_easy_as_pypi_follower_links "$@"
  infuse_easy_as_pypi_git_aliases
  infuse_easy_as_pypi_gh_configure
}

infuse_easy_as_pypi_follower_links () {
  link_private_exclude "$@"

  # Only look for ./.ignore if not part of the repo.
  if [ -z "$(git ls-files -- .ignore)" ]; then
    link_private_ignore "$@"
  fi

  # USYNC: CXREF: This list is SYNCD with:
  #   ~/.kit/py/easy-as-pypi/bin/update-faithful

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
  # UPDEP: ".pyproject.common.tmpl"
  # └→ Uses: ".pyproject.tmpl"
  # UPDEP: "pyproject.toml"
  # └→ Uses: ".pyproject.project.tmpl"
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

  # UPDEP: ".github/dependabot.yml"
  # UPDEP: ".github/doblabs-dependencies.yml"
  # IGNOR: ".github/README--github-variable-dump--example.rst"
  #
  # UPDEP: ".github/bin/update-poetry"
  #
  # UPDEP: ".github/deps/git-update-faithful/lib/update-faithful.sh"
  # UPDEP: ".github/deps/sh-logger/bin/logger.sh"
  # UPDEP: ".github/deps/sh-logger/deps/sh-colors/bin/colors.sh"
  #
  # IGNOR: ".github/disabled/coverity.yml"
  #
  # UPDEP: ".github/workflows/checks-unspecial.yml"
  # UPDEP: ".github/workflows/checks-versioned.yml"
  # UPDEP: ".github/workflows/checks.yml"
  # UPDEP: ".github/workflows/ci-tags-wrangle.yml"
  # UPDEP: ".github/workflows/codeql-analysis.yml"
  # UPDEP: ".github/workflows/coverage-comment-external.yml"
  # UPDEP: ".github/workflows/coverage-comment.yml"
  # UPDEP: ".github/workflows/readthedocs-preview.yml"
  # UPDEP: ".github/workflows/release-github.yml"
  # UPDEP: ".github/workflows/release-pypi.yml"
  # UPDEP: ".github/workflows/release-smoke-test.yml"
  # UPDEP: ".github/workflows/update-cascade.yml"
  # UPDEP: ".github/workflows/update-deps.yml"
  # UPDEP: ".github/workflows/update-merged.yml"

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
  if ! (
    symlink_mrinfuse_file ".trustme/.trustme.plugin"
    symlink_mrinfuse_file ".trustme/.trustme.sh"
    symlink_mrinfuse_file ".trustme/.trustme.vim"
  ); then
    warn "└→ Ignore the last warning, $(attr_emphasis)I'll allow this!$(attr_reset)"
  fi
}

infuse_easy_as_pypi_git_aliases () {
  # Project: https://github.com/landonb/git-bump-version-tag
  # - Easily apply a semantic version tag.
  git config alias.bump "! ${DOPP_KIT:-${HOME}/.kit}/py/easy-as-pypi/bin/git-bump-version-tag"
}

# ***

infuse_easy_as_pypi_gh_configure () {
  infuse_easy_as_pypi_gh_repo_set_default
}

# Adds 'gh-resolved' to `.git/config`, e.g.:
#
#   $ git remote get-url publish
#   git@github.com:DepoXy/depoxy.git
#
#   $ gh repo set-default DepoXy/depoxy
#
#   $ cat .git/config
#   ...
#   [remote "publish"]
#     ...
#     gh-resolved = base
#    
# REFER: gh help environment | less
infuse_easy_as_pypi_gh_repo_set_default () {
  local gh_repo="doblabs/$(basename "$(git rev-parse --show-toplevel)")"

  # Prints, e.g.,
  #   ✓ Set doblabs/easy-as-pypi as the default repository for the current directory
  # unless pipelined, then prints nothing.
  if gh repo set-default "${gh_repo}" \
    > /dev/null \
  ; then
    info "✓ $(font_emphasize "gh repo set-default") $(font_info_created "${gh_repo}")"
  else
    # Print error and fail.
    gh repo set-default "doblabs/$(basename "$(git rev-parse --show-toplevel)")"
  fi
}

# ========================================================================
# ------------------------------------------------------------------------

update_easy_as_pypi_follower () {
  # CXREF: ~/.kit/py/easy-as-pypi/bin/update-faithful
  ${DOPP_KIT:-${HOME}/.kit}/py/easy-as-pypi/bin/update-faithful
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
    shift

    git rm -q -f $@ "${filepath}" 2> /dev/null \
      || true
  }

  # ***

  is_canon () {
    [ "$(basename "$(realpath "$(pwd)")")" = "easy-as-pypi" ]
  }

  # ***

  remove_coveragerc () {
    git_rm_gentle ".coveragerc"

    if git_nothing_staged; then
      echo "SKIPD: .coveragerc"
    else
      git commit -q -m "Cleanup: Build: Remove unnecessary .coveragerc"

      echo "COMIT: ✗ .coveragerc"
    fi
  }

  remove_localized_sphinx_rtd_theme () {
    git_rm_gentle -r docs/_themes/sphinx_rtd_theme/

    if git_nothing_staged; then
      echo "SKIPD: docs/_themes/sphinx_rtd_theme"
    else
      git commit -q -m "Cleanup: Remove outdated and unnecessary sphinx_rtd_theme"

      echo "COMIT: ✗ docs/_themes/sphinx_rtd_theme"
    fi
  }

  remove_Makefile_local_example () {
    is_canon || git_rm_gentle "Makefile.local.example"

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

  remove_pytest_ini () {
    git_rm_gentle "pytest.ini"

    if git_nothing_staged; then
      echo "SKIPD: pytest.ini"
    else
      git commit -q -m "Cleanup: Build: Remove obsolete pytest.ini

- See instead [tool.pytest.ini_options] table in pyproject.toml"

      echo "COMIT: ✗ pytest.ini"
    fi
  }

  commit_pyproject_toml_and_decommission_setup_py () {
    git_rm_gentle ".flake8"
    git_rm_gentle "MANIFEST.in"
    git_rm_gentle "setup.cfg"
    git_rm_gentle "setup.py"
    git_rm_gentle "requirements.txt"
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
    [ -f "poetry.lock" ] || return 0

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
    if ls ./.trustme.* > /dev/null 2>&1; then
      command mkdir -p ./.trustme

      command mv ./.trustme.* ./.trustme 2> /dev/null \
        && echo "MOVED: → .trustme/ files" \
        || echo "SKIPD: .trustme/ files"
    fi
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

  remove_coveragerc

  remove_localized_sphinx_rtd_theme

  remove_Makefile_local_example

  remove_pytest_ini

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

