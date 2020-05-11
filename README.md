# Format-Menu
Menu framework for Powershell scripting

Displays a Top, Middle, Bottom Border, Menu Header, or a Menu Item

.PARAMETER Type
    Used to do differenciate between each type of entry
    1 is Top
    2 is Middle
    3 is Bottom
    4 is a Menu Header
    5 is a Menu Array

.PARAMETER BorderFG
    Color of the Foreground (0-16)

.PARAMETER BorderBG (0-16)
    Color of the Background

.PARAMETER Header
    One line Menu Header

.PARAMETER HeaderNumber
    Number of a Numbered parameter

.PARAMETER Array
    Array for creation of multiple lines with numbering

.PARAMETER Skiplines
    How many numbers to skip when using an Array

.PARAMETER Column
    What Column to use in the Array

.PARAMETER Front
    Number of spaces to put before the separator

.PARAMETER Back
    Number of spaces to put after the separator

.EXAMPLE

    A Top Bar
    Format-Menu 1
    ╔════╤═════════════════════════════════════════════════════════════════════════╗

    A Middle Bar
    Format-Menu 2
    ╠════╪═════════════════════════════════════════════════════════════════════════╣

    A Bottom Bar
    Format-Menu 3
    ╚════╧═════════════════════════════════════════════════════════════════════════╝

    A Header
    Format-Menu 4 "Hello World"
    ║    |Hello World                                                              ║
    
    A Array Menu
    FormatMenu 5 -Arr $Array_Name -Col "Column Name"
    ║  1 │ Core                                                                    ║
    ║  2 │ Node_1                                                                  ║
    ║  3 │ Node_2                                                                  ║
    ║  4 │ Node_3                                                                  ║
    ║  5 │ Node_4                                                                  ║
    ║  6 │ Test-Device                                                             ║
 
    All together
    FormatMenu 1
    FormatMenu 4 "Hello World"
    FormatMenu 2
    FormatMenu 5 -Arr $Array_Name -Col "Column Name"
    FormatMenu 3
    ╔════╤═════════════════════════════════════════════════════════════════════════╗
    ║    |Hello World                                                              ║
    ╠════╪═════════════════════════════════════════════════════════════════════════╣
    ║  1 │ Core                                                                    ║
    ║  2 │ Node_1                                                                  ║
    ║  3 │ Node_2                                                                  ║
    ║  4 │ Node_3                                                                  ║
    ║  5 │ Node_4                                                                  ║
    ║  6 │ Test-Device                                                             ║
    ╚════╧═════════════════════════════════════════════════════════════════════════╝
