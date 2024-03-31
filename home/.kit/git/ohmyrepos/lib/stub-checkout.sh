# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=bash
# Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

stub_checkout_directory () {
  mkdir -- "${MR_REPO}"
  touch -- "${MR_REPO}/${MR_REPO_STUB_NAME:-.keep--omr-stub}"
}

