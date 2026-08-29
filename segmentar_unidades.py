#!/usr/bin/env python3
"""Segmenta un PDF de apuntes en un archivo PDF por cada unidad.

Uso:
    python segmentar_unidades.py "teoria/RESUMEN DEFINITIVO EST2 .docx.pdf"
    python segmentar_unidades.py entrada.pdf --salida unidades

Instalación de la única dependencia:
    python -m pip install pypdf
"""

from __future__ import annotations

import argparse
import re
import unicodedata
from pathlib import Path

from pypdf import PdfReader, PdfWriter


# Acepta, por ejemplo: UNIDAD I: CONCEPTOS, UNIDAD "II": PRUEBAS DE HIPÓTESIS
UNIDAD_RE = re.compile(
    r"\bUNIDAD\s+['\"]?([IVXLCDM]+|\d+)['\"]?\s*:\s*(.+?)\s*$",
    re.IGNORECASE,
)


def normalizar_espacios(texto: str) -> str:
    return re.sub(r"\s+", " ", texto.replace("\u00a0", " ")).strip()


def nombre_archivo(texto: str) -> str:
    texto = unicodedata.normalize("NFKD", texto)
    texto = "".join(c for c in texto if not unicodedata.combining(c))
    texto = re.sub(r"[^A-Za-z0-9]+", "-", texto).strip("-").lower()
    return texto or "sin-nombre"


def detectar_unidades(reader: PdfReader) -> list[tuple[int, str, str]]:
    detectadas: list[tuple[int, str, str]] = []
    for pagina, page in enumerate(reader.pages):
        texto = page.extract_text() or ""
        for linea in texto.splitlines():
            linea = normalizar_espacios(linea)
            coincidencia = UNIDAD_RE.search(linea)
            if coincidencia:
                numero, titulo = coincidencia.groups()
                detectadas.append((pagina, numero.upper(), titulo.strip()))
                break
    return detectadas


def segmentar(entrada: Path, salida: Path) -> None:
    reader = PdfReader(str(entrada))
    unidades = detectar_unidades(reader)
    if not unidades:
        raise SystemExit(
            "No se encontraron encabezados 'UNIDAD X: NOMBRE'. "
            "Revisa el PDF o ajusta UNIDAD_RE."
        )

    salida.mkdir(parents=True, exist_ok=True)
    print(f"Páginas totales: {len(reader.pages)}")
    print(f"Unidades detectadas: {len(unidades)}")

    for indice, (pagina_inicio, numero, titulo) in enumerate(unidades):
        pagina_fin = (
            unidades[indice + 1][0] - 1
            if indice + 1 < len(unidades)
            else len(reader.pages) - 1
        )
        writer = PdfWriter()
        for pagina in range(pagina_inicio, pagina_fin + 1):
            writer.add_page(reader.pages[pagina])

        destino = salida / f"Unidad {indice + 1:02d} - {nombre_archivo(titulo)}.pdf"
        with destino.open("wb") as archivo:
            writer.write(archivo)
        print(
            f"  {numero}: páginas {pagina_inicio + 1}-{pagina_fin + 1} -> {destino.name}"
        )


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("entrada", type=Path, help="PDF original")
    parser.add_argument(
        "--salida",
        type=Path,
        default=Path("unidades_segmentadas"),
        help="Carpeta de salida (por defecto: unidades_segmentadas)",
    )
    args = parser.parse_args()
    if not args.entrada.is_file():
        parser.error(f"No existe el archivo: {args.entrada}")
    segmentar(args.entrada, args.salida)


if __name__ == "__main__":
    main()
