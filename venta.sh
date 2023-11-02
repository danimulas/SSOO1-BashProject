#!/bin/bash

# Función para barajar las cartas
barajarCartas() {
    # Inicializar un array para las cartas
    cartas=()

    # Generar todas las cartas con números del 1 al 40
    for ((numero=1; numero<=40; numero++)); do
        cartas+=("$numero")
    done

    # Barajar el array de cartas en orden aleatorio
    cartas=($(shuf -e "${cartas[@]}"))
    #imprimir el array de cartas
    echo "Cartas barajadas: ${cartas[*]}"
}

imprimirCartasIntro(){
    read -p "Pulse INTRO para continuar..."
    for((i=1;i<=numJugadores;i++)); do
        mostrarCartasJugadorEspecifico $i
    done

    echo "--------------------------------------------------"
    echo "Mesa Oros: ${mesaOros[*]}"
    echo "Mesa Copas: ${mesaCopas[*]}"
    echo "Mesa Espadas: ${mesaEspadas[*]}"
    echo "Mesa Bastos: ${mesaBastos[*]}"
    echo "--------------------------------------------------"
}

eliminarCarta() {
    for ((i = 0; i < ${#cartasJugadores[@]}; i++)); do
    carta="${cartasJugadores[$i]}"
    if [ "$carta" == "$numeroEliminar" ]; then
        unset "cartasJugadores[$i]"
        break
    fi
    done

   
    echo "Carta eliminada: $(decodificarCarta "$numeroEliminar")" #work
    if ((numeroEliminar >= 1 && numeroEliminar <= 10)); then
        mesaOros+=("$numeroEliminar")
    elif ((numeroEliminar >= 11 && numeroEliminar <= 20)); then
        mesaCopas+=("$numeroEliminar")
    elif ((numeroEliminar >= 21 && numeroEliminar <= 30)); then
        mesaEspadas+=("$numeroEliminar")
    elif ((numeroEliminar >= 31 && numeroEliminar <= 40)); then
        mesaBastos+=("$numeroEliminar")
    fi

    mesaOros=($(echo "${mesaOros[@]}" | tr ' ' '\n' | sort -n))
    mesaCopas=($(echo "${mesaCopas[@]}" | tr ' ' '\n' | sort -n))
    mesaEspadas=($(echo "${mesaEspadas[@]}" | tr ' ' '\n' | sort -n))
    mesaBastos=($(echo "${mesaBastos[@]}" | tr ' ' '\n' | sort -n))

}

turno() {
    # Inicializa la variable Turn en 0 (ningún jugador puede jugar la carta)
    Turn=0
    numeroEliminar=5
    #buscar en el array quien tiene el 5
    for ((i = 0; i < ${#cartasJugadores[@]}; i++)); do
        carta="${cartasJugadores[$i]}"
        if [ "$carta" -eq -1 ]; then
            contador=$((contador + 1))
        fi
        if [ "$carta" -eq 5 ]; then
            Turn=$((contador + 1))
            break
        fi
    done


        echo "El jugador $Turn empieza la partida"
        eliminarCarta
        imprimirCartasIntro
        pasar_turno
        while $jugar; do
            bucle_jugabilidad
        done
}


# Función para encontrar el valor mínimo en un conjunto de números
# Función para encontrar el valor mínimo en un conjunto de números
# Función para encontrar el valor mínimo en un conjunto de números
find_min() {
    local min="$1"
    shift
    for num in "$@"; do
        ((num < min)) && min=$num
    done
    echo "$min"
}


find_max() {

    local max="$1"
    shift
    for num in "$@"; do
        ((num > max)) && max=$num
    done
    echo "$max"
}

maxminmesas(){
  # Obtener los valores mínimos y máximos de las mesas
    min_mesaOros=$(find_min ${mesaOros[@]})
    max_mesaOros=$(find_max ${mesaOros[@]})

    min_mesaCopas=$(find_min ${mesaCopas[@]})
    max_mesaCopas=$(find_max ${mesaCopas[@]})

    min_mesaEspadas=$(find_min ${mesaEspadas[@]})
    max_mesaEspadas=$(find_max ${mesaEspadas[@]})

    min_mesaBastos=$(find_min ${mesaBastos[@]})
    max_mesaBastos=$(find_max ${mesaBastos[@]})
}

bucle_jugabilidad() {
        
    carta_valida=false
    echo "--------------------------------------------------"
    echo "Turno del jugador $Turn"
    maxminmesas
    # Obtener las cartas del jugador actual
    mostrarCartasJugadorEspecifico $Turn
   # echo "Cartas del jugadors $Turn: ${jugadorCartas[*]}"

    if [ "$Turn" -eq "1" ]; then
        jugar_manual
    else
        decidircarta
    fi
    
        if $carta_valida; then
            eliminarCarta
            imprimirCartasIntro
            if [ "${#cartasJugadorActual[@]}" -eq 1 ]; then
                    echo "¡El jugador $Turn ha ganado la partida!"
                    jugar=false 
                else
                    pasar_turno
                fi
        else
            echo "El jugador $Turn no puede jugar ninguna carta."
            pasar_turno
            echo "Se le pasa el turno al jugador $Turn"
        fi
}
decidircarta(){
        echo "Cartas del jugadorD $Turn: ${jugadorCartas[*]}"
    
        # Presiona INTRO para continuar
        read -p "Pulse INTRO para continuar..."
        maxminmesas
        echo "Maximo mesa oros: $max_mesaOros MinOros: $min_mesaOros"

       for ((i = 0; i < ${#jugadorCartas[@]}; i++)); do
        carta="${jugadorCartas[$i]}"
        echo "carta: $carta"
        if [ "$carta" -eq 15 ]; then
            mesacopas=true
            numeroEliminar="$carta"
            carta_valida=true
            return
        fi

        if [ "$carta" -eq 25 ]; then
            numeroEliminar="$carta"
            carta_valida=true
            return
        fi

        if [ "$carta" -eq 35 ]; then
            numeroEliminar="$carta"
            carta_valida=true
            return
        fi

        if ([ "$carta" -le 10 ] && [ "$carta" -eq "$((max_mesaOros + 1))" ]) || [ "$carta" -eq "$((min_mesaOros - 1))" ]; then
            numeroEliminar="$carta"
            carta_valida=true
            return
        fi
        if [ "$carta" -eq "$((min_mesaCopas - 1))" ] || [ "$carta" -eq "$((max_mesaCopas + 1))" ]; then
            if [ "$carta" -ge 11 ] && [ "$carta" -le 20 ]; then
                numeroEliminar="$carta"
                carta_valida=true
                return
            fi
        fi
        if [ "$carta" -eq "$((min_mesaEspadas - 1))" ] || [ "$carta" -eq "$((max_mesaEspadas + 1))" ]; then
            if [ "$carta" -ge 21 ] && [ "$carta" -le 30 ]; then
                numeroEliminar="$carta"
                carta_valida=true
                return
            fi
        fi
        if [ "$carta" -eq "$((min_mesaBastos - 1))" ] || [ "$carta" -eq "$((max_mesaBastos + 1))" ]; then
            if [ "$carta" -ge 31 ] && [ "$carta" -le 40 ]; then
                numeroEliminar="$carta"
                carta_valida=true
                return
            fi
        fi
    done
}
jugar(){
    repartirCartas
    turno
}
pasar_turno(){
# Le pasa el turno al jugador de su derecha
    if ((Turn == numJugadores)); then
        Turn=1
    else
        Turn=$((Turn+1))
    fi
}
#Funcion para jugar desde la terminal
descomponer_carta() {
  local cartaEchar="$1"  # Carta en formato "numero-letra"
  IFS="-" read -r -a partes <<< "$cartaEchar"  # Dividir la carta usando el guion como separador
  letra="${partes[1]}"
  numero="${partes[0]}"
  case "$letra" in
    [B]) numero=$((numero + 10));;
    [C]) numero=$((numero + 20));;
    [E]) numero=$((numero + 30));;
    *) echo "Error: Letra no válida. Las opciones válidas son O, B, C y E.";;
  esac
}

jugar_manual() {
    
    echar=false
    posibilidadOros=0
    posibilidadCopas=0
    posibilidadEspadas=0
    posibilidadBastos=0

    imprimirCartasIntro
    mostrarCartasJugadorEspecifico $Turn

    for ((i = 0; i < ${#jugadorCartas[@]}; i++)); do
        carta="${jugadorCartas[$i]}"
        if (
            [ "$carta" -eq "$((min_mesaOros - 1))" ] || [ "$carta" -eq "$((max_mesaOros + 1))" ] ||
            ([ "$carta" -ge 11 ] && [ "$carta" -eq "$((min_mesaBastos - 1))" ] && [ "$carta" -ne 1 ]) ||
            ([ "$carta" -le 20 ] && [ "$carta" -eq "$((max_mesaBastos + 1))" ] && [ "$carta" -ge 11 ]) ||
            ([ "$carta" -ge 21 ] && [ "$carta" -eq "$((min_mesaCopas - 1))" ]) ||
            ([ "$carta" -le 30 ] && [ "$carta" -eq "$((max_mesaCopas + 1))" ] && [ "$carta" -ge 21 ]) ||
            ([ "$carta" -ge 31 ] && [ "$carta" -eq "$((min_mesaEspadas - 1))" ]) ||
            ([ "$carta" -eq "$((max_mesaEspadas + 1))" ] && [ "$carta" -ge 31 ]) || [ "$carta" -eq 15 ] || [ "$carta" -eq 25 ] || [ "$carta" -eq 35 ] || [ "$carta" -eq 5 ]
        ); then
            echar=true
        fi
    done

    #Imprimir las posibilidades

    if $posibilidad; then
        while true; do
            palo_valido=false

            while true; do
                read -p "Escribe la carta que quieres echar: " cartaEchar
                descomponer_carta "$cartaEchar"
                #echo "Carta: $numero"
                break                
            done

            for ((i = 0; i < ${#jugadorCartas[@]}; i++)); do
                carta="${jugadorCartas[$i]}"
                echo "Carta: $carta"
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
                        carta_valida=true
                        break
                    fi
                fi
            done

            if [ "$carta_valida" = true ]; then
                clear
                break # Carta válida, salimos del bucle while
            else
                echo "ERROR. La carta seleccionada no es válida. Por favor, elige una carta válida."
            fi
        done
    else
        echo "posibilidad false"
    fi
}

# Función para decodificar el número de carta en palo
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
repartirCartas() {
    # Calcular la cantidad de cartas por jugador
    local cartasPorJugador=$((40 / numJugadores))

    # Barajar las cartas
    barajarCartas

    flag = false
    if ((numJugadores == 3)); then
        flag = true
    fi
    # Inicializar el array de cartas de todos los jugadores
    cartasJugadores=()

    # Repartir las cartas a los jugadores
    for ((i = 0; i < 40; i++)); do
        if ((i % cartasPorJugador == 0 && i != 0)); then
            cartasJugadores+=("-1")
        fi
        cartasJugadores+=("${cartas[i]}")
    done

    # Si el flag es true, añadir la ultima carta al final del array
    if $flag; then
        cartasJugadores+=("${cartas[39]}")
    fi
    echo "Cartas de todos los jugadores: ${cartasJugadores[*]}"
}
mostrarCartasJugadorEspecifico() { #work
    local jugador=$1
    jugadorCartas=()
    local encontrado=false
    local contador=0
    local posiblejugador=false
    for carta in "${cartasJugadores[@]}"; do
       # echo "Carta: $carta"
        if [[ $carta == "-1" ]]; then
           contador=$((contador+1))
           posiblejugador=true
        else
            jugadorCartas+=("$carta")
        fi

        if((contador == jugador)); then
            encontrado=true
            break
        fi

        if($posiblejugador); then
            jugadorCartas=()
            posiblejugador=false
        fi
    done

    if ((encontrado==true)); then
        echo "Cartas del JugadorEspecifico $jugador: ${jugadorCartas[*]}"
    else
        echo "Jugador $jugador no encontrado."
    fi

}
mostrarCartasJugadorGlobal() { #not work
    local jugador=1
    local jugadorCartas=()
    local encontrado=false
    local contador=0
    local posiblejugador=false

    for carta in "${cartasJugadores[@]}"; do
        if [[ $carta == "-1" ]]; then
            contador=$((contador + 1))
            posiblejugador=true
        else
            jugadorCartas+=("$carta")
        fi

        if ((contador == jugador)); then
            encontrado=true
            if ((posiblejugador)); then
                echo "Cartas del JugadorG $jugador: ${jugadorCartas[*]}"
            fi
            jugadorCartas=()
            posiblejugador=false
        fi
    done

    if ((encontrado)); then
        echo "Cartas del JugadoGr $jugador: ${jugadorCartas[*]}"
    else
        echo "Jugador $jugador no encontrado."
    fi
}

# Función para jugar una partida de 5illo
play_game() {
   # numJugadores=$(cat config.cfg | grep 'JUGADORES=' | cut -d'=' -f2)
    numJugadores=4
    echo "Comenzando una partida de 5illo con $numJugadores jugadores..."
    jugar
    read -p "Pulse INTRO para continuar..."
}


play_game