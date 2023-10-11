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
S)SALIR
“5illo”. Introduzca una opción >>"
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

    barajarCartas() {
    # Inicializar un array para las cartas
    cartas=()

    # Generar todas las cartas con números del 1 al 40
    for ((numero=1; numero<=40; numero++)); do
        cartas+=("$numero")
    done

    # Barajar el array de cartas en orden aleatorio
    cartas=($(shuf -e "${cartas[@]}"))

    # Imprimir el array de cartas en orden aleatorio
    #for carta in "${cartas[@]}"; do
    #    echo "$carta"
    #done
}

repartirCartas() {
    local cartasPorJugador=$((40 / numJugadores))  # Calcular la cantidad de cartas por jugador

    # Verificar que el número de jugadores sea válido (de 1 a 10)
    if ((numJugadores < 2 || numJugadores > 4)); then
        echo "Número de jugadores no válido."
        return
    fi

    # Barajar las cartas
    barajarCartas

    local cartasRepartidas=()  # Inicializar un array para las cartas repartidas a cada jugador

    # Repartir las cartas a los jugadores
    for ((i = 1; i <= numJugadores; i++)); do
        cartasPorJugadorActual=()
        for ((j = 1; j <= cartasPorJugador; j++)); do
            carta=${cartas[((i - 1) * cartasPorJugador + j - 1)]}
            cartasPorJugadorActual+=("$carta")
        done
        cartasRepartidas+=("${cartasPorJugadorActual[@]}")
    done

    # Devolver el array de cartas repartidas
    echo "${cartasRepartidas[@]}"
}


# Funcion para que se juegue con el array creado, y que se vaya eliminando la carta que se ha jugado, la carta
# que se ha jugado se añade a un nuevo array denominado mesa y se va eliminando del array de cartas de cada jugador
# un jugador solo puede echar una carta si es 5, 15, 25 o 35, si no es así, puede echar una carta que sea inmediatamente
# superior o inferior a la que está en la mesa, si no tiene ninguna carta que cumpla esta condición, se le pasa el turno
# el orden del juego es el siguiente: jugador con carta 5, jugador siguiente, jugador siguiente, jugador siguiente, jugador siguiente...

jugar(){
    local cartasPorJugador=$((40 / numJugadores))
    cartasRepartidas=($(repartirCartas))
    for ((i = 0; i < ${#cartasRepartidas[@]}; i++)); do
        if [[ ${cartasRepartidas[i]} == "5" ]]; then
            jugador=$((i / cartasPorJugador + 1))
            echo "El jugador que tiene la carta número 5 y debe sacar es el Jugador $jugador."
            return
        fi
    done
    echo "Ningún jugador tiene la carta número 5."

    # El jugador con la carta número 5 es el primero en jugar, entonces pone la carta en la mesa y se elimina del array de cartas del jugador


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



# Función para jugar una partida de 5illo
play_game() {
    numJugadores=$(cat config.cfg | grep 'JUGADORES=' | cut -d'=' -f2)
    #barajarCartas
    #echo "Decodificando cartas:"
    determinarJugadorConCartaNumero5
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
    read -p "Pulse INTRO para continuar..."
}

# Main loop
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