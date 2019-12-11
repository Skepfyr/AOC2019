day3part1(Distance) :-
    read_wires(Wire1, Wire2),
    points(Points1, Wire1, 0, 0),
    points(Points2, Wire2, 0, 0),
    sort(Points1, SortedPoints1),
    sort(Points2, SortedPoints2),
    ord_intersection(SortedPoints1, SortedPoints2, Crossings),
    maplist(manhattan_dist, Crossings, Distances),
    min_list(Distances, Distance).

day3part2(Distance) :-
    read_wires(Wire1, Wire2),
    step_points(Points1, Wire1, 0, 0, 0),
    step_points(Points2, Wire2, 0, 0, 0),
    sort(Points1, SortedPoints1),
    sort(Points2, SortedPoints2),
    ord_intersection(SortedPoints1, SortedPoints2, Crossings),
    maplist(step_dist, Crossings, Distances),
    min_list(Distances, Distance).

read_wires(Wire1, Wire2) :-
    csv_read_file("day3.input", [RowWire1, RowWire2]),
    RowWire1=..[_|RawWire1],
    RowWire2=..[_|RawWire2],
    maplist(parse_direction, RawWire1, Wire1),
    maplist(parse_direction, RawWire2, Wire2),
    !.

parse_direction(Raw, Direction) :-
    atom_codes(Raw, String),
    String=[Dir|Number],
    number_codes(Distance, Number),
    Direction=direction(Dir, Distance).

points([], [], _, _).
points(Points, [direction(_, 0)|Rest], X, Y) :-
    points(Points, Rest, X, Y).
points(Points, Wire, X, Y) :-
    Wire=[direction(Dir, Dist)|Rest],
    Dist>=1,
    NewDist is Dist-1,
    NewWire=[direction(Dir, NewDist)|Rest],
    move_dir(X, Y, Dir, NewX, NewY),
    Points=[point(NewX, NewY)|OtherPoints],
    points(OtherPoints, NewWire, NewX, NewY).

step_points([], [], _, _, _).
step_points(Points, [direction(_, 0)|Rest], X, Y, Steps) :-
    step_points(Points, Rest, X, Y, Steps).
step_points(Points, Wire, X, Y, Steps) :-
    Wire=[direction(Dir, Dist)|Rest],
    Dist>=1,
    NewDist is Dist-1,
    NewSteps is Steps+1,
    NewWire=[direction(Dir, NewDist)|Rest],
    move_dir(X, Y, Dir, NewX, NewY),
    Points=[point(NewX, NewY, NewSteps)|OtherPoints],
    step_points(OtherPoints, NewWire, NewX, NewY, NewSteps).

move_dir(X, Y, 85, NewX, NewY) :-
    NewX is X,
    NewY is Y+1.
move_dir(X, Y, 68, NewX, NewY) :-
    NewX is X,
    NewY is Y-1.
move_dir(X, Y, 76, NewX, NewY) :-
    NewX is X-1,
    NewY is Y.
move_dir(X, Y, 82, NewX, NewY) :-
    NewX is X+1,
    NewY is Y.

manhattan_dist(point(X, Y), Distance) :-
    Distance is abs(X)+abs(Y).

step_dist(point(_, _, steps), steps).