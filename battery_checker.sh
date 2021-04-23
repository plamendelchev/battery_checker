#!/usr/bin/env bash

# Plamen Delchev
## v1.0 - 20.04.2020
## v1.1 - 23.04.2021

set -o errexit
set -o pipefail
set -o nounset

usage() {
  cat << EOF

Battery Charge Checker

Usage:
  b2tr_chckr [-D] [-t time_to_refresh] [-m battery_alert_value]

EOF
}

BATT_CAP='/sys/class/power_supply/BAT0/capacity'
BATT_STATUS='/sys/class/power_supply/BAT0/status'
IS_DAEMON=false
TIME='1800'
BATT_ALERT_VALUE='20'

while getopts ':Dt:m:h' arg; do
  case "${arg}" in
    D )
      IS_DAEMON=true
      readonly IS_DAEMON
      ;;
    t )
      TIME="${OPTARG}"
      readonly TIME
      ;;
    m )
      BATT_ALERT_VALUE="${OPTARG}"
      readonly BATT_ALERT_VALUE
      ;;
    h )
      usage
      exit
      ;;
    : )
			printf 'Invalid: %s requires an argument\n' "-${OPTARG}" 1>&2
      exit 1
      ;;
    * )
      usage 1>&2
      exit 1
      ;;
  esac
done
shift "$((OPTIND - 1))"

# Health checks
[[ ! -e ${BATT_CAP} ]] && {
	printf 'Error: %s is not a valid path. Please check the script settings.\n' "${BATT_CAP}" 1>&2
	exit 1
}
[[ ! -e ${BATT_STATUS} ]] && {
	printf 'Error: %s is not a valid path. Please check the script settings.\n' "${BATT_STATUS}" 1>&2
	exit 1
}
[[ ! ${IS_DAEMON} = true ]] && {
	printf 'Battery level: %s\nStatus: %s\n' "$(cat "${BATT_CAP}")%" "$(cat "${BATT_STATUS}")"
	exit 0
}

while true; do
	BATT_PERC="$(cat "${BATT_CAP}")"
	BATT_CHRG="$(cat "${BATT_STATUS}")"

	printf 'DATE=%s BATT_PERC=%s BATT_STATUS=%s\n' "'$(date)'" "'${BATT_PERC}'" "'${BATT_CHRG}'" # Use as log for systemd
	(( ${BATT_PERC} <= ${BATT_ALERT_VALUE} )) && [[ "${BATT_CHRG}" == 'Discharging' ]] && printf 'Warning! Battery is at %s\n' "${BATT_PERC}%" | wall

	sleep "${TIME}"
done
