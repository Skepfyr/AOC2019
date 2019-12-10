day6part1(Checksum) :-
    load_orbits,
    aggregate_all(count, orbits(_, _), Checksum).

day6part2(Steps) :-
    load_orbits,
    orbits(X, 'YOU'),
    orbits(X, 'SAN'),
    \+ (directly_orbits(X, Y), orbits(Y, 'YOU'), orbits(Y, 'SAN')),
    count_orbits(X, 'YOU', Count1),
    count_orbits(X, 'SAN', Count2),
    Steps is Count1 + Count2 - 2.

:- dynamic(directly_orbits/2).
load_orbits :-
    csv_read_file(
        "day6input",
        Orbits,
        [functor(directly_orbits), separator(41), arity(2)]
    ),
    abolish(directly_orbits/2),
    maplist(assertz, Orbits),
    !.

orbits(A, B) :- directly_orbits(A, B).
orbits(A, C) :-
    directly_orbits(A, B),
    orbits(B, C).

count_orbits(X, X, 0).
count_orbits(X, Y, Count) :-
    directly_orbits(Z, Y),
    count_orbits(X, Z, Count1),
    Count is Count1 + 1.