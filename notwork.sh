#!/bin/bash


mostrarProgramadores() {
    cat << "EOF"
                 ┌─────────────────────────────────────────────────┐
                 │                 PROGRAMADORES                   │
                 ├─────────────────────────────────────────────────┤
                 │              Mario Prieta Sánchez               │
                 │              Daniel Mulas Fajardo               │
                 └─────────────────────────────────────────────────┘
                
                


EOF

cat << "EOF"
 ███████ ███████ ████████ ██████   █████  ████████ ███████  ██████  ██  █████  ███████ 
 ██      ██         ██    ██   ██ ██   ██    ██    ██      ██       ██ ██   ██ ██      
 █████   ███████    ██    ██████  ███████    ██    █████   ██   ███ ██ ███████ ███████ 
 ██           ██    ██    ██   ██ ██   ██    ██    ██      ██    ██ ██ ██   ██      ██ 
 ███████ ███████    ██    ██   ██ ██   ██    ██    ███████  ██████  ██ ██   ██ ███████ 
 
EOF
                                                                                      
                                                                                
cat << "EOF"
    ┌─────────────────────────────────────────────────────────────────────────────┐
    │                        ESTRATEGIA 1  (NIVEL FÁCIL)                          │
    ├─────────────────────────────────────────────────────────────────────────────┤
    │ La máquina juega primero las cartas de los palos que ya están sobre la mesa,│
    │ y si no tiene ninguna carta de esos palos, juega la carta 5                 │
    └─────────────────────────────────────────────────────────────────────────────┘
EOF

# Celda para Estrategia 2 (más grande)
cat << "EOF"
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
}

mostrarEstrategias(){



read -p "Pulse INTRO para continuar..."
}

comprobarArgumentos(){
    if [[ "$2" ]] || [[ "$1" ]] && [[ "$1" != "-g" ]]; then
        echo -e "ERROR: Para ejecutar el programa escribe 'domino.sh [-g]'."
        exit
    elif [[ "$1" = "-g" ]]; then
        mostrarProgramadores
        mostrarEstrategias
    fi
}



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
    echo "“5illo”. Introduzca una opción >>"
}
#!/bin/bash

# Definir la función
leerFicherolog() {
    # Verificar si el archivo config.cfg existe
    if [ -e "config.cfg" ]; then
        # Leer la línea que contiene "LOG="
        linea=$(grep "LOG=" config.cfg)

        # Extraer el valor después del "="
        log_file=${linea#*=}
        echo "El valor de log_file es: $log_file"
    else
        echo "El archivo config.cfg no existe."
    fi
}


guardarFicherolog() {
    # Obtener el valor de log_file
    leerFicherolog

    # Verificar si log_file está definido
    while true; do
        if [ -n "$log_file" ]; then
            # Comprobar si la ruta de destino existe y es un directorio
            if [ -d "$log_file" ]; then
                # Guardar el archivo fichero.log en la ruta de destino
                echo "Guardando fichero.log en $log_file"
                touch "$log_file/fichero.log"
                break  # Salir del bucle cuando se haya guardado el archivo
            else
                read -p "La ruta de destino no es un directorio válido. Introduzca una ruta válida: " log_file
            fi
        else
            echo "El valor de log_file no está definido."
            break  # Salir del bucle si log_file no está definido
        fi
    done
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

    read -p "Introduce la ruta del fichero de log: " log_file
    while [[ ! -d "$log_file" ]]; do
        read -p "Por favor, introduzca una ruta válida: " log_file
    done

    # Actualizar configuración
    echo "JUGADORES=$jugadores" > config.cfg
    echo "ESTRATEGIA=$estrategia" >> config.cfg
    echo "LOG=$log_file" >> config.cfg

    #guardarFicherolog en la ruta especificada
    guardarFicherolog

    echo -e "\nCONFIGURACIÓN ACTUALIZADA CORRECTAMENTE"
    read -p "Pulse INTRO para continuar..."
}

# Función para barajar las cartas
barajarCartas() {
    # Inicializar un array para las cartas
    cartas=()

    # Generar todas las cartas con números del 1 al 40
    numero=1
    while [ $numero -le 40 ]; do
        cartas+=("$numero")
        numero=$((numero+1))
    done

    local i j tmp
    for ((i=39; i>0; i--)); do
        j=$((RANDOM % (i+1)))
        tmp=${cartas[i]}
        cartas[i]=${cartas[j]}
        cartas[j]=$tmp
    done
}


repartirCartas() {

    local cartasPorJugador=$((40 / numJugadores))
    local cartasExtras=$((40 % numJugadores)) 

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

    if ((cartasExtras > 0)); then
        carta=${cartas[39]}
        cartasJugadores[0]+="$carta "
    fi
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
    $jugadas = 0
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
    #comprobar que existe el fichero de configuración, si existe leer la estrategia del fichero de configuracion y si no existe, avisar al usuario
    if [ -f "config.cfg" ]; then
        # Leer la configuración del archivo config.cfg
        source "config.cfg"
        # Verificar si la variable ESTRATEGIA está definida en la configuración
        if [ -n "$ESTRATEGIA" ]; then
            estrategia="$ESTRATEGIA"
        else
            echo "ERROR: La variable ESTRATEGIA no está definida en el archivo config.cfg"
        fi
    else
        echo "ERROR: El archivo de configuración config.cfg no existe."
    fi
    jugadas=$((jugadas + 1))

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
        # Escoger la estrategia dependiendo del valor de la variable estrategia
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
    

    if $carta_valida; then
        eliminarCarta
        if [ "${cartasJugadores[$((jugadorTurno-1))]}" == "" ]; then
            end_time=$(date +%s.%N)
            elapsed_time=$(echo "$end_time - $start_time" | bc -l)
            sumarPuntos
            echo "EL JUGADOR $jugadorTurno HA GANADO LA PARTIDA CON $puntosGanador PUNTOS!!"
            echo "LA PARTIDA HA DURADO $elapsed_time SEGUNDOS"
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
            ([ "$carta" -eq "$((max_mesaBastos + 1))" ] && [ "$carta" -ne 1 ])|| [ "$carta" -eq 15 ] || [ "$carta" -eq 25 ] || [ "$carta" -eq 35 ] || [ "$carta" -eq 5 ]); then
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
                    ([ "$carta" -eq "$((max_mesaBastos + 1))" ] && [ "$carta" -ge 31 ])|| [ "$carta" -eq 15 ] || [ "$carta" -eq 25 ] || [ "$carta" -eq 35 ] || [ "$carta" -eq 5 ]); then
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

estrategia0(){
    for ((i = 0; i < ${#cartasNumeros[@]}; i++)); do
            carta="${cartasNumeros[$i]}"
            
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

            if ( [ "$carta" -le 10 ] && [ "$carta" -eq "$((max_mesaOros + 1))" ] )|| [ "$carta" -eq "$((min_mesaOros - 1))" ] ; then
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

#Consiste en que si tienes alguna carta para jugar que no sea 5, la juegas, si no tienes ninguna carta para jugar, juegas la 5
estrategia1(){
    
    for ((i = 0; i < ${#cartasNumeros[@]}; i++)); do
            carta="${cartasNumeros[$i]}"

            if ( [ "$carta" -le 10 ] && [ "$carta" -eq "$((max_mesaOros + 1))" ] )|| [ "$carta" -eq "$((min_mesaOros - 1))" ] ; then
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

    for ((i = 0; i < ${#cartasNumeros[@]}; i++)); do
        carta="${cartasNumeros[$i]}"
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
    done
}

#Funcion que calcule el numero de cartas de cada palo que tiene el jugador actual y lo almacene en una variable para cada palo
calcularNumeroCartas(){

    numOros=0
    numCopas=0
    numEspadas=0
    numBastos=0
    maxDistanciaOros=0
    maxDistanciaCopas=0
    maxDistanciaEspadas=0
    maxDistanciaBastos=0

    # Calcula la distancia entre la carta más alta/baja de cada palo del 5

    for ((i = 0; i < ${#cartasNumeros[@]}; i++)); do
        carta="${cartasNumeros[$i]}"

        if [ "$carta" -ge 1 ] && [ "$carta" -le 10 ]; then
            distanciaOros=$(( (carta - 5) ))
            distanciaOros=${distanciaOros#-}  # Valor absoluto
            if [ "$distanciaOros" -gt "$maxDistanciaOros" ]; then
                maxDistanciaOros="$distanciaOros"
            fi
        fi

        if [ "$carta" -ge 11 ] && [ "$carta" -le 20 ]; then
            distanciaCopas=$(( (carta - 5) ))
            distanciaCopas=${distanciaCopas#-}  # Valor absoluto
            if [ "$distanciaCopas" -gt "$maxDistanciaCopas" ]; then
                maxDistanciaCopas="$distanciaCopas"
            fi
        fi

        if [ "$carta" -ge 21 ] && [ "$carta" -le 30 ]; then
            distanciaEspadas=$(( (carta - 5) ))
            distanciaEspadas=${distanciaEspadas#-}  # Valor absoluto
            if [ "$distanciaEspadas" -gt "$maxDistanciaEspadas" ]; then
                maxDistanciaEspadas="$distanciaEspadas"
            fi
        fi

        if [ "$carta" -ge 31 ] && [ "$carta" -le 40 ]; then
            distanciaBastos=$(( (carta - 5) ))
            distanciaBastos=${distanciaBastos#-}  # Valor absoluto
            if [ "$distanciaBastos" -gt "$maxDistanciaBastos" ]; then
                maxDistanciaBastos="$distanciaBastos"
            fi
        fi
    done

    #Comparar el numero de cartas de cada palo y quedarse con el palo que mas cartas tenga
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


estrategia2(){

    calcularNumeroCartas

    for ((i = 0; i < ${#cartasNumeros[@]}; i++)); do
            carta="${cartasNumeros[$i]}"

            if [ "$carta" -eq 15 ] && ([ "$maxDistanciaCopas" -eq 4 ] || [ "$maxDistanciaCopas" -eq 5 ]); then
                mesacopas=true
                numeroEliminar="$carta"
                carta_valida=true
                return
            fi

            if [ "$carta" -eq 25 ] && ([ "$maxDistanciaEspadas" -eq 4 ] || [ "$maxDistanciaEspadas" -eq 5 ]); then
                numeroEliminar="$carta"
                carta_valida=true
                return
            fi

            if [ "$carta" -eq 35 ] && ([ "$maxDistanciaBastos" -eq 4 ] || [ "$maxDistanciaBastos" -eq 5 ]); then
                numeroEliminar="$carta"
                carta_valida=true
                return
            fi

            if [ "$carta" -eq 15 ] && [ "$paloMayor" = "Copas" ]; then
                mesacopas=true
                numeroEliminar="$carta"
                carta_valida=true
                return
            fi

            if [ "$carta" -eq 25 ] && [ "$paloMayor" = "Espadas" ]; then
                numeroEliminar="$carta"
                carta_valida=true
                return
            fi

            if [ "$carta" -eq 35 ] && [ "$paloMayor" = "Bastos" ]; then
                numeroEliminar="$carta"
                carta_valida=true
                return
            fi

            if ( [ "$carta" -le 10 ] && [ "$carta" -eq "$((max_mesaOros + 1))" ] )|| [ "$carta" -eq "$((min_mesaOros - 1))" ] ; then
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

    for ((i = 0; i < ${#cartasNumeros[@]}; i++)); do
        carta="${cartasNumeros[$i]}"
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
    puntosGanador=0
    for ((i=0; i<numJugadores; i++)); do
        cartasJugador=${cartasJugadores[$i]}
        IFS=' ' read -ra cartasArray <<< "$cartasJugador"
        for carta in "${cartasArray[@]}"; do
            puntosGanador=$((puntosGanador+1))
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

    cartasRestantes=""
    for ((i=0; i<4; i++)); do
        cartasJugador=${cartasJugadores[$i]}
        IFS=' ' read -ra cartasArray <<< "$cartasJugador"
        
        if [ $i -lt $numJugadores ]; then
            if [ ${#cartasArray[@]} -eq 0 ]; then
                cartasRestantes+="   "
            else
                cartasRestantes+="${cartasJugadores[$i]}"
            fi
            # Agregar asteriscos para los jugadores que no han jugado
        else
            cartasRestantes+=" * "
        fi
        # Agregar un guion "-" entre los jugadores, excepto para el último jugador.
        if [ $i -lt 3 ]; then
            cartasRestantes+="-"
        fi
    done



    # Imprimir los datos en el archivo de registro en el formato deseado
    echo -e "$fecha_actual|$hora_actual|$numJugadores|$elapsed_time|$rondas|$jugadorTurno|$puntosGanador|$cartasRestantes" >> "$log_file/fichero.log"
    #Imprimir las cartas restantes de los jugadores y si no han jugado pones un * es decir JUGADOR1|JUGADOR2|JUGADOR3|JUGADOR4
    
    read -p "Pulse INTRO para continuar..."
    show_menu



}

calcular_estadisticas() {
    # Variables para almacenar las estadísticas
    # Definir la ruta del archivo de registro
    log_file="log/prueba.log"

    # Verificar si el archivo de registro existe
    if [ ! -f "$log_file" ]; then
        echo "ERROR: El archivo de registro '$log_file' no existe."
        return
    elif [ ! -s "$log_file" ]; then
        echo "ERROR: El archivo de registro '$log_file' está vacío."
        return
    else
        total_partidas=0
        total_tiempo=0
        total_puntos=0
        partidas_ganadas_1=0
        partidas_ganadas_2=0
        partidas_ganadas_3=0
        partidas_ganadas_4=0

        # Leer el fichero de log línea por línea
        while IFS='|' read -r fecha hora jugadores tiempo rondas ganador puntos cartas; do
            # Calcular estadísticas
            total_partidas=$((total_partidas + 1))
            total_tiempo=$(bc -l <<< "$total_tiempo + $tiempo")
            total_puntos=$(bc -l <<< "$total_puntos + $puntos")

            # Verificar el jugador ganador y contar las partidas ganadas por cada jugador
            case "$ganador" in
                1)
                    partidas_ganadas_1=$((partidas_ganadas_1 + 1))
                    ;;
                2)
                    partidas_ganadas_2=$((partidas_ganadas_2 + 1))
                    ;;
                3)
                    partidas_ganadas_3=$((partidas_ganadas_3 + 1))
                    ;;
                4)
                    partidas_ganadas_4=$((partidas_ganadas_4 + 1))
                    ;;
            esac
        done < "$1" # $1 es el nombre del fichero de log pasado como argumento

        # Calcular medias y porcentajes
        media_tiempo=$(bc -l <<< "$total_tiempo / $total_partidas")
        media_puntos=$(bc -l <<< "$total_puntos / $total_partidas")
        porcentaje_ganadas_1=$(bc -l <<< "($partidas_ganadas_1 / $total_partidas) * 100")
        porcentaje_ganadas_2=$(bc -l <<< "($partidas_ganadas_2 / $total_partidas) * 100")
        porcentaje_ganadas_3=$(bc -l <<< "($partidas_ganadas_3 / $total_partidas) * 100")
        porcentaje_ganadas_4=$(bc -l <<< "($partidas_ganadas_4 / $total_partidas) * 100")

        # Mostrar estadísticas
        echo "Número total de partidas jugadas: $total_partidas"
        echo "Media de los tiempos de todas las partidas jugadas: $media_tiempo"
        echo "Tiempo total invertido en todas las partidas: $total_tiempo"
        echo "Media de los puntos obtenidos por el ganador en todas las partidas: $media_puntos"
        echo "Porcentaje de partidas ganadas del jugador 1: $porcentaje_ganadas_1%"
        echo "Porcentaje de partidas ganadas del jugador 2: $porcentaje_ganadas_2%"
        echo "Porcentaje de partidas ganadas del jugador 3: $porcentaje_ganadas_3%"
        echo "Porcentaje de partidas ganadas del jugador 4: $porcentaje_ganadas_4%"
    fi
}


mostrar_partidas_destacadas() {
    # Variables para almacenar los datos de las partidas destacadas
    partida_mas_corta=""
    partida_mas_larga=""
    partida_mas_rondas=""
    partida_menos_rondas=""
    partida_mas_puntos=""
    partida_mas_cartas=""

    # Inicializar variables para comparaciones
    duracion_corta=9999999
    duracion_larga=0
    max_rondas=0
    min_rondas=9999999
    max_puntos=0
    max_cartas=0

    while IFS='|' read -r fecha hora jugadores tiempo rondas ganador puntos cartas; do
        # Comprobar si los valores son números enteros válidos
        if [[ "$tiempo" =~ ^[0-9]+$ ]]; then
            tiempo_int=$tiempo
        else
            tiempo_int=0
        fi

        if [[ "$rondas" =~ ^[0-9]+$ ]]; then
            rondas_int=$rondas
        else
            rondas_int=0
        fi

        if [[ "$puntos" =~ ^[0-9]+$ ]]; then
            puntos_int=$puntos
        else
            puntos_int=0
        fi

        if [[ "$cartas" =~ ^[0-9]+$ ]]; then
            cartas_int=$cartas
        else
            cartas_int=0
        fi

        # Comprobar duración de la partida
        if [ "$tiempo_int" -lt "$duracion_corta" ]; then
            duracion_corta="$tiempo_int"
            partida_mas_corta="$fecha|$hora|$jugadores|$tiempo|$rondas|$ganador|$puntos|$cartas"
        fi
        if [ "$tiempo_int" -gt "$duracion_larga" ]; then
            duracion_larga="$tiempo_int"
            partida_mas_larga="$fecha|$hora|$jugadores|$tiempo|$rondas|$ganador|$puntos|$cartas"
        fi

        # Comprobar número de rondas
        if [ "$rondas_int" -gt "$max_rondas" ]; then
            max_rondas="$rondas_int"
            partida_mas_rondas="$fecha|$hora|$jugadores|$tiempo|$rondas|$ganador|$puntos|$cartas"
        fi
        if [ "$rondas_int" -lt "$min_rondas" ]; then
            min_rondas="$rondas_int"
            partida_menos_rondas="$fecha|$hora|$jugadores|$tiempo|$rondas|$ganador|$puntos|$cartas"
        fi

        # Comprobar número de puntos
        if [ "$puntos_int" -gt "$max_puntos" ]; then
            max_puntos="$puntos_int"
            partida_mas_puntos="$fecha|$hora|$jugadores|$tiempo|$rondas|$ganador|$puntos|$cartas"
        fi

        # Comprobar número de cartas
        if [ "$cartas_int" -gt "$max_cartas" ]; then
            max_cartas="$cartas_int"
            partida_mas_cartas="$fecha|$hora|$jugadores|$tiempo|$rondas|$ganador|$puntos|$cartas"
        fi
    done < "$1" # $1 es el nombre del fichero de log pasado como argumento

    # Mostrar los datos de las partidas destacadas
    echo "Partida más corta:"
    echo "$partida_mas_corta"
    echo ""
    echo "Partida más larga:"
    echo "$partida_mas_larga"
    echo ""
    echo "Partida con más rondas:"
    echo "$partida_mas_rondas"
    echo ""
    echo "Partida con menos rondas:"
    echo "$partida_menos_rondas"
    echo ""
    echo "Partida con más puntos obtenidos por el ganador:"
    echo "$partida_mas_puntos"
    echo ""
    echo "Partida en la que un jugador se ha quedado con mayor número de cartas:"
    echo "$partida_mas_cartas"
}



# Función para jugar una partida de 5illo
play_game() {
    numJugadores=$(cat config.cfg | grep 'JUGADORES=' | cut -d'=' -f2)

    # Comprobar si el número de jugadores es válido
    if [[ ! $numJugadores =~ ^[2-4]$ ]]; then
        echo "ERROR: El número de jugadores debe de ser 2, 3 o 4."
        read -p "Pulse INTRO para continuar..."
        return
    fi
    echo "Comenzando una partida de 5illo con $numJugadores jugadores..."
    jugar
}

# Función para mostrar estadísticas
show_statistics() {
    # Implementa la lógica para mostrar estadísticas aquí
    calcular_estadisticas "log/prueba.log"
    read -p "Pulse INTRO para continuar..."
}

# Función para mostrar clasificación
show_leaderboard() {
    # Implementa la lógica para mostrar la clasificación aquí
    mostrar_partidas_destacadas "log/prueba.log"
    read -p "Pulse INTRO para continuar..."
}

# Bucle principal
while true; do
comprobarArgumentos "$*"
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
