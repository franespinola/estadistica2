$path = 'C:\Users\frane\Desktop\estadistica2\Resumenes por Unidad\Unidad 4\capitulo_4_corregido.tex'
$s = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
$latin1 = [System.Text.Encoding]::GetEncoding(1252)
$utf8 = [System.Text.Encoding]::UTF8
$fixed = $utf8.GetString($latin1.GetBytes($s))
[System.IO.File]::WriteAllText($path, $fixed, $utf8)
