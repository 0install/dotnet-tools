﻿Param ([Parameter(Mandatory=$True)] [string]$NewVersion)
$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

function SearchAndReplace($FilePath, $PatternLeft, $PatternRight)
{
  (Get-Content "$ScriptDir\$FilePath" -Encoding UTF8) `
    -replace "$PatternLeft.*$PatternRight", ($PatternLeft.Replace('\', '') + $NewVersion + $PatternRight.Replace('\', '')) |
    Set-Content "$ScriptDir\$FilePath" -Encoding UTF8
}

[System.IO.File]::WriteAllText("$ScriptDir\VERSION", $NewVersion)
SearchAndReplace src\GlobalAssemblyInfo.cs -PatternLeft 'AssemblyVersion\("' -PatternRight '"\)'
