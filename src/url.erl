-module( url ).
-author( "Warren Kenny <warren.kenny@gmail.com>" ).

-export( [join/2, join/3, encode/1, decode/1] ).

%%
%%	Generate a URL by joining a base URL with the provided path and query parameters
%%
-spec join( binary() | list(), binary() | list() ) -> list().
join( Url, Path ) ->
	join( Url, Path, [] ).

-spec join( binary() | list(), binary() | list(), [{ list() | binary(), list() | binary() }] ) -> list().
join( Url, Path, QueryParams ) when is_list( Url ) ->
	case lists:last( Url ) of
		$/	-> 	join( lists:droplast( Url ), Path, QueryParams );
		_	->	join( list_to_binary( Url ), Path, QueryParams )
	end;

join( <<Url, $/>>, Path, QueryParams ) ->
	join( Url, Path, QueryParams );

join( Url, Path, QueryParams ) when is_map( QueryParams ) ->
	join( Url, Path, maps:to_list( QueryParams ) );	

join( Url, Path, QueryParams ) ->
	binary_to_list( iolist_to_binary( lists:droplast( lists:flatten( [ 	Url, 
							[ [ $/, P ] || P <- Path ], 
							$?, 
							[ [ want:string( K ), $=, want:string( V ), $& ] || { K, V } <- QueryParams ] ] ) ) ) ).

%%
%%	URL/Percent encode the given string
%%
-spec encode( binary() | string() | char() ) -> binary().
encode( URL ) when is_binary( URL ) ->
	encode( binary_to_list( URL ) );

encode( URL ) when is_list( URL ) ->
	encode( URL, [] );
	
%% IMPORTANT: These appear to be reversed, keep in mind that the encode result
%% is pushed into the head of the output list and it's reversed when all characters
%% have been processed so they need to be inserted in reverse-form!
encode( $! ) -> "12%";
encode( $# ) -> "32%";
encode( $$ ) -> "42%";
encode( $& ) -> "62%";
encode( $' ) -> "72%";
encode( $( ) -> "82%";
encode( $) ) -> "92%";
encode( $* ) -> "A2%";
encode( $+ ) -> "B2%";
encode( $, ) -> "C2%";
encode( $/ ) -> "F2%";
encode( $: ) -> "A3%";
encode( $; ) -> "B3%";
encode( $= ) -> "D3%";
encode( $? ) -> "F3%";
encode( $@ ) -> "04%";
encode( $[ ) -> "B5%";
encode( $] ) -> "D5%";
encode( C )	 -> C.
	
-spec encode( string(), string() ) -> binary().
encode( [C | T], Out ) ->
	encode( T, [ encode( C ) | Out ] );
	
encode( [], Out ) ->
	list_to_binary( lists:reverse( lists:flatten( Out ) ) ).
	
-spec decode( binary() | string() | char() ) -> binary().
decode( Encoded ) when is_binary( Encoded ) ->
	decode( binary_to_list( Encoded ) );
	
decode( "%21" ) -> $!;
decode( "%23" ) -> $#;
decode( "%24" ) -> $$;
decode( "%26" ) -> $&;
decode( "%27" ) -> $';
decode( "%28" ) -> $(;
decode( "%29" ) -> $);
decode( "%2A" ) -> $*;
decode( "%2B" ) -> $+;
decode( "%2C" ) -> $,;
decode( "%2F" ) -> $/;
decode( "%3A" ) -> $:;
decode( "%3B" ) -> $;;
decode( "%3D" ) -> $=;
decode( "%3F" ) -> $?;
decode( "%40" ) -> $@;
decode( "%5B" ) -> $[;
decode( "%5D" ) -> $];
decode( C = [ $%, _, _ ] )	 	-> C;

decode( Encoded ) when is_list( Encoded ) ->
	decode( Encoded, [] ).
	
-spec decode( string(), string() ) -> binary().
decode( [ $%, A, B | Rest ], Out ) ->
	decode( Rest, [ decode( [ $%, A, B ] ) | Out ] );

decode( [ C | Rest ], Out ) ->
	decode( Rest, [ C | Out ] );
	
decode( [], Out ) ->
	list_to_binary( lists:reverse( lists:flatten( Out ) ) ).
	
