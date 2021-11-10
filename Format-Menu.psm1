Function Format-Menu {
    <#
    .SYNOPSIS
    Display a Menu

    .DESCRIPTION
    Displays a Simple Menu built from a JSON Object and returns the index the user selects
    
    .PARAMETER InputJSON
    The JSON object used to create the Menu.  The object should be built as follows.

    Required Objects
    - Header:  DataType String.  This is the Header that will be displayed at the top of the Menu.
    - MenuItems: DataType Array of Strings. This array will be parsed as the options displayed in the Menu.  Numbering will be given in a top down order starting from 0.
    
    Optional Objects
    - LineWidth: DataType Int. This is the width of the Menu.  The default of 80 will be set if omitted.
    - Colors: DataType Array of Objects.  This holds the Menu and Border color selections.
    - BorderBackground: DataType Int.  This will be the Border Background Color.  The default of 0 will be set if omitted.
    - BorderForeground: DataType Int.  This will be the Border Foreground Color.  The default of 6 will be set if omitted.
    - MenuBackground: DataType Int.  This will be the Menu Background Color.  The default of 0 will be set if omitted.
    - MenuForeground: DataType Int.  This will be the Menu Foreground Color.  The default of 10 will be set if omitted.

    Example JSON Object

    {
        "Header": "Test Menu",
        "LineWidth": 80,
        "Colors": {
            "MenuBackground": 0,
            "MenuForeground": 10,
            "BorderBackground": 0,
            "BorderForeground": 6
        },
        "MenuItems": [
            "Option 1",
            "Option 2",
            "Option 3"
        ]
    }

    .EXAMPLE
    $JSON = Get-Content .\Test\TestInput.json
    Format-Menu -InputObject $JSON
    
    ╔════╤═════════════════════════════════════════════════════════════════════════╗
    ║    │Test Menu                                                                ║
    ╠════╪═════════════════════════════════════════════════════════════════════════╣
    ║  0 │ Option 1                                                                ║
    ║  1 │ Option 2                                                                ║
    ║  2 │ Option 3                                                                ║
    ╚════╧═════════════════════════════════════════════════════════════════════════╝
    #>
    [CmdletBinding(ConfirmImpact='Low')]
    Param(
        [Parameter(Position = 1, Mandatory, ValueFromPipeline)][Array]$InputJSON
    )

    Function Confirm-JSON {
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

    Function Write-Menu {
        Clear-Screen      
        Write-Host -ForegroundColor $BorderFg -BackgroundColor $BorderBg $TLBC$CharsFront$TMBC$CharsBack$TRBC
        Write-Header -Header $JSON.Header
        Write-Host -ForegroundColor $BorderFg -BackgroundColor $BorderBg $VHLBC$CharsFront$MMBC$CharsBack$VHRBC

        $i = 0
        $JSON.MenuItems.PSObject.Properties.Foreach({
            Write-MenuItem -Item $_.Name -Index $i
            $i++
        })
    
        Write-Host -ForegroundColor $BorderFg -BackgroundColor $BorderBg $BLBC$CharsFront$BMBC$CharsBack$BRBC

        [int]$UserInput = Read-Host "Select Item"
        return $JSON.MenuItems.PSObject.Properties.Value[$UserInput]
    }

    Function Write-InteractiveMenu (){
        $MenuOptions = [System.Collections.ArrayList]::new()
        $JSON.MenuItems.PSObject.Properties.Foreach({$MenuOptions.Add($_.Name)})
        $MaxValue = $MenuOptions.count-1
        $Selection = 0
        $EnterPressed = $False
        
        Clear-Screen
    
        While($EnterPressed -eq $False){
            #Write-Host $JSON.Header
            Clear-Screen
            Write-Host -ForegroundColor $BorderFg -BackgroundColor $BorderBg $TLBC$CharsFront$TMBC$CharsBack$TRBC
            Write-Header -Header $JSON.Header
            Write-Host -ForegroundColor $BorderFg -BackgroundColor $BorderBg $VHLBC$CharsFront$MMBC$CharsBack$VHRBC

            For ($i=0; $i -le $MaxValue; $i++){
                
                If ($i -eq $Selection){
                    #Write-Host -BackgroundColor Cyan -ForegroundColor Black "[ $($MenuOptions[$i]) ]"
                    $HighlightedItem = "$($MenuOptions[$i]) <-"
                    Write-MenuItem -Item $HighlightedItem -Index $i
                } Else {
                    #Write-Host "  $($MenuOptions[$i])  "
                    Write-MenuItem -Item $MenuOptions[$i] -Index $i
                }
    
            }

            Write-Host -ForegroundColor $BorderFg -BackgroundColor $BorderBg $BLBC$CharsFront$BMBC$CharsBack$BRB
            Write-Host "Use up and down arrow keys to select and then press Enter"
            
            $KeyInput = $host.ui.rawui.readkey("NoEcho,IncludeKeyDown").virtualkeycode
            Switch($KeyInput){
                13 { $EnterPressed = $True }
                38{
                    If ($Selection -eq 0){
                        $Selection = $MaxValue
                    } Else {
                        $Selection -= 1
                    }
                }
    
                40{
                    If ($Selection -eq $MaxValue){
                        $Selection = 0
                    } Else {
                        $Selection += 1
                    }
                }
                Default {}
            }
        }
        return $Selection
    }

    Function Write-Header {
        Param(
            [Parameter(Position = 1, Mandatory)][String]$Header
        )
        [string]$BackCharBuffer = " " * ( $BackBuffer - $Header.Length - 1 )
        [string]$FrontCharBuffer = " " * $FrontBuffer
        Write-Host -Foregroundcolor $BorderFg -BackgroundColor $BorderBg "$VBC$FrontCharBuffer$VSBC" -NoNewLine
        Write-Host -Foregroundcolor $MenuFg -BackgroundColor $MenuBg $Header "$BackCharBuffer" -NoNewLine
        Write-Host -Foregroundcolor $BorderFg -BackgroundColor $BorderBg "$VBC"
    }

    Function Write-MenuItem {
        Param(
            [Parameter(Position = 1, Mandatory)][String]$Item,
            [Parameter(Position = 2, Mandatory)][Int]$Index
        )
        [string]$FrontCharBuffer = " " * ($FrontBuffer - $Index.ToString().Length - 1)
        if($Item.Length -gt ($JSON.LineWidth - ($FrontCharBuffer.Length + 3))){
            [string]$BackCharBuffer = " "
            $Item = $Item.Substring(0,$JSON.LineWidth - ($FrontCharBuffer.Length + 4))
        } else {
            [string]$BackCharBuffer = " " * ($BackBuffer - $Item.length - 1 )            
        }
        Write-Host -Foregroundcolor $BorderFg -BackgroundColor $BorderBg $VBC -NoNewLine
        Write-Host -ForegroundColor $MenuFg -BackgroundColor $MenuBg "$FrontCharBuffer$Index " -NoNewLine 
        Write-Host -Foregroundcolor $BorderFg -BackgroundColor $BorderBg $VSBC -NoNewLine
        Write-Host -ForegroundColor $MenuFg -BackgroundColor $MenuBg " $Item$BackCharBuffer" -NoNewLine
        Write-Host -Foregroundcolor $BorderFg -BackgroundColor $BorderBg $VBC
    }

    Function Clear-Screen{
        If($JSON.Interactive){
            Clear-Host
        } elseif ($JSON.ClearScreen) {
            Clear-Host
        }
    }

    Function Main {
        #[OutputType([Int])]
        [PSCustomObject]$JSON = $InputJSON | ConvertFrom-Json
        if ( -NOT (Confirm-JSON)) { exit }

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
        [int]$BorderFg = if ( $JSON.Colors.PSObject.Properties.name -match "BorderForeground" ) { $JSON.Colors.BorderForeground } else { 2 }
        [int]$MenuBg = if ( $JSON.Colors.PSObject.Properties.name -match "MenuBackground" ) { $JSON.Colors.MenuBackground } else { 0 }
        [int]$MenuFg = if ( $JSON.Colors.PSObject.Properties.name -match "MenuForeground" ) { $JSON.Colors.MenuForeground } else { 10 }

        #Setup spacing based on Menu length and LineWidth
        $Items = -1
        ForEach($Item in $JSON.MenuItems.PSObject.Properties) {$Items++}
        [Int]$FrontBuffer = ($Items).ToString().length + 2
        [Int]$BackBuffer = $JSON.LineWidth - $FrontBuffer - 3
        [string]$CharsFront = $HBC * $FrontBuffer
        [string]$CharsBack = $HBC * $BackBuffer

        If ($JSON.Interactive){
            $UserInput = Write-InteractiveMenu
            #   ToDo: Fix RealizedInput
            $RealizedInput = $UserInput[$UserInput.Length -1]
            Write-Host $JSON.MenuItems.PSObject.Properties.Value[$RealizedInput]
            return $JSON.MenuItems.PSObject.Properties.Value[$RealizedInput]
        } else {
            return Write-Menu
        }
    }
    Main
}