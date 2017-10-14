%%%-------------------------------------------------------------------
%%% @author Kornelia
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. maj 2017 19:49
%%%-------------------------------------------------------------------
-module(pollution_supervisor).
-author("Kornelia").

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},
init(_) ->
  {ok, {{one_for_all, 2, 2000},[{pollution_genserver,{pollution_genserver, start_link, []},permanent, brutal_kill, worker, [pollution_genserver]}]}}.
