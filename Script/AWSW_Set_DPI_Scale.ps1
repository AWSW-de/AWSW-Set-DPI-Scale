# Automatic "AWSW Set DPI Scale" script for multiple MS Windows screens" script by AWSW on https://github.com/AWSW-de
# DO NOT CHANGE ANYTHING FROM THIS LINE ON ! # # DO NOT CHANGE ANYTHING FROM THIS LINE ON ! # # DO NOT CHANGE ANYTHING FROM THIS LINE ON ! #

$ScriptVersion = "V1.0.1" # 15.03.2025


#####################################################################################################
# Welcome text outout
#####################################################################################################
clear
Write-Host "AWSW Set DPI Scale - Script Version:" $ScriptVersion
Write-Host " " 
Write-Host "This script can set the DPI scale for multiple screens fully automatically without"
Write-Host "the need to logoff from your current MS Windows 10 or MS Windows 11 session."
Write-Host " "
Write-Host "Kind regards AWSW"
Write-Host " "


#####################################################################################################
# Show project selection menu:
#####################################################################################################
Function CreateMenu{
    param(
        [parameter(Mandatory=$true)][String[]]$Selections,
        [switch]$IncludeExit,
        [string]$Title = $null
        )

    $Width = if($Title){$Length = $Title.Length;$Length2 = $Selections|%{$_.length}|Sort -Descending|Select -First 1;$Length2,$Length|Sort -Descending|Select -First 1}else{$Selections|%{$_.length}|Sort -Descending|Select -First 1}
    $Buffer = if(($Width*1.5) -gt 78){[math]::floor((78-$width)/2)}else{[math]::floor($width/4)}
    if($Buffer -gt 6){$Buffer = 6}
    $MaxWidth = $Buffer*2+$Width+$($Selections.count).length+2
    $Menu = @()
    $Menu += "╔"+"═"*$maxwidth+"╗"
    if($Title){
        $Menu += "║"+" "*[Math]::Floor(($maxwidth-$title.Length)/2)+$Title+" "*[Math]::Ceiling(($maxwidth-$title.Length)/2)+"║"
        $Menu += "╟"+"─"*$maxwidth+"╢"
    }
    For($i=1;$i -le $Selections.count;$i++){
        $Item = "$(if ($Selections.count -gt 9 -and $i -lt 10){" "})$i`. "
        $Menu += "║"+" "*$Buffer+$Item+$Selections[$i-1]+" "*($MaxWidth-$Buffer-$Item.Length-$Selections[$i-1].Length)+"║"
    }
    If($IncludeExit){
        $Menu += "║"+" "*$MaxWidth+"║"
        $Menu += "║"+" "*$Buffer+"X - Exit the script without changes"+" "*($MaxWidth-$Buffer-35)+"║"
    }
    $Menu += "╚"+"═"*$maxwidth+"╝"
    $menu
}

Do{
    #cls
    CreateMenu -Selections '100%','125%','150%','175%','200%','225%','250%' -Title 'Choose the desired DPI scale setting:' -IncludeExit 
    $Response = Read-Host " Choose the desired DPI scale setting"
}While($Response -notin 1,2,3,4,5,'6','7','x')


switch ($Response)
{
    1 { $myDPI = "4294967294"
	$myScale = "100%"}
    2 { $myDPI = "4294967295"
	$myScale = "125%"}
    3 { $myDPI = "0"
	$myScale = "150%"}
    4 { $myDPI = "1"
	$myScale = "175%"}
    5 { $myDPI = "2"
	$myScale = "200%"}
    6 { $myDPI = "3"
	$myScale = "225%"}
    7 { $myDPI = "4"
	$myScale = "250%"}
    x { Exit }
}


function Set-Scaling {
    param($scaling)
$source = @'
    [DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]
    public static extern bool SystemParametersInfo(
                      uint uiAction,
                      uint uiParam,
                      uint pvParam,
                      uint fWinIni);
'@
    $apicall = Add-Type -MemberDefinition $source -Name WinAPICall -Namespace SystemParamInfo –PassThru
    $apicall::SystemParametersInfo(0x009F, $scaling, $null, 1) | Out-Null
    }
Write-Host " "
Write-Host "Changing DPI scaling to:" $myScale "in 3 seconds..."
sleep 3
Set-Scaling $myDPI
Write-Host " "
Write-Host "DPI scaling changed to:" $myScale
sleep 3
Write-Host " "
Write-Host "Exiting script in 3 seconds..."
sleep 3