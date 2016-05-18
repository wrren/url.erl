## url.erl

Provides URL encoding/decoding and generation functions.

## Rebar Installation

Add the following to your rebar.config:

```erlang
{ url, ".*",	{ git, "git://github.com/wrren/url.erl.git", { branch, "master" } } }
```

## Examples 

```erlang

%% URL Generation
"http://localhost/hello" 			= url:join( "http://localhost", ["hello"] ),
"http://localhost/hello" 			= url:join( "http://localhost/", ["hello"] ),
"http://localhost/hello/goodbye" 	= url:join( "http://localhost/", ["hello", "goodbye"] ),
"http://localhost/hello?yo=dawg" 	= url:join( "http://localhost/", ["hello"], #{ "yo" => "dawg" } ),
"http://localhost/hello?yo=dawg" 	= url:join( "http://localhost", ["hello"], #{ "yo" => "dawg" } ),
"http://localhost/hello?yo=dawg" 	= url:join( "http://localhost/", ["hello"], [{"yo", "dawg"}] ).

%% URL Encoding
<<"http%3A%2F%2Flocalhost%3A8080%2Fcallback">>	= url:encode( "http://localhost:8080/callback" ).
	
%% URL Decoding
<<"http://localhost:8080/callback">> = url:decode( <<"http%3A%2F%2Flocalhost%3A8080%2Fcallback">> ).

```

### Join

Given a base URL, path components and query parameters (proplist or map), form a full URL.

```erlang
url:join( BaseUrl :: string(), PathComponents :: [string()], QueryParameters :: map() | [{ string(), string() }] ) -> URL :: string().
```

### Encode

Encodes special characters using percent-encoding, allowing them to be sent as part of a URL.

```erlang
url:encode( string() ) -> binary().
```

### Decode

Decodes a URL that's been encoded using the encode function.

```erlang
url:decode( binary() ) -> string().
```