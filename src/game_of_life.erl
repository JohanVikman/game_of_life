-module(game_of_life).
-include_lib("eunit/include/eunit.hrl").

-export([
         start_link/0
        ]).
%%@authors : simon.unge@gmail.com, jowi7613@gmail.com


start_link() ->
    StartingCellPosition = [{0,0, true},{0,1, true},{1,0, true},{1,1, true},{2,0, true},{2,1, true}],
    {ok, erlang:spawn_link(loop(StartingCellPosition, 0))}.

loop(Cells,Generation) ->    
    NewCells = lists:map(fun(Cell) -> apply_rules(Cell, Cells) end, Cells),
    io:format("The new state after generation ~p is ~n~p~n",[Generation, NewCells]),
    timer:sleep(500),
    loop(NewCells, Generation+1).

apply_rules({_,_,LifeStatus} = Cell, Cells) ->
    Neighbours = find_all_neighbours(Cell, Cells),
    case {length(Neighbours), LifeStatus} of
        {V,_} when V < 2 ->
            kill(Cell);
        {2, true} ->
            remain_alive(Cell);
        {3, true} ->
            remain_alive(Cell);
        {V,false} when V == 3 ->
            create_life(Cell);
        _ ->
            overcrowding(Cell)
    end.

find_all_neighbours({X,Y,_},Cells) ->
    F = fun({A,B, LifeStatus}) ->
                case LifeStatus of
                    false ->
                        false;
                    true ->
                        adjacent({X,Y}, {A,B})
                end
        end,
    lists:filter(F, Cells).
                            
adjacent({X,Y}, {A,B}) ->
    case trunc(math:sqrt(math:pow(A-X,2) + math:pow(B-Y,2))) of
        1 ->
            true;
        _ ->
            false
    end.

kill({X,Y,_}) ->
    {X,Y,false}.

remain_alive({X,Y,_}) ->
    {X,Y,true}.

create_life({X,Y,_}) ->
    {X,Y,true}.

overcrowding({X,Y,_}) ->
    {X,Y,false}.
                                               
