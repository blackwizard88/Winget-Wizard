README.txt – Winget Wizard v1.4.1

LEÍRÁS: Ez a "szoftver" egy felhőalapú vezérlőközpont, amely a Microsoft Winget technológiájára épül. Elsődleges célja a saját számítógépeden lévő szoftverpark naprakészen tartása, gyors telepítése és tiszta eltávolítása egy modern, grafikus felületen keresztül.

FŐ FUNKCIÓK:

-    Valós idejű Verzió-ellenőrzés

-    Indításkor a szkript végigkérdezi a Winget szervereit az aktuálisan elérhető legfrissebb verziókról.

-    A listában mindig a legfrissebb, "felhőben" lévő verziószámot látod.

     Hármas Műveleti Lehetőség:

-    TELEPÍTÉS: Letölti és telepíti a szoftvert (csendes módban, ahol lehetséges).

-    FRISSÍTÉS: Csak a kijelölt programot frissíti a legújabbra.

-    ELTÁVOLÍTÁS: Gyorsan és tisztán törli a kijelölt programokat a rendszeredből.

-    Automatikus Naplózás (Logging)

-    Minden végrehajtott műveletet rögzít a "wizard_history.log" fájlba.

-    Tartalmazza az időpontot, a program nevét, az ID-t és a művelet típusát.

-    Dinamikus Listakezelés

-    A "programlist.txt" fájl alapján dolgozik. Bármikor hozzáadhatsz új Winget ID-kat, a Wizard azonnal felismeri őket.
     Amit jelenleg ott látsz, az csak egy vázlat, ezt a "programparkot" használom, formáld úgy, ahogy szeretnéd.

HASZNÁLAT:

 -   Indítsd el a "start_wizard.bat" fájlt.

 -   Várd meg, amíg a Betöltő sáv végez az adatok lekérésével.

 -   Jelöld ki a listában a kívánt szoftvereket (Egér + Ctrl/Shift billentyűkkel).

 -   Kattints a megfelelő színes gombra a művelet végrehajtásához.

Mit jelent az "N/A" az Elérhető Verzió oszlopban? Az "N/A" (Not Available) jelzés akkor látható, ha a Winget adatbázisa az adott pillanatban nem küld vissza pontos verziószámot. Ez több okból is előfordulhat:

    Lassú válaszidő: A Winget szervere vagy az internetkapcsolat átmenetileg lassabb, és a lekérdezés túllépi az időkorlátot.

    Szoftverspecifikus ok: Egyes programok (pl. AnyDesk, Rufus) belső adatstruktúrája miatt a Winget nem tudja kinyerni a pontos verziót a show parancson keresztül.

    Nincs telepítve/Nincs adat: A program még nem szerepelt a Winget gyorsítótárában.

Fontos: Az "N/A" jelzés nem befolyásolja a szkript működését. A Telepítés, Frissítés és Eltávolítás gombok továbbra is hibátlanul fognak működni ezeknél a programoknál is, mivel a szkript a háttérben a program egyedi Winget ID-ját használja az azonosításhoz.


Egy kis sajátos magyarázat, kiegészítés, magyarázkodás

Ez a szkript azért született, hogy egy picit könnyebb legyen a programpark karbantartása/használata stb.

A szkriptet nem teljesen saját kútfőből írtam, a kód tartalmaz AI generált sorokat is, ezt vedd figyelembe mindenképp!

Mi a fenének csináltam? Minek van fent a GitHubon?

Az egész lényege az, hogy ha valaki hasonló "hasznos" eszközt keresne, ami egyszerű de nagyszerű, és könnyen modifikálható legyen, azonban semmit nem konyít a szkript íráshoz (vagy nem akar bajlódni vele), annak itt legyen ez a valami, mint egy vázlat. Létezik azonban egy olyan verzió, ami egyszerre kezel offline telepítést is, mellette egy winget lehetőséggel. Mivel már én sem vagyok mai "gyerek", én még abból az időből származom, ahol volt EGY pendrive. A PENDRIVE. Amin minden ott volt, ami kellett egy friss reinstall után. Driverek, programok, dolgok amik nélkül egy értelmezhetetlen idegenkedést váltott ki belőled a saját géped használata. Persze most már olyan Win telepítő szkripteket csinálhatsz amilyet akarsz, mint ahogy az is, ez is csak egy opció, kinek mi a kényelmes alapjogon.
Sőt ezen felül még arra is képes, hogy a programlistában szereplő programok alapján a legfrissebbet húzza le, és azt Te manuálisan feltolhatod egy pendrive-ra, mindazok mellett hogy ez elég melós folyamat tud lenni (szituációtól függően), itt lép színre a winget. Képes vagy vele gyorsan "karbantartani", ez pl tök hasznos amikor egy Windows reinstall után vagy, és kellenének AZOK AZ ESZKÖZÖK amik nélkül nem tudsz élni, aztán ha már ráérsz, a szkripten belül lehúzod magadnak a programlistában szereplő programokból a legfrissebb exéket, feltolod a pendrive-ra, és készen is vagy. Ezt a verziót EGYELŐRE nem szándékozom megosztani a nagyközönséggel, és amúgy is, ide profi programozók járnak fel, az ilyen kontárok mint én, csak egy kisebb anomália ebben a rendszerbe. Remélem, hogy cserébe aki hasznosnak találja a szkriptet, neki be fog válni.
Semmi világmegváltás, csak egy általam hasznosnak ítélt eszköz, ami bármikor jól jöhet, nekem például mindenképpen.
Nincs itt buymeacoffe link, nincs itt semmilyen kunyera. Amennyiben tetszik használd, örülni fogok neki. Mint ahogy fentebb írva vagyon, a lista szabadon módosítható, azt teszel bele amit akarsz, amit használsz. Honnan tudod, hogy mi elérhető winget paranccsal? Lehetne egy költői kérdés is, de azért megosztom az infót. Futtatsz egy powershell-t és beírod ezt a példa parancsot:
winget search 7zip
Nyilván a Name az magáért beszél, neked az ID lesz a lényeges, és a Version. Egyszerűen elkezded szerkeszteni a listát a benne lévő séma alapján, és voila, meg is vagy! Innentől kezdve a szkriptben benne lesz az a program, ami elérhető winget-en keresztül is. Ha valamiben nem vagy biztos, azt érdemes ellenőrizni.

Miért a winget? Miért nem valami más, mondjuk Chocolatey?

Mert ez jutott eszembe.

Maintained by: black_wizard Engine: Winget (Cloud Based)

Licenc (MIT License)

Copyright (c) 2026 black_wizard

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.