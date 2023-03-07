# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2015-2020 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# BWARE/2023-03-05: I haven't used these functions in a few years.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_aliases_node_jest () {
  # NOTED/2021-01-20: You can also do `-t ''` equivalent with `it.only('...')` in code.
  claim_alias_or_warn "jestdb" "JEST_INSPECT_BRK=true jest"

  # HINTD/2021-02-23: I often use slightly modified `./.eslintrc-develop`
  #                   on 'develop' or feature branches.
  claim_alias_or_warn "lint!" "lint -c ./.eslintrc"
  claim_alias_or_warn "lint1" "npx eslint -c ./.eslintrc"

  claim_alias_or_warn "jest!" "npm run test"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

lint-js () {
  local ignore_path="./.eslintignore.local"

  if [ ! -f "${ignore_path}" ]; then
    >&2 echo "NOTICE: No local ignore file at: ${ignore_path}"
    ignore_path="./.eslintignore"
  fi

  local ignore_opt=""
  if [ -f "${ignore_path}" ]; then
    ignore_opt="--ignore-path \"${ignore_path}\""
  else
    >&2 echo "NOTICE: No ESLint ignore file at: ${ignore_path}"
  fi

  eval "npx eslint \"**/*.{js,jsx}\" ${ignore_opt} $@"
}

coverage-js () {
  # HINT: You'll probably need to -- your/path/to.test.js
  # E.g., coverage -- some/path.test.js
  #  alias coverage="node ./node_modules/.bin/jest --coverage --coverageReporters \"json\" \"...\" ..."
  # - Why did I have the quotes escaped? Because of the outer doubles in the alias?
  #   - Any of these work:
  #     covReporters='\"json\" \"lcov\" ...'
  #     covReporters='"json" "lcov" ...'
  #     covReporters="json lcov ..."
  #   The --help says [array], but this didn't work for me from CLI:
  #     $ npx ... --coverageReporters "['json', 'lcov', 'text', 'clover']"
  #     ERROR: Error: Cannot find module '['json', 'lcov', 'text', 'clover']'
  # MAYBE/2021-01-27: I added cobertura, so maybe remove other reporters not needed.
  local covReporters="json json-summary lcov text clover html text text-summary cobertura"

  npx jest --coverage --coverageReporters ${covReporters} "$@"
}

coverage-js-html () {
  # 2021-01-28: I had `coverage && open` but threshold warning exits error,
  # though coverage also generated. So.
  #  coverage "$@" && sensible-open "coverage/index.html"
  coverage "$@"
  sensible-open "coverage/index.html"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

jest () {
  # HINTD/2021-02-23: I often use slightly modified `jest.config-DEV.js`
  #                   on 'develop' or feature branches.
  local jest_cfg='jest.config.js'

  local jest_bin='./node_modules/.bin/jest'

  local jest_opt_cfg=''
  local jest_opt_brk=''
  local jest_opt_run=''

  if [ -f "${jest_cfg}" ]; then
    jest_opt_cfg="-c \"${jest_cfg}\""
  fi

  if ${JEST_INSPECT_BRK:-false}; then
    jest_opt_brk="--inspect-brk"
    jest_opt_run="--runInBand"
  fi

  # You can run, e.g., jest some/path.test.js
  #                 or jest -t 'some test' some/path.test.js
  # And this'll run, e.g.,
  #                    jest \
  #                      --inspect-brk \
  #                      ./node_modules/.bin/jest \
  #                      --runInBand \
  #                      -c jest.config-DEV.js \
  #                      -t 'some test' some/path.test.js  # Your args last.
  # Node options:
  #   --inspect-brk[=[host:]port]   activate inspector on host:port
  #                                 and break at start of user script
  # Jest options:
  #   --config, -c      The path to a jest config file specifying how to find and execute tests.
  #   --runInBand, -i   Run all tests serially in the current process (rather than creating
  #                     a worker pool of child processes that run tests). This is sometimes
  #                     useful for debugging, but such use cases are pretty rare.
  # Not used here, but useful (i.e., pass as args):
  #   --bail, -b        Exit the test suite immediately after `n` number of failing tests.
  #   --onlyFailures, -f   Run tests that failed in the previous execution.
  #   --testNamePattern, -t   Run only tests with a name that matches the regex pattern.
  node ${jest_opt_brk} ${jest_bin} ${jest_opt_run} ${jest_opt_cfg} "$@"
}
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

_dxy_wire_aliases () {
  _dxy_wire_aliases_node_jest
  unset -f _dxy_wire_aliases_node_jest
}

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #

main () {
  _dxy_wire_aliases
  unset -f _dxy_wire_aliases
}

main "$@"
unset -f main


