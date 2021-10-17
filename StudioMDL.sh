#!/bin/bash
export WINEPREFIX="$HOME/.wine64"
export WINEARCH="win64"
export WINEDEBUG="-all"

export VPROJECT="/mnt/500GB/source1/0xdecompiled"
export SteamLibrary="/mnt/500GB/SteamLibrary/steamapps/common"
export CompileFlags="-verbose -printbones -fastbuild -fullcollide -collapsereport -dumpmaterials -nop4 -nox360 -n -h -parsecompletion $@"

export SFM="Z:$SteamLibrary/SourceFilmmaker/game/usermod"
export SFMbin="$SteamLibrary/SourceFilmmaker/game/bin"

export GMod="Z:$SteamLibrary/GarrysMod/garrysmod"
export GModbin="$SteamLibrary/GarrysMod/bin"

export L4D2="Z:$SteamLibrary/Left 4 Dead 2/left4dead2"
export L4D2bin="$SteamLibrary/Left 4 Dead 2/bin"
export proton4="/home/loverenamon/.steam/steam/steamapps/common/Proton 4.11/dist/bin/wine" # para l4d2 que tem DRM

export GAME=$GMod # Opção default

cd $SFMbin
title="\n\e[0;38;5;220mStudioMDL script para Source Engine. por: Davi (Debiddo) Gooz\e[0m\n"
prompt="Selecione uma opção: jogo ou compilar: "
options=("GMod" "SFM" "L4D2" "Compile")
gamemsg="\nO jogo selecionado é agora é"
compilemsg="Compilando para o relativo jogo em:\n\e[1;49;97m\"$GAME/models\"\e[0m\n"

echo -e "\nStudioMDL rodando em \e[1;49;97m\"$WINEARCH\"\e[0m dentro do prefixo \e[1;49;97m\"$WINEPREFIX\"\e[0m\n

 Observações:
 	 - Use arquivos de texto em .qc
 	 - Não há necessidade de inserir a extensão do arquivo
 	 - Evite usar espaços nos diretórios
 	 - Insira o diretório relativo à:
  \e[1;49;97m$VPROJECT0\e[0m

 Esse script roda em loop então poderá compilar inúmeros arquivos em sequência\n"
echo -e "$title"

PS3="$prompt"
select opt in "${options[@]}" "Quit"; do
    case "$REPLY" in
    1) echo -e "$gamemsg \e[1;49;97m\Garry's Mod\e[0m"
    export GAME=$GMod
    cd $GModbin;echo;;
    g*) echo -e "$gamemsg \e[1;49;97m\Garry's Mod"
    export GAME=$GMod
    cd $GModbin;echo;;

    2) echo -e "$gamemsg \e[1;49;97m\Source Filmmaker\e[0m"
    export GAME=$SFM
    cd $SFMbin;echo;;
    s*) echo -e "$gamemsg \e[1;49;97m\Source Filmmaker\e[0m"
    export GAME=$SFM
    cd $SFMbin;echo;;

    3) echo -e "$gamemsg \e[1;49;97m\Left 4 Dead 2\e[0m"
    export GAME="$L4D2"
    cd "$L4D2bin";
    echo -e "\npara compilar, digite \e[1;49;97m\"lc\"\e[0m";;
    l) echo -e "$gamemsg \e[1;49;97m\Left 4 Dead 2\e[0m"
    export GAME="$L4D2"
    cd "$L4D2bin";
    echo -e "\npara compilar, digite \e[1;49;97m\"lc\"\e[0m";;
    l4d*) echo -e "$gamemsg \e[1;49;97m\Left 4 Dead 2\e[0m"
    export GAME="$L4D2"
    cd "$L4D2bin";
    echo -e "\npara compilar, digite \e[1;49;97m\"lc\"\e[0m";;

    # Compile part:
    4) echo -e "$compilemsg"
    read -p "QC: " qcfile
    env wine studiomdl $CompileFlags -game "$GAME" "V:/0xdecompiled/$qcfile"
    echo -e $title;;
    c*) echo -e "$compilemsg"
    read -p "QC: " qcfile
    env wine studiomdl $CompileFlags -game "$GAME" "V:/0xdecompiled/$qcfile"
    echo -e $title;;
    m*) echo -e "$compilemsg"
    read -p "QC: " qcfile
    env wine studiomdl $CompileFlags -game "$GAME" "V:/0xdecompiled/$qcfile"
    echo -e $title;;

    # Especial para l4d2
    lc*) echo -e "\nCompilando especialmente para \e[1;49;97mLeft 4 Dead 2\e[0m em:\n\e[1;49;97m\"$GAME/models\"\e[0m\n"
    read -e -p "QC: " qcfile
    cd "$L4D2bin"
    env WINEPREFIX=/mnt/500GB/SteamLibrary/steamapps/compatdata/563/pfx "$proton4" ./studiomdl.exe '-checklenghts -n -h -printbones -printgraph -nox360 -fastbuild -dumpmaterials -nop4 -verbose' "$@" -game "$L4D2" "V:/0xdecompiled/$qcfile"
    echo -e "\n$title\n";;

    $((${#options[@]}+1))) break;;
    e*) break;;
    q*) break;;
    *) echo -e "\e[0;38;5;160mOpção inválida. Tente outra.\e[0m\n";
    continue;;
    esac
done
