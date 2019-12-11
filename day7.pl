:- use_module(intcode).

day7part1(MaxSolution) :-
    load_program("day7.input", Program),
    aggregate_all(max(X), amp_config(Program, _, X), MaxSolution).

amp_config(Program, Phases, Output) :-
    permutation([0, 1, 2, 3, 4], Phases),
    foldl(apply_amp(Program), Phases, 0, Output).

apply_amp(Program, Phase, Input, Output) :-
    interpret(Program, [Phase, Input], [Output, _]).

feedback_loop(Program, Phases, Output) :-
    permutation([5, 6, 7, 8, 9], Phases),
    Phases=[A, B, C, D, E],
    interpret(Program, [A, 0|InputA], InputB),
    interpret(Program, [B|InputB], InputC),
    interpret(Program, [C|InputC], InputD),
    interpret(Program, [D|InputD], InputE),
    interpret(Program, [E|InputE], InputA),
    reverse(InputA, [_,Output|_]).
