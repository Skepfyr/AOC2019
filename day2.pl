:- use_module(intcode).

day2part1(Output) :-
    load_program("day2input", Data),
    program_input(Program, Data, 12, 2),
    interpret(Program, [], [Output]).

day2part2(Noun, Verb):-
    load_program("day2input", Data),
    between(0, 99, Noun),
    between(0, 99, Verb),
    program_input(Program, Data, Noun, Verb),
    interpret(Program, [], [19690720]).
