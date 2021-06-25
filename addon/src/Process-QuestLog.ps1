<#
.DESCRIPTION
This is a prototype script, which will likely be replaced by a Flutter
application. The purpose of this script is to find and parse the saved variables
file for the related addon, and to POST/PUT it to the web api.

If a WTF folder is not found, you will be prompted to enter a valid path.

This supports CmdletBinding(). If you want to see verbose output, be sure
to include the -verbose switch when running the script.

.EXAMPLE
Using the default path to WTF folder:

Process-QuestLog.ps1

.EXAMPLE
Using custom path to WTF folder:

Process-QuestLog.ps1 -Path "E:\World of Warcraft\_classic_\WTF" -Verbose
#>
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$false)]
  [string] $WOW_WTF_PATH="C:\Program Files (x86)\World of Warcraft\_classic_\WTF"
)

$ADDON_NAME = "HelloWorld"
$ADDON_SAVED_VARS_FILE_NAME = "$ADDON_NAME.lua"

function Test-WOWWTFPath{
  <#
  .DESCRIPTION
  Will loop until a path to a existing World of Warcraft WTF directory is given.
  #>
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory=$true)]
    [string]$Path
  )
  $isValid = $false
  while(!$isValid){
    if(!(Test-Path $Path -PathType "Container" -ErrorAction SilentlyContinue)){
      Write-Warning "WoW WTF Directory was not found at: $Path."
      $Path = Read-Host "Please enter the path to your WoW WTF Directory"
  
    }
    else{
      Write-Verbose "Found WoW WTF Directory: $Path"
      $isValid=$true
    }
  }
  return $Path
}

function Get-SavedVariableFilePaths{
  <#
  .DESCRIPTION
  Will attempt to find the saved variable file objects associated with this
  addon.

  .PARAMETER Path
  The path to the World of Warcraft WTF directory under which our target files
  may or may not exist.
  #>
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory=$true)]
    [string]$Path
  )
  $res = @()
  $res += Get-ChildItem -Path "$X\Account\**\SavedVariables\$ADDON_NAME.lua"
  $res += Get-ChildItem -Path "$X\Account\**\**\**\SavedVariables\$ADDON_NAME.lua"
  return $res
}
function main{

  # validate the given wow wtf path
  $WOW_WTF_PATH = Test-WOWWTFPath -Path $WOW_WTF_PATH

  # now attempt to find all saved vars files for this addon
  $filesToParse = Get-SavedVariableFilePaths -Path $WOW_WTF_PATH
  Write-Verbose "Found [$($filesToParse.count)] saved variable files to process."

  foreach ($file in $filesToParse) {
    Write-Verbose "Begin Processing: $($file.Fullname)"
    # TODO: get file contents
    # TODO: validate that you are the owner of the character(s)?
    # TODO: parse for Quest IDs
    # TODO: parse for Character Gear
    # TODO: upload to web api
  }
  
}

main