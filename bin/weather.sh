#!/bin/sh
# vim:tw=0:ts=2:sw=2:et:norl:nospell:ft=bash
# Author: Landon Bouma <https://tallybark.com/>
# Project: https://github.com/DepoXy/depoxy#🍯
# License: MIT

# Copyright © 2024 Landon Bouma. All Rights Reserved.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# USAGE:
#
#   WX_OPENWEATHER_KEY=<Your Key> weather.sh <Location>
#
# Options:
#
#   --trace — Print curl responses
#   --faker — Use fake data (avoid API hit)
#
# Limits:
#
#   1,000 API calls per day for free [as of 2024-10-16]
#
#   - At 0.0015 USD per API call over the daily limit,
#     this is a $1.50 value!
#
#     https://openweathermap.org/price#weather
#
#   - If you query every 15 mins, that's 96 queries per day.
#
#   - If you wanna burn all 1,000 calls, you could query
#     every 1.44 mins (86.4 secs).
#
# Setup:
#
#   Snag your own OpenWeather API key for free (email required):
#
#     https://home.openweathermap.org/users/sign_up

# THANX: Inspired by github.com/nogara's gist:
# - "Simple alternative to wttr.in using OpenWeatherMap"
#   https://gist.github.com/nogara/4351f96b7531781fd4e3fdc4ecb4b196
# - No license specified, but we'll just overhaul the gist
#   to be something mostly completely different.

# WORDS: Per THE ATMOSPHERIC RESERVOIR, "WX" is an abbreviation for "Weather"
# https://www.swc.nd.gov/ARB/news/atmospheric_reservoir/pdfs/2011_07%20-%20Weather%20Acronyms.pdf

# MAYBE/LORPI: Add `fetch_location` cache, so we don't burn an extra
# API credit with every run.

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Print OpenWeather curl responses (JSON)
WX_TRACE=${WX_TRACE:-false}

# Use fake curl responses (for Minneapolis, on a cool, sunny Tues in Oct)
WX_FAKER=${WX_FAKER:-false}

# The required location (can be specified as command arg, or via environ)
WX_LOCATION="${WX_LOCATION}"

# Choices: "imperial" or "metric"
WX_UNITS="${WX_UNITS:-imperial}"

# Your OpenWeatherMap API key
WX_OPENWEATHER_KEY="${WX_OPENWEATHER_KEY}"

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

print_usage() {
  echo "USAGE: WX_OPENWEATHER_KEY=<Your OpenWeatherMap.org Key> $0 [--debug] [Location]"
  echo "REFER: Visit https://openweathermap.org/ to register for an API Key:"
  echo "  https://home.openweathermap.org/users/sign_up"
}

process_args () {
  local end_of_options_indicator="--"

  while [ "$1" != "" ] && [ "$1" != "${end_of_options_indicator}" ]; do
    case $1 in
      --trace | --debug)
        WX_TRACE=true
        ;;

      --fake | --faker)
        WX_FAKER=true
        ;;

      --key | --api-key)
        if [ -z "$2" ]; then
          >&2 echo "ERROR: Missing API key"

          exit 1
        fi
        WX_OPENWEATHER_KEY="$2"

        shift
        ;;

      -h | --help | help | usage)
        print_usage

        exit 0
        ;;

      *)
        WX_LOCATION="$1"
        ;;
    esac

    shift
  done

  # If user specified `--` end of options, check for location arg.
  if [ -n "$1" ]; then
    if [ -n "${WX_LOCATION}" ]; then
      >&2 echo "ERROR: Unrecognized arg: $1"

      exit 1
    fi

    WX_LOCATION="$1"

    shift

    if [ $# -gt 0 ]; then
      >&2 echo "ERROR: Unrecognized arg(s): $@"

      exit 1
    fi
  fi
}

insist_location_and_api_key () {
  # Insist that the location is specified
  if [ -z "${WX_LOCATION}" ]; then
    >&2 print_usage

    exit 1
  fi

  # Insist that the API key is specified
  if [ -z "${WX_OPENWEATHER_KEY}" ]; then
    >&2 print_usage

    exit 1
  fi
}

# Ensure `jq` and `bc` installed.
check_deps () {
  if ! command -v jq > /dev/null 2>&1; then
    >&2 printf "%s\n%s\n" \
      "ERROR: Missing ‘jq’" \
      "- HINT: Try ‘brew install jq’, or ‘apt install jq’, etc."

    exit 1
  fi

  if ! command -v bc > /dev/null 2>&1; then
    >&2 printf "%s\n%s\n" \
      "ERROR: Missing ‘bc’" \
      "- HINT: Try ‘apt install bc’, etc."

    exit 1
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

# Map weather condition to emoji
# REFER:
#   https://openweathermap.org/weather-conditions#Weather-Condition-Codes-2
# REFER: See wttr.in symbols for comparison:
#   https://github.com/chubin/wttr.in/blob/235581925/lib/constants.py#L54
# SAVVY: macOS prints some emoji as B&W VS15 variants in Alacritty/terminals.
#   echo "☀️  🌞 / ⛅ / 🌫 / 🌧 / ❄️  ☃  ⛄ 🏒 / 🌦 / ⛈ ⚡ 🌀 / ✨"
#            ✓✓        ✓✓   ✓✓            ✓✓   ✓✓         ✓✓   ✓✓

weather_to_emoji () {
  local weather_main="$1"
  local sunrise="$2"
  local sunset="$3"

  case "${weather_main}" in
    "Thunderstorm")
      # description: "thunderstorm with light rain", "... with rain",
      # "... with heavy rain", "light thunderstorm", "thunderstorm",
      # "heavy thunderstorm", "ragged thunderstorm", "... with light
      # drizzle", "... with drizzle", "... with heavy drizzle"
      echo "🌀"
      ;;
    "Drizzle")
      # description: "light intensity drizzle", "drizzle", "heavy
      # intensity drizzle", "light intensity drizzle rain", "drizzle
      # rain", "heavy intensity drizzle rain", "shower rain and drizzle",
      # "heavy shower rain and drizzle", "shower drizzle"
      echo "🌦"
      ;;
    "Rain")
      # description: "[light|moderate|heavy intensity|very heavy|
      # extreme|freezing|light intensity shower|shower|heavy
      # intensity shower|ragged shower] rain"
      echo "🌧"
      ;;
    "Snow")
      # description: "snow", "shower snow", "[light|heavy] [shower] snow",
      # "sleet", "[light shower|shower] sleet", "[light] rain and snow"
      echo "🏒"
      ;;
    "Mist")
      # description: "mist"
      echo "💦"
      ;;
    "Smoke")
      # description: "smoke"
      echo "🌿"  # 🚬
      ;;
    "Haze")
      # description: "haze"
      echo "💫"
      ;;
    "Dust")
      # description: "sand/dust whirls", "dust"
      echo "🤧"
      ;;
    "Fog")
      # description: "fog"
      echo "🥴"  # 🌁
      ;;
    "Sand")
      # description: "sand"
      echo "🏖️"
      ;;
    "Ash")
      # description: "volcanic ash"
      echo "🌋"
      ;;
    "Squall")
      # description: "squalls"
      echo "🌬️"  # 💨 🌬️ 
      ;;
    "Tornado")
      # description: "tornado"
      echo "🌪️"
      ;;
    "Clear")
      # description: "clear sky"
      local time_now="$(date +%s)"
      if [ ${time_now} -ge ${sunrise} ] && [ ${time_now} -lt ${sunset} ]; then
        echo "🌞"
      else
        # Show different icon at nighttime.
        #   echo "🌃  🌌  🌝  🌛  🌓  ⭐  🌙"
        #         ✓✓  ✓✓  ✓✓  ✓✓  ✓✓      ✓✓
        echo "🌓"
      fi
      ;;
    "Clouds")
      # description: "few clouds: 11-25%", "scattered clouds: 25-50%",
      # "broken clouds: 51-84%", "overcast clouds: 85-100%"
      echo "⛅"
      ;;
    *)
      # Unreachable/Unexpected (at least per docs)
      echo "❓"  # ✨
      ;;
  esac
}

# Map wind direction in degrees to arrows
wind_to_arrow () {
  local deg="$1"

  if ([ $deg -ge 0 ] && [ $deg -lt 23 ]) || [ $deg -ge 338 ]; then
    echo "→"  # ➡️
  elif [ $deg -ge 23 -a $deg -lt 68 ]; then
    echo "↗"  # ↗️
  elif [ $deg -ge 68 -a $deg -lt 113 ]; then
    echo "↑"  # ⬆️
  elif [ $deg -ge 113 -a $deg -lt 158 ]; then
    echo "↖"  # ↖️
  elif [ $deg -ge 158 -a $deg -lt 203 ]; then
    echo "←"  # ⬅️
  elif [ $deg -ge 203 -a $deg -lt 248 ]; then
    echo "↙"  # ↙️
  elif [ $deg -ge 248 -a $deg -lt 293 ]; then
    echo "↓"  # ⬇️
  else  # [ $deg -ge 293 -a $deg -lt 338 ]; then
    echo "↘"  # ↘️
  fi
}

round_to_nearest_integer () {
  local num="$1"

  bc -le "r(${num}, 0)"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

fetch_location () {
  local location="$1"

  if ! ${WX_FAKER}; then
    curl -s "http://api.openweathermap.org/geo/1.0/direct?q=${location}&appid=${WX_OPENWEATHER_KEY}"
  else
    echo '[{"name":"Minneapolis","local_names":{"ru":"Миннеаполис","uk":"Міннеаполіс","he":"מיניאפוליס","en":"Minneapolis","kn":"ಮಿನ್ಯಾಪೋಲಿಸ್","ja":"ミネアポリス","pt":"Mineápolis","fa":"مینیاپولیس","eo":"Mineapolo","hi":"मिन्यापोलिस्","oc":"Minneapòlis","zh":"明尼阿波利斯","ar":"منيابولس","oj":"Gakaabikaang"},"lat":44.9772995,"lon":-93.2654692,"country":"US","state":"Minnesota"}]'
  fi
}

fetch_weather () {
  local lat="$1"
  local lon="$2"

  if ! ${WX_FAKER}; then
    local parameters
    parameters="lat=${lat}&lon=${lon}&appid=${WX_OPENWEATHER_KEY}&units=${WX_UNITS}"

    curl -s "http://api.openweathermap.org/data/2.5/weather?${parameters}"
  else
    # From 2024-10-16 19:49:36.
    echo '{"coord":{"lon":-93.2655,"lat":44.9773},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}],"base":"stations","main":{"temp":53.55,"feels_like":50.25,"temp_min":51.22,"temp_max":55.85,"pressure":1020,"humidity":35,"sea_level":1020,"grnd_level":988},"visibility":10000,"wind":{"speed":9.22,"deg":180},"clouds":{"all":0},"dt":1729125631,"sys":{"type":2,"id":2012563,"country":"US","sunrise":1729081830,"sunset":1729121169},"timezone":-18000,"id":5037649,"name":"Minneapolis","cod":200}'
  fi
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

print_current_weather () {
  # URL-encode spaces
  local location
  location="$(echo "${WX_LOCATION}" | sed 's/ /%20/g')"

  # Get latitude and longitude of the location
  local geo_data
  geo_data="$(fetch_location "${location}")"

  if ${WX_TRACE}; then
    echo "Location: ${geo_data}"
  fi

  local lat lon location_name country
  lat=$(echo "${geo_data}" | jq -r '.[0].lat')
  lon=$(echo "${geo_data}" | jq -r '.[0].lon')
  location_name=$(echo "${geo_data}" | jq -r '.[0].name')
  country=$(echo "${geo_data}" | jq -r '.[0].country')

  # Get current weather data
  local weather_data
  weather_data="$(fetch_weather "${lat}" "${lon}")"

  if ${WX_TRACE}; then
    echo "Weather Data: ${weather_data}"
  fi

  local weather_main
  weather_main="$(echo ${weather_data} | jq -r '.weather[0].main')"

  local temp temp_units
  temp="$(echo "${weather_data}" | jq -r '.main.temp')"
  temp="$(round_to_nearest_integer "${temp}")"
  [ ${WX_UNITS} = "imperial" ] && temp_units="°F" || temp_units="°C"

  local wind_speed wind_units
  wind_speed="$(echo "${weather_data}" | jq -r '.wind.speed')"
  wind_speed="$(round_to_nearest_integer "${wind_speed}")"
  [ ${WX_UNITS} = "imperial" ] && wind_units="mph" || wind_units="kph"
  # On second thought, units make the one-liner wider than author likes.
  wind_units=""

  local wind_deg
  wind_deg="$(echo "${weather_data}" | jq -r '.wind.deg')"

  local sunrise sunset
  sunrise="$(echo ${weather_data} | jq -r '.sys.sunrise')"
  sunset="$(echo ${weather_data} | jq -r '.sys.sunset')"

  # Convert weather condition to emoji
  local weather_emoji
  weather_emoji="$(weather_to_emoji "${weather_main}" "${sunrise}" "${sunset}")"

  # Convert wind direction to arrow
  local wind_arrow
  wind_arrow="$(wind_to_arrow "${wind_deg}")"

  # Determine temperature sign
  local temp_sign=""
  if [ "$(echo "${temp} > 0" | bc -l)" -eq 0 ]; then
    temp_sign="-"
  fi

  # Print the one-liner
  #
  # - github.com/nogara's one-liner, e.g.,
  #   
  #     Minneapolis, US: ☀️  🌡️  +12.56°C 🌬️  ←9.22mph
  #
  #   echo "$location_name, $country:" \
  #     "$weather_emoji  🌡️  ${temp_sign}${temp}°C" \
  #     "🌬️  ${wind_arrow}${wind_speed}${wind_units}"
  #
  # - DepoXy's more concise one-liner, e.g.,
  #
  #     Minneapolis, US — 🌞 54 °F 💨 ← 9
  #
  #   - Hint: Feed through `sed` to shorten further, e.g.,
  #
  #       $ weather.sh Minneapolis | sed -e 's/Minneapolis, US/𝑴𝑷𝑳𝑺/'
  #       𝑴𝑷𝑳𝑺 — 🌞 54 °F 💨 ← 9

  echo "${location_name}, ${country}" \
    "— ${weather_emoji} ${temp_sign}${temp} ${temp_units}" \
    "💨 ${wind_speed} ${wind_arrow}"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

PROG_NAME="weather.sh"

main () {
  check_deps

  # Set WX_* vars.
  process_args "$@"

  insist_location_and_api_key

  print_current_weather
}

# Run the command unless being sourced.
if [ "$(basename -- "$(realpath -- "$0")")" = "${PROG_NAME}" ]; then
  main "$@"
fi

unset -f main

