function translit {
    param(
        [string]$inputString
    )
    $Translit = @{
        [char]'ä' = 'a'
        [char]'ö' = 'o'
        [char]'ü' = 'u'
        [char]'õ' = 'o'
    }
    $outputString = ''
    foreach($charater in $inputString.ToCharArray()){
        if($Translit[$charater] -cne $null) {
           
            $outputString = $outputString + $Translit[$charater]
        } else {
            $outputString = $outputString + $charater
        }
    }
    Write-Output $outputString
}

$users = Import-Csv "C:\Users\Administrator\ps_haldus\adusers.csv" -Encoding Default -Delimiter ";"
foreach ($user in $users) {
    $username = $user.FirstName.ToLower() + "." + $user.LastName.ToLower()
    $username = translit($username)
    $upname = $username + '@sv-kool.local'
    $displayname = $user.FirstName + " " + $user.LastName

    New-ADUser -Name $username `
               -DisplayName $displayname `
               -GivenName $user.FirstName `
               -Surname $user.LastName `
               -Department $user.Department `
               -Title $user.Role `
               -UserPrincipalName $upname `
               -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force) `
               -Enabled $true
}