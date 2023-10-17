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
    echo "Introduzca una opción >>"
}

# Función para cambiar la configuración
configure_game() {
    echo "Configuración actual:"
    cat config.cfg
    log_directory="log"  # Directorio fijo llamado "log"

    read -p "Nuevo número de jugadores (2-4): " jugadores
    while [[ ! $jugadores =~ ^[2-4]$ ]]; do
        read -p "Por favor, introduzca un número válido de jugadores (2-4): " jugadores
    done

    read -p "Nueva estrategia (0, 1 o 2): " estrategia
    while [[ ! $estrategia =~ ^[0-2]$ ]]; do
        read -p "Por favor, introduzca una estrategia válida (0, 1 o 2): " estrategia
    done

    read -p "Nombre del archivo de log (sin la extensión .log): " log_filename

    # Ruta completa del archivo de log
    log_file="$log_directory/$log_filename.log"

    # Actualizar configuración
    echo "JUGADORES=$jugadores" > config.cfg
    echo "ESTRATEGIA=$estrategia" >> config.cfg
    echo "LOG=$log_file" >> config.cfg

    echo -e "Fecha|Hora|Jugadores|TiempoTotal|Ganador|Puntos\n" > "$log_file"


    echo -e "\nCONFIGURACIÓN ACTUALIZADA CORRECTAMENTE"
    read -p "Pulse INTRO para continuar..."
}

# Función para barajar las cartas
barajarCartas() {
    # Inicializar un array para las cartas
    cartas=()

    # Generar todas las cartas con números del 1 al 40
    for ((numero=1; numero<=10; numero++)); do
        cartas+=("$numero")
    done

    # Barajar el array de cartas en orden aleatorio
    cartas=($(shuf -e "${cartas[@]}"))
}

# Función para repartir cartas a los jugadores
repartirCartas() {

    # Calcular la cantidad de cartas por jugador
    local cartasPorJugador=$((10 / numJugadores))
    local cartasExtras=$((10 % numJugadores)) 

    barajarCartas

    cartasJugadores=()

    mesaOros=()
    mesaCopas=()
    mesaEspadas=()
    mesaBastos=()

    for ((i = 1; i <= numJugadores; i++)); do
        cartasJugadorActual=" "

        if ((i <= cartasExtras)); then
            cartasRepartir=$((cartasPorJugador + 1))
        else
            cartasRepartir=$cartasPorJugador
        fi

        for ((j = 1; j <= cartasRepartir; j++)); do
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
    echo "--------------------------------------------------"
    echo "Mesa Oros: ${mesaOros[*]}"
    echo "Mesa Copas: ${mesaCopas[*]}"
    echo "Mesa Espadas: ${mesaEspadas[*]}"
    echo "Mesa Bastos: ${mesaBastos[*]}"
    echo "--------------------------------------------------"
}

eliminarCarta() {
    for ((i = 0; i < ${#cartasJugadores[@]}; i++)); do
        cartasJugadores[$i]=$(echo "${cartasJugadores[$i]}" | awk -v numeroEliminar="$numeroEliminar" '{gsub(" "numeroEliminar" ", " "); print}')
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
        IFS=' ' read -ra cartasArray <<< "$cartasJugador"
        for carta in "${cartasArray[@]}"; do
            if [ "$carta" -eq "$numeroEliminar" ]; then
                jugadorTurno=$((i+1))
                break 2  # Sale del bucle más externo
            fi
        done
    done

    cartasJugadorActual=${cartasJugadores[$((jugadorTurno-1))]}  

    # Convertir las cartas en un array
    IFS=' ' read -ra cartasNumeros <<< "$cartasJugadorActual"

    echo "El jugador $jugadorTurno empieza la partida"
    if [ "$jugadorTurno" -eq "1" ]; then
        jugarManualInicio
    fi
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
    clear
    echo "Turno del jugador $jugadorTurno"
    # Obtener las cartas del jugador actual
    cartasJugadorActual=${cartasJugadores[$((jugadorTurno-1))]}  

    IFS=' ' read -ra cartasNumeros <<< "$cartasJugadorActual"

    carta_valida=false

    maxminmesas

    if [ "$jugadorTurno" -eq "1" ]; then
        jugar_manual
    else
        decidirCarta
    fi
    

    if $carta_valida; then
        eliminarCarta
        if [ "${cartasJugadores[$((jugadorTurno-1))]}" == " " ]; then
            end_time=$(date +%s.%N)
            elapsed_time=$(awk -v st="$start_time" -v et="$end_time" 'BEGIN { printf "%.6f", et - st }')
            echo "Tiempo transcurrido: $elapsed_time segundos"
            echo "EL JUGADOR $jugadorTurno HA GANADO LA PARTIDA!!"
            sumarPuntos
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

jugarManualInicio(){

    imprimirCartas
    while true; do
        read -p "Elige una carta de tu mano: " posicion
        carta_valida=false

        for ((i = 0; i < ${#cartasNumeros[@]}; i++)); do
            carta="${cartasNumeros[$i]}"
            if [ "$carta" -eq "$posicion" ]; then
                if ([ "$carta" -eq 5 ]); then
                    numeroEliminar="$carta"
                    carta_valida=true
                    break
                fi
            fi
        done

        if [ "$carta_valida" = true ]; then
            clear
            break  # Carta válida, salimos del bucle while
        else
            echo "La carta seleccionada no es válida. Por favor, elige una carta válida."
        fi
    done

}

jugar_manual(){

    imprimirCartas

    posibilidad=false
   
    for ((i = 0; i < ${#cartasNumeros[@]}; i++)); do
        carta="${cartasNumeros[$i]}"
        if (
            [ "$carta" -eq "$((min_mesaOros - 1))" ] || [ "$carta" -eq "$((max_mesaOros + 1))" ] ||
            ([ "$carta" -ge 11 ] && [ "$carta" -eq "$((min_mesaCopas - 1))" ] && [ "$carta" -ne 1 ])||
            ([ "$carta" -le 20 ] && [ "$carta" -eq "$((max_mesaCopas + 1))" ] && [ "$carta" -ne 1 ])||
            ([ "$carta" -ge 21 ] && [ "$carta" -eq "$((min_mesaEspadas - 1))" ] && [ "$carta" -ne 1 ])||
            ([ "$carta" -le 30 ] && [ "$carta" -eq "$((max_mesaEspadas + 1))" ] && [ "$carta" -ne 1 ])||
            ([ "$carta" -ge 31 ] && [ "$carta" -eq "$((min_mesaBastos - 1))" ] && [ "$carta" -ne 1 ])||
            ([ "$carta" -eq "$((max_mesaBastos + 1))" ] && [ "$carta" -ne 1 ])|| [ "$carta" -eq 15 ] || [ "$carta" -eq 25 ] || [ "$carta" -eq 35 ] || [ "$carta" -eq 5 ]
        ); then
            posibilidad=true
            break
        fi
    done
    if $posibilidad; then
        while true; do
        read -p "Elige una carta de tu mano: " posicion
        carta_valida=false

        for ((i = 0; i < ${#cartasNumeros[@]}; i++)); do
            carta="${cartasNumeros[$i]}"
            if [ "$carta" -eq "$posicion" ]; then
                if (
                    [ "$carta" -eq "$((min_mesaOros - 1))" ] || [ "$carta" -eq "$((max_mesaOros + 1))" ] ||
                    ([ "$carta" -ge 11 ] && [ "$carta" -eq "$((min_mesaCopas - 1))" ] && [ "$carta" -ne 1 ])||
                    ([ "$carta" -le 20 ] && [ "$carta" -eq "$((max_mesaCopas + 1))" ] && [ "$carta" -ge 11 ])||
                    ([ "$carta" -ge 21 ] && [ "$carta" -eq "$((min_mesaEspadas - 1))" ])||
                    ([ "$carta" -le 30 ] && [ "$carta" -eq "$((max_mesaEspadas + 1))" ] && [ "$carta" -ge 21 ])||
                    ([ "$carta" -ge 31 ] && [ "$carta" -eq "$((min_mesaBastos - 1))" ])||
                    ([ "$carta" -eq "$((max_mesaBastos + 1))" ] && [ "$carta" -ge 31 ])|| [ "$carta" -eq 15 ] || [ "$carta" -eq 25 ] || [ "$carta" -eq 35 ] || [ "$carta" -eq 5 ]
                ); then
                    numeroEliminar="$carta"
                    carta_valida=true
                    break
                fi
            fi
        done

        if [ "$carta_valida" = true ]; then
            clear
            break  # Carta válida, salimos del bucle while
        else
            echo "La carta seleccionada no es válida. Por favor, elige una carta válida."
        fi
    done

    fi
}

decidirCarta(){
    for ((i = 0; i < ${#cartasNumeros[@]}; i++)); do
            carta="${cartasNumeros[$i]}"
            
            if [ "$carta" -eq 15 ]; then
                mesacopas=true
                numeroEliminar="$carta"
                carta_valida=true
                break
            fi

            if [ "$carta" -eq 25 ]; then
                numeroEliminar="$carta"
                carta_valida=true
                break
            fi

            if [ "$carta" -eq 35 ]; then
                numeroEliminar="$carta"
                carta_valida=true
                break
            fi

            if ( [ "$carta" -le 10 ] && [ "$carta" -eq "$((max_mesaOros + 1))" ] )|| [ "$carta" -eq "$((min_mesaOros - 1))" ] ; then
                numeroEliminar="$carta"
                carta_valida=true
                break
            fi
            if [ "$carta" -eq "$((min_mesaCopas - 1))" ] || [ "$carta" -eq "$((max_mesaCopas + 1))" ]; then
                if [ "$carta" -ge 11 ] && [ "$carta" -le 20 ]; then
                    numeroEliminar="$carta"
                    carta_valida=true
                    break
                fi
            fi
            if [ "$carta" -eq "$((min_mesaEspadas - 1))" ] || [ "$carta" -eq "$((max_mesaEspadas + 1))" ]; then
                if [ "$carta" -ge 21 ] && [ "$carta" -le 30 ]; then
                    numeroEliminar="$carta"
                    carta_valida=true
                    break
                fi
            fi
            if [ "$carta" -eq "$((min_mesaBastos - 1))" ] || [ "$carta" -eq "$((max_mesaBastos + 1))" ]; then
                if [ "$carta" -ge 31 ] && [ "$carta" -le 40 ]; then
                    numeroEliminar="$carta"
                    carta_valida=true
                    break
                fi
            fi
        done
}
jugar(){
    start_time=$(date +%s.%N)
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

#Funcion que sume el numero de cartas que tienen los jugadores que no han ganado
sumarPuntos(){
    #recorrer el array de cartas de los jugadores, por cada carta que tenga el jugador sumar 1 punto
    PUNTOS_PARTIDA_FINAL=0
    for ((i=0; i<numJugadores; i++)); do
        cartasJugador=${cartasJugadores[$i]}
        IFS=' ' read -ra cartasArray <<< "$cartasJugador"
        for carta in "${cartasArray[@]}"; do
            PUNTOS_PARTIDA_FINAL=$((PUNTOS_PARTIDA_FINAL+1))
        done
    done
}



cargarDatosPartidaEnFicherolog(){

    # Fecha|Hora|Jugadores|TiempoTotal|Ganador|Puntos
    #Buscar en config.cfg el LOG
    if [ -f "config.cfg" ]; then
        # Leer la configuración del archivo config.cfg
        source "config.cfg"
        # Verificar si la variable LOG está definida en la configuración
        if [ -n "$LOG" ]; then
            log_file="$LOG"
        else
            echo "ERROR: La variable LOG no está definida en el archivo config.cfg"
        fi
    fi
    # Obtener la fecha y hora actual
    fecha_actual=$(date +"%d/%m/%y")
    hora_actual=$(date +"%H:%M")


    # Imprimir los datos en el archivo de registro en el formato deseado
    echo -e "$fecha_actual|$hora_actual|$numJugadores|$elapsed_time|$jugadorTurno\n" >> "$log_file"
    #Imprimir las cartas restantes de los jugadores y si no han jugado pones un * es decir JUGADOR1|JUGADOR2|JUGADOR3|JUGADOR4
    echo -n "Cartas Jugadores: " >> "$log_file"

    for ((i=0; i<$jugadores; i++)); do
        cartasJugador=${cartasJugadores[$i]}
        IFS=' ' read -ra cartasArray <<< "$cartasJugador"
            echo -n "${cartasJugadores[$i]}|" >> "$log_file"
    done
    for((i=1; i<4-$jugadores; i++)); do
        echo -n "*|" >> "$log_file"
    done

    read -p "Pulse INTRO para continuar..."
    show_menu



}
esta
mostrarEstadisticas(){
    if test -r $FICHEROLOG
    then
        mostrarTextoEstadisticas

        # -s -> existe y tiene tamaño mayor que cero
        if ! [[ -s $FICHEROLOG ]]
        then
            echo -e "El registro de partidas está vacío, inicia un juego para mostrar resultados."
        else
            PARTIDAS_JUGADAS_TOTAL=0   
            MEDIA_TIEMPOS=0
            TIEMPO_TOTAL=0

            TIEMPO_TOTAL_PART_JUGADAS=0
            PORCENTAJE=0

            declare -a SUMA_PUNTOS

            for line in $(cat $FICHEROLOG)
            do
                let PARTIDAS_JUGADAS_TOTAL=$PARTIDAS_JUGADAS_TOTAL+1

                # Sumatorio puntos maximos de las partidas
                PUNTOS_TEMP=$( echo $line | cut -f 7 -d "|")
                let MEDIA_PUNTOS_GANADORES=$MEDIA_PUNTOS_GANADORES+$PUNTOS_TEMP

                # Sumatorio rondas jugadas de las partidas
                RONDAS_TEMP=$( echo $line | cut -f 5 -d "|")
                let MEDIA_RONDAS_JUGADAS=$MEDIA_RONDAS_JUGADAS+$RONDAS_TEMP

                # Sumatorio tiempo partidas jugadas
                TIEMPO_TEMP=$( echo $line | cut -f 4 -d "|")
                let MEDIA_TIEMPOS_PART_JUGADAS=$MEDIA_TIEMPOS_PART_JUGADAS+$TIEMPO_TEMP
                let TIEMPO_TOTAL_PART_JUGADAS=$TIEMPO_TOTAL_PART_JUGADAS+$TIEMPO_TEMP

                # Sumatorio inteligencia partidas
                INTELIGENCIA_TEMP=$( echo $line | cut -f 6 -d "|")
                if [[ $INTELIGENCIA_TEMP = "1" ]]
                then
                    let PORCENTAJE=$PORCENTAJE+1
                fi

                # Sumatorio puntos de todos los jugadores
                PUNTOS_TEMP=$( echo $line | cut -f 9 -d "|")
                SUMA_PUNTOS[1]=$( echo $PUNTOS_TEMP | cut -f 1 -d "-")
                SUMA_PUNTOS[2]=$( echo $PUNTOS_TEMP | cut -f 2 -d "-")
                SUMA_PUNTOS[3]=$( echo $PUNTOS_TEMP | cut -f 3 -d "-")
                SUMA_PUNTOS[4]=$( echo $PUNTOS_TEMP | cut -f 4 -d "-" | tr -d "\r" )

                let MEDIA_PUNTOS_TODOS_JUGADORES=$MEDIA_PUNTOS_TODOS_JUGADORES+${SUMA_PUNTOS[1]}
                let MEDIA_PUNTOS_TODOS_JUGADORES=$MEDIA_PUNTOS_TODOS_JUGADORES+${SUMA_PUNTOS[2]}
                if [[ ${SUMA_PUNTOS[3]} != "*" ]]
                then
                    let MEDIA_PUNTOS_TODOS_JUGADORES=$MEDIA_PUNTOS_TODOS_JUGADORES+${SUMA_PUNTOS[3]}
                fi

                if [[ ${SUMA_PUNTOS[4]} != "*" ]]
                then
                    let MEDIA_PUNTOS_TODOS_JUGADORES=$MEDIA_PUNTOS_TODOS_JUGADORES+${SUMA_PUNTOS[4]}
                fi

                #echo -e $MEDIA_PUNTOS_TODOS_JUGADORES
            done

            ## CALCULOS
            MEDIA_PUNTOS_GANADORES=$(( $MEDIA_PUNTOS_GANADORES/$PARTIDAS_JUGADAS_TOTAL ))
            MEDIA_RONDAS_JUGADAS=$(( $MEDIA_RONDAS_JUGADAS/$PARTIDAS_JUGADAS_TOTAL ))
            MEDIA_TIEMPOS_PART_JUGADAS=$(( $MEDIA_TIEMPOS_PART_JUGADAS/$PARTIDAS_JUGADAS_TOTAL ))
            PORCENTAJE=$(( ($PORCENTAJE*100)/$PARTIDAS_JUGADAS_TOTAL ))
            MEDIA_PUNTOS_TODOS_JUGADORES=$(( $MEDIA_PUNTOS_TODOS_JUGADORES/$PARTIDAS_JUGADAS_TOTAL ))

            echo -e "Numero total de partidas jugadas                                                         >> $PARTIDAS_JUGADAS_TOTAL"
            echo -e "Media de los puntos ganadores                                                            >> $MEDIA_PUNTOS_GANADORES"
            echo -e "Media de rondas de las partidas jugadas                                                  >> $MEDIA_RONDAS_JUGADAS"
            echo -e "Media de los tiempos de todas las partidas jugadas                                       >> $MEDIA_TIEMPOS_PART_JUGADAS"
            echo -e "Tiempo total invertido en todas las partidas                                             >> $TIEMPO_TOTAL_PART_JUGADAS"
            echo -e "Porcentaje de partidas jugadas con inteligencia activada                                 >> $PORCENTAJE %"
            echo -e "Media de la suma de los puntos obtenidos por todos los jugadores en las partidas jugadas >> $MEDIA_PUNTOS_TODOS_JUGADORES"
        fi
    else
        echo -e "ERROR: No existe $FICHEROLOG o no dispone de los permisos necesarios."
    fi
}
# Función para jugar una partida de 5illo
play_game() {
    numJugadores=$(cat config.cfg | grep 'JUGADORES=' | cut -d'=' -f2)
    echo "Comenzando una partida de 5illo con $numJugadores jugadores..."
    jugar
    #read -p "Pulse INTRO para continuar..."
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
