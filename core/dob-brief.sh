# vim:tw=0:ts=2:sw=2:et:norl:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright (c) © 2020-2021 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Report hours worked this week.
#
# - While this function lets you choose the day the work week starts
#   and which tag identifies billable hours, this function is still
#   somewhat coupled to business logic.
#
#   - E.g., my billable week is Sunday through Saturday, but I generate
#     invoices on Fridays, so I use Saturday as the start of the week,
#     to remind myself if I added any hours after invoicing (so that
#     I know to regenerate the Dob report for the week before).
#
#   - This function does not handle a two-week work week. Or sprint.
#
#   - This function assumes a single #tag to identify billable hours,
#     but you might be using an act@gory instead, or perhaps a
#     combination of activities and tags. (In which case it's easy
#     enough to adapt this template to your own particular needs.)
#
# - Note that this function is mostly high-level: it'll show you
#   hours for each act@gory marked #billable, but it'll coalesce
#   all tags, so each act@gory only shows up once. E.g., if you
#   had some Facts marked `Development@Work #billable #task-123`
#   and some Facts marked `Development@Work #billable #task-XYZ`,
#   this report will combines all those Facts and report just one
#   `Development@Work #billable` summary.
#
#   - See dob-report-work-week-tasks for reporting time on separate
#     tasks (unique combinations of #tags).
dob-report-work-week-hours () {
  local since_day="${1:-${DOB_REPORT_WORK_DAY_START:-saturday}}"
  local billable_tag="${2:-${DOB_REPORT_BILLABLE_TAG:-billable}}"

  # E.g.,
  #   dob report --since saturday -t billable --totals --df HHhMMm
  dob report --since "${since_day}" -t "${billable_tag}" --totals --df HHhMMm
}

alias dob-work-week-hours=dob-report-work-week-hours

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# USAGEs:
#   dob-report-work-week-tasks
#   dob-report-work-week-tasks sunday Personal
#   dob-report-work-week-tasks -- -t 'awesome app'
#   dob-report-work-week-tasks -- -c 'Personal'
#   dob-report-work-week-tasks sunday Personal -t 'open source'

# Note that adding a tag to the search currently breaks the intended
# use of this function -- this report is meant to show how many hours
# you spend on each unique combination of #tags, e.g.,
#
#   $ dob-report-work-week-tasks
#   Development@Work   0 hours 22 minutes  ▍         #billable(2) #task-123(2)
#                      2 hours 14 minutes  ██▎       #billable(3) #task-XYZ(3)
#
# But if you specify a tag in the query, the Facts are coalesced
# (the act@gories are grouped), e.g.,
#
#   $ dob-report-work-week-tasks -- -t 'billable'
#   Development@Work   2 hours 36 minutes  ██▍       #billable(5)
#
# FIXME/2021-07-24: I'm not sure if this is a bug or not, or if
# there already exists a way to keep the activities separated, but
# this behavior strikes me as... incorrect, or not ideal. It might
# be a consequence of how the SQL report query is written. Not that
# we cannot improve it, because I think we should. But for now, we
# just omit a tag query from this reporter, and we (mostly) get the
# report we want.

dob-report-work-week-tasks () {
  local since_day="${DOB_REPORT_WORK_DAY_START:-saturday}"
  local work_category="${DOB_REPORT_WORK_CATEGORY:-Work}"

  for posit in 1 2; do
    [ -z "$1" ] && break

    # Let user specify (or override) tags after a '--' argument.
    # E.g., `dob-report-work-week-tasks -- --since sunday`
    # Break now and append "${@}" to the command, below.
    [ "$1" = "--" ] && shift && break

    if [ "${posit}" = '1' ]; then
      since_day="${1}"
    elif [ "${posit}" = '2' ]; then
      work_category="${1}"
    fi
    shift
  done

  # FTREQ: There's also a group_count column, e.g.,
  #          -l actegory -l duration -l sparkline -l group_count -l tags
  #        which might be better than including the tag count in the
  #        tags column (e.g., you might see "#billable(3)").

  # NOTE/BUGBUG: Sorting by tag (-S tag) crashes, so sort by time.
  # MAYBE: Would this report be better sorted by tag?

  dob report \
    --since "${since_day}" \
    -c "${work_category}" \
    --totals --df HHhMMm \
    -A -C -T \
    -l actegory -l duration -l sparkline -l tags \
    -S activity -S time \
    "${@}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# This is basically `dob-report-work-week-tasks` but without the
# -T tag groupby, without -l tags column, and sorting by Activity.
dob-report-work-week-activities () {
  local since_day="${DOB_REPORT_WORK_DAY_START:-saturday}"
  local work_category="${DOB_REPORT_WORK_CATEGORY:-Work}"

  for posit in 1 2; do
    [ -z "$1" ] && break

    # Let user specify (or override) tags after a '--' argument.
    # E.g., `dob-report-work-week-tasks -- --since sunday`
    # Break now and append "${@}" to the command, below.
    [ "$1" = "--" ] && shift && break

    if [ "${posit}" = '1' ]; then
      since_day="${1}"
    elif [ "${posit}" = '2' ]; then
      work_category="${1}"
    fi
    shift
  done

  dob report \
    --since "${since_day}" \
    -c "${work_category}" \
    --totals --df HHhMMm \
    -A -C \
    -l actegory -l duration -l sparkline \
    -S time --dir desc \
    "${@}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

