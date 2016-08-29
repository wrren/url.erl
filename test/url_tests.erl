-module( url_tests ).
-author( "Warren Kenny <wkenny@riotgames.com>" ).

-include_lib( "eunit/include/eunit.hrl" ).

join_test() ->
	"http://localhost/hello" 			= url:join( "http://localhost", ["hello"] ),
	"http://localhost/hello" 			= url:join( "http://localhost/", ["hello"] ),
	"http://localhost/hello/goodbye" 	= url:join( "http://localhost/", ["hello", "goodbye"] ),
	"http://localhost/hello/goodbye" 	= url:join( "http://localhost/", ["/hello", "goodbye"] ),
	"http://localhost/hello/goodbye" 	= url:join( "http://localhost/", ["hello/", "goodbye"] ),
	"http://localhost/hello/goodbye" 	= url:join( "http://localhost/", ["/hello/", "goodbye"] ),
	"http://localhost/hello?yo=dawg" 	= url:join( "http://localhost/", ["hello"], #{ "yo" => "dawg" } ),
	"http://localhost/hello?yo=dawg" 	= url:join( "http://localhost", ["hello"], #{ "yo" => "dawg" } ),
	"http://localhost/hello?yo=dawg" 	= url:join( "http://localhost/", ["hello"], [{"yo", "dawg"}] ).

encode_test() ->
	<<"http%3A%2F%2Flocalhost%3A8080%2Fcallback">>	= url:encode( "http://localhost:8080/callback" ).
	
decode_test() ->
	<<"http://localhost:8080/callback">> = url:decode( <<"http%3A%2F%2Flocalhost%3A8080%2Fcallback">> ).
	
