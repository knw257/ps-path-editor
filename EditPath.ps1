$path = [Environment]::GetEnvironmentVariable('path','machine')
$patharr = $path -split ';'


function Show-Options {
write-host ""
write-host "Please choose an option"
write-host "1. Print Current Path Directories"
write-host "2. Add to system path"
write-host "3. Remove from system path"
write-host "4. Modify item in path"
write-host "5. Commit changes"

$sel = read-host -prompt "Please make a selection"

if($sel -eq 1){
    Print-Path
} elseif($sel -eq 2){
    Add-Path
} elseif ($sel -eq 3){
    Remove-Path
} elseif ($sel -eq 4){
    Modify-Path
} elseif($sel -eq 5){
    Commit-Changes
} else {
    write-host "You selection, $sel, is not valid. Please select a valid option"
    Show-Options
}
}

function Print-Path {
	$patharr = $global:patharr
    write-host ""
    write-host "Your new path directories"
    $patharr.foreach({write-host "$([array]::IndexOf($patharr, $_)+1). $_"})
    write-host ""
    write-host "You can make further changes, or commit them to save to the system"
    Show-Options
}

function Add-Path {
    #write-host "You want to add a directory to the path variable"
    $newdir = Read-Host "Please enter the directory you'd like to add"
    $global:patharr += $newdir
    Print-Path
}

function Remove-Path {
    #write-host "You want to remove a directory from the path variable"
    $remsel = Read-Host "Please enter the number of the selection you wish to remove"
    $remsel = $remsel - 1
    write-host ("Removing " + $patharr[$remsel])
    $global:patharr = $patharr | where {$_ -ne $patharr[$remsel]}
    Print-Path
}

function Modify-Path {
    #write-host "You want to change one of the directories in the path variable"
    do{
        $modsel = Read-Host "Please enter the number of the selection you want to change"
        $modsel -= 1
        $conf = read-host ("You are trying to change " + $patharr[$modsel] + ", correct? (Y/n)")
    } while ($conf -eq 'n')
    
    do{
        $np = Read-Host ("Please enter the new path")
        $conf = Read-Host ("Are you sure you want to replace " + $patharr[$modsel] + " with " + $np + "? (Y/n)")
    } while ($conf -eq 'n')
    
    $global:patharr[$modsel] = $np
    Print-Path
}

function Commit-Changes {
    #write-host "Change commit not yet programmed, exiting"
    $newpath = $global:patharr -join ';'
    write-host "The following directories will be committed to the system Path variable:"
    $newpath -split ';'
    write-host ""
    write-host "This is the string which will be saved as the system Path variable"
    $newpath
    write-host ""
    write-host "*WARNING: THIS CANNOT BE UNDONE*"
    $conf = Read-Host "Are you sure you want to set the above as your system Path variable? (y/N)"
    if ($conf -ne 'y'){
        Print-Path
    }
    write-host "Saving to machine-level Environment Variable 'Path'"
    [Environment]::SetEnvironmentVariable("path", $newpath, "machine")
}

write-host "Your current path directories"
$patharr.foreach({write-host "$([array]::IndexOf($patharr, $_)+1). $_"})
Show-Options