#!/bin/bash
#set -euo pipefail
#IFS=$'\n\t'

# -----------------------------------------------------------------------------
# Bash helper script used in project generate.sh scripts.
# -----------------------------------------------------------------------------

# $1 = device name suffix (like "stm32f407xx")
# $2 (optional) = scope (like ilg, lix, ...)
do_add_stm32_cmsis_xpack() {
  local device=$(echo $1 | tr '[:upper:]' '[:lower:]')
  local family=${device:5:2}
  local family_uc=$(echo ${family} | tr '[:lower:]' '[:upper:]')
  local scope="ilg"
  if [ $# -ge 2 ]
  then
    scope="$2"
  fi

  local pack_name="stm32${family}-cmsis"
  do_tell_xpack "${pack_name}-xpack"

  do_select_pack_folder "${scope}/${pack_name}.git"

  local include_path="${pack_folder}/Drivers/CMSIS/Device/ST/STM32${family_uc}xx/Include"
  local src_path="${pack_folder}/Drivers/CMSIS/Device/ST/STM32${family_uc}xx/Source/Templates"
  if [ "${family}" == "f3" ]
  then
    # Some Keil packages have different paths.
    include_path="${pack_folder}/Device/Include"
    src_path="${pack_folder}/Device/Source"
  fi

  do_prepare_dest "${pack_name}/${device}/include"
  do_add_content "${include_path}/cmsis_device.h" 
  do_add_content "${include_path}/stm32${family}xx.h" 
  do_add_content "${include_path}/${device}.h" 
  do_add_content "${include_path}/system_stm32${family}xx.h" 

  do_prepare_dest "${pack_name}/${device}/src"
  do_add_content "${src_path}/system_stm32${family}xx.c" 
  do_add_content "${src_path}/gcc/vectors_${device}.c" 
}

# -----------------------------------------------------------------------------

# $1 = family name (like "f0", "f4", ...)
# $2 (optional) = scope (like ilg, lix, ...)
do_add_stm32_cmsis_driver_xpack() {
  local family=$(echo $1 | tr '[:upper:]' '[:lower:]')
  local scope="ilg"
  if [ $# -ge 2 ]
  then
    scope="$2"
  fi

  local pack_name="stm32${family}-cmsis"
  do_tell_xpack "${pack_name}-xpack"

  do_select_pack_folder "${scope}/${pack_name}.git"

  do_prepare_dest "${pack_name}/driver/src"
  do_add_content "${pack_folder}/CMSIS/Driver/"* 

  echo "Removing '${dest_folder}/Config'..."
  rm -rf "${dest_folder}/Config"
}

# -----------------------------------------------------------------------------

# $1 = family shortcut (like "f0", "f4", ...)
# $2 (optional) = scope (like ilg, lix, ...)
do_add_stm32_hal_xpack() {
  local family=$(echo $1 | tr '[:upper:]' '[:lower:]')
  local family_uc=$(echo ${family} | tr '[:lower:]' '[:upper:]')
  local scope="ilg"
  if [ $# -ge 2 ]
  then
    scope="$2"
  fi

  local pack_name="stm32${family}-hal"

  do_tell_xpack "${pack_name}-xpack"

  do_select_pack_folder "${scope}/${pack_name}.git"

  do_prepare_dest "${pack_name}/include"
  do_add_content "${pack_folder}/Drivers/STM32${family_uc}xx_HAL_Driver/Inc"/* 

  do_prepare_dest "${pack_name}/src"
  do_add_content "${pack_folder}/Drivers/STM32${family_uc}xx_HAL_Driver/Src"/* 

  echo "Removing '${dest_folder}/*_template.c'..."
  rm "${dest_folder}/"*_template.c
}

# -----------------------------------------------------------------------------

# $1 = device name suffix (like "stm32f407xx")
do_add_stm32_cmsis_cube() {
  local device=$(echo $1 | tr '[:upper:]' '[:lower:]')
  local family=${device:5:2}
  local family_uc=$(echo ${family} | tr '[:lower:]' '[:upper:]')

  local pack_name="stm32${family}-cmsis"
  do_tell_xpack "${pack_name}-cube"

  do_set_cube_folder

  do_prepare_dest "${pack_name}/${device}/include"
  echo "#include \"stm32${family}xx.h\"" >"${dest_folder}/cmsis_device.h"
  do_add_content "${cube_folder}/Drivers/CMSIS/Device/ST/STM32${family_uc}xx/Include/stm32${family}xx.h" 
  do_add_content "${cube_folder}/Drivers/CMSIS/Device/ST/STM32${family_uc}xx/Include/${device}.h" 
  do_add_content "${cube_folder}/Drivers/CMSIS/Device/ST/STM32${family_uc}xx/Include/system_stm32${family}xx.h" 

  do_prepare_dest "${pack_name}/${device}/src"
  do_add_content "${cube_folder}/Drivers/CMSIS/Device/ST/STM32${family_uc}xx/Source/Templates/system_stm32${family}xx.c" 
  do_create_vectors "${cube_folder}/Drivers/CMSIS/Device/ST/STM32${family_uc}xx/Source/Templates/arm/startup_${device}.s" >"${dest_folder}/vectors_${device}.c"
}

# -----------------------------------------------------------------------------

# $1 = family shortcut (like "f0", "f4", ...)
do_add_stm32_hal_cube() {
  local family=$1
  local family_uc=$(echo ${family} | tr '[:lower:]' '[:upper:]')

  local pack_name="stm32${family}-hal"

  do_tell_xpack "${pack_name}-cube"

  do_set_cube_folder

  do_prepare_dest "${pack_name}/include"
  do_add_content "${cube_folder}/Drivers/STM32${family_uc}xx_HAL_Driver/Inc"/* 

  do_prepare_dest "${pack_name}/src"
  do_add_content "${cube_folder}/Drivers/STM32${family_uc}xx_HAL_Driver/Src"/* 

  echo "Removing '${dest_folder}/*_template.c'..."
  rm "${dest_folder}/"*_template.c
}

# -----------------------------------------------------------------------------
