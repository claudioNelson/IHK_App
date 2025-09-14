# create_txt.py
from __future__ import annotations
import calendar
from datetime import date
from pathlib import Path
import argparse
import sys

def get_script_dir() -> Path:
    # Ordner des Skripts ermitteln – Fallback: aktuelles Arbeitsverzeichnis
    try:
        return Path(__file__).resolve().parent
    except NameError:
        return Path.cwd()

def load_template(target_folder: Path) -> str:
    # Falls im Ordner eine template.txt liegt, diese verwenden; sonst Standardvorlage
    default_template = (
    
  
        
        "Torzone:\n"
        "Nexus:\n"
        "DrugHub\n"
        "MarsMarket\n"
        "Kerberos\n"
        "BlackOps\n"
        
        
        "Total EUR:\n"
    )
    tmpl_file = target_folder / "template.txt"
    if tmpl_file.exists():
        try:
            return tmpl_file.read_text(encoding="utf-8")
        except Exception as e:
            print(f"Vorlage 'template.txt' konnte nicht gelesen werden ({e}). "
                  f"Verwende Standardvorlage.")
    return default_template

def main():
    script_dir = get_script_dir()
    target_folder = script_dir  # Immer im Skript-Ordner arbeiten
    target_folder.mkdir(parents=True, exist_ok=True)

    # Argumente: Monat/Jahr flexibel, Standard: aktuelles Jahr & September (9)
    today = date.today()
    parser = argparse.ArgumentParser(
        description="Erstellt pro Tag eines Monats eine TXT-Datei im Ordner des Skripts."
    )
    parser.add_argument("-m", "--month", type=int, default=9,
                        help="Monat als Zahl (1-12). Standard: 9 (September).")
    parser.add_argument("-y", "--year", type=int, default=today.year,
                        help=f"Jahr (z. B. {today.year}). Standard: aktuelles Jahr.")
    parser.add_argument("--overwrite", action="store_true",
                        help="Existierende Dateien überschreiben.")
    args = parser.parse_args()

    year = args.year
    month = args.month
    if not (1 <= month <= 12):
        print("Fehler: Monat muss zwischen 1 und 12 liegen.")
        sys.exit(1)

    # Anzahl Tage im Monat ermitteln
    days_in_month = calendar.monthrange(year, month)[1]

    # Vorlage laden (mit Platzhaltern {date}, {day}, {month})
    template = load_template(target_folder)

    created, skipped = 0, 0
    for day in range(1, days_in_month + 1):
        filename = f"{day:02d}.{month:02d}.txt"
        path = target_folder / filename

        if path.exists() and not args.overwrite:
            print(f"Übersprungen (existiert): {filename}")
            skipped += 1
            continue

        date_str = f"{day:02d}.{month:02d}"
        content = template.format(date=date_str, day=day, month=month)

        # Dateien mit LF-Zeilenende und UTF-8
        path.write_text(content, encoding="utf-8")
        print(f"Erstellt: {filename}")
        created += 1

    print(f"Fertig. Erstellt: {created}, Übersprungen: {skipped}. Zielordner: {target_folder}")

if __name__ == "__main__":
    main()
