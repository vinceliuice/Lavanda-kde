#! /usr/bin/env bash

SRC_DIR=$(cd $(dirname $0) && pwd)

ROOT_UID=0

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  AURORAE_DIR="/usr/share/aurorae/themes"
  SCHEMES_DIR="/usr/share/color-schemes"
  PLASMA_DIR="/usr/share/plasma/desktoptheme"
  LOOKFEEL_DIR="/usr/share/plasma/look-and-feel"
  KVANTUM_DIR="/usr/share/Kvantum"
  WALLPAPER_DIR="/usr/share/wallpapers"
else
  AURORAE_DIR="$HOME/.local/share/aurorae/themes"
  SCHEMES_DIR="$HOME/.local/share/color-schemes"
  PLASMA_DIR="$HOME/.local/share/plasma/desktoptheme"
  LOOKFEEL_DIR="$HOME/.local/share/plasma/look-and-feel"
  KVANTUM_DIR="$HOME/.config/Kvantum"
  WALLPAPER_DIR="$HOME/.local/share/wallpapers"
fi

THEME_NAME=Lavanda
LATTE_DIR="$HOME/.config/latte"

COLOR_VARIANTS=('-Light' '-Dark')
THEME_VARIANTS=('' '-Sea')

cp -rf "${SRC_DIR}"/configs/Xresources "$HOME"/.Xresources

mkdir -p                                                                                     ${AURORAE_DIR}
mkdir -p                                                                                     ${SCHEMES_DIR}
mkdir -p                                                                                     ${PLASMA_DIR}
mkdir -p                                                                                     ${LOOKFEEL_DIR}
mkdir -p                                                                                     ${KVANTUM_DIR}
mkdir -p                                                                                     ${WALLPAPER_DIR}

install() {
  local name=${1}
  local theme=${2}
  local color=${3}

  [[ ${color} == '-Dark' ]] && local ELSE_COLOR='Dark'
  [[ ${color} == '-Light' ]] && local ELSE_COLOR='Light'
  [[ ${theme} == '-Sea' ]] && local ELSE_THEME='Sea'

  local AURORAE_THEME="${AURORAE_DIR}/${name}${theme}${color}"
  local PLASMA_THEME="${PLASMA_DIR}/${name}${theme}${color}"
  local LOOKFEEL_THEME="${LOOKFEEL_DIR}/com.github.vinceliuice.${name}${theme}${color}"
  local SCHEMES_THEME="${SCHEMES_DIR}/${name}${ELSE_THEME}${ELSE_COLOR}.colors"
  local KVANTUM_THEME="${KVANTUM_DIR}/${name}${ELSE_THEME}"
  local WALLPAPER_THEME="${WALLPAPER_DIR}/${name}${theme}${color}"
  local LATTE_THEME="${LATTE_DIR}/${name}.layout.latte"

  [[ -d ${AURORAE_THEME} ]] && rm -rf ${AURORAE_THEME}
  [[ -d ${PLASMA_THEME} ]] && rm -rf ${PLASMA_THEME}
  [[ -d ${LOOKFEEL_THEME} ]] && rm -rf ${LOOKFEEL_THEME}
  [[ -f ${SCHEMES_THEME} ]] && rm -rf ${SCHEMES_THEME}
  [[ -d ${KVANTUM_THEME} ]] && rm -rf ${KVANTUM_THEME}
  [[ -d ${WALLPAPER_THEME} ]] && rm -rf ${WALLPAPER_THEME} && rm -rf ${WALLPAPER_DIR}/${name}${theme}
  [[ -f ${LATTE_THEME} ]] && rm -rf ${LATTE_THEME}

  cp -r ${SRC_DIR}/aurorae/${name}${theme}${color}                                           ${AURORAE_DIR}
  cp -r ${SRC_DIR}/color-schemes/${name}${ELSE_THEME}${ELSE_COLOR}.colors                    ${SCHEMES_DIR}
  cp -r ${SRC_DIR}/Kvantum/${name}${ELSE_THEME}                                              ${KVANTUM_DIR}
  cp -r ${SRC_DIR}/plasma/desktoptheme/${name}${theme}${color}                               ${PLASMA_DIR}
  cp -r ${SRC_DIR}/plasma/desktoptheme/icons                                                 ${PLASMA_THEME}/icons

  if [[ ${theme} == '-Sea' ]]; then
    cp -r ${SRC_DIR}/plasma/desktoptheme/icons-Sea/*                                         ${PLASMA_THEME}/icons
  fi

  cp -r ${SRC_DIR}/color-schemes/${name}${ELSE_THEME}${ELSE_COLOR}.colors                    ${PLASMA_THEME}/colors
  cp -r ${SRC_DIR}/plasma/look-and-feel/com.github.vinceliuice.${name}${theme}${color}       ${LOOKFEEL_DIR}
  cp -r ${SRC_DIR}/wallpaper/${name}${theme}${color}                                         ${WALLPAPER_DIR}
  cp -r ${SRC_DIR}/wallpaper/${name}${theme}                                                 ${WALLPAPER_DIR}
  mkdir -p                                                                                   ${PLASMA_THEME}/wallpapers
  cp -r ${SRC_DIR}/wallpaper/${name}${theme}${color}                                         ${PLASMA_THEME}/wallpapers

  if [[ -d ${LATTE_THEME} ]]; then
    cp -r ${SRC_DIR}/latte-dock/${name}.layout.latte                                         ${LATTE_THEME}
    cp -r ${SRC_DIR}/latte-dock/${name}_x2.layout.latte                                      ${LATTE_THEME}
  fi
}

echo "Installing '${THEME_NAME} kde themes'..."

for theme in "${themes[@]:-${THEME_VARIANTS[@]}}"; do
  for color in "${colors[@]:-${COLOR_VARIANTS[@]}}"; do
    install "${name:-${THEME_NAME}}" "${theme}" "${color}"
  done
done

echo "Install finished..."
