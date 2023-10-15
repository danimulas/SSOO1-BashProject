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
    #imprimir el array de cartas
    echo "Cartas barajadas: ${cartas[*]}"
}

# Función para repartir cartas a los jugadores
repartirCartas() {

    # Calcular la cantidad de cartas por jugador
    local cartasPorJugador=$((40 / numJugadores))

    # Barajar las cartas
    barajarCartas

    cartasjugador1=()
    cartasjugador2=()

    mesaOros=()
    mesaCopas=()
    mesaEspadas=()
    mesaBastos=()
    #si los numJugadores son 3
    if [ "$numJugadores" -eq 3 ]; then
        cartasjugador3=()
        for ((i = 1; i <= cartasPorJugador; i++)); do
            cartasjugador1+=("${cartas[$((i-1))]}")
            cartasjugador2+=("${cartas[$((i+cartasPorJugador-1))]}")
            cartasjugador3+=("${cartas[$((i+cartasPorJugador*2-1))]}")
        done
    #si los jugadores son 4
    elif [ "$numJugadores" -eq 4 ]; then
        cartasjugador3=()
        cartasjugador4=()
        for ((i = 1; i <= cartasPorJugador; i++)); do
            cartasjugador1+=("${cartas[$((i-1))]}")
            cartasjugador2+=("${cartas[$((i+cartasPorJugador-1))]}")
            cartasjugador3+=("${cartas[$((i+cartasPorJugador*2-1))]}")
            cartasjugador4+=("${cartas[$((i+cartasPorJugador*3-1))]}")
        done
    #si los jugadores son 2
    else
        for ((i = 1; i <= cartasPorJugador; i++)); do
            cartasjugador1+=("${cartas[$((i-1))]}")
            cartasjugador2+=("${cartas[$((i+cartasPorJugador-1))]}")
        done
    fi

}


imprimirCartasIntro(){
    read -p "Pulse INTRO para continuar..."
    echo "Cartas del Jugador 1: ${cartasjugador1[*]}"
    echo "Cartas del Jugador 2: ${cartasjugador2[*]}"
    echo "Cartas del Jugador 3: ${cartasjugador3[*]}"
    echo "Cartas del Jugador 4: ${cartasjugador4[*]}"
    echo "--------------------------------------------------"
    echo "Mesa Oros: ${mesaOros[*]}"
    echo "Mesa Copas: ${mesaCopas[*]}"
    echo "Mesa Espadas: ${mesaEspadas[*]}"
    echo "Mesa Bastos: ${mesaBastos[*]}"
    echo "--------------------------------------------------"
}
imprimirCartas(){
    echo "Cartas del Jugador 1: ${cartasjugador1[*]}"
    echo "Cartas del Jugador 2: ${cartasjugador2[*]}"
    echo "Cartas del Jugador 3: ${cartasjugador3[*]}"
    echo "Cartas del Jugador 4: ${cartasjugador4[*]}"
}

eliminarCarta() {
    for ((i = 0; i < ${#cartasjugador1[@]}; i++)); do
        if [ "${cartasjugador1[$i]}" -eq "$numeroEliminar" ]; then
            unset "cartasjugador1[$i]"
            cartasjugador1=("${cartasjugador1[@]}")  # Reindexar el arreglo
            break
        fi
    done

    for ((i = 0; i < ${#cartasjugador2[@]}; i++)); do
        if [ "${cartasjugador2[$i]}" -eq "$numeroEliminar" ]; then
            unset "cartasjugador2[$i]"
            cartasjugador2=("${cartasjugador2[@]}")  # Reindexar el arreglo
            break
        fi
    done

    for ((i = 0; i < ${#cartasjugador3[@]}; i++)); do
        if [ "${cartasjugador3[$i]}" -eq "$numeroEliminar" ]; then
            unset "cartasjugador3[$i]"
            cartasjugador3=("${cartasjugador3[@]}")  # Reindexar el arreglo
            break
        fi
    done

    for ((i = 0; i < ${#cartasjugador4[@]}; i++)); do
        if [ "${cartasjugador4[$i]}" -eq "$numeroEliminar" ]; then
            unset "cartasjugador4[$i]"
            cartasjugador4=("${cartasjugador4[@]}")  # Reindexar el arreglo
            break
        fi
    done

    echo "Carta eliminada: $(decodificarCarta "$numeroEliminar")"

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
    # Inicializa la variable jugadorTurno en 0 (ningún jugador puede jugar la carta)
    jugadorTurno=0
    numeroEliminar=5
    pEliminar=false
    jugar=true

    for ((i = 0; i < ${#cartasjugador1[@]}; i++)); do
        carta=${cartasjugador1[$i]}
        if [ "$carta" -eq "$numeroEliminar" ]; then
            jugadorTurno=1
            break
        fi
    done

    for ((i = 0; i < ${#cartasjugador2[@]}; i++)); do
        carta=${cartasjugador2[$i]}
        if [ "$carta" -eq "$numeroEliminar" ]; then
            jugadorTurno=2
            break
        fi
    done

    for ((i = 0; i < ${#cartasjugador3[@]}; i++)); do
        carta=${cartasjugador3[$i]}
        if [ "$carta" -eq "$numeroEliminar" ]; then
            jugadorTurno=3
            break
        fi
    done

    for ((i = 0; i < ${#cartasjugador4[@]}; i++)); do
        carta=${cartasjugador4[$i]}
        if [ "$carta" -eq "$numeroEliminar" ]; then
            jugadorTurno=4
            break
        fi
    done

        echo "El jugador $jugadorTurno empieza la partida"
        eliminarCarta
        imprimirCartasIntro
        pasar_turno
        mesacopas=false
        mesaespadas=false
        mesabastos=false
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

# Función para encontrar el valor máximo en un conjunto de números
find_max() {
    local max="5"
    shift
    for num in "$@"; do
        ((num > max)) && max=$num
    done
    echo "$max"
}

# Función para convertir los valores en una cadena de cartas a números
convertir_a_numeros() {
    local cartas=("${!1}")
    local cartasNumeros=()
    for carta in "${cartas[@]}"; do
        cartasNumeros+=("$((carta + 0))")
    done
    echo "${cartasNumeros[@]}"
}
maxminmesas(){
  # Obtener los valores mínimos y máximos de las mesas
    min_mesaOros=$(find_min ${mesaOrosNumeros[@]})
    max_mesaOros=$(find_max ${mesaOrosNumeros[@]})

    min_mesaCopas=$(find_min ${mesaCopasNumeros[@]})
    max_mesaCopas=$(find_max ${mesaCopasNumeros[@]})

    min_mesaEspadas=$(find_min ${mesaEspadasNumeros[@]})
    max_mesaEspadas=$(find_max ${mesaEspadasNumeros[@]})

    min_mesaBastos=$(find_min ${mesaBastosNumeros[@]})
    max_mesaBastos=$(find_max ${mesaBastosNumeros[@]})
}
convertir(){
    # Convertir las cartas en un array
    cartasArrayActual=("${cartasJugadorActual[@]}")
    # Convertir los valores de las cartas a números
    cartasNumeros=($(convertir_a_numeros cartasArrayActual[@]))

    # Convertir los valores en los arrays de la mesa a números
    mesaOrosNumeros=($(convertir_a_numeros mesaOros[@]))
    mesaCopasNumeros=($(convertir_a_numeros mesaCopas[@]))
    mesaEspadasNumeros=($(convertir_a_numeros mesaEspadas[@]))
    mesaBastosNumeros=($(convertir_a_numeros mesaBastos[@]))
}
bucle_jugabilidad() {
        
    carta_valida=false
    echo "Turno del jugador $jugadorTurno"
    convertir
    maxminmesas
    # Obtener las cartas del jugador actual
    cartasJugadorActual=()
    
    if [ "$jugadorTurno" -eq "1" ]; then
        cartasJugadorActual=("${cartasjugador1[@]}")
        #echo "Cartas del jugador $jugadorTurno: ${cartasJugadorActual[*]}"
        jugar_manual
    elif [ "$jugadorTurno" -eq "2" ]; then
        cartasJugadorActual=("${cartasjugador2[@]}")
        echo "LE TOCA AL 2"
    elif [ "$jugadorTurno" -eq "3" ]; then
        cartasJugadorActual=("${cartasjugador3[@]}")

        echo "LE TOCA AL 3"
    elif [ "$jugadorTurno" -eq "4" ]; then
        cartasJugadorActual=("${cartasjugador4[@]}")
        echo "LE TOCA AL 4"
    fi

    if [ "$jugadorTurno" -ne "1" ]; then
        decidircarta
    fi
        if $carta_valida; then
            eliminarCarta
            imprimirCartasIntro
            if [ "${#cartasJugadorActual[@]}" -eq 1 ]; then
                    echo "¡El jugador $jugadorTurno ha ganado la partida!"
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
decidircarta(){
        echo "Cartas del jugador $jugadorTurno: ${cartasJugadorActual[*]}"
    
        # Presiona INTRO para continuar
        read -p "Pulse INTRO para continuar..."
        convertir
        maxminmesas
        
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
    imprimirCartasIntro
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
#Funcion para jugar desde la terminal
jugar_manual(){
    #Elegir el numero del array que quieres hechar
    #DEBERIAMOS HACER ESTO YA QUE ES OBLIGATORIO HECHAR SI TIENES PERO DE MOMENTO HE PROBADO ESTO Y NO VA
    posibilidad=false
    for ((i = 0; i < ${#cartasJugadorActual[@]}; i++)); do
                carta="${cartasJugadorActual[$i]}"
         if (
        [ "$carta" -eq "$((min_mesaOros - 1))" ] || [ "$carta" -eq "$((max_mesaOros + 1))" ] ||
        [ "$carta" -ge 11 ] && [ "$carta" -eq "$((min_mesaCopas - 1))" ] ||
        [ "$carta" -le 20 ] && [ "$carta" -eq "$((max_mesaCopas + 1))" ] ||
        [ "$carta" -ge 21 ] && [ "$carta" -eq "$((min_mesaEspadas - 1))" ] ||
        [ "$carta" -le 30 ] && [ "$carta" -eq "$((max_mesaEspadas + 1))" ] ||
        [ "$carta" -ge 31 ] && [ "$carta" -eq "$((min_mesaBastos - 1))" ] ||
        [ "$carta" -eq "$((max_mesaBastos + 1))" ]|| [ "$carta" -eq 15 ] || [ "$carta" -eq 25 ] || [ "$carta" -eq 35 ]
        ); then
            posibilidad=true
            break
        fi
    done
    if $posibilidad; then
        echo "Elige la carta que quieres hechar, si no quieres hechar ninguna carta introduce -1" #ESTO DE NO INTRODUCIR NO VALE
        read -p "Elige una carta de tu mano: " posicion
        if [ "$posicion" -eq -1 ]; then
            pasar_turno
            echo "Se le pasa el turno al jugador $jugadorTurno"
        else
            for ((i = 0; i < ${#cartasJugadorActual[@]}; i++)); do
                carta="${cartasJugadorActual[$i]}"
                echo "Carta elegida: $posicion carta: ${cartasJugadorActual[$i]}"
                if [ "$carta" -eq "$posicion" ]; then
                    echo "La carta $carta es igual a $posicion"
                    # if [ "$carta" -eq "$((min_mesaOros - 1))" ] || ( [ "$carta" -le 10 ] && [ "$carta" -eq "$((max_mesaOros + 1))" ] ) || [ "$carta" -ge 11 ] && [ "$carta" -eq "$((min_mesaCopas - 1))" ] || [ "$carta" -le 20 ] && [ "$carta" -eq "$((max_mesaCopas + 1))" ] || [ "$carta" -ge 21 ] && [ "$carta" -eq "$((min_mesaEspadas - 1))" ] || [ "$carta" -le 30 ] && [ "$carta" -eq "$((max_mesaEspadas + 1))" ] || [ "$carta" -ge 31 ] && [ "$carta" -eq "$((min_mesaBastos - 1))" ] || [ "$carta" -eq "$((max_mesaBastos + 1))" ]; then
                        echo "Has elegido la carta: $carta"
                        numeroEliminar="$carta"
                        carta_valida=true
                    #   break
                    #fi
            #  else
                #  echo "La carta $i no es valida"
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
