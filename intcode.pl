:- module(intcode,
          [ load_program/2,
            program_input/4,
            interpret/3
          ]).

load_program(File, Program) :-
    csv_read_file_row(File, Row, [convert(true)]),
    Row=..[_|Program],
    !.

program_input(NewProgram, Program, Noun, Verb) :-
    Program=[Pos0, _, _|Rest],
    NewProgram=[Pos0, Noun, Verb|Rest].

get(List, Index, '0', Value):-
    length(Before, Index),
    append(Before, [Value|_After], List).
get(_List, Value, '1', Value).

set(NewList, List, Index, '0', Value):-
    length(Before, Index),
    append(Before, [_|After], List),
    append(Before, [Value|After], NewList).

interpret(Program, Input, Ouput):-
    interpret(Program, 0, Input, Ouput).

decode_op(Op, Opcode, Modes) :-
    Opcode is mod(Op, 100),
    ModeNum is Op // 100,
    decode_modes(ModeNum, Modes).
decode_modes(0, []).
decode_modes(ModeNum, Modes) :-
    ModeNum \= 0,
    number_chars(ModeNum, ReverseModes),
    reverse(ReverseModes, Modes).


extend_with_zeros(List, Length, NewList) :-
    length(NewList, Length),
    append(List, Zeros, NewList),
    maplist(=('0'), Zeros).

interpret(Program, Counter, Input, Ouput) :-
    length(Before, Counter),
    append(Before, [Op|_], Program),
    decode_op(Op, Opcode, Modes),
    interpret(Program, Counter, Opcode, Modes, Input, Ouput),
    !.

interpret(Program, Counter, 1, Modes, Input, Ouput):-
    length(Before, Counter),
    append(Before, [_, A, B, C|_], Program),
    extend_with_zeros(Modes, 3, [AMode, BMode, CMode]),
    get(Program, A, AMode, AVal),
    get(Program, B, BMode, BVal),
    CVal is AVal + BVal,
    set(NewProgram, Program, C, CMode, CVal),
    NewCounter is Counter + 4,
    interpret(NewProgram, NewCounter, Input, Ouput).

interpret(Program, Counter, 2, Modes, Input, Ouput):-
    length(Before, Counter),
    append(Before, [_, A, B, C|_], Program),
    extend_with_zeros(Modes, 3, [AMode, BMode, CMode]),
    get(Program, A, AMode, AVal),
    get(Program, B, BMode, BVal),
    CVal is AVal * BVal,
    set(NewProgram, Program, C, CMode, CVal),
    NewCounter is Counter + 4,
    interpret(NewProgram, NewCounter, Input, Ouput).

interpret(Program, Counter, 3, Modes, [Input|NextInput], Ouput) :-
    length(Before, Counter),
    append(Before, [_, I|_], Program),
    extend_with_zeros(Modes, 1, [Mode]),
    set(NewProgram, Program, I, Mode, Input),
    NewCounter is Counter + 2,
    interpret(NewProgram, NewCounter, NextInput, Ouput).

interpret(Program, Counter, 4, Modes, Input, [Output|NextOutput]) :-
    length(Before, Counter),
    append(Before, [_, I|_], Program),
    extend_with_zeros(Modes, 1, [Mode]),
    get(Program, I, Mode, Output),
    NewCounter is Counter + 2,
    interpret(Program, NewCounter, Input, NextOutput).

interpret(Program, Counter, 5, Modes, Input, Ouput):-
    length(Before, Counter),
    append(Before, [_, T, J|_], Program),
    extend_with_zeros(Modes, 2, [TMode, JMode]),
    get(Program, T, TMode, TVal),
    (
        TVal\=0
        ->
        get(Program, J, JMode, JVal),
        NewCounter is JVal
        ;
        NewCounter is Counter + 3
    ),
    interpret(Program, NewCounter, Input, Ouput).

interpret(Program, Counter, 6, Modes, Input, Ouput):-
    length(Before, Counter),
    append(Before, [_, T, J|_], Program),
    extend_with_zeros(Modes, 2, [TMode, JMode]),
    get(Program, T, TMode, TVal),
    (
        TVal=0
        ->
        get(Program, J, JMode, JVal),
        NewCounter is JVal
        ;
        NewCounter is Counter + 3
    ),
    interpret(Program, NewCounter, Input, Ouput).

interpret(Program, Counter, 7, Modes, Input, Ouput):-
    length(Before, Counter),
    append(Before, [_, A, B, C|_], Program),
    extend_with_zeros(Modes, 3, [AMode, BMode, CMode]),
    get(Program, A, AMode, AVal),
    get(Program, B, BMode, BVal),
    (AVal < BVal -> CVal=1 ; CVal=0),
    set(NewProgram, Program, C, CMode, CVal),
    NewCounter is Counter + 4,
    interpret(NewProgram, NewCounter, Input, Ouput).

interpret(Program, Counter, 8, Modes, Input, Ouput):-
    length(Before, Counter),
    append(Before, [_, A, B, C|_], Program),
    extend_with_zeros(Modes, 3, [AMode, BMode, CMode]),
    get(Program, A, AMode, AVal),
    get(Program, B, BMode, BVal),
    (AVal = BVal -> CVal=1 ; CVal=0),
    set(NewProgram, Program, C, CMode, CVal),
    NewCounter is Counter + 4,
    interpret(NewProgram, NewCounter, Input, Ouput).

interpret(Program, _, 99, [], _Input, [Output|_]):-
    Program = [Output|_].