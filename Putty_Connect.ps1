[String]$LocalBackup = ".\Configs\"
[String]$PuttyDesktopPath = ".\"
[String]$PuttyLocalPath = $PuttyDesktopPath
[String]$UserName = "etadmin"
[String]$UserCisco = ""
[String]$UserUnix = ""
[String]$DeviceName = ""
[String]$DeviceIP = ""
[String]$UserInput = ""
[String]$BorderBG = ""
[String]$BorderFG = ""
[String]$ProgressBG = ""
[String]$ProgressFG = ""
#[String]$PuttyLocal = $PuttyLocalPath + "Putty_Connect.ps1"
[String]$Global:ConfigFile = "./config.ini"

#Create our arrays
[Array]$Users = Import-CSV ($PuttyLocalPath + "\Putty_Connect_AuthUser.txt")
[Array]$Devices = Import-CSV ($PuttyLocalPath + "\Putty_Connect_Devices.txt")
[Array]$Subnets = Import-CSV ($PuttyLocalPath + "\Putty_Connect_Subnets.txt")
[Array]$Config = Import-CSV ($Configfile)

#Variables used for "graphical" menu

[String]$Global:VSBC = [String][Char]9474
[Int]$Global:GlobalBFG = $Config.BorderFG
[Int]$Global:GlobalBBG = $Config.BorderBG
[Int]$Global:GlobalMFG = $Config.MenuFG
[Int]$Global:GlobalMBG = $Config.MenuBG
[Int]$Global:GlobalPFG = $Config.ProgressFG
[Int]$Global:GlobalPBG = $Config.ProgressBG


$Users | ForEach-Object {
<#Setup Username per
device type#>
	If ($_.Username -eq $Username) {
		$UserCisco = $_.Cisco
		$UserUnix = $_.Unix
	}
}

Function Main {
	<#
	.SYNOPSIS
	The Main Construct
	.DESCRIPTION
	First it will Log the user as running the script.  Then it will check that the user is Authorized. Finally it Displays the Main Menu.
	#>
	Config
	AuthUser
	DisplayMainMenu
	Close			#Close is only here incase another function breaks.  It never normally gets called from here.
}

Function Config {
	<#
	.SYNOPSIS
	Runs base config options.
	.DESCRIPTION
	As of right now only the host colors and Title Text are configured.
	#>
	#Change Window Settings
	$host.ui.rawui.WindowTitle = "Putty Connect"
	$Buffer = $host.ui.rawui.BufferSize
	$Buffer.width = 81
	$Buffer.height = 50
	$host.ui.rawui.WindowSize = $Buffer
	$host.ui.rawui.Set_BufferSize($Buffer)
}

Function AuthUser {
	<#
	.SYNOPSIS
	Checks if User is Authorized
	.DESCRIPTION
	Open up Putty_Connect_AuthUsers.txt and create ArrUsers.  Runs logged in user against ArrUsers for Authorization.
	#>
	For ($i=0; $i -le $Users.Length; $i++) {
		If ($UserName = $Users[$i].Username) {
			$UserCisco = $Users[$i].Cisco
			$UserUnix = $Users[$i].Unix
		}
	}
	#Check that the environmental variable %USERNAME% is in Putty_Connect_AuthUsers.txt
	If ($UserCisco -eq"") {
		Log "$Username is not an Authorized User" -1
		Close
	}
}

Function DisplayMainMenu {
	<#
	.SYNOPSIS
	Displays Main Menu
	.DESCRIPTION
	Displays an interactive menu to the user.  All Display_________ Functions are written the same way.
	#>
	Clear-Host									#Make sure the console is clear
	FormatMenu 1							#Draw the Top Border
	FormatMenu 4 "    $VSBC Main"					#Draw the Menu Title
	FormatMenu 2								#Draw a Spacer Border
	FormatMenu 4 "  0 $VSBC Close Program"		#Draw a Static Menu Entry	
	FormatMenu 4 "  1 $VSBC Connection Menu"
	FormatMenu 4 "  2 $VSBC Ping Menu"
	FormatMenu 4 "  3 $VSBC Options"
	FormatMenu 3							#Draw the Bottom Border
	
	[Int]$UserInput = Read-Host -prompt "# "	#Wait for and Read User Input
	$UserInput = UserInput 3 $UserInput			#Check if UserInput is valid
	
	Switch ($UserInput) {
		0 {Close}
		1 {DisplayConnectMenu}
		2 {DisplayPingMenu}
		3 {DisplayOptionsMenu}
		default {DisplayMainMenu}				#Default back to this function if all else fails. This should only be called in the event a -1 is returned from UserInput
	}
}

Function DisplayConnectMenu {
	<#
	.SYNOPSIS
	Display Connect Menu
	.DESCRIPTION
	Displays an Interactive menu to user created from Putty_Connect_Devices.txt
	#>
	Clear-Host
	FormatMenu 1
	FormatMenu 4 "    $VSBC Connection"
	FormatMenu 2
	FormatMenu 4 "  0 $VSBC Goto Main Menu"
	FormatMenu 5 -Arr $Devices -Col 'Device_Name' #User the Array $Devices to create a menu
	FormatMenu 3
	
	[Int]$UserInput = Read-Host -prompt "# "
	$UserInput = UserInput $Devices.Length $UserInput
	
	Switch ($UserInput) {
		-1 {DisplayConnectMenu}
		0 {DisplayMainMenu}
		default {ConnectSetup}
	}
}

Function DisplayOptionsMenu {
	<#
	.SYNOPSIS
	Display Options Menu
	.DESCRIPTION
	Displays a menu to user
	#>
	Clear-Host
	FormatMenu 1
	FormatMenu 4 "    $VSBC Options"
	FormatMenu 2
	FormatMenu 4 "  0 $VSBC Goto Main Menu"
	FormatMenu 4 "  1 $VSBC Local Config File Folder"
	FormatMenu 4 "  2 $VSBC Local Putty Folder"
	FormatMenu 4 "  3 $VSBC Change Script Colors"
	FormatMenu 4 "  4 $VSBC Update IANA Ports"
	FormatMenu 4 "  5 $VSBC Reload Script"
	FormatMenu 3
	
	[Int]$UserInput = Read-Host -prompt "# "
	$UserInput = UserInput 5 $UserInput
	
	Switch ($UserInput) {
		0 {DisplayMainMenu}
		1 {explorer.exe $LocalBackup}
		2 {explorer.exe $PuttyDesktopPath}
		3 {DisplayColorMenu}
		4 {UpdateListFromIANA}
		5 {Reload}
		default {DisplayMainMenu}
	}
	DisplayOptionsMenu
}

Function DisplayPingMenu {
	<#
	.SYNOPSIS
	Display Ping Menu
	.DESCRIPTION
	Displays a menu to user to ping Single IPs or Subnets
	#>
	$SkipLines = 4

	Clear-Host
	FormatMenu 1
	FormatMenu 4 "    $VSBC Ping"
	FormatMenu 2
	FormatMenu 4 "  0 $VSBC Goto Main Menu"
	FormatMenu 4 "  1 $VSBC Single Host"
	FormatMenu 4 "  2 $VSBC Multi host"
	FormatMenu 4 "  3 $VSBC Ping DNS"
	FormatMenu 5 -Arr $Subnets -Col 'Subnet_Name' -Skip $SkipLines
	FormatMenu 3
	
	[Int]$UserInput = Read-Host -prompt "# "
	$UserInput = UserInput ($Subnets.Length + $SkipLines) $UserInput
	
	Switch ($UserInput) {
		-1 {DisplayPingMenu}
		0 {DisplayMainMenu}
		1 {
			Clear-Host
			FormatMenu 1
			FormatMenu 4 "    $VSBC Type in the IP Address"
			FormatMenu 3
			$IP = Read-Host -prompt "# "
			$result = Test-Connection $IP -Quiet
			If ($result -eq $True) {
				Write-Host $IP" is reachable"
			} Else {Write-Host $IP" is down"}
			Read-Host "Press the Enter key to continue"
		}
		2 {
			Clear-Host
			FormatMenu 1
			FormatMenu 4 "    $VSBC Type in the Start IP address"
			FormatMenu 3
			$IPStart = Read-Host -prompt "# "
			Clear-Host
			FormatMenu 1
			FormatMenu 4 "    $VSBC Type in the End IP address"
			FormatMenu 3
			$IPEnd = Read-Host -prompt "# "
			Clear-Host
			ping-IPRange -startaddress $IPStart -endaddress $IPend -interval 20
			Write-Host "Results for $IPStart to $IPEnd"
			Read-Host "Press the Enter key to continue"
		}
		3 {
			Clear-Host
			SetupPingDNS
			PingDNS
		}
		default {
			#Clear-Host
			write-host $UserInput
			ping-IPRange -startaddress $Subnets[$UserInput - $SkipLines].Network_Start -endaddress $Subnets[$UserInput - $SkipLines].Network_End -interval 20
			Write-Host "Results for "$Subnets[$UserInput - $SkipLines].Subnet_Name
			Read-Host "Press the Enter key to continue"
		}
	}
	DisplayPingMenu
}

Function DisplayColorMenu {
	<#
	.SYNOPSIS
	Display Color Menu
	.DESCRIPTION
	Displays a menu to user to allow custom colors
	#>
	Clear-Host
	FormatMenu 1
	FormatMenu 4 "    $VSBC Change Colors"
	FormatMenu 4 "    $VSBC Colors can be"
	FormatMenu 2
	FormatMenu 4 "  0 $VSBC Black"
	FormatMenu 4 "  1 $VSBC Dark Blue"
	FormatMenu 4 "  2 $VSBC Dark Green"
	FormatMenu 4 "  3 $VSBC Dark Cyan"
	FormatMenu 4 "  4 $VSBC Dark Red"
	FormatMenu 4 "  5 $VSBC Dark Magenta"
	FormatMenu 4 "  6 $VSBC Dark Yellow"
	FormatMenu 4 "  7 $VSBC Grey"
	FormatMenu 4 "  8 $VSBC Dark Grey"
	FormatMenu 4 "  9 $VSBC Blue"
	FormatMenu 4 " 10 $VSBC Green"
	FormatMenu 4 " 11 $VSBC Cyan"
	FormatMenu 4 " 12 $VSBC Red"
	FormatMenu 4 " 13 $VSBC Magenta"
	FormatMenu 4 " 14 $VSBC Yellow"
	FormatMenu 4 " 15 $VSBC White"
	FormatMenu 2
	FormatMenu 4 "    $VSBC Border Background"
	FormatMenu 3
	[Int]$UserInput = Read-Host -prompt "# "
	$BorderBG = UserInput 15 $UserInput
	FormatMenu 1
	FormatMenu 4 "    $VSBC Border Foreground"
	FormatMenu 3
	[Int]$UserInput = Read-Host -prompt "# "
	$BorderFG = UserInput 15 $UserInput
	FormatMenu 1
	FormatMenu 4 "    $VSBC Menu Background"
	FormatMenu 3
	[Int]$UserInput = Read-Host -prompt "# "
	$MenuBG = UserInput 15 $UserInput
	FormatMenu 1
	FormatMenu 4 "    $VSBC Menu Foreground"
	FormatMenu 3
	[Int]$UserInput = Read-Host -prompt "# "
	$MenuFG = UserInput 16 $UserInput
	FormatMenu 1
	FormatMenu 4 "    $VSBC Progress Background"
	FormatMenu 3
	[Int]$UserInput = Read-Host -prompt "# "
	$ProgressBG = UserInput 15 $UserInput
	FormatMenu 1
	FormatMenu 4 "    $VSBC Progress Foreground"
	FormatMenu 3
	[Int]$UserInput = Read-Host -prompt "# "
	$ProgressFG = UserInput 15 $UserInput
	
	#Save the new Config
	"BorderBG,BorderFG,MenuBG,MenuFG,ProgressBG,ProgressFG" | Out-File $ConfigFile
	"$BorderBG,$BorderFG,$MenuBG,$MenuFG,$ProgressBG,$ProgressFG" | Out-File $ConfigFile -append
	DisplayOptionsMenu
}

Function ConnectSetup {
	<#
	.SYNOPSIS
	Setup for Connections
	.DESCRIPTION
	Pulls information about user selected device for use in setting up connections
	#>
	$DeviceName = $Devices[$UserInput - 1].Device_Name
	$DeviceIP = $Devices[$UserInput - 1].IP_Address
	$DeviceCert = $Devices[$UserInput - 1].Cert
	Switch ($Devices[$UserInput - 1].Devices_Type) {
		"cisco" {$UserName = $UserCisco}
		"fw" {$UserName = Read-Host -prompt "What login do you want to use"}
		"nsm" {$arg = @('-ssh', '-2', $DeviceIP)
			& "PuttyLocalPath\putty.exe" $arg
			Return}
		"unix" {$UserName = $UserUnix}
	}
	Connect $UserName $DeviceIP $DeviceCert
}

Function Connect {
	<#
	.SYNOPSIS
	Connect to device
	.DESCRIPTION
	Use user selected options to connect to device via putty
	.PARAMETER UserName
	Username to use for connection
	.PARAMETER IP
	Does device have require a cert for connection
	Bool
	#>
	$arg = @('-ssh', '-2', "-l", $args[0], $args[1])
	& "$PuttyLocalPath\putty.exe" $arg
	$LogEntry = $Username + " connected to " + $DeviceName
	Log $LogEntry 2
	DisplayConnectMenu
}

Function UserInput {
	<#
	.SYNOPSIS
	Validate User Input
	.DESCRIPTION
	Makes sure UserInput is a valid integer
	.PARAMETER ArraySize
	Size of array to compute with
	.PARAMETER UserInput
	Value that the user inputs
	#>
	If ($args[1] -is [Int]) {
		If ($args[1] -gt $args[0]) {-1}
			Else {[Int]$args[1]}
	}	Else {-1}
}

Function Close {
	<#
	.SYNOPSIS
	Close script
	.DESCRIPTION
	Clean up, Log close, and close gracefully
	#>
	Write-Host "bye"
	Exit
}

Function Reload {
	<#
	.SYNOPSIS
	Reload Script
	.DESCRIPTION
	Open a new version of the script and close this one
	#>
	Write-Warning "Reloading Script"
	Set-Location $PuttyLocalPath
	Start-Process ".\Putty_Connect.bat"
	Close
}

Function SetupPingDNS {

	$IntId = Get-NetAdapter | where status -eq "up" | select -Property "interfaceindex"
	$DNS = Get-DnsClientServerAddress | where InterfaceIndex -eq $IntId.interfaceindex
	$Ping = "ping -t " + $DNS[0].ServerAddresses[0]
	Start-Process powershell -ArgumentList $Ping
	#start-process powershell '-noexit -command "[console]::windowwidth=100; [console]::windowheight=50; [console]::bufferwidth=[console]::windowwidth"' -ArgumentList $Ping
}

Function StatsPingDNS {

	[CmdletBinding(ConfirmImpact='Low')]
	Param(
        [Parameter(Mandatory = $True, Position = 1)][Int]$RepliesOrig,
        [Parameter(Mandatory = $True, Position = 2)][Int]$RequestsOrig
	)

	$RepliesTotal = ICMPReply
	$RequestTotal = ICMPRequest

	$RepliesTotal = ($RepliesTotal-$RepliesOrig)
	$RequestTotal = ($RequestTotal-$RequestsOrig)
	
	If ($RequestTotal -eq 0) { $PrecentReply = "100%" }
	else {$PrecentReply = (($RepliesTotal)/($RequestTotal)).ToString("P")}
	
	$Time = (Get-Date -DisplayHint time).ToString()
	
	$Output = "`n`r" + $Time + "`n`r"
	$Output = $Output + "`t" + "Total Requests : " + $RequestTotal + "`n`r"
	$Output = $Output + "`t" + "Total Replies : " + $RepliesTotal + "`n`r"
	$Output = $Output + "`t" + "Percent Reply : " + $PrecentReply
	Return $Output

}

Function ICMPReply{

	$Replies = netsh interface ipv4 show icmpstats | Select-String "Echo Replies"
	[Int]$Replies0 = $Replies[0] -replace '\D+(\d+)','$1'
	[Int]$Replies1 = $Replies[1] -replace '\D+(\d+)','$1'
	[Int]$RepliesTotal = $Replies0 + $Replies1
	Return $RepliesTotal

}

Function ICMPRequest{

	$Requests = netsh interface ipv4 show icmpstats | Select-String "Echo Requests"
	[Int]$Requests0 = $Requests[0] -replace '\D+(\d+)','$1'
	[Int]$Requests1 = $Requests[1] -replace '\D+(\d+)','$1'
	[Int]$RequestTotal = $Requests0 + $Requests1
	Return $RequestTotal

}

Function PingDNS {

	$Title = "Refresh in 30 secs"
	$Blank = "`b" * ($Title.Length+11)
	$Anim = @("o.......o0","0o.......o","o0o.......",".o0o......","..o0o.....","...o0o....","....o0o...",".....o0o..","......o0o.",".......o0o")

	$RepliesTotal = ICMPReply
	$RequestTotal = ICMPRequest
	Start-Process ".\Putty_Connect.bat"
	While($True){
		StatsPingDNS $RepliesTotal $RequestTotal
		for ($i = 0; $i -lt 30; $i++) {
			$Anim | % {
				Write-Host -ForegroundColor $Global:GlobalPFG -BackgroundColor $Global:GlobalPBG "$Blank$Title $_" -NoNewline
				Start-Sleep -Milliseconds 100
			}
		}
	}
}

Function Global:ping-IPRange {
	<#
	.SYNOPSIS
	Ping an IP Range
	.DESCRIPTION
	This will ping a range of IP addresses.  It is modified to show a simplified progress bar and output headers each time
	.PARAMETER IPStart
	Starting IP address
	.PARAMETER IPEnd
	End IP address
	#>
	[CmdletBinding(ConfirmImpact='Low')]
	Param(
		[Parameter(Mandatory = $True, Position = 0)][System.Net.IPAddress]$StartAddress,
		[Parameter(Mandatory = $True, Position = 1)][System.Net.IPAddress]$EndAddress,
		[Int]$Interval = 30,
		[Switch]$RawOutput = $False
	)
	
	$Timeout = 2000
	
	Function New-Range ($Start, $End) {
		[Byte[]]$BySt = $Start.GetAddressBytes()
		[Array]::Reverse($BySt)
		[Byte[]]$ByEn = $End.GetAddressBytes()
		[Array]::Reverse($ByEn)
		$i1 = [System.BitConverter]::ToUInt32($BySt,0)
		$i2 = [System.BitConverter]::ToUInt32($ByEn,0)
		For ($x = $i1; $x -le $i2; $x++) {
			$IP = ([System.Net.IPAddress]$x).GetAddressBytes()
			[Array]::Reverse($IP)
			[System.Net.IPAddress]::Parse($($IP -join '.'))
		}
	}
	
	$IPRange = New-Range $StartAddress $EndAddress
	$IPTotal = $IPRange.Count
	
	Get-Event -SourceIdentifier "ID-Ping*" | Remove-Event
	Get-EventSubscriber -SourceIdentifier "ID-Ping*" | Unregister-Event
	
	Write-Host "Sending Pings"
	$IPRange | ForEach {
		[String]$VarName = "Ping_" + $_.Address
		New-Variable -Name $VarName -Value (New-Object System.Net.NetworkInformation.Ping)
		Register-ObjectEvent -InputObject (Get-Variable $VarName -ValueOnly) -EventName PingCompleted -SourceIdentifier "ID-$VarName"
		(Get-Variable $VarName -ValueOnly).SendAsync($_,$Timeout,$VarName)
		Remove-Variable $VarName
		Try {
			$Pending = (Get-Event -SourceIdentifier "ID-Ping*").Count
		} Catch [System.InvalidOperationException]{}
		$Index = [Array]::indexof($IPRange,$_)
		Start-Sleep -Milliseconds $Interval
	}
	
	Write-Host "Done Sending Pings. Awaiting Response"
	$Title = "Waiting for ping reply"
	$Blank = "`b" * ($Title.Length+11)
	$Anim = @("o.......o0","0o.......o","o0o.......",".o0o......","..o0o.....","...o0o....","....o0o...",".....o0o..","......o0o.",".......o0o")
	
	While ($Pending -lt $IPTotal) {
		Wait-Event -SourceIdentifier "ID-Ping*" | Out-Null
		$Anim | % {
			#Write-Host -ForegroundColor $ProgressFG -BackgroundColor $ProgressBG "$Blank$Title $_" -NoNewLine
			Write-Host "$Blank$Title $_" -NoNewLine
			Start-Sleep -Milliseconds 100
		}
		$Pending = (Get-Event -SourceIdentifier "ID-Ping*").Count
	}
	
	If ($RawOutput) {
		$Reply = Get-Event -SourceIdentifier "ID-Ping*" | ForEach {
			If ($_.SourceEventArgs.Reply.Status -eq "Success") { $_.SourceEventArgs.Reply}
			Unregister-Event $_.SourceIdentifier
			Remove-Event $_.SourceIdentifier
		}
	} Else {
		$Reply = Get-Event -SourceIdentifier "ID-Ping*" | ForEach {
			If ($_.SourceEventArgs.Reply.Status -eq "Success") { 
				$_.SourceEventArgs.Reply | Select @{Name="IPAddress" ; Expression={$_.Address}},
												  @{Name="Bytes" ; Expression={$_.Buffer.Length}},
												  @{Name="ResponseTime" ; Expression={$_.RoundtripTime}},
												  @{Name="Status" ; Expression={$_.Status}}
			}
			Unregister-Event $_.SourceIdentifier
			Remove-Event $_.SourceIdentifier
		}
	}
	
	If ($Reply -eq $Null) {Write-Host "No IP Address Responded"}
	$Reply | Format-Table -expand Both
}

function UpdateListFromIANA{

	# IANA --> Service Name and Transport Protocol Port Number Registry -> xml-file
	$IANA_PortList_WebUri = "https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.txt"
	# Port list path
	$Backup_Services_Path = ".\IANA_ServiceName_and_TransportProtocolPortNumber_Registry.txt"
	$Services_Path = ".\services"

	try{
		Write-Verbose -Message "Create backup of the IANA Service Name and Transport Protocol Port Number Registry..."
		# Backup file, before donload a new version
		if(Test-Path -Path $Services_Path -PathType Leaf){Rename-Item -Path $Services_Path -NewName $Backup_Services_Path}

		Write-Verbose -Message "Updating Service Name and Transport Protocol Port Number Registry from IANA.org..."

		# Download xml-file from IANA and save it
		$New_XML_PortList = Invoke-WebRequest -Uri $IANA_PortList_WebUri -ErrorAction Stop -OutFile $Services_Path

		# Remove backup, if no error
		if(Test-Path -Path $Services_Path -PathType Leaf){Remove-Item -Path $Backup_Services_Path}

	}
	catch{
		Write-Verbose -Message "Cleanup downloaded file and restore backup..."

		# On error: cleanup downloaded file and restore backup
		if(Test-Path -Path $Services_Path -PathType Leaf){Remove-Item -Path $Services_Path -Force}
		if(Test-Path -Path $Backup_Services_Path -PathType Leaf){Rename-Item -Path $Backup_Services_Path -NewName $Services_Path}
		$_.Exception.Message  
	}
} 

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


Main