# PizzaLab – tesztelési jegyzőkönyv
Dátum: 2026-11-18

## Elvégzett ellenőrzések
- TypeScript/TSX szintaktikai transpile ellenőrzés: 4 fájl rendben.
- Tésztamennyiség számítási teszt: 4/4 sikeres.
- Javítva az élesztőszámítás sorrendhibája és a hiányos useMemo függőségi lista.
- Az időzítő visszaszámlálása másodpercenként frissül.

## Nem lefuttatott tesztek
- Teljes Expo build és alkalmazásindítás: a függőségek telepítése időtúllépés miatt nem fejeződött be.
- iPhone/Android eszközteszt és háttérértesítések tesztje.
- Supabase online teszt: nincs beállítva projekt URL és anon kulcs.
- App Store / Google Play kiadás előtti build.

## Ismert korlátozások
- Az automatikus élesztőszázalék heurisztika, nem szakmailag validált.
- A sütési napló fotója galéria-URI-t tárolhat, tartós fájlmásolás nincs.
- Receptek és napló helyi tárolásúak, felhőszinkron nincs.
- A közösségi jelentés beküldhető, de admin moderációs felület nincs.
