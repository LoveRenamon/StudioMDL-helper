#!/bin/bash
export WINEPREFIX="$HOME/.wine64"
export WINEARCH="win64"
export WINEDEBUG="-all"

export VPROJECT="/mnt/500GB/source1/0xdecompiled"
export SteamLibrary="/mnt/500GB/SteamLibrary/steamapps/common"
export CompileFlags="-verbose -printbones -fastbuild -fullcollide -collapsereport -dumpmaterials -nop4 -nox360 -n -h -parsecompletion"

export SFM="Z:$SteamLibrary/SourceFilmmaker/game/usermod"
export SFMbin="$SteamLibrary/SourceFilmmaker/game/bin"

export GMod="Z:$SteamLibrary/GarrysMod/garrysmod"
export GModbin="$SteamLibrary/GarrysMod/bin"

export L4D2="Z:$SteamLibrary/Left 4 Dead 2/left4dead2"
export L4D2bin="$SteamLibrary/Left 4 Dead 2/bin"
export wine="/home/loverenamon/.steam/steam/steamapps/common/Proton 4.11/dist/bin/wine" # para l4d2 que tem DRM

export GAME=$GMod # Opção default

cd $SFMbin
title="StudioMDL script para Source Engine. por: Davi (Debiddo) Gooz"
prompt="Selecione uma opção: jogo ou compilar: "
options=("GMod" "SFM" "L4D2" "Compile")
gamemsg="O jogo selecionado é agora é"
compilemsg="Compilando em '$GAME/models' para o relativo jogo..."

echo "
StudioMDL rodando em '$WINEARCH' dentro do prefixo '$WINEPREFIX'


 Observações:
 	 - Use arquivos de texto em .qc
 	 - Não há necessidade de inserir a extensão do arquivo
 	 - Evite usar espaços nos diretórios
 	 - Insira o diretório relativo à:
  $VPROJECT

 Esse script roda em loop então poderá compilar inúmeros arquivos em sequência
"
echo "
  $title
"

PS3="$prompt"
select opt in "${options[@]}" "Quit"; do
    case "$REPLY" in
    1) echo "$gamemsg Garry's Mod"; export GAME=$GMod; cd $SFMbin;echo;;
    g) echo "$gamemsg Garry's Mod"; export GAME=$GMod; cd $SFMbin;echo;;
    gmod) echo "$gamemsg Garry's Mod"; export GAME=$GMod; cd $SFMbin;echo;;

    2) echo "$gamemsg Source Filmmaker"; export GAME=$SFM; cd $SFMbin;echo;;
    s) echo "$gamemsg Source Filmmaker"; export GAME=$SFM; cd $SFMbin;echo;;
    sfm) echo "$gamemsg Source Filmmaker"; export GAME=$SFM; cd $SFMbin;echo;;

    3) echo "$gamemsg Left 4 Dead 2"; export GAME="$L4D2"; cd "$L4D2bin";echo;;
    l) echo "$gamemsg Left 4 Dead 2"; export GAME="$L4D2"; cd "$L4D2bin";echo;;
    l4d2) echo "$gamemsg Left 4 Dead 2"; export GAME="$L4D2"; cd "$L4D2bin";echo;;

    # Compile part:
    4) echo "$compilemsg"; read -p "Arquivo (.qc): " qcfile ; env wine studiomdl $CompileFlags -game "$GAME" "V:/0xdecompiled/$qcfile";echo;echo $title;;
    c) echo "$compilemsg"; read -p "Arquivo (.qc): " qcfile ; env wine studiomdl $CompileFlags -game "$GAME" "V:/0xdecompiled/$qcfile";echo;echo $title;;
    m) echo "$compilemsg"; read -p "Arquivo (.qc): " qcfile ; env wine studiomdl $CompileFlags -game "$GAME" "V:/0xdecompiled/$qcfile";echo;echo $title;;
    mdl) echo "$compilemsg"; read -p "Arquivo (.qc): " qcfile ; env wine studiomdl $CompileFlags -game "$GAME" "V:/0xdecompiled/$qcfile";echo;echo $title;;
    compile) echo "$compilemsg"; read -p "Arquivo (.qc): " qcfile ; env wine studiomdl $CompileFlags -game "$GAME" "V/0xdecompiled/:$qcfile";echo;echo $title;;

    # Especial para l4d2
    lc) echo "Compilando especialmente em '$GAME/models' para Left 4 Dead 2 "; read -p "Arquivo (.qc): " qcfile ; cd "$L4D2bin";env WINEPREFIX="/mnt/500GB/SteamLibrary/steamapps/compatdata/563/pfx" "$wine" studiomdl -checklenghts -n -h -printbones -printgraph -nox360 -fastbuild -dumpmaterials -nop4 -verbose -game "$GAME" "V:/0xdecompiled/$qcfile";echo;echo $title;;

    $((${#options[@]}+1))) break;;
    quit) break;;
    sair) break;;
    q) break;;
    *) echo "opção inválida. tente outra.";continue;;
    esac
done
