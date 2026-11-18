# PizzaLab – induló alkalmazásprojekt

Expo + React Native alapú, Androidra és iOS-re előkészített fejlesztési alap.

## Indítás
1. Telepítsd a függőségeket: `npm install`
2. Indítás: `npx expo start`
3. iPhone-on Expo Go-val olvasd be a terminálban megjelenő QR-kódot.

## Funkciók
- Prémium, sötét PizzaLab felület
- Tésztakalkulátor: bucik, tömeg, hidratáció, só
- Poolish, Biga és közvetlen tészta
- Fermentációs folyamat, receptek, időzítő, sütési napló
- Közösségi felület Supabase kapcsolattal

## Közösség beállítása
1. Hozz létre Supabase projektet.
2. Futtasd a `supabase/community.sql` fájlt az SQL Editorban.
3. Másold az `.env.example` fájlt `.env` néven, majd add meg a Supabase URL-t és anon kulcsot.
4. Indítsd újra az Expo fejlesztői szervert.

A service role kulcsot soha ne tedd mobilalkalmazásba.

## Korlátozások
Ez fejlesztési alap, nem publikálásra kész alkalmazás. Teljes Expo build, iPhone/Android eszközteszt és áruházi kiadás még nincs igazolva. Az automatikus élesztőszázalék csak heurisztika, nem validált receptajánlás. A receptek és a napló helyben tárolódnak; felhőszinkron és admin moderációs felület nincs.
