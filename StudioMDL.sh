#!/bin/bash
# WINE / Proton setup env
export WINEPREFIX="$HOME/.wine64"
export WINEARCH="win64"
export WINEDEBUG="-all"

# default compile flags, and yeah I use all of then
export CompileFlags="-verbose -printbones -fastbuild -fullcollide -collapsereport -dumpmaterials -nop4 -nox360 -n -h -parsecompletion $@"

# nix paths
export SteamLibrary="/mnt/500GB/SteamLibrary/steamapps/common"

# this will be used as prefix for every QCProject
export VPROJECT0="/mnt/500GB/source1/0xdecompiled"
export qcprefix="Z:${VPROJECT0}"

# This set the StudioMDL -game flag
export GMod="Z:$SteamLibrary/GarrysMod/garrysmod"
export SFM="Z:$SteamLibrary/SourceFilmmaker/game/usermod"
export L4D2="Z:$SteamLibrary/Left 4 Dead 2/left4dead2"

# here the *nix path to the bin filder
export GModbin="$SteamLibrary/GarrysMod/bin"
export L4D2bin="$SteamLibrary/Left 4 Dead 2/bin"
export SFMbin="$SteamLibrary/SourceFilmmaker/game/bin"

# here a special path for the l4d2 WINEPREFIX and avoid mess with our above WINEPREFIX
export L4D2pfx="/mnt/500GB/SteamLibrary/steamapps/compatdata/563/pfx"

# l4d2 had a throublesome authoring way, so we need set proton to enforce steam can see can use this StudioMDL. the "$@" is necessary to accept arguments
proton4() {
  $HOME/.steam/steam/steamapps/common/Proton\ 4.11/dist/bin/wine "$@"
}

# Uncomment if you have a special WINE environment, or even use Proton instaed, like we did with above Proton 4.11 
#wine() {
#    put here your custom wine path is you wanna use a specific version, examples:
#    $HOME/.steam/steam/steamapps/common/Proton\ 5.0/dist/bin/wine "$@"
#}

print_env() {
  gamemsg="\nO Jogo selecionado é: \e[1;49;97m${1}\e[0m\n\nEnvironment modified to:\n\t\e[1;49;97mGAMEINFO:\e[0m $GAME\n\t\e[1;49;97mGAMEBIN:\e[0m $(pwd)\n\t\e[1;49;97mWINEPREFIX:\e[0m $WINEPREFIX\n\t\e[1;49;97mWINEARCH:\e[0m $WINEARCH\n"
  compilemsg="Compiling for the previously selected gamemod at:\n\e[1;49;97m\"$GAME/models\"\e[0m\n"
  echo -e ${gamemsg}
}

set_wine_prefix() {
  case "$1" in
    w64) export WINEPREFIX=$WINE64;;
    563) export WINEPREFIX="$L4D2pfx";;
    help) echo -e "valid options: w64 | 563 | Any SteamID";;
    *) export WINEPREFIX="${SteamLibrary::-7}/compatdata/$1/pfx";;
  esac
}

set_custom_mod() {
  read -e -p "WINEPREFIX: " pfx
  read -e -p "GAMEBIN: " gamebin
  read -e -p "GAMEINFO (where is your gameinfo.txt): " gameinfo
  set_wine_prefix $pfx
  cd "$gamebin"
  export GAME="Z:$gameinfo"
  print_env
}

# Default Option
set_default() {
  GAME=$GMod
  cd $SFMbin
  set_wine_prefix w64
  print_env "Garry's Mod"
}

# gmod bin folder is a mess and their StudioMDL cant deal with higher density $lod, so we'll mix with SFM by default, change if you think it should be
set_gmod() {
  GAME=$GMod
  set_wine_prefix w64
  cd $GModbin
  print_env "Garry's Mod"
}

set_sfm() {
  GAME=$SFM
  set_wine_prefix w64
  cd $SFMbin
  print_env "Source Filmmaker"
}

set_l4d2() {
  GAME="$L4D2"
  set_wine_prefix 563
  cd "$L4D2bin"
  print_env "Left 4 Dead 2"
}

do_compile() {
  echo -e "$compilemsg"
  read -p "QC: " qcfile
  wine studiomdl $CompileFlags -game "$GAME" "$qcprefix/$qcfile"
  echo -e $title
}

do_l4d2() {
  set_l4d2
  echo -e "$compilemsg"
  read -e -p "QC: " qcfile
  proton4 ./studiomdl.exe '-checklenghts -n -h -printbones -printgraph -nox360 -fastbuild -dumpmaterials -nop4 -verbose' "$@" -game "$GAME" "$qcprefix/$qcfile"
  echo -e $title
}

ajuda_ai_meu() {
  echo -e "\n\tsorry I'm still working at this option\n"
}

title="\n\e[0;38;5;220mStudioMDL-helper para Source Engine.\n por: Davi (Debiddo) Gooz\e[0m\n"
options=("Set Garry's Mod" "Set Source Filmmaker" "Set Left 4 Dead 2" "Compile a QC" "L4D2 Compile (dev)" "Reset Defaults" "Set Custom Environment" "Help")
prompt="
Select one of above options:
"
## Start the shit
echo -e "\nStudioMDL running at \e[1;49;97m\"$WINEARCH\"\e[0m arch inside the \e[1;49;97m\"$WINEPREFIX\"\e[0m\n Wine Prefix

 TIPs:
 	 - Insert bellow a .qc file
 	 - You don't need to write their extension
 	 - Avoid \"space\" usage
 	 - Insert your QC project relative to:  \e[1;49;97m$VPROJECT0\e[0m

 This script run in loop so you'll be able to compile sequentially many files\n"
echo -e "$title"

set_default

# Ask what should be done
PS3="$prompt"
select opt in "${options[@]}" "Quit"; do
    case "$REPLY" in
      # Environments Setup
      1*|g*) set_gmod;;
      2*|sf*) set_sfm;;
      3*|l|l4d2) set_l4d2;;

      # Compile part:
      4*|c*|m*) do_compile;;

      # L4D2 Special
      5*|lc|l4d2c) do_l4d2;;

      # reset to Default Env
      6*|def*) set_default;;

      # set custom Env
      7*|set) set_custom_mod;;

      # Help
      8*|help|ajuda) ajuda_ai_meu;;

      # Quit
      $((${#options[@]}+1))|e*|q*) break;;

      # Non valid option
      *) echo -e "\e[0;38;5;160mInvalid Option. Try again.\e[0m\n"; continue;;
    esac
done
