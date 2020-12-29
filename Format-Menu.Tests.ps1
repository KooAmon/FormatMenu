BeforeAll {
    Import-Module .\Format-Menu.psm1
}

Describe "Format-Menu" {
    Context "Menu Borders" {
        It "Displays a Top Bar" {
            Mock Write-Host {}
            Format-Menu 1
            Should -Invoke Write-Host -Scope It -ParameterFilter { $Object -eq "╔════╤═════════════════════════════════════════════════════════════════════════╗" }
        }
        
        It "Displays a Middle Bar" {
            Mock Write-Host {}
            Format-Menu 2
            Should -Invoke Write-Host -Scope It -ParameterFilter { $Object -eq "╠════╪═════════════════════════════════════════════════════════════════════════╣" }
        }

        It "Displays a Bottom Bar" {
            Mock Write-Host {}
            Format-Menu 3
            Should -Invoke Write-Host -Scope It -ParameterFilter { $Object -eq "╚════╧═════════════════════════════════════════════════════════════════════════╝" }
        }

        It "Displays Smaller Line Width" {
            Mock Write-Host {}
            Format-Menu 1 -LineWidth 50
            Should -Invoke Write-Host -Scope It -ParameterFilter { $Object -eq "╔════╤═══════════════════════════════════════════╗" }
        }
        
        It "Displays Larger Line Width" {
            Mock Write-Host {}
            Format-Menu 1 -LineWidth 100
            Should -Invoke Write-Host -Scope It -ParameterFilter { $Object -eq "╔════╤═════════════════════════════════════════════════════════════════════════════════════════════╗" }
        }
    }

    Context "Single Item Input" {
        It "Displays a Header" {
            Mock Write-Host {}
            Format-Menu 4 "Hello World"
            Should -Invoke Write-Host -Exactly 3 -Scope It
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "║    │" }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Hello World                                                             " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "║" }
        }

        It "Displays a Menu Number" {
            Mock Write-Host {}
            Format-Menu 6 "Hello World" -MenuNumber 0
            Should -Invoke Write-Host -Exactly 3 -Scope It
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "║  0 │" }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Hello World                                                             " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "║" }
        }

        It "Errors on No Header Given" {
            Mock Write-Host {}
            Format-Menu 4
            Should -Invoke Write-Host -Exactly 1 -Scope It
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "Error!   No Header" }
        }

        It "Errors on No MenuNumber Given" {
            Mock Write-Host {}
            Format-Menu 6 "Test"
            Should -Invoke Write-Host -Exactly 1 -Scope It
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "Error!   No Menu Item" }
        }
    }

    Context "Input Objects" {
        It "Accepts Arrays" {
            Mock Write-Host {}
            $Array = Import-Csv .\TestArray.csv
            Format-Menu 5 -Array $Array -Column "Name"
            Should -Invoke Write-Host -Exactly 9 -Scope It
            Should -Invoke Write-Host -Exactly 6 -Scope It -ParameterFilter { $Object -contains "║" }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -contains "  1 │ Leroy                                                                   " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -contains "  2 │ Sam                                                                     " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -contains "  3 │ Fiona                                                                   " }
        }

        It "Accepts JSON" {
            Mock Write-Host {}
            $JSON = (Import-CSV .\TestArray.csv) | ConvertTo-Json | ConvertFrom-Json
            Format-Menu 5 -JSON $JSON -Column "Name"
            Should -Invoke Write-Host -Exactly 9 -Scope It
            Should -Invoke Write-Host -Exactly 6 -Scope It -ParameterFilter { $Object -contains "║" }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -contains "  1 │ Leroy                                                                   " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -contains "  2 │ Sam                                                                     " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -contains "  3 │ Fiona                                                                   " }
        }

        It "Errors on Missing Arrays" {
            Mock Write-Host {}
            Format-Menu 5
            Should -Invoke Write-Host -Exactly 1 -Scope It
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "Error!   Missing Array Info" }
        }

        It "Errors on Missing JSON" {
            Mock Write-Host {}
            $JSON = (@{}) | ConvertTo-Json | ConvertFrom-Json
            Format-Menu 5 -JSON $JSON
            Should -Invoke Write-Host -Exactly 1 -Scope It
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "Error!   Missing Array Info" }
        }
    }
}

<#
function TestMenuItem {
    $Array = Import-CSV .\TestArray.csv
    format-menu 1
    format-menu 4  "test Menu"
    format-menu 2
    format-menu 6 "Option 1" -menunumber 0
    format-menu 6 "Option 2" -menunumber 1
    format-menu 6 "Exit" -menunumber 2 
    format-menu 3
}
function TestArray {
    $Array = Import-CSV .\TestArray.csv
    format-menu 1
    format-menu 4  "test Menu"
    format-menu 2
    format-menu 6 "Option 1" -menunumber 0
    format-menu 5 -Array $Array -Column "Name"
    format-menu 3
}
function BadArray {
    $Array = @{}
    format-menu 1
    format-menu 4  "test Menu" 
    format-menu 2
    format-menu 4 "Option 1"
    format-menu 5 -Array $Array -Column "Name"
    format-menu 3
}

function BadCol {
    $Array = Import-CSV .\TestArray.csv
    format-menu 1
    format-menu 4  "test Menu" 
    format-menu 2
    format-menu 4 "Option 1"
    format-menu 5 -Array $Array -Column ""
    format-menu 3
}

function TestJson {
    $JSON = (Import-CSV .\TestArray.csv) | ConvertTo-Json | ConvertFrom-Json
    format-menu 1
    format-menu 4  "test Menu" 
    format-menu 2
    format-menu 4 "Option 1"
    format-menu 5 -JSON $JSON -Column "Name"
    format-menu 3
}

function BadJson {
    $JSON = (@{}) | ConvertTo-Json | ConvertFrom-Json
    format-menu 1
    format-menu 4  "test Menu" 
    format-menu 2
    format-menu 4 "Option 1"
    format-menu 5 -JSON $JSON -Column "Name"
    format-menu 3
}

function lencount{
    Write-Host "Array Length: "$test.Length
    Write-Host "Array Count: "$test.Count
    Write-Host "JSON Length: "$JSON.Length
    Write-Host "JSON Count: "$JSON.Count
}

testMenuItem
TestArray
BadArray
BadCol
TestJson
BadJson
#>