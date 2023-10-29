#INTENTAR HACER QUE GUARDE EN EL ARRAY TODOS LOS CARACTERES, PERO SI HAY DOS NUMEROS JUNTOS QUE LOS GUARDE COMO UNO SOLO

function convertir_cartas() {
    local cartas="$1"
    local cartas_convertidas=""

    IFS=" -*" read -ra cartas_array <<< "$cartas"

    for carta in "${cartas_array[@]}"; do

        if ((carta >= 1 && carta <= 10)); then
            cartas_convertidas="${cartas_convertidas}${carta}o "
        elif ((carta >= 11 && carta <= 20)); then
            carta=$((carta - 10))
            cartas_convertidas="${cartas_convertidas}${carta}c "
        elif ((carta >= 21 && carta <= 30)); then
            carta=$((carta - 20))
            cartas_convertidas="${cartas_convertidas}${carta}e "
        elif ((carta >= 21 && carta <= 30)); then
            carta=$((carta - 30))
            cartas_convertidas="${cartas_convertidas}${carta}b "
        fi
    done

    echo "$cartas_convertidas"
}

cartas="1-   -10 11 25 35- *"
resultado=$(convertir_cartas "$cartas")
echo "$resultado"