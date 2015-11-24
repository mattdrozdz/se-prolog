:- module(sport,[wykonaj/0]).

:- dynamic([xpozytywne/2, xnegatywne/2, xjak/2]).


sport_to(pilka_nozna) :-
	jest_to(gracz_zespolowy),
	jest_to(typ_elastyczny)
	jest_to(typ_szybkosciowy).

sport_to(siatkowka) :-
	jest_to(gracz_zespolowy),
	jest_to(typ_szybkosciowy),	
	pozytywne(czy, jest_wysoki).

sport_to(kolarstwo) :-
	jest_to(gracz_zespolowy),
	jest_to(typ_wytrzymalosciowy),
	jest_to(ektomorfik).
	
sport_to(rugby) :-
	jest_to(gracz_zespolowy),
	jest_to(typ_elastyczny),
	jest_to(typ_agresywny).	

sport_to(biegi_dlugdystansowe) :-
	jest_to(indywidualista),
	jest_to(typ_wytrzymalosciowy),
	jest_to(ektomorfik).	

sport_to(biegi_sprinterskie) :-
	jest_to(indywidualista),
	jest_to(typ_szybkosciowy).
	
sport_to(podnoszenie_ciezarow) :-
	jest_to(indywidualista),
	pozytywne(ma, krotkie_konczyny),
	jest_to(mezomorfik),
	jest_to(typ_elastyczny).
	
sport_to(sztuki_walki) :-
	jest_to(indywidualista),
	jest_to(typ_agresywny).
	
sport_to(wspinaczka) :-
	jest_to(typ_elastyczny),
	jest_to(ektomorfik),
	pozytywne(czy, dlugo_utrzymuje_sie_na_drazku).

sport_to(wioslarstwo) :-
	jest_to(typ_wytrzymalosciowy),
	pozytywne(ma, dlugie_konczyny).


jest_to(endomorfik) :-
	jak("Jak rozwiniete umiesnienie?", "mocno", "slabo/srednio/mocno"),
	pozytywne(ma, pokazna_ilosc_tkanki_tluszczowej).

jest_to(ektomorfik) :-
	pozytywne(ma, waskie_ramiona_i_miednica),
	jak("Jak rozwiniete umiesnienie?", "slabo", "slabo/srednio/mocno").

jest_to(mezomorfik) :-
	jak("Jak rozwiniete umiesnienie?", "mocno", "slabo/srednio/mocno"),
	pozytywne(ma, waskie_biodra),
	pozytywne(ma, szerokie_barki),
	pozytywne(ma, sylwetka_typu_V).

jest_to(typ_szybkosciowy) :-
	pozytywne(czy, szybko_biega_50m),
	pozytywne(czy, daleko_skacze_w_dal).

jest_to(typ_wytrzymalosciowy) :-
	pozytywne(czy, ma_dobry_wynik_w_tescie_Coopera),
	pozytywne(czy, dlugo_utrzymuje_sie_na_drazku).

jest_to(typ_elastyczny) :-
	pozytywne(czy, ma_dobry_wynik_w_biegu_zwinnosciowym),
	pozytywne(czy, ma_dobry_wynik_w_probie_gibkosci).

jest_to(indywidualista) :-
	pozytywne(czy, liczy_tylko_na_siebie),
	negatywne(czy, lubi_sie_dzielic).

jest_to(gracz_zespolowy) :-
	pozytywne(czy, lubi_pomagac_innym),
	pozytywne(czy, lubi_sie_dzielic).

jest_to(typ_agresywny) :-
	negatywne(czy, potrafi_lagodzic_spory),
	pozytywne(czy, czesto_podnosi_glos).

jak(Pytanie, Oczekiwana, Mozliwosci) :-
	zapytano_wczesniej(Pytanie, Oczekiwana, _); ! ,
	pytaj_tekst(Pytanie, Oczekiwana, Mozliwosci).

zapytano_wczesniej(Pytanie, Oczekiwana, PoprzedniaOdpowiedz) :-
	xjak(Pytanie, PoprzedniaOdpowiedz),
	sub_string(PoprzedniaOdpowiedz, 0, _, _, Oczekiwana).

pytaj_tekst(Pytanie, Oczekiwana, Mozliwosci) :-
	!, write(Pytanie), write(" ("), write(Mozliwosci), write(")\n"),
	readln([Replay]),
	assertz(xjak(Pytanie, Replay)),
	sub_string(Replay, 0, _, _, Oczekiwana).

pozytywne(X, Y) :-
	xpozytywne(X, Y), !.

pozytywne(X, Y) :-
	not(xnegatywne(X, Y)),
	pytaj(X, Y, tak).

negatywne(X, Y) :-
	xnegatywne(X, Y), !.

negatywne(X, Y) :-
	not(xpozytywne(X, Y)),
	pytaj(X, Y, nie).

pytaj(X, Y, tak) :-
	!, write(X), write(' '), write(Y), write(' ? (t/n)\n'),
	readln([Replay]),
	pamietaj(X, Y, Replay),
	odpowiedz(Replay, tak).


pytaj(X, Y, nie) :-
	!, write(X), write(' '), write(Y), write(' ? (t/n)\n'),
	readln([Replay]),
	pamietaj(X, Y, Replay),
	odpowiedz(Replay, nie).

odpowiedz(Replay, tak):-
	sub_string(Replay, 0, _, _, 't').

odpowiedz(Replay, nie):-
	sub_string(Replay, 0, _, _, 'n').

pamietaj(X, Y, Replay) :-
	odpowiedz(Replay, tak),
	assertz(xpozytywne(X, Y)).

pamietaj(X, Y, Replay) :-
	odpowiedz(Replay, nie),
	assertz(xnegatywne(X, Y)).

wyczysc_fakty :-
	write('\n\nNacisnij enter aby zakonczyc\n'),
	retractall(xpozytywne(_, _)),
	retractall(xnegatywne(_, _)),
	readln(_).

wykonaj :-
	sport_to(X), !,
	write('Odpowiednim sportem moze byc '), write(X), nl,
	wyczysc_fakty.

wykonaj :-
	write('\nNie jestem w stanie stwierdzic, '),
	write('jaki sport jest odpowiedni.\n\n'), wyczysc_fakty.


