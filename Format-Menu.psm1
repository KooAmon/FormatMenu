Function Format-Menu {
    [CmdletBinding(ConfirmImpact='Low')]
    Param(
        [Parameter(Position = 1, Mandatory)][Array]$InputJSON
    )

    Function Check-JSON {
        if ( -NOT ($JSON.PSObject.Properties.name -match "Header" )) {
            Write-Host "Error - Missing Header!"
            return $false
        }
        if ( -NOT ($JSON.PSObject.Properties.name -match "MenuItems" )) {
            Write-Host "Error - Missing Menu Items!"
            return $false
        }
        if ( -NOT ($JSON.PSObject.Properties.name -match "LineWidth" )) {
            Add-Member -InputObject $JSON -NotePropertyName LineWidth -NotePropertyValue 80
        }
        return $true
    }

    Function Draw-Menu {
        Clear-Host
        Write-Host -ForegroundColor $BorderFg -BackgroundColor $BorderBg $TLBC$CharsFront$TMBC$CharsBack$TRBC
    
        Draw-Header -Header $JSON.Header
    
        Write-Host -ForegroundColor $BorderFg -BackgroundColor $BorderBg $VHLBC$CharsFront$MMBC$CharsBack$VHRBC
    
        ForEach ($MenuItem in $JSON.MenuItems) {
            Draw-MenuItem -Item $MenuItem -Index $JSON.MenuItems.Indexof($MenuItem)
        }
    
        Write-Host -ForegroundColor $BorderFg -BackgroundColor $BorderBg $BLBC$CharsFront$BMBC$CharsBack$BRBC
    
        return Read-Host "Select an Item"
    }

    Function Draw-Header {
        Param(
            [Parameter(Position = 1, Mandatory)][String]$Header
        )
        [string]$BackCharBuffer = " " * ( $BackBuffer - $Header.Length - 1 )
        [string]$FrontCharBuffer = " " * $FrontBuffer
        Write-Host -Foregroundcolor $BorderFg -BackgroundColor $BorderBg "$VBC$FrontCharBuffer$VSBC" -NoNewLine
        Write-Host -Foregroundcolor $MenuFg -BackgroundColor $MenuBg $Header "$BackCharBuffer" -NoNewLine
        Write-Host -Foregroundcolor $BorderFg -BackgroundColor $BorderBg "$VBC"
    }

    Function Draw-MenuItem {
        Param(
            [Parameter(Position = 1, Mandatory)][String]$Item,
            [Parameter(Position = 2, Mandatory)][Int]$Index
        )
        [string]$FrontCharBuffer = " " * ($FrontBuffer - $Index.ToString().Length - 1)
        [string]$BackCharBuffer = " " * ($BackBuffer - $Item.length - 1 )
        Write-Host -Foregroundcolor $BorderFg -BackgroundColor $BorderBg $VBC -NoNewLine
        Write-Host -ForegroundColor $MenuFg -BackgroundColor $MenuBg "$FrontCharBuffer$Index $VSBC $Item$BackCharBuffer" -NoNewLine
        Write-Host -Foregroundcolor $BorderFg -BackgroundColor $BorderBg $VBC
    }

    [PSCustomObject]$JSON = $InputJSON | ConvertFrom-Json
    if ( -NOT (Check-JSON)) { break }

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

    [int]$BorderBg = if ( $JSON.Colors.PSObject.Properties.name -match "BorderBackground" ) { $JSON.Colors.BorderBackground } else { 0 }
    [int]$BorderFg = if ( $JSON.Colors.PSObject.Properties.name -match "BorderForeground" ) { $JSON.Colors.BorderForeground } else { 8 }
    [int]$MenuBg = if ( $JSON.Colors.PSObject.Properties.name -match "MenuBackground" ) { $JSON.Colors.MenuBackground } else { 0 }
    [int]$MenuFg = if ( $JSON.Colors.PSObject.Properties.name -match "MenuForeground" ) { $JSON.Colors.MenuForeground } else { 8 }

    #Setup spacing based on Menu length and LineWidth
    [Int]$FrontBuffer = ($JSON.MenuItems.Count).ToString().length + 2
    [Int]$BackBuffer = $JSON.LineWidth - $FrontBuffer - 3
    [string]$CharsFront = $HBC * $FrontBuffer
    [string]$CharsBack = $HBC * $BackBuffer
    
    $UserInput = Draw-Menu

    if ( $UserInput -lt 0 -OR $UserInput -gt $JSON.MenuItems.Count - 1 ) {
        $UserInput = Format-Menu -InputJSON  $InputJSON
    }
    return $UserInput
}
