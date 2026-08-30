#!/usr/bin/env python3
"""
Baut aus iOS-Screenshots die fertigen App-Store-Bilder (1320 x 2868).

Layout: violette Serifen-Ueberschrift oben, darunter der Screenshot in einem
abgerundeten Rahmen, der unten aus dem Bild laeuft. Gerendert wird ueber
headless Chromium, damit die Typografie stimmt (Instrument Serif, dieselbe
Schrift wie in der App).

Aufruf:  python3 render_store_bilder.py
Ergebnis: ausgabe/01_lernen.png ... usw.

Ueberschriften aendern: unten in BILDER die Texte anpassen und neu laufen
lassen. "zeile2" ist optional und wird kleiner gesetzt.
"""

import asyncio
import base64
from pathlib import Path

from playwright.async_api import async_playwright

HIER = Path(__file__).resolve().parent
AUSGABE = HIER / "ausgabe"
FONT = HIER / "node_modules/@fontsource/instrument-serif/files/instrument-serif-latin-400-normal.woff2"

BREITE, HOEHE = 1320, 2868

# --- Hier die Bilder und ihre Ueberschriften pflegen ---------------------
# quelle: Pfad zum iOS-Screenshot (muss 1320 x 2868 sein)
# zeile1: grosse Ueberschrift. Zeilenumbruch mit \n selbst setzen — nie
#         automatisch umbrechen lassen, sonst reisst es Woerter auseinander.
# zeile2: optionale kleinere zweite Zeile.
BILDER = [
    {
        "quelle": "quelle/01_lernen.png",
        "ziel": "01_lernen.png",
        "zeile1": "Dein Lernhub.",
        "zeile2": "Alles an einem Ort.",
    },
    {
        "quelle": "quelle/02_pruefen.png",
        "ziel": "02_pruefen.png",
        "zeile1": "Unter echten\nPrüfungsbedingungen.",
    },
    {
        "quelle": "quelle/03_levels.png",
        "ziel": "03_levels.png",
        "zeile1": "Schritt für Schritt\nzur Prüfung.",
    },
    {
        "quelle": "quelle/04_zertifikate.png",
        "ziel": "04_zertifikate.png",
        "zeile1": "AWS, Azure, GCP\nund SAP.",
    },
    {
        "quelle": "quelle/05_arena.png",
        "ziel": "05_arena.png",
        "zeile1": "Fordere andere\nAzubis heraus.",
    },
]

VORLAGE = """
<!doctype html>
<meta charset="utf-8">
<style>
  @font-face {{
    font-family: 'Instrument Serif';
    src: url(data:font/woff2;base64,{font}) format('woff2');
    font-weight: 400;
    font-style: normal;
  }}

  * {{ margin: 0; padding: 0; box-sizing: border-box; }}

  html, body {{
    width: {breite}px;
    height: {hoehe}px;
    overflow: hidden;
    background: #0B0C16;
  }}

  /* Sehr dezenter violetter Schimmer hinter der Ueberschrift, damit die
     Flaeche oben nicht tot wirkt. */
  body::before {{
    content: '';
    position: absolute;
    top: -340px; left: 50%;
    width: 1500px; height: 900px;
    transform: translateX(-50%);
    background: radial-gradient(closest-side, rgba(124,92,255,0.16), transparent 70%);
  }}

  .kopf {{
    position: absolute;
    top: 150px; left: 0; right: 0;
    padding: 0 90px;
    text-align: center;
  }}

  .zeile1 {{
    font-family: 'Instrument Serif', Georgia, serif;
    font-size: {gross}px;
    line-height: 1.02;
    letter-spacing: -1px;
    color: #7C5CFF;
    white-space: pre-line;   /* \\n im Text wird zum Umbruch */
    display: inline-block;   /* Breite = laengste Zeile, fuer die Messung */
  }}

  .zeile2 {{
    font-family: 'Instrument Serif', Georgia, serif;
    font-size: {klein}px;
    line-height: 1.05;
    letter-spacing: -0.5px;
    color: #9B82FF;
    margin-top: 14px;
    white-space: pre-line;
    display: inline-block;
  }}

  /* Der Screenshot laeuft unten bewusst aus dem Bild — das signalisiert,
     dass der Inhalt weitergeht, und vermeidet eine tote Leiste. */
  .geraet {{
    position: absolute;
    left: 50%;
    top: {oben}px;
    transform: translateX(-50%);
    width: {geraet_breite}px;
    border-radius: 46px;
    overflow: hidden;
    border: 1px solid rgba(255,255,255,0.09);
    box-shadow: 0 40px 90px rgba(0,0,0,0.55);
  }}

  .geraet img {{ display: block; width: 100%; }}
</style>

<div class="kopf">
  <div class="zeile1">{zeile1}</div>
  {block2}
</div>

<div class="geraet"><img src="data:image/png;base64,{bild}"></div>
"""


GERAET_BREITE = 1060

# Das Geraet laeuft unten aus dem Bild heraus. Der Startpunkt ergibt sich
# aus der skalierten Hoehe des Screenshots plus dem gewuenschten Ueberstand.
UEBERSTAND = 80
GERAET_OBEN = HOEHE - int(HOEHE * GERAET_BREITE / BREITE) + UEBERSTAND


def html_bauen(
    font_b64: str, bild_b64: str, zeile1: str, zeile2: str | None,
    gross: int, klein: int,
) -> str:
    block2 = f'<div class="zeile2">{zeile2}</div>' if zeile2 else ""

    return VORLAGE.format(
        font=font_b64,
        bild=bild_b64,
        breite=BREITE,
        hoehe=HOEHE,
        oben=GERAET_OBEN,
        geraet_breite=GERAET_BREITE,
        gross=gross,
        klein=klein,
        zeile1=zeile1,
        block2=block2,
    )


async def main() -> None:
    if not FONT.exists():
        raise SystemExit(
            f"Schrift fehlt: {FONT}\n"
            "Vorher einmal:  npm install @fontsource/instrument-serif"
        )

    font_b64 = base64.b64encode(FONT.read_bytes()).decode()
    AUSGABE.mkdir(exist_ok=True)

    async with async_playwright() as p:
        browser = await p.chromium.launch()
        seite = await browser.new_page(
            viewport={"width": BREITE, "height": HOEHE},
            device_scale_factor=1,
        )

        for eintrag in BILDER:
            quelle = HIER / eintrag["quelle"]
            if not quelle.exists():
                print(f"UEBERSPRUNGEN — fehlt: {quelle}")
                continue

            bild_b64 = base64.b64encode(quelle.read_bytes()).decode()
            html = html_bauen(
                font_b64, bild_b64, eintrag["zeile1"], eintrag.get("zeile2"),
                gross=150, klein=108,
            )

            await seite.set_content(html)
            await seite.wait_for_timeout(400)  # Schrift und Bild sicher da

            # Lange Ueberschriften kleiner setzen, bis sie in die Breite
            # passen. Ohne das stossen Zeilen wie "Prüfungsbedingungen."
            # an beide Raender.
            await seite.evaluate(
                """(grenze) => {
                    for (const wahl of ['.zeile1', '.zeile2']) {
                        const el = document.querySelector(wahl);
                        if (!el) continue;
                        let px = parseFloat(getComputedStyle(el).fontSize);
                        while (el.offsetWidth > grenze && px > 56) {
                            px -= 2;
                            el.style.fontSize = px + 'px';
                        }
                    }
                }""",
                BREITE - 2 * 130,
            )
            await seite.wait_for_timeout(150)

            ziel = AUSGABE / eintrag["ziel"]
            await seite.screenshot(path=str(ziel))
            print(f"Fertig: {ziel.name}")

        await browser.close()

    # App Store nimmt keinen Alphakanal. Playwright liefert RGBA, also
    # nachtraeglich flach machen.
    from PIL import Image

    for datei in sorted(AUSGABE.glob("*.png")):
        im = Image.open(datei)
        if im.mode != "RGB":
            im.convert("RGB").save(datei)
        breite, hoehe = Image.open(datei).size
        status = "ok" if (breite, hoehe) == (BREITE, HOEHE) else "FALSCHE GROESSE"
        print(f"{datei.name}: {breite} x {hoehe} — {status}")


if __name__ == "__main__":
    asyncio.run(main())
