$ErrorActionPreference = 'Stop'

$srcPath = Join-Path $PSScriptRoot 'calories\index.html'
$buildDir = Join-Path $PSScriptRoot '_docxbuild'
$wordDir = Join-Path $buildDir 'word'
$relsDir = Join-Path $buildDir '_rels'

New-Item -ItemType Directory -Force -Path $wordDir | Out-Null
New-Item -ItemType Directory -Force -Path $relsDir | Out-Null

# --- Lecture du code source (UTF-8) ---
$lines = [System.IO.File]::ReadAllLines($srcPath, [System.Text.Encoding]::UTF8)

function Esc([string]$s) {
    return $s.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;')
}

# --- Paragraphes de code (Consolas 9pt, interligne serré) ---
$paras = foreach ($line in $lines) {
    $e = Esc $line
    '<w:p><w:pPr><w:spacing w:after="0" w:line="240" w:lineRule="auto"/></w:pPr><w:r><w:rPr><w:rFonts w:ascii="Consolas" w:hAnsi="Consolas"/><w:sz w:val="18"/></w:rPr><w:t xml:space="preserve">' + $e + '</w:t></w:r></w:p>'
}
$codeXml = $paras -join ''

$date = Get-Date -Format 'dd/MM/yyyy'

# --- Corps du document ---
$body = @'
<w:p><w:pPr><w:jc w:val="center"/></w:pPr><w:r><w:rPr><w:b/><w:sz w:val="44"/><w:color w:val="2D5A3D"/></w:rPr><w:t>Application Calories et Nutrition</w:t></w:r></w:p>
<w:p><w:pPr><w:jc w:val="center"/></w:pPr><w:r><w:rPr><w:sz w:val="22"/><w:color w:val="666666"/></w:rPr><w:t>Code source complet - document genere le DATEHERE - depot github.com/jv2580/meteo-casablanca</w:t></w:r></w:p>
<w:p><w:pPr><w:spacing w:before="360"/></w:pPr><w:r><w:rPr><w:b/><w:sz w:val="28"/></w:rPr><w:t>Presentation de l application</w:t></w:r></w:p>
<w:p><w:r><w:t xml:space="preserve">Cette application calcule les besoins caloriques quotidiens a partir du profil (age, sexe, poids, taille), des activites sportives pratiquees chaque jour et de l objectif choisi : perdre du poids, maintenir son poids ou prise de masse. Elle affiche ensuite les calories cibles, la repartition en macronutriments (proteines, glucides, lipides) et un exemple de journee type avec trois repas.</w:t></w:r></w:p>
<w:p><w:r><w:t xml:space="preserve">Calculs utilises : metabolisme de base selon l equation de Mifflin-St Jeor (reference scientifique), depense hors sport egale au metabolisme de base multiplie par 1,375, calories du sport calculees avec les coefficients MET (marche 3,5 - course 9,8 - velo 7,5 - natation 8,3 - musculation 6,0 multiplies par le poids et la duree). Objectif perte de poids : deficit de 500 kcal par jour. Objectif prise de masse : surplus de 300 kcal par jour. Proteines : 2 g par kg en seche, 1,8 g en prise de masse, 1,6 g en maintien. Lipides : 27 pourcent des calories. Glucides : le reste.</w:t></w:r></w:p>
<w:p><w:r><w:t xml:space="preserve">Fichier de l application : calories/index.html - page unique qui contient la structure HTML, le style CSS et la logique JavaScript. Pour utiliser l application, il suffit d ouvrir ce fichier dans un navigateur, ou de visiter la page deployee sur Vercel.</w:t></w:r></w:p>
<w:p><w:pPr><w:spacing w:before="360"/></w:pPr><w:r><w:rPr><w:b/><w:sz w:val="28"/></w:rPr><w:t>Code source complet (calories/index.html)</w:t></w:r></w:p>
CODEHERE
'@
$body = $body.Replace('DATEHERE', $date).Replace('CODEHERE', $codeXml)

$documentXml = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
    '<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"><w:body>' +
    $body +
    '<w:sectPr><w:pgSz w:w="11906" w:h="16838"/><w:pgMar w:top="1134" w:right="1134" w:bottom="1134" w:left="1134"/></w:sectPr>' +
    '</w:body></w:document>'

# --- Fichiers du paquet Open XML ---
$contentTypes = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="xml" ContentType="application/xml"/><Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/></Types>
'@

$rootRels = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/></Relationships>
'@

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText((Join-Path $wordDir 'document.xml'), $documentXml, $utf8NoBom)
[System.IO.File]::WriteAllText((Join-Path $buildDir '[Content_Types].xml'), $contentTypes, $utf8NoBom)
[System.IO.File]::WriteAllText((Join-Path $relsDir '.rels'), $rootRels, $utf8NoBom)

# --- Validation : le XML doit etre bien forme ---
$xmlCheck = New-Object System.Xml.XmlDocument
$xmlCheck.Load((Join-Path $wordDir 'document.xml')) | Out-Null
Write-Output ('XML valide - ' + $lines.Count + ' lignes de code incluses')

# --- Compression en .docx (bsdtar de Windows, entrees en forward slashes) ---
$tar = Join-Path $env:SystemRoot 'System32\tar.exe'
Push-Location $buildDir
& $tar -a -cf 'app.zip' '[Content_Types].xml' '_rels' 'word' 2>&1 | Out-Null
Pop-Location
if ($LASTEXITCODE -ne 0) { throw "tar a echoue avec le code $LASTEXITCODE" }

$out = Join-Path $PSScriptRoot 'Application-Calories-Code.docx'
Move-Item -Force (Join-Path $buildDir 'app.zip') $out
Write-Output ('OK : ' + $out + ' (' + [math]::Round((Get-Item $out).Length / 1KB, 1) + ' Ko)')
