:- use_module(intcode).

day5part1(DiagnosticCode) :-
    load_program("day5input", Program),
    interpret(Program, [1], Output),
    reverse(Output, [_, DiagnosticCode|Rest]),
    maplist(=(0), Rest).

day5part2(DiagnosticCode) :-
    load_program("day5input", Program),
    interpret(Program, [5], Output),
    reverse(Output, [_, DiagnosticCode|Rest]),
    maplist(=(0), Rest).