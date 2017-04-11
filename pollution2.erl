-module(pollution2).
-author("Kornelia Rohulko").

-export([createMonitor/0, addStation/3, addValue/5, removeValue/4, getOneValue/4, getStationMean/3, getMinimumDistanceStations/1]).

-record(station, {name, coordinates , measurements=[]}).
-record(measurement,{localTime, valueType, value}).

createMonitor() -> [].

addStation(Sname, SCoordinates, M) ->
	case (lists:any(fun(#station{name=Name}) -> Name=:=Sname end, M) or lists:any(fun(#station{name=Name}) -> Name=:=Sname end, M)) of
		true -> {error,"Taka stacja już istnieje."};
		_ -> [#station{name=Sname, coordinates=SCoordinates}|M]
	end.
	
addValue({X,Y},Date,Type,Value,M) ->
	case lists:any(fun(#station{coordinates={X1,Y1}, measurements=Meauserm}) -> {X1,Y1}=:={X,Y}  andalso
	lists:any(fun(#measurement{localTime=Time, valueType=ValType}) -> Time=:=Date andalso ValType=:=Type end, Meauserm) end, M) of 
		false -> addValueActually({X,Y}, Date, Type, Value, M);
		_ -> {error,"Taki pomiar już istnieje."}
	end;

addValue(Sname, Date, Type, Value, M) ->
	case lists:any(fun(#station{name=Name, measurements=Meauserm}) -> Name=:=Sname andalso
	lists:any(fun(#measurement{localTime=Time, valueType=ValType}) -> Time=:=Date andalso ValType=:=Type end, Meauserm) end, M) of 
		false -> addValueActually(Sname, Date, Type, Value, M);
		_ -> {error,"Taki pomiar już istnieje."}
	end.

addValueActually(Sname, Date, Type, Value, [H=#station{name=Sname}|T]) -> [#station{name=H#station.name, coordinates=H#station.coordinates, measurements=H#station.measurements++[#measurement{localTime=Date, valueType=Type, value=Value}]}|T];
addValueActually(Sname, Date, Type, Value, [H|T]) -> [H|addValueActually(Sname, Date, Type, Value, T)];
addValueActually({X,Y}, Date, Type, Value, [H=#station{coordinates={X,Y}}|T]) -> [#station{name=H#station.name, coordinates=H#station.coordinates, measurements=H#station.measurements++[#measurement{localTime=Date, valueType=Type, value=Value}]}|T];
addValueActually({X,Y}, Date, Type, Value, [H|T]) -> [H|addValueActually({X,Y}, Date, Type, Value, T)].

removeValue({X,Y},Date,Type,M) ->
	case lists:any(fun(#station{coordinates={X1,Y1}, measurements=Meauserm}) -> {X1,Y1}=:={X,Y} andalso
	lists:any(fun(#measurement{localTime=Time, valueType=ValType}) -> Time=:=Date andalso ValType=:=Type end, Meauserm) end, M) of 
		true -> removeValueActually({X,Y}, Date, Type, M);
		_ -> {error, "Taki pomiar nie istnieje."}
	end;

removeValue(Sname,Date,Type,M) ->
	case lists:any(fun(#station{name=Name, measurements=Meauserm}) -> Name=:=Sname andalso
	lists:any(fun(#measurement{localTime=Time, valueType=ValType}) -> Time=:=Date andalso ValType=:=Type end, Meauserm) end, M) of 
		true -> removeValueActually(Sname, Date, Type, M);
		_ -> {error, "Taki pomiar nie istnieje."}
	end.

removeValueActually(Sname, Date, Type, [H=#station{name=Sname}|T]) -> [#station{name=H#station.name, coordinates=H#station.coordinates, measurements = lists:filter(fun(#measurement{localTime=T1, valueType=VT}) -> (VT/=Type andalso T1/=Date) end, H#station.measurements)}|T];
removeValueActually(Sname, Date, Type, [H|T]) -> [H|removeValueActually(Sname, Date, Type, T)];
removeValueActually({X,Y}, Date, Type, [H=#station{coordinates={X,Y}}|T]) -> [#station{name=H#station.name, coordinates=H#station.coordinates, measurements = lists:filter(fun(#measurement{localTime=T1, valueType=VT}) -> (VT/=Type andalso T1/=Date) end, H#station.measurements)}|T];
removeValueActually({X,Y}, Date, Type, [H|T]) -> [H|removeValueActually({X,Y}, Date, Type, T)].

getOneValue(Type,Date,Sname,M) ->
	case lists:any(fun(#station{name=Name, measurements=Meauserm}) -> Name=:=Sname andalso
	lists:any(fun(#measurement{localTime=Time, valueType=ValType}) -> Time=:=Date andalso ValType=:=Type end, Meauserm) end, M) of 
		true -> getValueActually(Type, Date, Sname,M);
		_ -> {error, "Taki pomiar nie istnieje."}
	end.
	
getValueActually(_,_,_,[]) -> {error, "Nie ma takiej wartości"};
getValueActually(Type, Date, Sname, [H=#station{name=Sname}|T]) ->	
	getSingleVal(lists:filter(fun(#measurement{localTime=T1, valueType=V1}) -> T1=:=Date andalso V1=:=Type end, H#station.measurements)).
	
getSingleVal([#measurement{value = V}]) -> V.

	
averageWith0([], 0, _) -> 0;
averageWith0(List,Length,Sum) -> average(List,Length,Sum).

average([H|T], Length, Sum) -> average(T, Length + 1, Sum + H);
average([], Length, Sum) -> Sum / Length.

getStationMean(Name, Type, []) -> 0;
getStationMean(Name, ValueType,[H=#station{name=Name}|T]) -> averageWith0(getList(H, ValueType),0,0);
getStationMean(Name,Type,[H|T]) -> getStationMean(Name,Type,T).

getList(#station{name = Name, measurements = Measurments}, ValueType) ->
  lists:map(fun(#measurement{localTime = LocalTime,valueType = ValueType, value = V}) -> V end,
    lists:filter(fun(#measurement{valueType = Type1}) -> (Type1=:= ValueType) end,Measurments)).
	
getDailyMean(_, _, []) -> [];
getDailyMean(LocalTime, ValueType, Monitor) -> averageWith0(lists:filter(fun(#measurement{localTime = LocalTime1,valueType = ValueType1, value = V}) -> (LocalTime=:=LocalTime1)and (ValueType=:=ValueType1)  end, conCat(makeAllMeasurementsList(Monitor))),0,0).

makeAllMeasurementsList(M) ->
  lists:map(fun(#station{name=N, coordinates=Coordinates, measurements = Measurements}) -> Measurements end ,M).

conCat([]) -> [];
conCat([H|Tail]) -> H++ conCat(Tail).

getMinimumDistanceStations(M) ->
	NewList= [{X,Y} || {_,_,{X,Y},_} <- M],
	ListX=[erlang:abs(X-Y) || {X,_} <- NewList, {Y,_} <- NewList],
	ListY=[erlang:abs(X-Y) || {_,X} <- NewList, {_,Y} <- NewList],
    [H|T]=lists:reverse(lists:sort([math:sqrt(X*X+Y*Y) || X <- ListX, Y<-ListY])),
	H.
