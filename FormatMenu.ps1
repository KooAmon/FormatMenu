#Variables used for "graphical" menu
[String]$Global:VSBC = [String][Char]9474

Function FormatMenu {
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
    6 is a Custom Color Header
    .PARAMETER BorderFG
    Color of the Foreground (0-16)
    .PARAMETER BorderBG (0-16)
    Color of the Background
    .PARAMETER Header
    One line Menu Header
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
    #>
    [CmdletBinding(ConfirmImpact='Low')]
    Param(
        [Parameter(Mandatory = $True, Position = 1)][Int]$Type,
        [Parameter(Mandatory = $False, Position = 2)][String]$Header,
        [Parameter(Mandatory = $False)][Alias("BFG")][Int]$BorderFG = $GlobalBFG,
        [Parameter(Mandatory = $False)][Alias("BBG")][Int]$BorderBG= $GlobalBBG,
        [Parameter(Mandatory = $False)][Alias("MFG")][Int]$MenuFG = $GlobalMFG,
        [Parameter(Mandatory = $False)][Alias("MBG")][Int]$MenuBG= $GlobalMBG,
        [Parameter(Mandatory = $False)][Alias("Arr")][Array]$Array,
        [Parameter(Mandatory = $False)][Alias("Col")][String]$Column,
        [Parameter(Mandatory = $False)][Alias("Skip")][Int]$SkipLines = 1,
        [String]$Front = 4,
        [String]$Back = 73
    )
    
    $HBC = [String][Char]9552
    $VBC = [String][Char]9553
    $TLBC = [String][Char]9556
    $TRBC = [String][Char]9559
    $BLBC = [String][Char]9562
    $BRBC = [String][Char]9565
    $TMBC = [String][Char]9572
    $MMBC = [String][Char]9578
    $BMBC = [String][Char]9575
    $VHLBC = [String][Char]9568
    $VHRBC = [String][Char]9571
    $CharsFront = $HBC * $Front
    $CharsBack = $HBC * $Back
    
    Switch ($Type) {
        1 {Write-Host -ForegroundColor $BorderFG -BackgroundColor $BorderBG "$TLBC$CharsFront$TMBC$CharsBack$TRBC"}
        2 {Write-Host -ForegroundColor $BorderFG -BackgroundColor $BorderBG "$VHLBC$CharsFront$MMBC$CharsBack$VHRBC"}
        3 {Write-Host -ForegroundColor $BorderFG -BackgroundColor $BorderBG "$BLBC$CharsFront$BMBC$CharsBack$BRBC"}
        4 {
            If (-Not $Header -eq "") {
                $Chars = $Header.length
                $Chars = " " * (77 - $Chars)
                Write-Host -Foregroundcolor $BorderFG -BackgroundColor $BorderBG "$VBC" -nonewline
                Write-Host -Foregroundcolor $MenuFG -BackgroundColor $MenuBG $Header $Chars -nonewline
                Write-Host -Foregroundcolor $BorderFG -BackgroundColor $BorderBG "$VBC"
            } Else {Write-Warning "Error!   No Header" }
        }
        5 {
            If ($Array.length -gt 0) {
                If ($Column -ne "") {
                    For ($i=0;$i -le $Array.length - 1; $i++) {
                        $MenuItem = $Array[$i].$Column
                        $MenuNumber = $i + $SkipLines
                        $Chars = ($Array[$i].$Column).length
                        $Chars = " " * (74 - $Chars - $CharsFront.Count - $CharsBack.count)
 #                        If ($MenuItem.contains("-") -eq $True) {
 #                            $Result = $MenuItem.substring(0, $MenuItem.lastindexofany("-"))
 #                            If ($Result -ne $Result2) {
 #                                $Result2 = $Result
 #                                Write-Host -ForegroundColor $BorderFG -BackgroundColor $BorderBG "$VHLBC$CharsFront$MMBC$CharsBack$VHRBC"
 #                            }
 #                        } 
                    	Write-Host -Foregroundcolor $BorderFG -BackgroundColor $BorderBG "$VBC" -NoNewLine
                        If ($MenuNumber -lt 10) {
	                        Write-Host -ForegroundColor $MenuFG -BackgroundColor $MenuBG "  $MenuNumber $VSBC $MenuItem$Chars" -NoNewLine
                        } Else {Write-Host -ForegroundColor $MenuFG -BackgroundColor $MenuBG " $MenuNumber $VSBC $MenuItem$Chars" -NoNewLine}
                        Write-Host -Foregroundcolor $BorderFG -BackgroundColor $BorderBG "$VBC"
                    }
                } Else {Write-Warning "Error!   Missing Column Info"}
            } Else {Write-Warning "Error!   Missing Array Info"}
        }
        6 {
            If (-Not $Header -eq "") {
                $Chars = $Header.length
                $Chars = " " * (77 - $Chars)
                Write-Host -Foregroundcolor $BorderFG -BackgroundColor $BorderBG "$VBC" -nonewline
                Write-Host -Foregroundcolor $GlobalMBG -BackgroundColor $GlobalMBG $Header $Chars -nonewline
                Write-Host -Foregroundcolor $BorderFG -BackgroundColor $BorderBG "$VBC"
            } Else {Write-Warning "Error!   No Header" }
        }
    }
}
