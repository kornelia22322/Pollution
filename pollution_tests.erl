-module(pollution_tests).
-author("Kornelia Rohulko").

-export([getOneValue_test/0, getMinimumDistance_test/0]).

-include_lib("eunit/include/eunit.hrl").

getOneValue_test() ->
 P = pollution:createMonitor(),
 P1 = pollution:addStation("Krak_Aleje", {40.23, 54.23}, P),
 P2 = pollution:addValue("Krak_Aleje", {{2017,5,8},{15,11,20}}, "PM10", 250, P1),
 P3 = pollution:addValue("Krak_Aleje", {{2017,5,8},{15,31,20}}, "PM10", 300, P2),
 ?assertEqual(250, pollution:getOneValue("PM10",{{2017,5,8},{15,11,20}}, "Krak_Aleje",P3)),
 ?assertEqual(300, pollution:getOneValue("PM10",{{2017,5,8},{15,31,20}}, "Krak_Aleje",P3)). 

getMaximumDistanceStations_test() ->
 P = pollution:createMonitor(),
 P1 = pollution:addStation("Krak_Aleje", {40.23, 54.23}, P), 
 P2 = pollution:addStation("Krak_Aleje2", {40.33, 54.33}, P1), 
 P3 = pollution:addStation("Sandomierz", {45.33, 58.33}, P2), 
 P4 = pollution:addStation("Bialystok", {50.33, 59.33}, P3), 
 P5 = pollution:addStation("Sopot", {105.33, 165.33}, P4),
 ?assertEqual({"Krak_Aleje","Sopot"}, pollution:getMaximumDistanceStations(P5)).
 

