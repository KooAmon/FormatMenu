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
    Format-Menu 4 "Hello World"
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
    Format-Menu 4 "Hello World"
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
    [CmdletBinding(ConfirmImpact='Low')]
    Param(
        [Parameter(Position = 1, Mandatory)][Int]$Type,
        [Parameter(Position = 2)][String]$Header,
        [Parameter()][Alias("BorderForeground")][Int]$BorderFG,
        [Parameter()][Alias("BorderBackground")][Int]$BorderBG,
        [Parameter()][Alias("MenuForeground")][Int]$MenuFG,
        [Parameter()][Alias("MenuBackground")][Int]$MenuBG,
        [Parameter(ParameterSetName = "Array")][Alias("Arr")][Array]$Array,
        [Parameter(ParameterSetName = "Array")][Alias("Col")][String]$Column,
        [Parameter(ParameterSetName = "Array")][Alias("Skip")][Int]$SkipLines = 1,
        [Parameter()][String]$LineWidth = 80
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
                Format-Menu 4 "Error!   No Header" -MenuBG $MenuBG -MenuFG $MenuFG -BorderBG $BorderBG -BorderFG $BorderFG -LineWidth $LineWidth
            }
            
            [string]$BackCharBuffer = " " * ( $BackBuffer - $Header.Length - 1 )
            [string]$FrontCharBuffer = " " * $FrontBuffer
            Write-Host -Foregroundcolor $BorderFG -BackgroundColor $BorderBG "$VBC$FrontCharBuffer$VSBC" -NoNewLine
            Write-Host -Foregroundcolor $MenuFG -BackgroundColor $MenuBG " $Header$BackCharBuffer" -NoNewLine
            Write-Host -Foregroundcolor $BorderFG -BackgroundColor $BorderBG "$VBC"
        }
        5 {
            if ( $Array.Count -lt 2 ) {
                Format-Menu 4 "Error!   Missing Array Info" -MenuBG $MenuBG -MenuFG $MenuFG -BorderBG $BorderBG -BorderFG $BorderFG -LineWidth $LineWidth
                break
            } elseif ( [string]::IsNullOrEmpty($Column) ) {
                Format-Menu 4 "Error!   Missing Column Info" -MenuBG $MenuBG -MenuFG $MenuFG -BorderBG $BorderBG -BorderFG $BorderFG -LineWidth $LineWidth
                break
            }

            for ($i=0;$i -le $Array.length - 1; $i++) {
                $MenuItem = $Array[$i].$Column
                $MenuNumber = $i + $SkipLines
                $BackCharBuffer = " " * ($BackBuffer - ($Array[$i].$Column).length - 1 )
                Write-Host -Foregroundcolor $BorderFG -BackgroundColor $BorderBG $VBC -NoNewLine
                if ( $MenuNumber -lt 10 ) {
                    Write-Host -ForegroundColor $MenuFG -BackgroundColor $MenuBG "  $MenuNumber $VSBC $MenuItem$BackCharBuffer" -NoNewLine
                } else {
                    Write-Host -ForegroundColor $MenuFG -BackgroundColor $MenuBG " $MenuNumber $VSBC $MenuItem$BackCharBuffer" -NoNewLine
                }
                Write-Host -Foregroundcolor $BorderFG -BackgroundColor $BorderBG $VBC
            }
        }
    }
}