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
    # Obtener el número de jugadores desde la configuración
    numJugadores=$(cat config.cfg | grep 'JUGADORES=' | cut -d'=' -f2)

    # Verificar que el número de jugadores sea válido (de 2 a 4)
    if ((numJugadores < 2 || numJugadores > 4)); then
        echo "Número de jugadores no válido."
        return
    fi

    # Calcular la cantidad de cartas por jugador
    local cartasPorJugador=$((40 / numJugadores))

    # Barajar las cartas
    barajarCartas

    cartasJugadores=()

    for ((i = 1; i <= numJugadores; i++)); do
        cartasJugadorActual=()
        for ((j = 1; j <= cartasPorJugador; j++)); do
            carta=${cartas[((i - 1) * cartasPorJugador + j - 1)]}
            cartasJugadorActual+="$carta "
        done
        cartasJugadores+=("${cartasJugadorActual[@]}")
    done

    # Imprimir las cartas de cada jugador

}

imprimirCartas(){
    for ((i=0; i<numJugadores; i++)); do
        echo "Cartas del Jugador $((i+1)): ${cartasJugadores[$i]}"
    done
}

#Funcion para elegir la persona con el carta numero "5 " y eliminar esta carta de su mano
eliminarCarta() {
    # Carta a eliminar
    cartaAEliminar="5 "

    # Iterar a través de las manos de los jugadores
    for ((i = 0; i < numJugadores; i++)); do
        mano=(${cartasJugadores[i]})
        nuevaMano=()

        # Iterar a través de las cartas en la mano del jugador actual
        for carta in "${mano[@]}"; do
            if [[ $carta != $cartaAEliminar ]]; then
                nuevaMano+=("$carta")
            fi
        done

        # Actualizar la mano del jugador sin la carta eliminada
        cartasJugadores[i]="${nuevaMano[@]}"
    done
}




# Función para jugar una partida de 5illo
jugar(){
    repartirCartas
    imprimirCartas
    eliminarCarta
    imprimirCartas
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
