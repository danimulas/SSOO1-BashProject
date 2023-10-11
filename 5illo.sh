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

    barajar_cartas() {
    # Definir los palos y los valores
        palos=("oros" "copas" "espadas" "bastos")
        valores=("1" "2" "3" "4" "5" "6" "7" "10" "11" "12")

        # Inicializar un array para las cartas
        cartas=()

        # Generar todas las cartas combinando palos y valores
        for palo in "${palos[@]}"; do
            for valor in "${valores[@]}"; do
                cartas+=("$valor de $palo")
            done
        done

        # Barajar el array de cartas en orden aleatorio
        cartas=($(shuf -e "${cartas[@]}"))

        # Imprimir el array de cartas en orden aleatorio
        for carta in "${cartas[@]}"; do
            echo "$carta"
        done


    }



# Función para jugar una partida de 5illo
play_game() {
    barajar_cartas

    echo "La partida ha comenzado. ¡Buena suerte!"
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

# Main loop
while true; do
    show_menu
    read option

    case $option in
        C|c)
            configure_game
            ;;
        J|j)
            play_game
            ;;
        E|e)
            show_statistics
            ;;
        F|f)
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