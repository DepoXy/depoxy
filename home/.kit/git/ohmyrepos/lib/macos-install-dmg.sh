# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=bash
# Author: Landon Bouma (landonb &#x40; retrosoft &#x2E; com)
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

install_dmg_with_download_user_prompt_and_symlink () {
  local app_image_url="$1"
  local app_name_local="$2"
  local applications_name="$3"
  local local_bin_name="$4"

  local applications_path="/Applications/${applications_name}"

  if [ -n "${app_image_url}" ]; then
    if [ -z "${app_name_local}" ]; then
      app_name_local="$(basename -- "${app_image_url}")"
    fi

    if [ ! -f "${app_name_local}" ]; then
      wget "${app_image_url}"
    fi
  fi

  # Note to re-install via this function, user can delete the path.
  # - Or they could just call `open` themselves.
  if [ ! -d "${applications_path}" ]; then
    echo
    echo "STEPS: Drag-drop ${applications_name} to Applications to install"

    open "${app_name_local}"
  fi

  # Sit in sleep-loop polling until user completes their action.
  while [ ! -d "${applications_path}" ]; do
    sleep 1
  done

  local local_bin_shim="${HOME}/.local/bin/${local_bin_name}"
  # MEH: if [ ! -e "${local_bin_shim}" ]; then :; fi
  printf "%s\n%s" "#!/bin/sh" "open ${applications_path}" \
    > "${local_bin_shim}"
  chmod +x "${local_bin_shim}"

  echo
  echo "Via is now installed. You can run it thusly:"
  echo
  echo "  open ${applications_path}"
  echo
  echo "Or more conveniently:"
  echo
  echo "  $(basename -- "${local_bin_shim}")"

  # DUNNO/2024-04-26: This might be annoying....
  echo
  echo "STEPS: Open Finder and click Unmount ⏏ symbol to unmount the install image"
  open /Volumes
}

