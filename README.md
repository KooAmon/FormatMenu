# FormatMenu
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
    FormatMenu 1
    ╔════╤═════════════════════════════════════════════════════════════════════════╗

    A Middle Bar
    FormatMenu 2
    ╠════╪═════════════════════════════════════════════════════════════════════════╣

    A Bottom Bar
    FormatMenu 3
    ╚════╧═════════════════════════════════════════════════════════════════════════╝

    A Header
    FormatMenu 4 "Hello World"
    ║    |Hello World                                                              ║
