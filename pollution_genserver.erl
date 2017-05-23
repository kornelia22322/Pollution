%%%-------------------------------------------------------------------
%%% @author Kornelcia
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. maj 2017 12:18
%%%-------------------------------------------------------------------
-module(pollution_genserver).
-behavior(gen_server).
-author("Kornelia").

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,  
  terminate/2]).

-export([crash/0,addStation/2,addValue/4, removeValue/3,getOneValue/3,getStationMean/2,getDailyMean/2]).

-define(SERVER, ?MODULE).

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
  {ok, []}.


addStation(Name,{Latitude, Longitude}) -> gen_server:call(?SERVER, {addStation,Name,{Latitude, Longitude}}).
addValue({Latitude, Longitude},{Day,Hour},Type,Value) -> gen_server:call(?SERVER, {addValue,{Latitude, Longitude},{Day,Hour},Type,Value});
addValue(Name,{Day,Hour},Type,Value)-> gen_server:call(?SERVER, {addValue,Name,{Day,Hour},Type,Value}).
getDailyMean(Type,Day)-> gen_server:call(?SERVER, {getDailyMean,Type,Day}).
getStationMean(Name,Type)-> gen_server:call(?SERVER, {getStationMean,Name,Type}).
getOneValue(Name,Type,{Day,Hour})-> gen_server:call(?SERVER, {getOneValue,Name,Type,{Day,Hour}}).
removeValue(Name,{Day,Hour},Type)-> gen_server:call(?SERVER, {removeValue,Name,{Day,Hour},Type}).

crash()-> 2/0.


handle_call({addValue,{Latitude, Longitude},{Day,Hour},Type,Value}, _From, State) ->
  case pollution:addValue({Latitude, Longitude},{Day,Hour},Type,Value,State) of
    {error, _} -> {reply,error, state};
    NewState -> {reply,ok, NewState}
  end;
handle_call({addValue,Name,{Day,Hour},Type,Value}, _From, State) ->
  case pollution:addValue(Name,{Day,Hour},Type,Value,State) of
    {error, _} -> {reply,error, state};
    NewState -> {reply,ok, NewState}
  end;
handle_call({addStation,Name,{Latitude, Longitude}}, _From, State) ->
  case pollution:addStation(Name,{Latitude, Longitude},State) of
    {error, _} -> {reply,error, state};
    NewState -> {reply,ok, NewState}
  end;
handle_call({getDailyMean,Type,Day}, _From, State) ->
  case pollution:getDailyMean(Type,Day,State) of
    {error, _} -> {reply,error, state};
    NewState -> {reply,ok, NewState}
  end;
handle_call({getStationMean,Name,Type}, _From, State) ->
  case pollution:getStationMean(Name,Type,State) of
    {error, _} -> {reply,error, state};
    NewState -> {reply,ok, NewState}
  end;
handle_call({getOneValue,Name,Type,{Day,Hour}}, _From, State) ->
  case pollution:getOneValue(Name,Type,{Day,Hour},State) of
    {error, _} -> {reply,error, state};
    NewState -> {reply,ok, NewState}
  end;
handle_call({removeValue,Name,{Day,Hour},Type}, _From, State) ->
  case pollution:removeValue(Name,{Day,Hour},Type,State) of
    {error, _} -> {reply,error, state};
    NewState -> {reply,ok, NewState}
  end.

terminate(_Reason, _State) ->
  ok.
%%%-------------------------------------------------------------------
%%% @author Kornelcia
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. maj 2017 12:18
%%%-------------------------------------------------------------------
-module(pollution_genserver).
-behavior(gen_server).
-author("Kornelia").

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,  
  terminate/2]).

-export([crash/0,addStation/2,addValue/4, removeValue/3,getOneValue/3,getStationMean/2,getDailyMean/2]).

-define(SERVER, ?MODULE).

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
  {ok, []}.


addStation(Name,{Latitude, Longitude}) -> gen_server:call(?SERVER, {addStation,Name,{Latitude, Longitude}}).
addValue({Latitude, Longitude},{Day,Hour},Type,Value) -> gen_server:call(?SERVER, {addValue,{Latitude, Longitude},{Day,Hour},Type,Value});
addValue(Name,{Day,Hour},Type,Value)-> gen_server:call(?SERVER, {addValue,Name,{Day,Hour},Type,Value}).
getDailyMean(Type,Day)-> gen_server:call(?SERVER, {getDailyMean,Type,Day}).
getStationMean(Name,Type)-> gen_server:call(?SERVER, {getStationMean,Name,Type}).
getOneValue(Name,Type,{Day,Hour})-> gen_server:call(?SERVER, {getOneValue,Name,Type,{Day,Hour}}).
removeValue(Name,{Day,Hour},Type)-> gen_server:call(?SERVER, {removeValue,Name,{Day,Hour},Type}).

crash()-> 2/0.


handle_call({addValue,{Latitude, Longitude},{Day,Hour},Type,Value}, _From, State) ->
  case pollution:addValue({Latitude, Longitude},{Day,Hour},Type,Value,State) of
    {error, _} -> {reply,error, state};
    NewState -> {reply,ok, NewState}
  end;
handle_call({addValue,Name,{Day,Hour},Type,Value}, _From, State) ->
  case pollution:addValue(Name,{Day,Hour},Type,Value,State) of
    {error, _} -> {reply,error, state};
    NewState -> {reply,ok, NewState}
  end;
handle_call({addStation,Name,{Latitude, Longitude}}, _From, State) ->
  case pollution:addStation(Name,{Latitude, Longitude},State) of
    {error, _} -> {reply,error, state};
    NewState -> {reply,ok, NewState}
  end;
handle_call({getDailyMean,Type,Day}, _From, State) ->
  case pollution:getDailyMean(Type,Day,State) of
    {error, _} -> {reply,error, state};
    NewState -> {reply,ok, NewState}
  end;
handle_call({getStationMean,Name,Type}, _From, State) ->
  case pollution:getStationMean(Name,Type,State) of
    {error, _} -> {reply,error, state};
    NewState -> {reply,ok, NewState}
  end;
handle_call({getOneValue,Name,Type,{Day,Hour}}, _From, State) ->
  case pollution:getOneValue(Name,Type,{Day,Hour},State) of
    {error, _} -> {reply,error, state};
    NewState -> {reply,ok, NewState}
  end;
handle_call({removeValue,Name,{Day,Hour},Type}, _From, State) ->
  case pollution:removeValue(Name,{Day,Hour},Type,State) of
    {error, _} -> {reply,error, state};
    NewState -> {reply,ok, NewState}
  end.


stop() ->
gen_server: cast(var_server, stop).
%% callbacks
handle_cast(stop, Value) ->
{stop, normal, Value}.
terminate(Reason, Value) ->
io:format("exit with value ~p~n", [Value]),
Reason.
