day4part1(Count) :-
   aggregate_all(count, valid_password(_), Count). 

day4part2(Count) :-
   aggregate_all(count, valid_password_2(_), Count). 

valid_password(Password) :-
    between(347312, 805915, Password),
    number_codes(Password, CodeList),
    adjacent_digits(CodeList),
    msort(CodeList, CodeList).

valid_password_2(Password) :-
    between(347312, 805915, Password),
    number_codes(Password, CodeList),
    double_digits(0, CodeList),
    msort(CodeList, CodeList).

adjacent_digits([A, B|Rest]) :-
    (A = B; adjacent_digits([B|Rest])),
    !.

double_digits(First, [A, B]) :-
    A\= First, A = B, !.
double_digits(First, [A, B, C|Rest]) :-
    (A\= First, A = B, B \= C; double_digits(A, [B, C|Rest])),
    !.