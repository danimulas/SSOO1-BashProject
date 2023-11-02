#!/bin/bash

mostrarProgramadoresEstrategias() {
    cat <<"EOF"
                 ┌─────────────────────────────────────────────────┐
                 │                 PROGRAMADORES                   │
                 ├─────────────────────────────────────────────────┤
                 │              Mario Prieta Sánchez               │
                 │              Daniel Mulas Fajardo               │
                 └─────────────────────────────────────────────────┘
                
                


EOF

    cat <<"EOF"
 ███████ ███████ ████████ ██████   █████  ████████ ███████  ██████  ██  █████  ███████ 
 ██      ██         ██    ██   ██ ██   ██    ██    ██      ██       ██ ██   ██ ██      
 █████   ███████    ██    ██████  ███████    ██    █████   ██   ███ ██ ███████ ███████ 
 ██           ██    ██    ██   ██ ██   ██    ██    ██      ██    ██ ██ ██   ██      ██ 
 ███████ ███████    ██    ██   ██ ██   ██    ██    ███████  ██████  ██ ██   ██ ███████ 
 
EOF

    cat <<"EOF"
    ┌─────────────────────────────────────────────────────────────────────────────┐
    │                        ESTRATEGIA 1  (NIVEL FÁCIL)                          │
    ├─────────────────────────────────────────────────────────────────────────────┤
    │ La máquina juega primero las cartas de los palos que ya están sobre la mesa,│
    │ y si no tiene ninguna carta de esos palos, juega la carta 5                 │
    └─────────────────────────────────────────────────────────────────────────────┘
EOF

    cat <<"EOF"
    ┌─────────────────────────────────────────────────────────────────────────────┐
    │                        ESTRATEGIA 2  (NIVEL DIFÍCIL)                        │
    ├─────────────────────────────────────────────────────────────────────────────┤
    │ La máquina analiza sus cartas.                                              │
    │    - Si tiene la carta 5 de algún palo, y además el 1, el 9 o el 10         │
    │      de ese mismo palo, jugará la carta 5.                                  │    
    │    - Si tiene la carta 5 de algún palo, y además tiene más número de cartas │
    │      de ese palo que del resto, jugará la carta 5.                          │
    │    - Si no cumple ninguna de las dos condiciones anteriores,                │
    │      no jugará la carta 5 si es posible.                                    │
    └─────────────────────────────────────────────────────────────────────────────┘
EOF

    read -p "Pulse INTRO para salir..."
}

comprobarArgumentos() {

    if test "$1" && test "$1" != "-g"; then
        echo -e "ERROR: Parámetro inválido. Para ejecutar el programa, escribe 'domino.sh [-g]'."
        exit
    fi

    if test "$1" = "-g"; then
        mostrarProgramadoresEstrategias
        exit
    fi
}


showMenu() {
    clear
    echo "                                                       
 _____ _ _ _       
|  ___(_) | |      
|___ \ _| | | ___  
    \ \ | | |/ _ \ 
/\__/ / | | | (_) |
\____/|_|_|_|\___/ 
                   

C)CONFIGURACION
J)JUGAR
E)ESTADISTICAS
F)CLASIFICACION
S)SALIR"
    echo "“5illo”. Introduzca una opción >>"
}

leerFicheroLog() {
    if test -e "config.cfg"; then 
        if test -r "config.cfg"; then 
            if test $(grep -c "LOG=" config.cfg) -gt 0; then #comprobamos que la linea "LOG=" existe
                linea=$(grep "LOG=" config.cfg)
                ficheroLog=${linea#*=}
                
                if ! test -f "$ficheroLog"; then #comprobamos que el fichero de log existe
                    echo "ERROR: El fichero de log ubicado en $ficheroLog no existe."
                fi
            else
            echo "ERROR: No se encontró la línea 'LOG=' en el archivo config.cfg."
            fi
        else
            echo "ERROR: No se puede leer el archivo config.cfg."
        fi
    else
        echo "ERROR: El archivo config.cfg no existe."
    fi

}

changeConfig() {
    echo "Configuración actual:"
    cat config.cfg

    if ! test -e "config.cfg"; then
        echo "ERROR: El archivo 'config.cfg' no existe."
        return
    fi

    if ! test -r "config.cfg"; then
        echo "ERROR: No se puede abrir el archivo 'config.cfg'."
        return
    fi

    read -p "Nuevo número de jugadores (2-4): " jugadores
    while ! [[ "$jugadores" =~ ^[2-4]$ ]]; do
        echo "ERROR: Por favor, introduzca un número válido de jugadores (2-4)."
        read -p "Nuevo número de jugadores (2-4): " jugadores
    done

    read -p "Nueva estrategia (0, 1 o 2): " estrategia
    while ! [[ "$estrategia" =~ ^[0-2]$ ]]; do
        echo "ERROR: Por favor, introduzca una estrategia válida (0, 1 o 2)."
        read -p "Nueva estrategia (0, 1 o 2): " estrategia
    done

    read -p "Introduzca la ruta del fichero log: " ficheroLog
    while ! test -f "$ficheroLog" || ! test -s "$ficheroLog"; do 
        echo "ERROR: La ruta proporcionada no es válida o el archivo está vacío."
        read -p "Por favor, introduzca una ruta válida: " ficheroLog
    done

    if test -e "config.cfg"; then
        if test -w "config.cfg"; then
            echo "JUGADORES=$jugadores" > "config.cfg"
            if test $? -ne 0; then
                echo "Error al escribir la configuración JUGADORES en config.cfg"
                exit 1
            fi

            echo "ESTRATEGIA=$estrategia" >> "config.cfg"
            if test $? -ne 0; then
                echo "Error al escribir la configuración ESTRATEGIA en config.cfg"
                exit 1
            fi

            echo "LOG=$ficheroLog" >> "config.cfg"
            if test $? -ne 0; then
                echo "Error al escribir la configuración LOG en config.cfg"
                exit 1
            fi

            echo "Configuración escrita con éxito en config.cfg"
        else
            echo "Error: El archivo config.cfg no es escribible."
            exit 1
        fi
    else
        echo "Error: El archivo config.cfg no existe."
        exit 1
    fi
    echo -e "\nCONFIGURACIÓN ACTUALIZADA CORRECTAMENTE"
    read -p "Pulse INTRO para continuar..."
}

barajarCartas() {

    cartas=()

    numero=1
    while [ $numero -le 10 ]; do
        cartas+=("$numero")
        numero=$((numero + 1))
    done

    local i j tmp
    for ((i = 9; i > 0; i--)); do
        j=$((RANDOM % (i + 1)))
        tmp=${cartas[i]}
        cartas[i]=${cartas[j]}
        cartas[j]=$tmp
    done
}

cargarDatosPartidaEnFicheroLog() {
    fechaActual=$(date +"%d/%m/%y")
    horaActual=$(date +"%H:%M")

    cartasRestantes=""

    for ((i = 0; i < 4; i++)); do
        cartasJugador=${cartasJugadores[$i]}
        IFS=' ' read -ra cartasArray <<<"$cartasJugador"

        numCartas=${#cartasArray[@]}

        if [ $i -lt $numJugadores ]; then
            if [ $numCartas -eq 0 ]; then
                cartasRestantes+="0"
            else
                cartasRestantes+="$numCartas"
            fi
        else
            cartasRestantes+="*"
        fi
        if [ $i -lt 3 ]; then
            cartasRestantes+="-"
        fi
    done

    leerFicheroLog
    echo "$fechaActual|$horaActual|$numJugadores|$elapsedTime|$rondas|$jugadorTurno|$puntosGanador|$cartasRestantes"
    if test -f "$ficheroLog"; then
        if test -w "$ficheroLog"; then
            echo -e "$fechaActual|$horaActual|$numJugadores|$elapsedTime|$rondas|$jugadorTurno|$puntosGanador|$cartasRestantes" >> "$ficheroLog"
        else
            echo "ERROR: No se puede escribir en el archivo de log $ficheroLog."
        fi
    else
        echo "ERROR: El archivo de log $ficheroLog no existe."
    fi
}

repartirCartas() {

    local cartasPorJugador=$((10 / numJugadores))

    barajarCartas

    cartasJugadores=()

    mesaOros=()
    mesaCopas=()
    mesaEspadas=()
    mesaBastos=()

    for ((i = 1; i <= numJugadores; i++)); do
        cartasJugadorActual=" "

        for ((j = 1; j <= cartasPorJugador; j++)); do
            carta=${cartas[((i - 1) * cartasPorJugador + j - 1)]}
            cartasJugadorActual+="$carta "
        done
        cartasJugadores+=("${cartasJugadorActual[@]}")
    done

    #si el numero de jugadores es 3, le repartimos al jugador 1 una carta extra
    if [ "$numJugadores" -eq 3 ]; then
        cartasJugadores+="${cartas[9]}"
    fi
}

imprimirCartasIntro() {

    read -p "Pulse INTRO para continuar..."
     for ((i = 0; i < numJugadores; i++)); do
        jugadorCartas="${cartasJugadores[$i]}"
        cartas_convertidas=""
        
        for carta in $jugadorCartas; do
            if ((carta >= 1 && carta <= 10)); then
                cartas_convertidas="${cartas_convertidas}${carta}-O "
            elif ((carta >= 11 && carta <= 20)); then
                carta=$((carta - 10))
                cartas_convertidas="${cartas_convertidas}${carta}-C "
            elif ((carta >= 21 && carta <= 30)); then
                carta=$((carta - 20))
                cartas_convertidas="${cartas_convertidas}${carta}-E "
            else
                carta=$((carta - 30))
                cartas_convertidas="${cartas_convertidas}${carta}-B "
            fi
        done
        
        echo "Cartas del Jugador $((i + 1)): ${cartas_convertidas}"
    done

    echo "--------------------------------------------------"

    echo -n "Cartas de Oros: "
    for ((i = 0; i < ${#mesaOros[@]}; i++)); do
        echo -n "${mesaOros[$i]} "
    done
    echo

    echo -n "Cartas de Copas: "
    for ((i = 0; i < ${#mesaCopas[@]}; i++)); do
            echo -n "$((mesaCopas[$i] - 10)) "
    done
    echo

    echo -n "Cartas de Espadas: "
    for ((i = 0; i < ${#mesaEspadas[@]}; i++)); do
            echo -n "$((mesaEspadas[$i] - 20)) "
    done
    echo

    echo -n "Cartas de Bastos: "
    for ((i = 0; i < ${#mesaBastos[@]}; i++)); do
            echo -n "$((mesaBastos[$i] - 30)) "
    done
    echo""
    echo "--------------------------------------------------"
}
imprimirCartas() {

    for ((i = 0; i < numJugadores; i++)); do
        jugadorCartas="${cartasJugadores[$i]}"
        cartas_convertidas=""
        
        for carta in $jugadorCartas; do
            if ((carta >= 1 && carta <= 10)); then
                cartas_convertidas="${cartas_convertidas}${carta}-O "
            elif ((carta >= 11 && carta <= 20)); then
                carta=$((carta - 10))
                cartas_convertidas="${cartas_convertidas}${carta}-C "
            elif ((carta >= 21 && carta <= 30)); then
                carta=$((carta - 20))
                cartas_convertidas="${cartas_convertidas}${carta}-E "
            else
                carta=$((carta - 30))
                cartas_convertidas="${cartas_convertidas}${carta}-B "
            fi
        done
        
        echo "Cartas del Jugador $((i + 1)): ${cartas_convertidas}"
    done

    echo "--------------------------------------------------"

    echo -n "Cartas de Oros: "
    for ((i = 0; i < ${#mesaOros[@]}; i++)); do
        echo -n "${mesaOros[$i]} "
    done
    echo

    echo -n "Cartas de Copas: "
    for ((i = 0; i < ${#mesaCopas[@]}; i++)); do
            echo -n "$((mesaCopas[$i] - 10)) "
    done
    echo

    echo -n "Cartas de Espadas: "
    for ((i = 0; i < ${#mesaEspadas[@]}; i++)); do
            echo -n "$((mesaEspadas[$i] - 20)) "
    done
    echo

    echo -n "Cartas de Bastos: "
    for ((i = 0; i < ${#mesaBastos[@]}; i++)); do
            echo -n "$((mesaBastos[$i] - 30)) "
    done
    echo""
    echo "--------------------------------------------------"
}



eliminarCarta() {
    for ((i = 0; i < ${#cartasJugadores[@]}; i++)); do
        cartasJugadores[$i]=$(echo "${cartasJugadores[$i]}" | nawk -v numeroEliminar="$numeroEliminar" 'BEGIN {
                                                                                                            OFS=FS=" "
                                                                                                        }
                                                                                                        {
                                                                                                            for (i=1; i<=NF; i++) {
                                                                                                                if ($i != numeroEliminar) {
                                                                                                                    printf "%s%s", $i, (i<NF) ? OFS : ORS
                                                                                                                }
                                                                                                            }
                                                                                                        }')
    done

    if ((numeroEliminar >= 1 && numeroEliminar <= 10)); then
        mesaOros+=("$numeroEliminar")
    elif ((numeroEliminar >= 11 && numeroEliminar <= 20)); then
        mesaCopas+=("$numeroEliminar")
    elif ((numeroEliminar >= 21 && numeroEliminar <= 30)); then
        mesaEspadas+=("$numeroEliminar")
    elif ((numeroEliminar >= 31 && numeroEliminar <= 40)); then
        mesaBastos+=("$numeroEliminar")
    fi

    mesaOros=($(printf "%s\n" "${mesaOros[@]}" | sort -n))
    mesaCopas=($(printf "%s\n" "${mesaCopas[@]}" | sort -n))
    mesaEspadas=($(printf "%s\n" "${mesaEspadas[@]}" | sort -n))
    mesaBastos=($(printf "%s\n" "${mesaBastos[@]}" | sort -n))

    imprimirCartas
    echo -e "El jugador $jugadorTurno ha jugado la carta $(decodificarCarta $numeroEliminar)\n"
}

turno() {
    numeroEliminar=5
    jugar=true
    for ((i = 0; i < ${#cartasJugadores[@]}; i++)); do
        cartasJugador=${cartasJugadores[$i]}
        IFS=' ' read -ra cartasArray <<<"$cartasJugador"
        for carta in "${cartasArray[@]}"; do
            if [ "$carta" -eq "$numeroEliminar" ]; then
                jugadorTurno=$((i + 1))
                break 2
            fi
        done
    done

    cartasJugadorActual=${cartasJugadores[$((jugadorTurno - 1))]}

    IFS=' ' read -ra cartasNumeros <<<"$cartasJugadorActual"

    echo "El jugador $jugadorTurno empieza la partida"
    if [ "$jugadorTurno" -eq "1" ]; then
        jugarManualInicio
    fi
    eliminarCarta
    imprimirCartasIntro
    pasar_turno
    $jugadas = 0
    while $jugar; do
        bucleJugabilidad
        read -p "Pulse INTRO para continuar..."
        showMenu
    done

}

encontrarMinimo() {
    local min="$1"
    shift
    for num in "$@"; do
        ((num < min)) && min=$num
    done
    echo "$min"
}


encontrarMaximo() {

    local max="$1"
    shift
    for num in "$@"; do
        ((num > max)) && max=$num
    done
    echo "$max"
}



bucleJugabilidad() {

    jugadas=$((jugadas + 1))

    clear
    echo "Turno del jugador $jugadorTurno"
    cartasJugadorActual=${cartasJugadores[$((jugadorTurno - 1))]}

    IFS=' ' read -ra cartasNumeros <<<"$cartasJugadorActual"

    cartaValida=false

    maxminmesas

    if [ "$jugadorTurno" -eq "1" ]; then
        jugarManual
    else
        case "$estrategia" in
        0)
            estrategia0
            ;;
        1)
            estrategia1
            ;;
        2)
            estrategia2
            ;;
        *)
            echo "ERROR. La estrategia no es válida. Elije la estrategia [0, 1 o 2]."
            read -p "Pulse INTRO para continuar..."
            ;;
        esac
    fi

    if $cartaValida; then
        eliminarCarta
        if [ "${cartasJugadores[$((jugadorTurno - 1))]}" == "" ]; then
            tiempoFinal=$SECONDS
            elapsedTime=$((tiempoFinal - tiempoInicial))
            sumarPuntos
            echo "EL JUGADOR $jugadorTurno HA GANADO LA PARTIDA CON $puntosGanador PUNTOS!!"
            imprimirPuestos
            echo "LA PARTIDA HA DURADO $elapsedTime SEGUNDOS"
            rondas=$(echo "scale=0; $jugadas / $numJugadores" | bc)
            cargarDatosPartidaEnFicherolog
            jugar=false
        else
            pasar_turno
        fi
    else
        echo "El jugador $jugadorTurno no puede jugar ninguna carta."
        pasar_turno
        echo "Se le pasa el turno al jugador $jugadorTurno"
    fi

}

jugarManualInicio() {

    imprimirCartas
    while true; do
        read -p "Inicia la pártida con el 5 de oros: " carta
        if [[ "$carta" =~ ^5-[oO]$ ]]; then
            break
        else
            echo "Carta no válida. Por favor, elige la carta 5 de oros [5-O]."
        fi
    done

    clear
}

descomponerCarta() {
  local cartaEchar=""
  while true; do
    read -p "Por favor, ingresa una carta con el formato '[1-10]-[O, B, C o E]': " cartaEchar
    if [[ "$cartaEchar" =~ ^([1-9]|10)-[obceOBCE]$ ]]; then
      IFS="-" read -r -a partes <<< "$cartaEchar"
      letra="${partes[1]}"
      numero="${partes[0]}"
      
      case "$letra" in
        [bB])
          numero=$((numero + 30))
          ;;
        [cC])
          numero=$((numero + 10))
          ;;
        [eE])
          numero=$((numero + 20))
          ;;
      esac
      break
    else
      echo "Error: Carta no válida. Debe estar en el formato especificado."
    fi
  done
}

jugarManual() {

    imprimirCartas

    posibilidad=false
    posibilidadOros=0
    posibilidadCopas=0
    posibilidadEspadas=0
    posibilidadBastos=0

    for ((i = 0; i < ${#cartasNumeros[@]}; i++)); do
        carta="${cartasNumeros[$i]}"
        if (
            [ "$carta" -eq "$((min_mesaOros - 1))" ] || [ "$carta" -eq "$((max_mesaOros + 1))" ] ||
            ([ "$carta" -ge 11 ] && [ "$carta" -eq "$((min_mesaCopas - 1))" ] && [ "$carta" -ne 1 ]) ||
            ([ "$carta" -le 20 ] && [ "$carta" -eq "$((max_mesaCopas + 1))" ] && [ "$carta" -ge 11 ]) ||
            ([ "$carta" -ge 21 ] && [ "$carta" -eq "$((min_mesaEspadas - 1))" ]) ||
            ([ "$carta" -le 30 ] && [ "$carta" -eq "$((max_mesaEspadas + 1))" ] && [ "$carta" -ge 21 ]) ||
            ([ "$carta" -ge 31 ] && [ "$carta" -eq "$((min_mesaBastos - 1))" ]) ||
            ([ "$carta" -eq "$((max_mesaBastos + 1))" ] && [ "$carta" -ge 31 ]) || [ "$carta" -eq 15 ] || [ "$carta" -eq 25 ] || [ "$carta" -eq 35 ] || [ "$carta" -eq 5 ]
        ); then
            posibilidad=true

        fi
    done

    if $posibilidad; then
        while true; do
            descomponerCarta
            for ((i = 0; i < ${#cartasNumeros[@]}; i++)); do
                carta="${cartasNumeros[$i]}"
                if [ "$carta" -eq "$numero" ]; then
                    if (
                        [ "$carta" -eq "$((min_mesaOros - 1))" ] || [ "$carta" -eq "$((max_mesaOros + 1))" ] ||
                        ([ "$carta" -ge 11 ] && [ "$carta" -eq "$((min_mesaCopas - 1))" ] && [ "$carta" -ne 1 ]) ||
                        ([ "$carta" -le 20 ] && [ "$carta" -eq "$((max_mesaCopas + 1))" ] && [ "$carta" -ge 11 ]) ||
                        ([ "$carta" -ge 21 ] && [ "$carta" -eq "$((min_mesaEspadas - 1))" ]) ||
                        ([ "$carta" -le 30 ] && [ "$carta" -eq "$((max_mesaEspadas + 1))" ] && [ "$carta" -ge 21 ]) ||
                        ([ "$carta" -ge 31 ] && [ "$carta" -eq "$((min_mesaBastos - 1))" ]) ||
                        ([ "$carta" -eq "$((max_mesaBastos + 1))" ] && [ "$carta" -ge 31 ]) || [ "$carta" -eq 15 ] || [ "$carta" -eq 25 ] || [ "$carta" -eq 35 ] || [ "$carta" -eq 5 ]
                    ); then
                        numeroEliminar="$carta"
                        cartaValida=true
                        break
                    fi
                fi
            done

            if [ "$cartaValida" = true ]; then
                clear
                break 
            else
                echo "ERROR. La carta seleccionada no es válida. Por favor, elige una carta válida."
            fi
        done
    fi
}



estrategia0() {

    for ((i = 0; i < ${#cartasNumeros[@]}; i++)); do
        carta="${cartasNumeros[$i]}"

        if [ "$carta" -eq 15 ]; then
            
            numeroEliminar="$carta"
            cartaValida=true
            return
        fi

        if [ "$carta" -eq 25 ]; then
            numeroEliminar="$carta"
            cartaValida=true
            return
        fi

        if [ "$carta" -eq 35 ]; then
            numeroEliminar="$carta"
            cartaValida=true
            return
        fi

        if ([ "$carta" -le 10 ] && [ "$carta" -eq "$((max_mesaOros + 1))" ]) || [ "$carta" -eq "$((min_mesaOros - 1))" ]; then
            numeroEliminar="$carta"
            cartaValida=true
            return
        fi
        if [ "$carta" -eq "$((min_mesaCopas - 1))" ] || [ "$carta" -eq "$((max_mesaCopas + 1))" ]; then
            if [ "$carta" -ge 11 ] && [ "$carta" -le 20 ]; then
                numeroEliminar="$carta"
                cartaValida=true
                return
            fi
        fi
        if [ "$carta" -eq "$((min_mesaEspadas - 1))" ] || [ "$carta" -eq "$((max_mesaEspadas + 1))" ]; then
            if [ "$carta" -ge 21 ] && [ "$carta" -le 30 ]; then
                numeroEliminar="$carta"
                cartaValida=true
                return
            fi
        fi
        if [ "$carta" -eq "$((min_mesaBastos - 1))" ] || [ "$carta" -eq "$((max_mesaBastos + 1))" ]; then
            if [ "$carta" -ge 31 ] && [ "$carta" -le 40 ]; then
                numeroEliminar="$carta"
                cartaValida=true
                return
            fi
        fi
    done
}

estrategia1() {

    for ((i = 0; i < ${#cartasNumeros[@]}; i++)); do
        carta="${cartasNumeros[$i]}"

        if ([ "$carta" -le 10 ] && [ "$carta" -eq "$((max_mesaOros + 1))" ]) || [ "$carta" -eq "$((min_mesaOros - 1))" ]; then
            numeroEliminar="$carta"
            cartaValida=true
            return
        fi
        if [ "$carta" -eq "$((min_mesaCopas - 1))" ] || [ "$carta" -eq "$((max_mesaCopas + 1))" ]; then
            if [ "$carta" -ge 11 ] && [ "$carta" -le 20 ]; then
                numeroEliminar="$carta"
                cartaValida=true
                return
            fi
        fi
        if [ "$carta" -eq "$((min_mesaEspadas - 1))" ] || [ "$carta" -eq "$((max_mesaEspadas + 1))" ]; then
            if [ "$carta" -ge 21 ] && [ "$carta" -le 30 ]; then
                numeroEliminar="$carta"
                cartaValida=true
                return
            fi
        fi
        if [ "$carta" -eq "$((min_mesaBastos - 1))" ] || [ "$carta" -eq "$((max_mesaBastos + 1))" ]; then
            if [ "$carta" -ge 31 ] && [ "$carta" -le 40 ]; then
                numeroEliminar="$carta"
                cartaValida=true
                return
            fi
        fi

    done

    for ((i = 0; i < ${#cartasNumeros[@]}; i++)); do
        carta="${cartasNumeros[$i]}"
        if [ "$carta" -eq 15 ]; then
            
            numeroEliminar="$carta"
            cartaValida=true
            return
        fi

        if [ "$carta" -eq 25 ]; then
            numeroEliminar="$carta"
            cartaValida=true
            return
        fi

        if [ "$carta" -eq 35 ]; then
            numeroEliminar="$carta"
            cartaValida=true
            return
        fi
    done
}

calcularNumeroCartas() {

    numOros=0
    numCopas=0
    numEspadas=0
    numBastos=0
    maxDistanciaOros=0
    maxDistanciaCopas=0
    maxDistanciaEspadas=0
    maxDistanciaBastos=0

    for ((i = 0; i < ${#cartasNumeros[@]}; i++)); do
        carta="${cartasNumeros[$i]}"

        if [ "$carta" -ge 1 ] && [ "$carta" -le 10 ]; then
            distanciaOros=$(((carta - 5)))
            distanciaOros=${distanciaOros#-} # Valor absoluto
            if [ "$distanciaOros" -gt "$maxDistanciaOros" ]; then
                maxDistanciaOros="$distanciaOros"
            fi
        fi

        if [ "$carta" -ge 11 ] && [ "$carta" -le 20 ]; then
            distanciaCopas=$(((carta - 5)))
            distanciaCopas=${distanciaCopas#-} # Valor absoluto
            if [ "$distanciaCopas" -gt "$maxDistanciaCopas" ]; then
                maxDistanciaCopas="$distanciaCopas"
            fi
        fi

        if [ "$carta" -ge 21 ] && [ "$carta" -le 30 ]; then
            distanciaEspadas=$(((carta - 5)))
            distanciaEspadas=${distanciaEspadas#-} # Valor absoluto
            if [ "$distanciaEspadas" -gt "$maxDistanciaEspadas" ]; then
                maxDistanciaEspadas="$distanciaEspadas"
            fi
        fi

        if [ "$carta" -ge 31 ] && [ "$carta" -le 40 ]; then
            distanciaBastos=$(((carta - 5)))
            distanciaBastos=${distanciaBastos#-} # Valor absoluto
            if [ "$distanciaBastos" -gt "$maxDistanciaBastos" ]; then
                maxDistanciaBastos="$distanciaBastos"
            fi
        fi
    done

    if [ "$numOros" -gt "$numCopas" ] && [ "$numOros" -gt "$numEspadas" ] && [ "$numOros" -gt "$numBastos" ]; then
        paloMayor="Oros"
    fi
    if [ "$numCopas" -gt "$numOros" ] && [ "$numCopas" -gt "$numEspadas" ] && [ "$numCopas" -gt "$numBastos" ]; then
        paloMayor="Copas"
    fi
    if [ "$numEspadas" -gt "$numOros" ] && [ "$numEspadas" -gt "$numCopas" ] && [ "$numEspadas" -gt "$numBastos" ]; then
        paloMayor="Espadas"
    fi
    if [ "$numBastos" -gt "$numOros" ] && [ "$numBastos" -gt "$numCopas" ] && [ "$numBastos" -gt "$numEspadas" ]; then
        paloMayor="Bastos"
    fi
}

estrategia2() {

    calcularNumeroCartas

    for ((i = 0; i < ${#cartasNumeros[@]}; i++)); do
        carta="${cartasNumeros[$i]}"

        if [ "$carta" -eq 15 ] && ([ "$maxDistanciaCopas" -eq 4 ] || [ "$maxDistanciaCopas" -eq 5 ]); then
            
            numeroEliminar="$carta"
            cartaValida=true
            return
        fi

        if [ "$carta" -eq 25 ] && ([ "$maxDistanciaEspadas" -eq 4 ] || [ "$maxDistanciaEspadas" -eq 5 ]); then
            numeroEliminar="$carta"
            cartaValida=true
            return
        fi

        if [ "$carta" -eq 35 ] && ([ "$maxDistanciaBastos" -eq 4 ] || [ "$maxDistanciaBastos" -eq 5 ]); then
            numeroEliminar="$carta"
            cartaValida=true
            return
        fi

        if [ "$carta" -eq 15 ] && [ "$paloMayor" = "Copas" ]; then
            numeroEliminar="$carta"
            cartaValida=true
            return
        fi

        if [ "$carta" -eq 25 ] && [ "$paloMayor" = "Espadas" ]; then
            numeroEliminar="$carta"
            cartaValida=true
            return
        fi

        if [ "$carta" -eq 35 ] && [ "$paloMayor" = "Bastos" ]; then
            numeroEliminar="$carta"
            cartaValida=true
            return
        fi

        if ([ "$carta" -le 10 ] && [ "$carta" -eq "$((max_mesaOros + 1))" ]) || [ "$carta" -eq "$((min_mesaOros - 1))" ]; then
            numeroEliminar="$carta"
            cartaValida=true
            return
        fi
        if [ "$carta" -eq "$((min_mesaCopas - 1))" ] || [ "$carta" -eq "$((max_mesaCopas + 1))" ]; then
            if [ "$carta" -ge 11 ] && [ "$carta" -le 20 ]; then
                numeroEliminar="$carta"
                cartaValida=true
                return
            fi
        fi
        if [ "$carta" -eq "$((min_mesaEspadas - 1))" ] || [ "$carta" -eq "$((max_mesaEspadas + 1))" ]; then
            if [ "$carta" -ge 21 ] && [ "$carta" -le 30 ]; then
                numeroEliminar="$carta"
                cartaValida=true
                return
            fi
        fi
        if [ "$carta" -eq "$((min_mesaBastos - 1))" ] || [ "$carta" -eq "$((max_mesaBastos + 1))" ]; then
            if [ "$carta" -ge 31 ] && [ "$carta" -le 40 ]; then
                numeroEliminar="$carta"
                cartaValida=true
                return
            fi
        fi
    done

    for ((i = 0; i < ${#cartasNumeros[@]}; i++)); do
        carta="${cartasNumeros[$i]}"
        if [ "$carta" -eq 15 ]; then
            
            numeroEliminar="$carta"
            cartaValida=true
            return
        fi

        if [ "$carta" -eq 25 ]; then
            numeroEliminar="$carta"
            cartaValida=true
            return
        fi

        if [ "$carta" -eq 35 ]; then
            numeroEliminar="$carta"
            cartaValida=true
            return
        fi
    done
}

play() {
 
    if test -f "config.cfg"; then
        if test -r "config.cfg"; then
            lineaJugadores=$(grep "JUGADORES=" "config.cfg")
            if [ -z "$lineaJugadores" ]; then
                echo "ERROR: La variable JUGADORES no está definida en el archivo config.cfg"
                read -p "Pulse INTRO para continuar..."
                return
            fi

            numJugadores=$(echo "$lineaJugadores" | cut -d'=' -f2)

            if ! [[ $numJugadores =~ ^[2-4]$ ]]; then
                echo "ERROR: El número de jugadores debe de ser 2, 3 o 4."
                read -p "Pulse INTRO para continuar..."
                return
            fi

            lineaEstrategia=$(grep "ESTRATEGIA=" "config.cfg")
            if [ -z "$lineaEstrategia" ]; then
                echo "ERROR: La variable ESTRATEGIA no está definida en el archivo config.cfg"
            else
                estrategia=$(echo "$lineaEstrategia" | cut -d'=' -f2)
            fi
        else
            echo "ERROR: No se puede leer el archivo config.cfg."
            read -p "Pulse INTRO para salir..."
            exit
        fi
    else
        echo "ERROR: El archivo de configuración config.cfg no existe."
        read -p "Pulse INTRO para salir..."
        exit
    fi

    tiempoInicial=$SECONDS

    echo "Comenzando una partida de 5illo con $numJugadores jugadores..."
    repartirCartas
    turno

}

pasar_turno() {
    if ((jugadorTurno == numJugadores)); then
        jugadorTurno=1
    else
        jugadorTurno=$((jugadorTurno + 1))
    fi
}

decodificarCarta() {
    numero="$1"

    if ((numero >= 1 && numero <= 10)); then
        echo "$numero de oros"
    elif ((numero >= 11 && numero <= 20)); then
        echo "$((numero - 10)) de copas"
    elif ((numero >= 21 && numero <= 30)); then
        echo "$((numero - 20)) de espadas"
    elif ((numero >= 31 && numero <= 40)); then
        echo "$((numero - 30)) de bastos"
    else
        echo "Número de carta fuera de rango"
    fi
}

maxminmesas() {
    min_mesaOros=$(encontrarMinimo ${mesaOros[@]})
    max_mesaOros=$(encontrarMaximo ${mesaOros[@]})

    min_mesaCopas=$(encontrarMinimo ${mesaCopas[@]})
    max_mesaCopas=$(encontrarMaximo ${mesaCopas[@]})

    min_mesaEspadas=$(encontrarMinimo ${mesaEspadas[@]})
    max_mesaEspadas=$(encontrarMaximo ${mesaEspadas[@]})

    min_mesaBastos=$(encontrarMinimo ${mesaBastos[@]})
    max_mesaBastos=$(encontrarMaximo ${mesaBastos[@]})
}

sumarPuntos() {
    puntosGanador=0
    declare -a puntosJugadores

    for ((i = 0; i < numJugadores; i++)); do
        cartasJugador=${cartasJugadores[$i]}
        IFS=' ' read -ra cartasArray <<<"$cartasJugador"
        puntosJugadores[$i]=${#cartasArray[@]}
        for carta in "${cartasArray[@]}"; do
            puntosGanador=$((puntosGanador + 1))
        done
    done

    calcularPuesto
}

calcularPuesto() {
    declare -a puestosAsignados

    for ((i = 0; i < numJugadores; i++)); do
        puestosJugadores[$i]=1
    done

    for ((i = 0; i < numJugadores; i++)); do
        for ((j = 0; j < numJugadores; j++)); do
            if ((puntosJugadores[j] < puntosJugadores[i])); then
                puestosJugadores[i]=$((puestosJugadores[i] + 1))
            fi
        done
    done
}

imprimirPuestos() {
    echo "PUESTOS DE LOS JUGADORES:"
    declare -A puestosOrdenados

    for ((i = 0; i < numJugadores; i++)); do
        jugador="JUGADOR $((i + 1))"
        puesto="${puestosJugadores[$i]}"
        if [ -z "${puestosOrdenados[$puesto]}" ]; then
            puestosOrdenados[$puesto]="$jugador"
        else
            puestosOrdenados[$puesto]+=", $jugador"
        fi
    done

    for ((i = 1; i <= numJugadores; i++)); do
        if [ -n "${puestosOrdenados[$i]}" ]; then
            echo "TOP $i: ${puestosOrdenados[$i]}"
        fi
    done
}


calculateStatistics() {

    totalPartidas=0
    totalTiempo=0
    totalPuntos=0
    partidasGanadas1=0
    partidasGanadas2=0
    partidasGanadas3=0
    partidasGanadas4=0

    while IFS='|' read -r fecha hora jugadores tiempo rondas ganador puntos cartas; do
        totalPartidas=$((totalPartidas + 1))
        totalTiempo=$(bc -l <<<"$totalTiempo + $tiempo")
        totalPuntos=$(bc -l <<<"$totalPuntos + $puntos")

        case "$ganador" in
        1)
            partidasGanadas1=$((partidasGanadas1 + 1))
            ;;
        2)
            partidasGanadas2=$((partidasGanadas2 + 1))
            ;;
        3)
            partidasGanadas3=$((partidasGanadas3 + 1))
            ;;
        4)
            partidasGanadas4=$((partidasGanadas4 + 1))
            ;;
        esac
    done <"$1"

    mediaTiempo=$(bc -l <<<"$totalTiempo / $totalPartidas")
    mediaPuntos=$(bc -l <<<"$totalPuntos / $totalPartidas")
    porcentajeGanadas1=$(bc -l <<<"($partidasGanadas1 / $totalPartidas) * 100")
    porcentajeGanadas2=$(bc -l <<<"($partidasGanadas2 / $totalPartidas) * 100")
    porcentajeGanadas3=$(bc -l <<<"($partidasGanadas3 / $totalPartidas) * 100")
    porcentajeGanadas4=$(bc -l <<<"($partidasGanadas4 / $totalPartidas) * 100")

    echo "Número total de partidas jugadas: $totalPartidas"
    echo "Media de los tiempos de todas las partidas jugadas: $mediaTiempo"
    echo "Tiempo total invertido en todas las partidas: $totalTiempo"
    echo "Media de los puntos obtenidos por el ganador en todas las partidas: $mediaPuntos"
    echo "Porcentaje de partidas ganadas del jugador 1: $porcentajeGanadas1%"
    echo "Porcentaje de partidas ganadas del jugador 2: $porcentajeGanadas2%"
    echo "Porcentaje de partidas ganadas del jugador 3: $porcentajeGanadas3%"
    echo "Porcentaje de partidas ganadas del jugador 4: $porcentajeGanadas4%"
}

calculateLeaderboard() {
    partidaMasCorta=""
    partidaMasLarga=""
    partidaMasRondas=""
    partidaMenosRondas=""
    partidaMasPuntos=""
    partidaMasCartas=""

    duracionMinima=9999999
    duracionMaxima=0
    maxRondas=0
    minRondas=9999999
    maxPuntos=0
    maxCartas=0

    while IFS='|' read -r fecha hora jugadores tiempo rondas ganador puntos cartas; do
        if [[ "$tiempo" =~ ^[0-9]+$ ]]; then
            tiempoEntero=$tiempo
        else
            tiempoEntero=0
        fi

        if [[ "$rondas" =~ ^[0-9]+$ ]]; then
            rondasEntero=$rondas
        else
            rondasEntero=0
        fi

        if [[ "$puntos" =~ ^[0-9]+$ ]]; then
            puntosEntero=$puntos
        else
            puntosEntero=0
        fi

        cartasMax=0
        IFS="-" read -ra jugadoresCartas <<<"$cartas"
        for jugadorCartas in "${jugadoresCartas[@]}"; do
            if [[ "$jugadorCartas" != "*" && "$jugadorCartas" -gt cartasMax ]]; then
                cartasMax="$jugadorCartas"
            fi
        done

        if [ "$tiempoEntero" -lt "$duracionMinima" ]; then
            duracionMinima="$tiempoEntero"
            partidaMasCorta="$fecha|$hora|$jugadores|$tiempo|$rondas|$ganador|$puntos|$cartas"
        fi
        if [ "$tiempoEntero" -gt "$duracionMaxima" ]; then
            duracionMaxima="$tiempoEntero"
            partidaMasLarga="$fecha|$hora|$jugadores|$tiempo|$rondas|$ganador|$puntos|$cartas"
        fi

        if [ "$rondasEntero" -gt "$maxRondas" ]; then
            maxRondas="$rondasEntero"
            partidaMasRondas="$fecha|$hora|$jugadores|$tiempo|$rondas|$ganador|$puntos|$cartas"
        fi
        if [ "$rondasEntero" -lt "$minRondas" ]; then
            minRondas="$rondasEntero"
            partidaMenosRondas="$fecha|$hora|$jugadores|$tiempo|$rondas|$ganador|$puntos|$cartas"
        fi

        if [ "$puntosEntero" -gt "$maxPuntos" ]; then
            maxPuntos="$puntosEntero"
            partidaMasPuntos="$fecha|$hora|$jugadores|$tiempo|$rondas|$ganador|$puntos|$cartas"
        fi

        if [ "$cartasMax" -gt "$maxCartas" ]; then
            maxCartas="$cartasMax"
            partidaMasCartas="$fecha|$hora|$jugadores|$tiempo|$rondas|$ganador|$puntos|$cartas"
        fi
    done <"$1"

    echo "Partida más corta:"
    echo "$partidaMasCorta"
    echo ""
    echo "Partida más larga:"
    echo "$partidaMasLarga"
    echo ""
    echo "Partida con más rondas:"
    echo "$partidaMasRondas"
    echo ""
    echo "Partida con menos rondas:"
    echo "$partidaMenosRondas"
    echo ""
    echo "Partida con más puntos obtenidos por el ganador:"
    echo "$partidaMasPuntos"
    echo ""
    echo "Partida en la que un jugador se ha quedado con mayor número de cartas:"
    echo "$partidaMasCartas"
}

# Función para mostrar estadísticas
showStatistics() {
    cat <<"EOF"
███████ ███████ ████████  █████  ██████  ██ ███████ ████████ ██  ██████  █████  ███████ 
██      ██         ██    ██   ██ ██   ██ ██ ██         ██    ██ ██      ██   ██ ██      
█████   ███████    ██    ███████ ██   ██ ██ ███████    ██    ██ ██      ███████ ███████ 
██           ██    ██    ██   ██ ██   ██ ██      ██    ██    ██ ██      ██   ██      ██ 
███████ ███████    ██    ██   ██ ██████  ██ ███████    ██    ██  ██████ ██   ██ ███████ 

EOF
    leerFicheroLog
    calculateStatistics "$ficheroLog"
    read -p "Pulse INTRO para continuar..."
}

showLeaderboard() {
    cat <<"EOF"
 ██████ ██       █████  ███████ ██ ███████ ██  ██████  █████   ██████ ██  ██████  ███    ██ 
██      ██      ██   ██ ██      ██ ██      ██ ██      ██   ██ ██      ██ ██    ██ ████   ██ 
██      ██      ███████ ███████ ██ █████   ██ ██      ███████ ██      ██ ██    ██ ██ ██  ██ 
██      ██      ██   ██      ██ ██ ██      ██ ██      ██   ██ ██      ██ ██    ██ ██  ██ ██ 
 ██████ ███████ ██   ██ ███████ ██ ██      ██  ██████ ██   ██  ██████ ██  ██████  ██   ████ 
                                                                                            

EOF
    leerFicheroLog
    calculateLeaderboard "$ficheroLog"
    read -p "Pulse INTRO para continuar..."
}

# Bucle principal
while true; do
    comprobarArgumentos "$*"
    showMenu
    read option

    case $option in
    C | c)
        clear
        changeConfig
        ;;
    J | j)
        clear
        play
        ;;
    E | e)
        clear
        showStatistics
        ;;
    F | f)
        clear
        showLeaderboard
        ;;
    S | s)
        echo "Saliendo del juego..."
        exit
        ;;
    *)
        echo "Opción no válida. Por favor, elija una opción válida."
        read -p "Pulse INTRO para continuar..."
        ;;
    esac
done