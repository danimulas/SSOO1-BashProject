#!/bin/bash

# Comprobar si se proporciona el argumento -g
if [ "$1" == "-g" ]; then 
    # Mostrar datos del grupo y estrategias
    echo "COMPONENTES DEL GRUPO"
    echo "[Mario Prieta Sánchez 49839758T]"
    echo "[Daniel Mulas Fajardo 70961169M]"
    echo "ESTRATEGIAS IMPLEMENTADAS"
    echo "Estrategia 1: [Descripción de la estrategia 1]"
    echo "Estrategia 2: [Descripción de la estrategia 2]"
    
    exit
fi

# Función para mostrar el menú principal
show_menu() {
    clear
    echo "C)CONFIGURACION
J)JUGAR
E)ESTADISTICAS
F)CLASIFICACION
S)SALIR"
    echo "Introduzca una opción >>"
}

# Función para cambiar la configuración
configure_game() {
    echo "Configuración actual:"
    cat config.cfg

    read -p "Nuevo número de jugadores (2-4): " jugadores
    while [[ ! $jugadores =~ ^[2-4]$ ]]; do
        read -p "Por favor, introduzca un número válido de jugadores (2-4): " jugadores
    done

    read -p "Nueva estrategia (0, 1 o 2): " estrategia
    while [[ ! $estrategia =~ ^[0-2]$ ]]; do
        read -p "Por favor, introduzca una estrategia válida (0, 1 o 2): " estrategia
    done

    read -p "Nueva ruta del archivo de log: " log
    # Asegurarse de que la ruta del archivo de log es válida
    while [[ ! -d $(dirname $log) ]]; do
        read -p "Ruta no válida. Por favor, introduzca una ruta válida para el archivo de log: " log
    done
    
    # Actualizar configuración
    echo "JUGADORES=$jugadores" > config.cfg
    echo "ESTRATEGIA=$estrategia" >> config.cfg
    echo "LOG=$log" >> config.cfg

    echo -e "\nCONFIGURACIÓN ACTUALIZADA CORRECTAMENTE"
    read -p "Pulse INTRO para continuar..."
}

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
}

# Función para repartir cartas a los jugadores
repartirCartas() {


    # Calcular la cantidad de cartas por jugador
    local cartasPorJugador=$((40/ numJugadores))

    # Barajar las cartas
    barajarCartas

    cartasJugadores=()

    mesaOros=()
    mesaCopas=()
    mesaEspadas=()
    mesaBastos=()

    for ((i = 1; i <= numJugadores; i++)); do
        #Añadir espacio inicial en el string cartasJugadorActualç
        cartasJugadorActual=" "
        for ((j = 1; j <= cartasPorJugador; j++)); do
            carta=${cartas[((i - 1) * cartasPorJugador + j - 1)]}
            cartasJugadorActual+="$carta "
        done
        cartasJugadores+=("${cartasJugadorActual[@]}")
    done    
}


imprimirCartasIntro(){
    read -p "Pulse INTRO para continuar..."
    for ((i=0; i<numJugadores; i++)); do
        echo "Cartas del Jugador $((i+1)): ${cartasJugadores[$i]}"
    done
    echo "--------------------------------------------------"
    echo "Mesa Oros: ${mesaOros[*]}"
    echo "Mesa Copas: ${mesaCopas[*]}"
    echo "Mesa Espadas: ${mesaEspadas[*]}"
    echo "Mesa Bastos: ${mesaBastos[*]}"
    echo "--------------------------------------------------"
}
imprimirCartas(){
    for ((i=0; i<numJugadores; i++)); do
        echo "Cartas del Jugador $((i+1)): ${cartasJugadores[$i]}"
    done
}

eliminarCarta() {
    for ((i = 0; i < ${#cartasJugadores[@]}; i++)); do
        cartasJugadores[$i]=$(echo "${cartasJugadores[$i]}" | awk -v numeroEliminar="$numeroEliminar" '{gsub(" "numeroEliminar" ", " "); print}')
    done
    echo "Carta eliminada: $(decodificarCarta "$numeroEliminar")"
    #imprimir cartas tras eliminar
    imprimirCartas
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
}

turno() {
    numeroEliminar=5
    pEliminar=false
    jugar=true
    for ((i = 0; i < ${#cartasJugadores[@]}; i++)); do
        cartasJugador=${cartasJugadores[$i]}
        IFS=' ' read -ra cartasArray <<< "$cartasJugador"
        for carta in "${cartasArray[@]}"; do
            if [ "$carta" -eq "$numeroEliminar" ]; then
                jugadorTurno=$((i+1))
                break 2  # Sale del bucle más externo
            fi
        done
    done

    echo "El jugador $jugadorTurno empieza la partida"
    eliminarCarta
    imprimirCartasIntro
    pasar_turno
    while $jugar; do
        bucle_jugabilidad
        read -p "Pulse INTRO para continuar..."
    done
    
    
}

# Función para encontrar el valor mínimo en un array
find_min() {
    local min="$1"
    shift
    for num in "$@"; do
        ((num < min)) && min=$num
    done
    echo "$min"
}

# Función para encontrar el valor máximo en un conjunto de números
find_max() {
    local max="$1"
    shift
    for num in "$@"; do
        ((num > max)) && max=$num
    done
    echo "$max"
}


bucle_jugabilidad() {
    echo "Turno del jugador $jugadorTurno"
    # Obtener las cartas del jugador actual
    cartasJugadorActual=${cartasJugadores[$((jugadorTurno-1))]}  

    # Presiona INTRO para continuar
    #read -p "Pulse INTRO para continuar..."

    # Convertir las cartas en un array
    IFS=' ' read -ra cartasNumeros <<< "$cartasJugadorActual"
    echo "Cartas del jugador $jugadorTurno: $cartasJugadorActual"

    # Obtener los valores mínimos y máximos de las mesas
    


    carta_valida=false

    maxminmesas
    #Imprime los maximos y minimos de las mesas
    echo "Maximo mesa oros: $max_mesaOros"
    echo "Minimo mesa oros: $min_mesaOros"
    echo "Maximo mesa copas: $max_mesaCopas"
    echo "Minimo mesa copas: $min_mesaCopas"
    echo "Maximo mesa espadas: $max_mesaEspadas"
    echo "Minimo mesa espadas: $min_mesaEspadas"
    echo "Maximo mesa bastos: $max_mesaBastos"
    echo "Minimo mesa bastos: $min_mesaBastos"

    if [ "$jugadorTurno" -eq "1" ]; then
        jugar_manual
    else
        decidirCarta
    fi
    

    if $carta_valida; then
        eliminarCarta
        #clear
        imprimirCartasIntro
         # Comprobar si el jugador se ha quedado sin cartas
        if [ "${cartasJugadores[$((jugadorTurno-1))]}" == " " ]; then
            echo "EL JUGADOR $jugadorTurno HA GANADO LA PARTIDA!!"
            jugar=false
        else
            pasar_turno
        fi
    else
        #clear
        echo "El jugador $jugadorTurno no puede jugar ninguna carta."
        pasar_turno
        echo "Se le pasa el turno al jugador $jugadorTurno"
        #read -p "Pulse INTRO para continuar..."
    fi
    
}

jugar_manual(){
    # Elegir el número de la carta que deseas jugar, si no deseas jugar ninguna carta, introduce -1

    posibilidad=false

    for ((i = 0; i < ${#cartasNumeros[@]}; i++)); do
        carta="${cartasNumeros[$i]}"
        if (
            [ "$carta" -eq "$((min_mesaOros - 1))" ] || [ "$carta" -eq "$((max_mesaOros + 1))" ] ||
            ([ "$carta" -ge 11 ] && [ "$carta" -eq "$((min_mesaCopas - 1))" ]) ||
            ([ "$carta" -le 20 ] && [ "$carta" -eq "$((max_mesaCopas + 1))" ]) ||
            ([ "$carta" -ge 21 ] && [ "$carta" -eq "$((min_mesaEspadas - 1))" ]) ||
            ([ "$carta" -le 30 ] && [ "$carta" -eq "$((max_mesaEspadas + 1))" ]) ||
            ([ "$carta" -ge 31 ] && [ "$carta" -eq "$((min_mesaBastos - 1))" ]) ||
            [ "$carta" -eq "$((max_mesaBastos + 1))" ] || [ "$carta" -eq 15 ] || [ "$carta" -eq 25 ] || [ "$carta" -eq 35 ]
        ); then
            posibilidad=true
            break
        fi
    done
    if $posibilidad; then
        read -p "Elige una carta de tu mano: " posicion
        echo "Carta elegida: $posicion"
        if [ "$posicion" -eq -1 ]; then
            pasar_turno
            echo "Se le pasa el turno al jugador $jugadorTurno"
        else
            for ((i = 0; i < ${#cartasNumeros[@]}; i++)); do
                carta="${cartasNumeros[$i]}"
                if [ "$carta" -eq "$posicion" ]; then
                    if (
                        [ "$carta" -eq "$((min_mesaOros - 1))" ] || [ "$carta" -eq "$((max_mesaOros + 1))" ] ||
                        ([ "$carta" -ge 11 ] && [ "$carta" -eq "$((min_mesaCopas - 1))" ]) ||
                        ([ "$carta" -le 20 ] && [ "$carta" -eq "$((max_mesaCopas + 1))" ]) ||
                        ([ "$carta" -ge 21 ] && [ "$carta" -eq "$((min_mesaEspadas - 1))" ]) ||
                        ([ "$carta" -le 30 ] && [ "$carta" -eq "$((max_mesaEspadas + 1))" ]) ||
                        ([ "$carta" -ge 31 ] && [ "$carta" -eq "$((min_mesaBastos - 1))" ]) ||
                        [ "$carta" -eq "$((max_mesaBastos + 1))" ] || [ "$carta" -eq 15 ] || [ "$carta" -eq 25 ] || [ "$carta" -eq 35 ]
                    ); then
                        numeroEliminar="$carta"
                        carta_valida=true
                       break
                    fi
                fi
            done
        fi
    else
         echo "El jugador $jugadorTurno no puede jugar ninguna carta."
     pasar_turno
     echo "Se le pasa el turno al jugador $jugadorTurno"
     return
    fi
}

decidirCarta(){
    for ((i = 0; i < ${#cartasNumeros[@]}; i++)); do
            carta="${cartasNumeros[$i]}"
            
            if [ "$carta" -eq 15 ]; then
                mesacopas=true
                echo "El jugador $jugadorTurno puede jugar la carta $carta."
                numeroEliminar="$carta"
                carta_valida=true
                break
            fi

            if [ "$carta" -eq 25 ]; then
                echo "El jugador $jugadorTurno puede jugar la carta $carta."
                numeroEliminar="$carta"
                carta_valida=true
                break
            fi

            if [ "$carta" -eq 35 ]; then
            echo "El jugador $jugadorTurno puede jugar la carta $carta."
                numeroEliminar="$carta"
                carta_valida=true
                break
            fi

            if ( [ "$carta" -le 10 ] && [ "$carta" -eq "$((max_mesaOros + 1))" ] )|| [ "$carta" -eq "$((min_mesaOros - 1))" ] ; then
                echo "El jugador $jugadorTurno puede jugar la carta $carta."
                numeroEliminar="$carta"
                carta_valida=true
                break
            fi
            if [ "$carta" -eq "$((min_mesaCopas - 1))" ] || [ "$carta" -eq "$((max_mesaCopas + 1))" ]; then
                if [ "$carta" -ge 11 ] && [ "$carta" -le 20 ]; then
                    echo "El jugador $jugadorTurno puede jugar la carta $carta."
                    numeroEliminar="$carta"
                    carta_valida=true
                    break
                fi
            fi
            if [ "$carta" -eq "$((min_mesaEspadas - 1))" ] || [ "$carta" -eq "$((max_mesaEspadas + 1))" ]; then
                if [ "$carta" -ge 21 ] && [ "$carta" -le 30 ]; then
                    echo "El jugador $jugadorTurno puede jugar la carta $carta."
                    numeroEliminar="$carta"
                    carta_valida=true
                    break
                fi
            fi
            if [ "$carta" -eq "$((min_mesaBastos - 1))" ] || [ "$carta" -eq "$((max_mesaBastos + 1))" ]; then
                if [ "$carta" -ge 31 ] && [ "$carta" -le 40 ]; then
                    echo "El jugador $jugadorTurno puede jugar la carta $carta."
                    numeroEliminar="$carta"
                    carta_valida=true
                    break
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
    if ((jugadorTurno == numJugadores)); then
        jugadorTurno=1
    else
        jugadorTurno=$((jugadorTurno+1))
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

# Función para jugar una partida de 5illo
play_game() {
    numJugadores=$(cat config.cfg | grep 'JUGADORES=' | cut -d'=' -f2)
    echo "Comenzando una partida de 5illo con $numJugadores jugadores..."
    jugar
    read -p "Pulse INTRO para continuar..."
}

# Función para mostrar estadísticas
show_statistics() {
    # Implementa la lógica para mostrar estadísticas aquí
    echo "Función para mostrar estadísticas (pendiente de implementar)."
    read -p "Pulse INTRO para continuar..."
}

# Función para mostrar clasificación
show_leaderboard() {
    # Implementa la lógica para mostrar la clasificación aquí
    echo "Función para mostrar la clasificación (pendiente de implementar)."
    read -p "Pulse INTRO para continuar..."
}

# Bucle principal
while true; do
    show_menu
    read option

    case $option in
        C|c)
            clear
            configure_game
            ;;
        J|j)
            clear
            play_game
            ;;
        E|e)
            clear
            show_statistics
            ;;
        F|f)
            clear
            show_leaderboard
            ;;
        S|s)
            echo "Saliendo del juego. ¡Hasta luego!"
            exit
            ;;
        *)
            echo "Opción no válida. Por favor, elija una opción válida."
            read -p "Pulse INTRO para continuar..."
            ;;
    esac
done
