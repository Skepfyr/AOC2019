day8part1(Output) :-
    read_image(Image, 6, 25, _),
    maplist(pair_with_count(0), Image, LayersWithCounts),
    sort(2, @=<, LayersWithCounts, [Layer-_|_]),
    count_layer(1, Layer, Count1),
    count_layer(2, Layer, Count2),
    Output is Count1 * Count2.

day8part2(Output) :-
    read_image(Image, 6, 25, _),
    flatten_image(Image, Layer),
    layer_string(Layer, Output).

read_image(Image, Height, Width, Depth) :-
    open("day8.input", read, Stream),
    read_line_to_codes(Stream, Line),
    maplist(number_code, Numbers, Line),
    read_layers(Numbers, Image, Height, Width, Depth).
number_code(Number, Code) :- number_codes(Number, [Code]).

read_layers([], [], _, _, 0).
read_layers(Numbers, Image, Height, Width, Depth) :-
    Size is Height * Width,
    length(LayerNums, Size),
    append(LayerNums, Numbers1, Numbers),
    read_layers(Numbers1, Image1, Height, Width, Depth1),
    Depth is Depth1 + 1,
    Image=[Layer|Image1],
    read_rows(LayerNums, Layer, Width).

read_rows([], [], _).
read_rows(Numbers, Layer, Width) :-
    length(Row, Width),
    append(Row, Numbers1, Numbers),
    read_rows(Numbers1, Layer1, Width),
    Layer=[Row|Layer1].

count_layer(Val, Layer, Count) :-
    maplist(count(Val), Layer, RowCounts),
    sum_list(RowCounts, Count).

count(_, [], 0).
count(Val, [Head|Tail], Count) :-
    count(Val, Tail, Count1),
    (Val=Head -> Matches=1 ; Matches=0),
    Count is Matches+Count1.

pair_with_count(Val, Layer, LayerWithCount) :-
    count_layer(Val, Layer, Count),
    LayerWithCount=Layer-Count.

flatten_image([Layer], Layer).
flatten_image([Layer1|Tail], Layer) :-
    flatten_image(Tail, Layer2),
    maplist(overwrite_row, Layer1, Layer2, Layer).

overwrite_row([], [], []).
overwrite_row([Pixel1|Row1], [Pixel2|Row2], [Pixel|Row]) :-
    overwrite_row(Row1, Row2, Row),
    (Pixel1=2 -> Pixel=Pixel2 ; Pixel=Pixel1).

layer_string(Layer, String) :-
    maplist(row_string, Layer, Rows),
    reverse(Rows, Flipped),
    foldl(string_concat, Flipped, "", String).
    
row_string(Row, String) :-
    maplist(pixel_char, Row, Chars1),
    append(Chars1, [10], Chars),
    string_codes(String, Chars).

pixel_char(0, 0' ).
pixel_char(1, 0'X).
pixel_char(2, 0'O).