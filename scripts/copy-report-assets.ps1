$outputDir = ($env:QUARTO_PROJECT_OUTPUT_DIR -split "`r?`n" | Select-Object -First 1).Trim()
if ([string]::IsNullOrWhiteSpace($outputDir)) {
  $outputDir = "docs"
}

$projectRoot = (Get-Location).Path
$sourceRoot = Join-Path $projectRoot "Reports"
$destRoot = if ([System.IO.Path]::IsPathRooted($outputDir)) {
  $outputDir
} else {
  Join-Path $projectRoot $outputDir
}
$destReportsRoot = Join-Path $destRoot "Reports"

if (-not (Test-Path $sourceRoot)) {
  exit 0
}

if (-not (Test-Path $destReportsRoot)) {
  New-Item -ItemType Directory -Path $destReportsRoot -Force | Out-Null
}

Get-ChildItem -LiteralPath $sourceRoot -Directory -Filter "*_files" | ForEach-Object {
  $destPath = Join-Path $destReportsRoot $_.Name
  Copy-Item -LiteralPath $_.FullName -Destination $destPath -Recurse -Force
}
