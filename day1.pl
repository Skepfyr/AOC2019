day1part1(Fuel) :-
    read_input(Input),
    total_fuel(Input, Fuel).

day1part2(Fuel) :-
    read_input(Input),
    total_fuel_fuel(Input, Fuel).

read_input(Input) :-
    open("day1input", read, Stream),
    read_line_to_codes(Stream, Line),
    read_input(Stream, Input, [], Line),
    close(Stream),
    !.
read_input(_, Input, Input, end_of_file).
read_input(Stream, Input, Numbers, Line) :-
    number_codes(Number, Line),
    append(Numbers, [Number], Numbers1),
    read_line_to_codes(Stream, Line1),
    read_input(Stream, Input, Numbers1, Line1).

fuel_for_mass(Fuel, Mass) :-
    Fuel is Mass//3-2.

total_fuel([], 0).
total_fuel([Mass|Masses], Fuel) :-
    total_fuel(Masses, RemainingFuel),
    fuel_for_mass(Fuel1, Mass),
    Fuel is Fuel1+RemainingFuel.

fuel_fuel(Fuel, Mass) :-
    Mass>8,
    fuel_for_mass(NewFuel, Mass),
    fuel_fuel(Fuel1, NewFuel),
    Fuel is Fuel1+NewFuel.
fuel_fuel(Fuel, Mass) :-
    Mass=<8,
    Fuel=0.
total_fuel_fuel([], 0).
total_fuel_fuel([Mass|Masses], Fuel) :-
    total_fuel_fuel(Masses, Fuel1),
    fuel_fuel(FuelFuel, Mass),
    Fuel is Fuel1+FuelFuel.
