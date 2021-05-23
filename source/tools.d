module tools;


string cleanClassName( T )( T obj )
{
    import std.string : lastIndexOf;

    auto name = obj.classinfo.name;
    auto pos = name.lastIndexOf( '.' );

    if ( pos != -1 )
        return name[ pos + 1 .. $ ];
    else
        return name;
}