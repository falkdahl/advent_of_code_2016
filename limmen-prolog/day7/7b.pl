%% AdventOfCode day 7 7b.pl
%% swi-prolog
%% compile: ['7b.pl']
%%
%% start.
%% or
%% count_SSL(+,-).
%% count_SSL(Input, Count).
%%
%% Author Kim Hammar limmen@github.com <kimham@kth.se>

%%%===================================================================
%%% Predicates
%%%===================================================================

%% Test cases
test:-
    string_codes("aba[bab]xyz", C0),
    string_codes("xyx[xyx]xyx", C1),
    string_codes("aaa[kek]eke", C2),
    string_codes("zazbz[bzb]cdb", C3),
    count_SSL([C0,C1,C2,C3], 3).


%% Solves the puzzle with 7.txt as input string
start:-
    get_input(Input),
    count_SSL(Input, Count),
    pretty_print(Count).

%% counts number of IP's in Input that supports TLS
%% count_SSL(+,-).
%% count_SSL(Input, Count).
count_SSL(Input, Count):-
    count_SSL(Input, 0, Count).

count_SSL([], I, I).

count_SSL([H|T], I, Count):-
    (parse_line(H) ->
         I1 is I + 1;
     (
         I1 is I
     )
    ),
    count_SSL(T, I1, Count).

%% Checks if the line is valid according to the rules
%% valid_line(+,+).
%% valid_line(Parts,Squares).
valid_line(Parts, Squares):-
    valid_parts(Parts, ABA),
    valid_squares(Squares, ABA).

%% Cecks that there is atleast one ABA outside square brackets
%% valid_parts(+).
%% valid_parts(Squares)
valid_parts([H|_], ABA):-
    contains_aba(H, ABA).

valid_parts([_|T], ABA):-
    valid_parts(T, ABA).

%% Cecks that there is a BAB inside the square brackets
%% valid_squares(+).
%% valid_squares(Squares)
valid_squares([]).

valid_squares([H|_], ABA):-
    contains_bab(H, ABA).

valid_squares([_|T], ABA):-
    valid_squares(T, ABA).

%% Parses a line of input and checks it it is valid
%% parse_line(+).
%% parse_line(Line).
parse_line(Line):-
    parse_line(Line, [], [], Parts, Squares),
    valid_line(Parts, Squares).

parse_line([], Parts, Squares, Parts, Squares).

parse_line(Line, AccParts, AccSquares, Parts, Squares):-
    Line \= [],
    get_part(Line, Parts1, Rest),
    get_square(Rest, Squares1, Rest1),
    parse_line(Rest1, [Parts1|AccParts], [Squares1|AccSquares], Parts, Squares).

%% parses the test outside brackets
%% get_part(+,-,-).
%% get_part(Input, Text, Rest).
get_part([], [], []).

get_part([91|T], [], T).

get_part([H|T], [H|Xs], Rest):-
    H \= 91,
    get_part(T, Xs, Rest).

%% parses the test inside brackets
%% get_square(+,-,-).
%% get_square(Input, Text, Rest).
get_square([], [], []).

get_square([93|T], [], T).

get_square([H|T], [H|Xs], Rest):-
    H \= 93,
    get_square(T, Xs, Rest).

%% Checks if a string of text contains an ABBA
%% contains_abba(+).
%% contains_abba(String).
contains_aba([A,B,A|_], [A,B,A]):-
    A \= B.

contains_aba([_|T], ABA):-
    contains_aba(T, ABA).

contains_bab([B,A,B|_], [A,B,A]).

contains_bab([_|T], ABA):-
    contains_bab(T, ABA).

%% Reads inputstring
%% read_input(-).
%% read_input(VariableToStoreReadData).
get_input(Input):-
    open("7.txt", read, Stream),
    read_line_to_codes(Stream,Line1),
    get_input(Stream, Line1, Input).

get_input(Stream, Line1, Input):-
    get_input(Stream, Line1, [], Input).

get_input(_, end_of_file, Input, Input).

get_input(Stream, Line, Acc, Input):-
    is_list(Line),
    append(Acc, [Line], Acc1),
    read_line_to_codes(Stream,Line1),
    get_input(Stream, Line1, Acc1, Input).

%% Pretty print the result
%% pretty_print(+).
%% pretty_print(Result).
pretty_print(Count):-
    format("~p IPs support SSL ~n", [Count]).
