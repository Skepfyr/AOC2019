day2part1(Output) :-
    csv_read_file_row("day2input", Row, [convert(true), separator(44)]),
    !,
    Row=..[_, Pos0, _, _|Program],
    interpret([Pos0, 12, 2|Program], Output).

day2part2(Noun, Verb):-
    csv_read_file_row("day2input", Row, [convert(true), separator(0',)]),
    !,
    Row =.. [_,Pos0,_,_|Program],
    Output = 19690720,
    between(0, 99, Noun),
    between(0, 99, Verb),
    interpret([Pos0, Noun, Verb|Program], Output).

get(List, Index, Value):-
    length(Before, Index),
    append(Before, [Value|_After], List).

set(NewList, List, Index, Value):-
    length(Before, Index),
    append(Before, [_|After], List),
    append(Before, [Value|After], NewList).

interpret(Program, Ouput):-
    Program = [Op|_],
    interpret(Program, 0, Op, Ouput).

interpret(Program, Counter, 1, Ouput):-
    length(Before, Counter),
    append(Before, [1, A, B, C, NextOp|_], Program),
    get(Program, A, AVal),
    get(Program, B, BVal),
    CVal is AVal + BVal,
    set(NewProgram, Program, C, CVal),
    NewCounter is Counter + 4,
    interpret(NewProgram, NewCounter, NextOp, Ouput).

interpret(Program, Counter, 2, Ouput):-
    length(Before, Counter),
    append(Before, [2, A, B, C, NextOp|_], Program),
    get(Program, A, AVal),
    get(Program, B, BVal),
    CVal is AVal * BVal,
    set(NewProgram, Program, C, CVal),
    NewCounter is Counter + 4,
    interpret(NewProgram, NewCounter, NextOp, Ouput).

interpret(Program, _, 99, Ouput):-
    Program = [Ouput|_].