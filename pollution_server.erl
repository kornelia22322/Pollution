
-module(pollution_server).
-author("K").
%% API
-import(pollution,[createMonitor/0,addStation/3, addValue/5, removeValue/4,
getOneValue/4, getStationMean/3, getDailyMean/3,getMaximumGradientStation/2]).

-export([start/0, stop/0, loop/1]).
start() ->
  ServerPid = spawn(fun() -> loop(pollution:createMonitor()) end), % nowy proces, wysyłam monitor do loop, ma nazywac się pid zwrocony
  register(server, ServerPid). % do serwera wysylami pid
stop() ->
  server ! quit.

loop(Monitor) ->
  receive
    {addValue,{Latitude, Longitude},{Day,Hour},Type,Value} ->
      case addValue({Latitude, Longitude},{Day,Hour},Type,Value,Monitor) of
      {error, _} -> io:format("Monitor is going to end. Error.~n");
      _ -> io:format("ok~n"), loop(addValue({Latitude, Longitude},{Day,Hour},Type,Value,Monitor))
      end;
    {addValue,Name,{Day,Hour},Type,Value} ->
      case addValue(Name,{Day,Hour},Type,Value,Monitor) of
        {error, _} -> io:format("Monitor is going to end. Error.~n");
        _ ->       io:format("ok~n"),
          loop(addValue(Name,{Day,Hour},Type,Value,Monitor))
      end;
    {addStation,Name,{Latitude, Longitude}} ->
      case addStation(Name,{Latitude, Longitude},Monitor) of
        {error, _} -> io:format("Monitor is going to end. Error.~n");
        _ ->       io:format("ok~n"),
          loop(addStation(Name,{Latitude, Longitude},Monitor))
      end;
    {getDailyMean,Type,Day} ->
      case getDailyMean(Type, Day, Monitor) of
        {error, _} -> io:format("Monitor is going to end. Error.~n");
        _ ->       io:format("ok~n"),
          getDailyMean(Type, Day, Monitor),
          loop(Monitor)
      end;
    {getStationMean,Name,Type} ->
      case getStationMean(Name, Type, Monitor) of
        {error, _} -> io:format("Monitor is going to end. Error.~n");
        _ ->       io:format("ok~n"),
          {N}=getStationMean(Name, Type, Monitor),
          io:fwrite("~p ~n",[N]),
          loop(Monitor)
      end;
    {getOneValue,Name,Type,{Day,Hour}} ->
      case getOneValue(Name, Type, {Day,Hour}, Monitor) of
        {error, _} -> io:format("Monitor is going to end. Error.~n");
        _ ->       io:format("ok~n"),
          getOneValue(Name, Type, {Day,Hour}, Monitor),
          loop(Monitor)
      end;
    {removeValue,Name,{Day,Hour},Type} ->
      case removeValue(Name, {Day,Hour}, Type, Monitor) of
        {error, _} -> io:format("Monitor is going to end. Error.~n");
        _ ->       io:format("ok~n"),
          loop(removeValue(Name, {Day,Hour}, Type, Monitor))
      end;
    printMonitor ->
      io:format("ok~n"),
      [io:format("~p ~n",[Latitude])|| Latitude <- Monitor],
      loop(Monitor);
    quit -> io:format("quit")
  end.