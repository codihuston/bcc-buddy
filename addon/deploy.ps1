$WOWAddonsPath = "E:\World of Warcraft\_classic_\Interface\AddOns\"
$AddonName = "HelloWorld"
$AddonPath = "$WOWAddonsPath/$AddonName"

New-Item -ItemType Directory -Path $AddonPath -ErrorAction SilentlyContinue
Copy-Item "$PSScriptRoot/src/*" $AddonPath