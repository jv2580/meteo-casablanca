$ErrorActionPreference = 'Stop'

$buildDir = Join-Path $PSScriptRoot '_docxbuild2'
New-Item -ItemType Directory -Force -Path (Join-Path $buildDir 'word') | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $buildDir '_rels') | Out-Null

function P([string]$text, [string]$style) {
    switch ($style) {
        'title'   { return '<w:p><w:pPr><w:jc w:val="center"/></w:pPr><w:r><w:rPr><w:b/><w:sz w:val="40"/><w:color w:val="2D5A3D"/></w:rPr><w:t xml:space="preserve">' + $text + '</w:t></w:r></w:p>' }
        'subtitle'{ return '<w:p><w:pPr><w:jc w:val="center"/></w:pPr><w:r><w:rPr><w:sz w:val="20"/><w:color w:val="666666"/></w:rPr><w:t xml:space="preserve">' + $text + '</w:t></w:r></w:p>' }
        'h2'      { return '<w:p><w:pPr><w:spacing w:before="320" w:after="120"/></w:pPr><w:r><w:rPr><w:b/><w:sz w:val="28"/><w:color w:val="2D5A3D"/></w:rPr><w:t xml:space="preserve">' + $text + '</w:t></w:r></w:p>' }
        'bullet'  { return '<w:p><w:pPr><w:spacing w:after="60"/><w:ind w:left="360" w:hanging="180"/></w:pPr><w:r><w:t xml:space="preserve">•  ' + $text + '</w:t></w:r></w:p>' }
        'num'     { return '<w:p><w:pPr><w:spacing w:after="80"/><w:ind w:left="360" w:hanging="240"/></w:pPr><w:r><w:rPr><w:b/></w:rPr><w:t xml:space="preserve">' + $text + '</w:t></w:r></w:p>' }
        default   { return '<w:p><w:pPr><w:spacing w:after="120"/></w:pPr><w:r><w:t xml:space="preserve">' + $text + '</w:t></w:r></w:p>' }
    }
}

$paras = @()
$paras += P 'Application Calories et Nutrition' 'title'
$paras += P ('Resume et points d amelioration - genere le ' + (Get-Date -Format 'dd/MM/yyyy') + ' - depot github.com/jv2580/meteo-casablanca') 'subtitle'

$paras += P '1. Presentation de l application' 'h2'
$paras += P 'L application calcule les besoins caloriques quotidiens a partir du profil (age, sexe, poids, taille), des activites sportives pratiquees chaque jour et de l objectif choisi : perdre du poids, maintenir son poids ou prise de masse. Elle affiche les calories cibles, la repartition en macronutriments (proteines, glucides, lipides) et une journee type en trois repas. Le tout tient dans une seule page web (calories/index.html), utilisable sur ordinateur et sur telephone.'
$paras += P 'Calculs utilises : metabolisme de base selon l equation de Mifflin-St Jeor (reference scientifique), depense hors sport egale au metabolisme de base multiplie par 1,375, calories du sport via les coefficients MET propres a chaque activite. Objectif perte de poids : deficit de 500 kcal par jour (environ moins 0,5 kg de gras par semaine). Prise de masse : surplus de 300 kcal par jour. Proteines : 2 g par kg en seche, 1,8 g en prise de masse, 1,6 g en maintien. Lipides : 27 pourcent des calories. Glucides : le reste.'

$paras += P '2. Fonctionnalites actuelles' 'h2'
$paras += P 'Profil complet : age, sexe, poids, taille, avec validation des valeurs (age 10-100, poids 30-250 kg, taille 120-230 cm).' 'bullet'
$paras += P 'Onze activites sportives : marche, course a pied, velo, natation, musculation, volley-ball, football, basket-ball, tennis, danse et corde a sauter (minutes par jour).' 'bullet'
$paras += P 'Trois objectifs : perdre du poids, maintenir, prise de masse.' 'bullet'
$paras += P 'Allergies a exclusion stricte (sante) : lactose, gluten, fruits a coque, poisson, oeufs. Aucun aliment exclu ne peut apparaitre dans les repas.' 'bullet'
$paras += P 'Gouts personnels separés des allergies : chaque categorie (viande, poisson, oeufs, laitages, legumineuses) accepte un cycle j aime / j aime pas au clic. Les aliments apprecies sont privilegies, ceux declinees ne servent qu en dernier recours.' 'bullet'
$paras += P 'Mode vegetarien : place viande et poisson en j aime pas en un clic.' 'bullet'
$paras += P 'Bouton Varier les repas : propose a chaque clic une nouvelle combinaison de repas adaptée aux filtres actifs.' 'bullet'
$paras += P 'Base d une vingtaine d aliments variés, dont des petit-dejeuners sans gluten ni lactose.' 'bullet'

$paras += P '3. Verifications effectuees' 'h2'
$paras += P 'Calculs controles a la main : homme de 30 ans, 75 kg, 175 cm, 30 minutes de marche donne bien un metabolisme de base de 1699 kcal, un maintien a 2467 kcal et une cible de 1970 kcal avec 150 g de proteines.' 'bullet'
$paras += P 'Nouveau sport verifie : 60 minutes de volley a 75 kg consomment 300 kcal (MET 4,0).' 'bullet'
$paras += P 'Allergies : parcours automatique de 12 variations avec lactose, gluten, poisson et oeufs exclus - aucune violation detectee (les mots lait d avoine ou yaourt de soja sont des aliments autorises, sans lactose).' 'bullet'
$paras += P 'Gouts : avec oeufs en j aime, 7 petit-dejeuners sur 14 en contiennent (favorises) ; en j aime pas, 0 sur 14 (ecartes tant que des alternatives existent).' 'bullet'
$paras += P 'Cas extremes : combinaison de filtres trop restrictive affiche un message clair invitant a retirer une contrainte.' 'bullet'

$paras += P '4. Points d amelioration prevus' 'h2'
$paras += P 'Sauvegarde du profil et suivi du poids dans le temps avec graphique de progression (stockage local du telephone).' 'num'
$paras += P 'Journal alimentaire : composer ses repas reels de la journee et voir les calories restantes par rapport a la cible.' 'num'
$paras += P 'Base d aliments enrichie avec calories et macros par aliment, quantites ajustees automatiquement a la cible.' 'num'
$paras += P 'Version application mobile sur App Store via Expo (necessite l installation de Node.js, en attente sur ce PC).' 'num'
$paras += P 'Plan de repas sur 7 jours genere automatiquement avec liste de courses.' 'num'
$paras += P 'Recherche d aliments par code-barres via l API gratuite Open Food Facts.' 'num'
$paras += P 'Compte utilisateur pour retrouver ses donnees sur plusieurs appareils.' 'num'
$paras += P 'Export PDF des recommandations et partage du resume.' 'num'

$paras += P '5. Utilisation' 'h2'
$paras += P 'Ouvrir le fichier calories/index.html dans un navigateur, ou utiliser la version publiee sur Vercel. Sur iPhone ou Android, ajouter la page a l ecran d accueil pour l utiliser comme une application.'
$paras += P 'Avertissement : les estimations reposent sur des equations scientifiques reconnues mais restent indicatives et ne remplacent pas un avis medical ou dietetique professionnel.'

$body = $paras -join ''
$documentXml = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
    '<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"><w:body>' +
    $body +
    '<w:sectPr><w:pgSz w:w="11906" w:h="16838"/><w:pgMar w:top="1134" w:right="1134" w:bottom="1134" w:left="1134"/></w:sectPr>' +
    '</w:body></w:document>'

$contentTypes = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="xml" ContentType="application/xml"/><Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/></Types>
'@

$rootRels = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/></Relationships>
'@

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText((Join-Path $buildDir 'word\document.xml'), $documentXml, $utf8NoBom)
[System.IO.File]::WriteAllText((Join-Path $buildDir '[Content_Types].xml'), $contentTypes, $utf8NoBom)
[System.IO.File]::WriteAllText((Join-Path $buildDir '_rels\.rels'), $rootRels, $utf8NoBom)

$xmlCheck = New-Object System.Xml.XmlDocument
$xmlCheck.Load((Join-Path $buildDir 'word\document.xml')) | Out-Null
Write-Output ('XML valide - ' + $paras.Count + ' paragraphes')

$tar = Join-Path $env:SystemRoot 'System32\tar.exe'
Push-Location $buildDir
& $tar -a -cf 'resume.zip' '[Content_Types].xml' '_rels' 'word' 2>&1 | Out-Null
Pop-Location
if ($LASTEXITCODE -ne 0) { throw "tar a echoue avec le code $LASTEXITCODE" }

$out = Join-Path $PSScriptRoot 'Application-Calories-Resume.docx'
Move-Item -Force (Join-Path $buildDir 'resume.zip') $out
Remove-Item -Recurse -Force $buildDir
Write-Output ('OK : ' + $out + ' (' + [math]::Round((Get-Item $out).Length / 1KB, 1) + ' Ko)')
