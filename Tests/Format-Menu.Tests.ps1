BeforeAll {
    Import-Module .\Format-Menu.psm1
}

Describe "Format-Menu" {
    Context "Displays" {
        It "Menu" {
            Mock Write-Host {}
            Mock Read-Host {return "0"}
            $JSON = Get-Content .\Tests\TestInput.json
            Format-Menu -InputJSON $JSON
            Should -Invoke Write-Host -Exactly 61 -Scope It
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "╔════╤═════════════════════════════════════════════════════════════════════════╗" }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "║    │" }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "Test Menu" }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "╠════╪═════════════════════════════════════════════════════════════════════════╣" }
            Should -Invoke Write-Host -Exactly 23 -Scope It -ParameterFilter { $Object -eq "║" }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "  0 " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "  1 " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "  2 " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "  3 " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "  4 " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "  5 " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "  6 " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "  7 " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "  8 " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "  9 " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " 10 " }
            Should -Invoke Write-Host -Exactly 11 -Scope It -ParameterFilter { $Object -eq "│" }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Option 1                                                                " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Option 2                                                                " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Option 3                                                                " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Option 4                                                                " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Option 5                                                                " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Option 6                                                                " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Option 7                                                                " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Option 8                                                                " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Option 9                                                                " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Option 10                                                               " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Option 11                                                               " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "╚════╧═════════════════════════════════════════════════════════════════════════╝" }
        }

        It "Displays on Missing LineWidth" {
            Mock Write-Host {}
            Mock Read-Host {return "0"}
            $JSON = Get-Content .\Tests\TestInput-MissingLineWidth.json
            Format-Menu -InputJSON $JSON
            Should -Invoke Write-Host -Exactly 61 -Scope It
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "╔════╤═════════════════════════════════════════════════════════════════════════╗" }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "║    │" }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "Test Menu" }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "╠════╪═════════════════════════════════════════════════════════════════════════╣" }
            Should -Invoke Write-Host -Exactly 23 -Scope It -ParameterFilter { $Object -eq "║" }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "  0 " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "  1 " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "  2 " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "  3 " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "  4 " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "  5 " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "  6 " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "  7 " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "  8 " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "  9 " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " 10 " }
            Should -Invoke Write-Host -Exactly 11 -Scope It -ParameterFilter { $Object -eq "│" }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Option 1                                                                " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Option 2                                                                " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Option 3                                                                " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Option 4                                                                " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Option 5                                                                " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Option 6                                                                " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Option 7                                                                " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Option 8                                                                " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Option 9                                                                " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Option 10                                                               " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Option 11                                                               " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "╚════╧═════════════════════════════════════════════════════════════════════════╝" }
        }

        It "Displays on Smaller LineWidth" {
            Mock Write-Host {}
            Mock Read-Host {return "0"}
            $JSON = Get-Content .\Tests\TestInput-SmallerLineWidth.json
            Format-Menu -InputJSON $JSON
            Should -Invoke Write-Host -Exactly 11 -Scope It
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "╔═══╤══════════════════════════════════╗" }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "║   │" }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "Test Menu" }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "╠═══╪══════════════════════════════════╣" }
            Should -Invoke Write-Host -Exactly 3 -Scope It -ParameterFilter { $Object -eq "║" }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " 0 " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "│" }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Option 1                         " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "╚═══╧══════════════════════════════════╝" }
        }

        It "Displays on Missing Colors" {
            Mock Write-Host {}
            Mock Read-Host {return "0"}
            $JSON = Get-Content .\Tests\TestInput-MissingColors.json
            Format-Menu -InputJSON $JSON
            Should -Invoke Write-Host -Exactly 11 -Scope It
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "╔═══╤══════════════════════════════════════════════════════════════════════════╗" }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "║   │" }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "Test Menu" }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "╠═══╪══════════════════════════════════════════════════════════════════════════╣" }
            Should -Invoke Write-Host -Exactly 3 -Scope It -ParameterFilter { $Object -eq "║" }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " 0 " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "│" }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq " Option 1                                                                 " }
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "╚═══╧══════════════════════════════════════════════════════════════════════════╝" }
        }
    }

    Context "Errors" {
        It "on Missing Header" {
            Mock Write-Host {}
            Mock Read-Host {return "0"}
            $JSON = Get-Content .\Tests\TestInput-MissingHeader.json
            Format-Menu -InputJSON $JSON
            Should -Invoke Write-Host -Exactly 1 -Scope It
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "Error - Missing Header!" }
        }
        
        It "on Missing Menu Items" {
            Mock Write-Host {}
            Mock Read-Host {return "0"}
            $JSON = Get-Content .\Tests\TestInput-MissingHeader.json
            Format-Menu -InputJSON $JSON
            Should -Invoke Write-Host -Exactly 1 -Scope It
            Should -Invoke Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "Error - Missing Menu Items!" }
        }
    }
}