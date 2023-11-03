# SSOO1-BashProject
Proyecto BASH 2023 5illo.sh

                 ┌─────────────────────────────────────────────────┐
                 │                 PROGRAMADORES                   │
                 ├─────────────────────────────────────────────────┤
                 │              Mario Prieta Sánchez               │
                 │              Daniel Mulas Fajardo               │
                 └─────────────────────────────────────────────────┘

    ┌─────────────────────────────────────────────────────────────────────────────┐
    │                        ESTRATEGIA 1  (NIVEL FÁCIL)                          │
    ├─────────────────────────────────────────────────────────────────────────────┤
    │ La máquina juega primero las cartas de los palos que ya están sobre la mesa,│
    │ y si no tiene ninguna carta de esos palos, juega la carta 5                 │
    └─────────────────────────────────────────────────────────────────────────────┘

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
