Function Format-Menu {
    <#
    .SYNOPSIS
    Display a Border

    .DESCRIPTION
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

    .PARAMETER LineWidth
    Number of Charaters in a line.  Defaults to 80.

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
    Write-Host "Hello World"
    ║    |Hello World                                                              ║

    A Array Menu
    Format-Menu 5 -Arr $Array_Name -Col "Column Name"
    ║  1 │ Core                                                                    ║
    ║  2 │ Node_1                                                                  ║
    ║  3 │ Node_2                                                                  ║
    ║  4 │ Node_3                                                                  ║
    ║  5 │ Node_4                                                                  ║
    ║  6 │ Test-Device                                                             ║

    All together
    Format-Menu 1
    Write-Host "Hello World"
    Format-Menu 2
    Format-Menu 5 -Arr $Array_Name -Col "Column Name"
    Format-Menu 3
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
    #>
    [CmdletBinding(ConfirmImpact='Low', DefaultParameterSetName = "Base")]
    Param(
        [Parameter(ParameterSetName = "Base", Position = 1, Mandatory)]
        [Parameter(ParameterSetName = "Header", Position = 1, Mandatory)]
        [Parameter(ParameterSetName = "Item", Position = 1, Mandatory)]
        [Parameter(ParameterSetName = "Array", Position = 1, Mandatory)][Int]$Type,
        [Parameter(ParameterSetName = "Header", Position = 2, Mandatory)]
        [Parameter(ParameterSetName = "Item", Position = 2, Mandatory)][String]$Header,
        [Parameter(ParameterSetName = "Item", Mandatory)][System.Nullable[[System.Int32]]]$MenuNumber = $NULL,
        [Parameter(ParameterSetName = "Base")][Alias("BorderForeground")][Int]$BorderFG = 7,
        [Parameter(ParameterSetName = "Base")][Alias("BorderBackground")][Int]$BorderBG,
        [Parameter(ParameterSetName = "Base")][Alias("MenuForeground")][Int]$MenuFG = 7,
        [Parameter(ParameterSetName = "Base")][Alias("MenuBackground")][Int]$MenuBG,
        [Parameter(ParameterSetName = "Base")][String]$LineWidth = 80,
        [Parameter(ParameterSetName = "Array")][Alias("JSON")][Array]$Array,
        [Parameter(ParameterSetName = "Array")][String]$Column,
        [Parameter(ParameterSetName = "Array")][Int]$SkipLines = 1
    )

    #Variables used for "graphical" menu
    [string]$HBC = [String][Char]9552           #Horizontal Double Bar
    [string]$VBC = [String][Char]9553           #Veritcal Double Bar
    [string]$TLBC = [String][Char]9556          #Top Left Corner Double Bar 
    [string]$TRBC = [String][Char]9559          #Top Right Coner Double Bar
    [string]$BLBC = [String][Char]9562          #Bottom Left Corner Double Bar
    [string]$BRBC = [String][Char]9565          #Bottom Right Coner Double Bar
    [string]$TMBC = [String][Char]9572          #Top Double Bar Middle Single Bar
    [string]$MMBC = [String][Char]9578          #Middle Double Bar Middle Single Bar
    [string]$BMBC = [String][Char]9575          #Bottom Double Bar Middle Single Bar
    [string]$VHLBC = [String][Char]9568
    [string]$VHRBC = [String][Char]9571
    [string]$VSBC = [String][Char]9474          #Vertical Single Bar
    [Int]$FrontBuffer = 4
    [Int]$BackBuffer = $LineWidth - $FrontBuffer - 3
    [string]$CharsFront = $HBC * $FrontBuffer
    [string]$CharsBack = $HBC * $BackBuffer
    
    Switch ($Type) {
        1 { Write-Host -ForegroundColor $BorderFG -BackgroundColor $BorderBG $TLBC$CharsFront$TMBC$CharsBack$TRBC }
        2 { Write-Host -ForegroundColor $BorderFG -BackgroundColor $BorderBG $VHLBC$CharsFront$MMBC$CharsBack$VHRBC }
        3 { Write-Host -ForegroundColor $BorderFG -BackgroundColor $BorderBG $BLBC$CharsFront$BMBC$CharsBack$BRBC }
        4 {
            if ( $Header -eq "" ) {
                Write-Host "Error!   No Header"
                break
            }
            
            [string]$BackCharBuffer = " " * ( $BackBuffer - $Header.Length - 1 )
            [string]$FrontCharBuffer = " " * $FrontBuffer
            Write-Host -Foregroundcolor $BorderFG -BackgroundColor $BorderBG "$VBC$FrontCharBuffer$VSBC" -NoNewLine
            Write-Host -Foregroundcolor $MenuFG -BackgroundColor $MenuBG " $Header$BackCharBuffer" -NoNewLine
            Write-Host -Foregroundcolor $BorderFG -BackgroundColor $BorderBG "$VBC"
        }
        5 {
            if ( -NOT $MyInvocation.BoundParameters.ContainsKey("Array") -OR -NOT [bool]$Array.$Column ) {
                Write-Host "Error!   Missing Array Info"
                break
            } elseif ( -NOT $MyInvocation.BoundParameters.ContainsKey("Column") ) {
                Write-Host "Error!   Missing Column Info"
                break
            }

            for ($i=0;$i -le $Array.length - 1; $i++) {
                [string]$MenuItem = $Array[$i].$Column
                [int]$MenuNumber = $i + $SkipLines
                [string]$BackCharBuffer = " " * ($BackBuffer - ($Array[$i].$Column).length - 1 )
                Write-Host -Foregroundcolor $BorderFG -BackgroundColor $BorderBG $VBC -NoNewLine
                if ( $MenuNumber -lt 10 ) {
                    Write-Host -ForegroundColor $MenuFG -BackgroundColor $MenuBG "  $MenuNumber $VSBC $MenuItem$BackCharBuffer" -NoNewLine
                } elseif ( $MenuNumber -lt 100) {
                    Write-Host -ForegroundColor $MenuFG -BackgroundColor $MenuBG " $MenuNumber $VSBC $MenuItem$BackCharBuffer" -NoNewLine
                } else {
                    Write-Host -ForegroundColor $MenuFG -BackgroundColor $MenuBG "$MenuNumber $VSBC $MenuItem$BackCharBuffer" -NoNewLine
                }
                Write-Host -Foregroundcolor $BorderFG -BackgroundColor $BorderBG $VBC
            }
        }
        6 {
            if ( -NOT $MyInvocation.BoundParameters.ContainsKey("MenuNumber")) {
                Write-Host "Error!   No Menu Item"
                break
            }
            [string]$BackCharBuffer = " " * ( $BackBuffer - $Header.Length - 1 )
            if ( $MenuNumber -lt 10 ) {
                [string]$FrontCharBuffer = " " * ( $FrontBuffer - 2 )
            } elseif ( $MenuNumber -lt 100 ) {
                [string]$FrontCharBuffer = " " * ( $FrontBuffer - 3 )
            } else {
                [string]$FrontCharBuffer = " " * ( $FrontBuffer - 4 )
            }

            Write-Host -Foregroundcolor $BorderFG -BackgroundColor $BorderBG "$VBC$FrontCharBuffer$MenuNumber $VSBC" -NoNewLine
            Write-Host -Foregroundcolor $MenuFG -BackgroundColor $MenuBG " $Header$BackCharBuffer" -NoNewLine
            Write-Host -Foregroundcolor $BorderFG -BackgroundColor $BorderBG "$VBC"
        }
    }
}