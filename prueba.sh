function convertir_cartas() {
    cartas_originales="$1"
    cartas_convertidas=""
    cartas=()

    carta_actual=""
    for ((i=0; i<${#cartas_originales}; i++)); do
        carta="${cartas_originales:$i:1}"

        # Verificar si el carácter actual es un número
        if [[ "$carta" =~ [0-9] ]]; then
            carta_actual="${carta_actual}${carta}"
        else
            # Si no es un número, agregar la carta_actual al arreglo
            if [[ -n "$carta_actual" ]]; then
                cartas+=("$carta_actual")
            fi
            # También agregar el carácter actual al arreglo
            cartas+=("$carta")
            carta_actual=""
        fi
    done

    for carta in "${cartas[@]}"; do
        if [[ "$carta" == "*" || "$carta" == " " || "$carta" == "-" ]]; then
            # Si la carta es "*" o un espacio en blanco, omitirla
            cartas_convertidas="${cartas_convertidas}${carta}"
        else
            if ((carta >= 1 && carta <= 10)); then
                # Si la carta está en el rango de 1-10, añadir una 0
                cartas_convertidas="${cartas_convertidas}${carta}o"
            elif ((carta >= 11 && carta <= 20)); then
                # Si la carta está en el rango de 11-20, restar 10 y añadir una C
                carta=$((carta - 10))
                cartas_convertidas="${cartas_convertidas}${carta}c"
            elif ((carta >= 21 && carta <= 30)); then
                # Si la carta está en el rango de 21-30, restar 20 y añadir una E
                carta=$((carta - 20))
                cartas_convertidas="${cartas_convertidas}${carta}e"
            else
                # En caso contrario, mantener la carta como está y añadir una B
                carta=$((carta - 30))
                cartas_convertidas="${cartas_convertidas}${carta}b"
            fi
        fi
    done

    echo "$cartas_convertidas"
}

# Ejemplo de uso:
cartas_originales="1-   -10 11 25 35- *"
cartas_convertidas=$(convertir_cartas "$cartas_originales")
echo "$cartas_convertidas"
