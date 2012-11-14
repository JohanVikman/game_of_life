-module(game_of_life_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    game_of_life_sup:start_link().

stop(_State) ->
    ok.
