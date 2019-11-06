## --- CreateDoco - Quick create an ADOC structure for a new docment.
##     This PS script needs to be available from anywhere
##     use alias quickest way


clear-host
convert-text2ascii -text "Create-Doco" 
write-host 'Create a new ADOC folder for a new document - V2.1f' -ForegroundColor cyan
write-host 'GeekMustHave' -ForegroundColor Yellow

$dirName = read-host 'Enter the folder name for new ADOC document' 
$currentFolder = get-location
$myCommands = "c:\myCommands\PowerShellScripts\create-doco"   # --- Where are title images collection kept at 11/28/18 changed

# --- @TODO - display full path name
$fullFolderPath = "$currentFolder\$dirName"

# --- Verify folder doesn't  already exist
if ( -not (test-path $fullFolderPath)) {
  write-host 'This new folder '$fullFolderPath' will be created under the current directory.' -ForegroundColor Yellow
  new-item -itemType directory -name "./$dirName"
}
else {
  write-host 'That folder already exist' -ForegroundColor Red
  exit
}

# --- Create images under new folder
Write-Host "Creating 'images' sub-folder" -ForegroundColor Yellow
new-item -ItemType Directory -name "./$dirName/images"

# --- copy ALL logo images into images directory
Write-Host "Copying title-logo collection into 'images' sub-folder" -ForegroundColor Yellow
copy-item -path $myCommands\create-doco*.png -destination ./$dirName/images

$docoTitle = read-host "`nEnter the Document Title" 

# --- Create a .gitignore with a single line in it.
write-host "Creating '.gitignore' file" -ForegroundColor Yellow
New-Item -Path "./$dirName" -Name ".gitignore" -ItemType file -Value ".gitignore"

# --- Copy the readme.template into the document folder
Write-Host "Copying 'readme.adoc' template document" -ForegroundColor Yellow
copy-item -path $myCommands\create-doco_readme.adoc -destination ./$dirName/readme.adoc

# --- Change the Docutment Title
((Get-Content -path ./$dirName/readme.adoc -Raw) -replace 'xxyyzz', $docoTitle) | Set-Content -Path ./$dirName/readme.adoc


# --- Change the mm/dd/yyyy to todays date in the readme.adoc
$timeStamp = get-date  -f "MM/dd/yyyy"
((Get-Content -path ./$dirName/readme.adoc -Raw) -replace 'mm/dd/yyyy', $timeStamp) | Set-Content -Path ./$dirName/readme.adoc



# --- create the highligh folder for code highlighting
##Write-Host "Creating 'highlight' sub-folder" -ForegroundColor Yellow
##new-item -ItemType Directory -name "./$dirName/highlight"

# --- Copy the highligh language bundle I created
##Write-Host "Copying highlight.min.js file into 'highlight' sub-folder" -ForegroundColor Yellow
##copy-item -path $myCommands\CreateDoco_highlight.min.js -destination ./$dirName/highlight/highlight.min.js

# --- create the styles folder under the highlight for code highlighting
##Write-Host "Creating 'styles' sub-folder" -ForegroundColor Yellow
##new-item -ItemType Directory -name "./$dirName/highlight/styles"

# --- Copy the github.min.css file to styles
#Write-Host "Copying highlight.min.js file into 'highlight' sub-folder" -ForegroundColor Yellow
#copy-item -path $myCommands\CreateDoco_github.min.css  -destination ./$dirName/highlight/styles/github.min.css 


# --- create the git repository with first commit -PassThru display PWD
Set-Location -Path ./$dirName -PassThru
Write-Host "Creating GIT repository" -ForegroundColor Yellow

git init  
git add . 
git commit -m'Initial document created'

# --- Start up vsCode?
#     reference: https://stackoverflow.com/questions/24649019/how-to-use-confirm-in-powershell/24649481
$message = '** Start editing **'
$question = 'Start Visual Studio Code?'

$choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
$choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

$decision = $Host.UI.PromptForChoice($message, $question, $choices, 0)
if ($decision -eq 0) {
  code .
  exit
}
else {
  Write-Host 'CreateDoco completed.' -ForegroundColor cyan

}










## -- History
##  
##    Date     Version  Author    Descriotion
## 11/01/2019   V2.1j    JHRS     Adjusted the Header area of generated document :title-page:
## 12/06/2018   V2.1h    JHRS     Changed ASCII banner to avoid font, requires Internet access
## 12/05/2018   V2.1g    JHRS     Add select for the Image name
## 11/28/2018   V2.1f    JHRS     Changed Blue to Cyan
##                                Added current date replacement
##                                Added Document Title prompt and repalcement
## 11/28/2018   V2.1F    JHRS     Renamed create-doco to more PS like commandlet
## 11/21/2018   V2.1e    JHRS     Clean up, update tempate doco
##                                Remove `highlight` as the syntax highligher
##                                Replace with Code ray
## 11/07/2018   V2.1c    JHRS     Added updated highlight library
## 10/26/2018   V2.1b    JHRS     Brain fart