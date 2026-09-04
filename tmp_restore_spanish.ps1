$path = 'C:\Users\frane\Desktop\estadistica2\Resumenes por Unidad\Unidad 4\capitulo_4_corregido.tex'
$dictPath = 'C:\Program Files\Common Files\Adobe\Acrobat\DC\Linguistics\Providers\Plugins2\AdobeHunspellPlugin\Dictionaries\es_ES\es_ES.dic'
$text = [IO.File]::ReadAllText($path, [Text.Encoding]::UTF8)
$dict = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
Get-Content $dictPath | Select-Object -Skip 1 | ForEach-Object { [void]$dict.Add(($_ -split '/')[0]) }
$words = [regex]::Matches($text,'[A-Za-zÁÉÍÓÚÜÑáéíóúüñ�¿¡]+') | ForEach-Object {$_.Value} | Where-Object {$_ -like '*�*'} | Sort-Object -Unique
foreach($word in $words){
  $candidates = foreach($ch in @('á','é','í','ó','ú','ü','ñ','¿','¡')) { $candidate=$word.Replace('�',$ch); if($dict.Contains($candidate)){$candidate} }
  $candidates = @($candidates | Sort-Object -Unique)
  if($candidates.Count -eq 1){ $text = $text.Replace($word,$candidates[0]) }
}
$map = [ordered]@{
'distribuci�n'='distribución'; 'estad�stico'='estadístico'; 'estad�stica'='estadística'; 'estad�sticos'='estadísticos'; 'estad�sticas'='estadísticas'; 'estad�sticamente'='estadísticamente';
'hip�tesis'='hipótesis'; 'n�mero'='número'; 'n�meros'='números'; 'te�rica'='teórica'; 'te�rico'='teórico'; 'm�todo'='método'; 'm�todos'='métodos'; 'significaci�n'='significación';
'est�ndar'='estándar'; 'Estad�stica'='Estadística'; 'tama�o'='tamaño'; 'tama�os'='tamaños'; 'Qu�'='Qué'; '�Qu�'='¿Qué'; '�Por'='¿Por'; '�C�mo'='¿Cómo'; '�Cu�l'='¿Cuál'; '�Cu�ndo'='¿Cuándo';
'm�xima'='máxima'; 'm�ximo'='máximo'; 'm�ximas'='máximas'; 'cr�tico'='crítico'; 'cr�tica'='crítica'; 'cr�ticos'='críticos'; 'cr�ticas'='críticas';
'Param�tricas'='Paramétricas'; 'param�trica'='paramétrica'; 'param�trico'='paramétrico'; 'param�tricos'='paramétricos'; 'param�tricas'='paramétricas'; 'No Param�tricas'='No Paramétricas';
'interpretaci�n'='interpretación'; 'Interpretaci�n'='Interpretación'; 'poblaci�n'='población'; 'f�rmula'='fórmula'; 'F�rmula'='Fórmula'; 'F�rmulas'='Fórmulas'; 'desviaci�n'='desviación';
'Decisi�n'='Decisión'; 's�mbolos'='símbolos'; 'Cap�tulo'='Capítulo'; 'regi�n'='región'; 'observaci�n'='observación'; 'escal�n'='escalón'; 'secci�n'='sección'; 'Secci�n'='Sección';
'sustituci�n'='sustitución'; 'Sim�trica'='Simétrica'; 'sim�trica'='simétrica'; 'sim�tricos'='simétricos'; 'simetr�a'='simetría'; 'funci�n'='función'; 'asimetr�a'='asimetría'; 'asim�trica'='asimétrica'; 'asim�tricas'='asimétricas';
'par�metros'='parámetros'; 'Exposici�n'='Exposición'; 'id�nticas'='idénticas'; 'id�nticos'='idénticos'; 'id�ntica'='idéntica'; 'Gr�fico'='Gráfico'; 'gr�fico'='gráfico'; 'gr�fica'='gráfica'; 'Gr�ficamente'='Gráficamente';
'emp�rica'='empírica'; 'emp�ricas'='empíricas'; 'aglomeraci�n'='aglomeración'; 'localizaci�n'='localización'; 'Num�rica'='Numérica'; 'num�rica'='numérica'; 'num�ricas'='numéricas'; 'num�ricos'='numéricos';
'An�lisis'='Análisis'; 'an�lisis'='análisis'; 'c�lculo'='cálculo'; 'c�lculos'='cálculos'; 'est�n'='están'; 'est�'='está'; 'aproximaci�n'='aproximación'; 'informaci�n'='información'; 'definici�n'='definición';
'resoluci�n'='resolución'; 'justificaci�n'='justificación'; 'Explicaci�n'='Explicación'; 'explicaci�n'='explicación'; 'cronol�gica'='cronológica'; 'cronol�gico'='cronológico'; 'cronol�gicamente'='cronológicamente';
'comparaci�n'='comparación'; 'patr�n'='patrón'; 'despu�s'='después'; 'Gu�a'='Guía'; 'gu�a'='guía'; 'p�gina'='página'; 'aplicaci�n'='aplicación'; 'di�metros'='diámetros'; 'di�metro'='diámetro'; 'm�quina'='máquina';
'separaci�n'='separación'; 'cl�sica'='clásica'; 'cl�sicos'='clásicos'; 'producci�n'='producción'; 'Contin�a'='Continúa'; 'pr�ctico'='práctico'; 'C�tedra'='Cátedra'; 'peque�o'='pequeño'; 'peque�os'='pequeños'; 'peque�a'='pequeña'; 'peque�as'='pequeñas';
'l�mite'='límite'; 'l�mites'='límites'; 'eval�a'='evalúa'; 'dicot�mico'='dicotómico'; 'dicot�micos'='dicotómicos'; 'dicot�mica'='dicotómica'; 'dicot�micas'='dicotómicas'; 'teor�a'='teoría'; 'm�nimo'='mínimo'; 't�rmino'='término'; 't�rminos'='términos';
'c�clicos'='cíclicos'; 'elecci�n'='elección'; 'aritm�tica'='aritmética'; 'aritm�ticas'='aritméticas'; 'aritm�ticos'='aritméticos'; 'seg�n'='según'; 'posici�n'='posición'; 'Determinaci�n'='Determinación'; 'ser�a'='sería'; 'deber�a'='debería'; 'deber�an'='deberían';
'autom�tico'='automático'; '�rea'='área'; '�reas'='áreas'; '�ndice'='Índice'; '�NDICE'='ÍNDICE'; 'clasificaci�n'='clasificación'; 'anal�tica'='analítica'; 'anal�ticamente'='analíticamente'; '�xitos'='éxitos'; '�xito'='éxito'; 'matem�tica'='matemática'; 'matem�ticas'='matemáticas';
'dise�ado'='diseñado'; 'dise�ada'='diseñada'; 'dise�adas'='diseñadas'; 'dise�o'='diseño'; 'espec�ficamente'='específicamente'; 'fracci�n'='fracción'; 'transformaci�n'='transformación'; 'aparici�n'='aparición'; 'sucesi�n'='sucesión';
'geom�trica'='geométrica'; 'geom�tricamente'='geométricamente'; 'Ubicaci�n'='Ubicación'; '�ptima'='óptima'; 'a�n'='aún'; 'N�'='N.º'; 'm�trica'='métrica'; 'Caracter�stica'='Característica'; 't�cnica'='técnica'; 't�cnicas'='técnicas'; 'asignaci�n'='asignación'; 'v�lido'='válido';
'repetici�n'='repetición'; 'concentraci�n'='concentración'; 'oscilaci�n'='oscilación'; 'espec�fica'='específica'; 'espec�ficos'='específicos'; 'r�pida'='rápida'; 'r�pidos'='rápidos'; 'l�nea'='línea'; 'precisi�n'='precisión'; 'inter�s'='interés'; 'hipot�tico'='hipotético';
'raz�n'='razón'; 'satisfacci�n'='satisfacción'; 'mayor�a'='mayoría'; 'at�pico'='atípico'; 'at�picos'='atípicos'; 'probabil�stica'='probabilística'; 'probabil�stico'='probabilístico'; 'subestimaci�n'='subestimación'; 'correcci�n'='corrección'; 't�pica'='típica';
'ubic�ndose'='ubicándose'; 'ex�menes'='exámenes'; 'alg�n'='algún'; 'Introducci�n'='Introducción'; 'Program�tica'='Programática'; 'Identificaci�n'='Identificación'; 'selecci�n'='selección'; 'act�a'='actúa'; 'P�rdida'='Pérdida'; 's�'='sí'; 'reducci�n'='reducción'; '�nica'='única';
'disminuy�'='disminuyó'; 'c�digo'='código'; 'requerir�n'='requerirán'; 'd�bil'='débil'; 'mil�simas'='milésimas'; 'Configuraci�n'='Configuración'; 'obtenci�n'='obtención'; 'mil�metros'='milímetros'; 'Se�ores'='Señores'; 'acad�micas'='académicas'; 'acad�micos'='académicos';
'metodol�gicas'='metodológicas'; 'bas�ndose'='basándose'; 'bas�ndonos'='basándonos'; 'all�'='allí'; 'S�ntesis'='Síntesis'; 'intuici�n'='intuición'; 'asign�rseles'='asignárseles'; 'dar�a'='daría'; 'requerir�'='requerirá'; 'dividir�a'='dividiría'; 'transform�ndolos'='transformándolos';
'acad�mico'='académico'; 'aqu�'='aquí'; 's�lida'='sólida'; 'detr�s'='detrás'; 'peri�dicas'='periódicas'; 'agrupaci�n'='agrupación'; 'electrol�tica'='electrolítica'; 'p�rpura'='púrpura'; 'acumul�ndose'='acumulándose'; 'estar�an'='estarían'; 'estimaci�n'='estimación'; 'f�sica'='física'; 'f�sicas'='físicas';
'se�ala'='señala'; 'proporci�n'='proporción'; 'obligar�'='obligará'; 'peri�dica'='periódica'; 'concentrar�n'='concentrarán'; 'suposici�n'='suposición'; 'as�'='así'; 'matem�tico'='matemático'; 'par�metro'='parámetro'; '�til'='útil'; 'b�sicas'='básicas'; 'generalizaci�n'='generalización'; 'v�lidas'='válidas'; 'habr�an'='habrían'; 'Matem�ticamente'='Matemáticamente'
}
foreach($key in $map.Keys){ $text=$text.Replace($key,$map[$key]) }
# Elimina solo citas numéricas precedidas por espacio: [3], [3, 38, 40], etc.
$text=[regex]::Replace($text,'\s+\[(?:\d+\s*,\s*)*\d+\]','')
[IO.File]::WriteAllText($path,$text,[Text.UTF8Encoding]::new($false))
