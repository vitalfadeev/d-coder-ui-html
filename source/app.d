import std.stdio;

import std.algorithm : find;
import std.conv      : to;
import std.format    : format;
import std.math      : round;
import std.range     : front;
import std.range     : back;
import std.range     : empty;
import std.range     : retro;
import log           : Log;
import tools;


version ( Windows )
void main()
{
	writeln( "Start" );

    // App( "app.html" ).run();

    App app = {
        url: "app.html"
    };

    app.run();


    writeln( "Finish" );
}

/** */
version ( Windows )
{
    void initSDL()
    {
        import bindbc.sdl;

        auto ret = loadSDL();

        if ( ret != sdlSupport ) 
        {
            if ( ret == SDLSupport.noLibrary ) 
            {
                writeln( "SDLSupport.noLibrary" );
            }
            else 

            if ( SDLSupport.badLibrary ) 
            {
                writeln( "SDLSupport.badLibrary" );
            }
        }
    }
}

/** */
version ( Windows )
struct App
{
    string url = "index.html";
    string windowName;
    Window window;
    bool   running = true;


    void run()
    {
        initialize();

        SDL_Event Event;

        while ( SDL_PollEvent( &Event ) ) 
        {
            event( &Event );

            loop();

            render();
        }
         
        cleanup();
    }

private:
    void Initialize()
    {
        initSDL();

        window = Window.open( url, windowName );
        //window = Window.open( url, windowName, "width=640,height=480" );
    }

    void event( SDL_Event* event )
    {
        if ( event.type == SDL_QUIT ) 
        {
            running = false;
        }
    }

    void loop()
    {
        //
    }

    void render()
    {
        draw( surface, testSurface, 0, 0 );
        SDL_Flip( surface );
    }

    void cleanup()
    {
        SDL_FreeSurface( testSurface );
        SDL_FreeSurface( surface );
        SDL_Quit();
    }

    void draw( SDL_Surface* dst, SDL_Surface* src, int x, int y ) 
    {
        if ( dst == NULL || src == NULL) 
        {
            return;
        }
     
        SDL_Rect rect;
     
        rect.x = x;
        rect.y = y;
     
        SDL_BlitSurface( src, NULL, dst, &rect );
    }
}

/** */
struct HTMLParser
{
    string url = "index.html";

    void parse()
    {
        parseFile( url );
    }

    void parseFile( string fileName )
    {
        import std.file;
        string s = readText( fileName );
        parseString( s );
    }
    
    void parseString( string s )
    {
        //
    }    
}


/** */
interface IEventTarget
{
    //
}

/** */
class EventTarget : IEventTarget
{
    /** Registers an event handler to a specific event type on the element. */
    void addEventListener( string type, EventListener listener, Options options, bool useCapture=false )
    {
        _routes[ type ] = listener;
    }
    void addEventListener( string type, EventListener listener, Options options )
    {
        _routes[ type ] = listener;
    }
    void addEventListener( string type, EventListener listener, bool useCapture=false )
    {
        _routes[ type ] = listener;
    }
    void addEventListener( string type, EventListener listener )
    {
        _routes[ type ] = listener;
    }

    /** Dispatches an event to this node in the DOM and returns a Boolean that indicates whether no handler canceled the event. */
    bool dispatchEvent( Event event )
    {
        auto listener = event.type in _routes;

        if ( listener !is null )
        {
            listener.handleEvent( event );
            return true;
        }

        return true;
    }
    bool dispatchEvent( Event event, Element target )
    {
        Event event2 = new Event( event );
        event2.target = target;

        auto listener = event.type in _routes;

        if ( listener !is null )
        {
            listener.handleEvent( event2 );
            return true;
        }

        return true;
    }

    /** Removes an event listener from the element. */
    void removeEventListener( string type, EventListener listener, RemoveEventListenerOptions options )
    {
        _routes.remove( type );
    }
    void removeEventListener( string type, EventListener listener, bool useCapture )
    {
        _routes.remove( type );
    }
    void removeEventListener( string type, EventListener listener )
    {
        _routes.remove( type );
    }

protected:
    EventListener[ EventType ] _routes;
}

/** */
interface IDocument
{
    //
}

/** */
class Document : Node, IDocument
{
    // Properties
    /** Returns the Element that currently has focus. */
    Element activeElement()
    {
        return _activeElement;
    }

    /** Returns the <body> or <frameset> node of the current document. */
    Element body()
    {
        return _body;
    }

    /** Returns the character set being used by the document. */
    string characterSet()
    {
        return _characterSet;
    }

    /** Returns the number of child elements of the current document. */
    size_t childElementCount()
    {
        size_t count;

        foreach ( child; childNodes )
        {
            if ( child.nodeType == ELEMENT_NODE )
            {
                count += 1;
            }
        }

        return count;
    }

    /** Returns the child elements of the current document. */
    HTMLCollection children()
    {
        Element[] elements;

        for ( auto node = _firstChild; node !is null; node = node.nextSibling )
        {
            if ( node.nodeType == ELEMENT_NODE )
            {
                elements ~= cast ( Element ) node;
            }
        }

        return new HTMLCollection( elements );
    }

    /** Indicates whether the document is rendered in quirks or strict mode. */
    CompatMode compatMode()
    {
        return _compatMode;
    }

    /** Returns the Content-Type from the MIME Header of the current document. */
    string contentType()
    {
        return _contentType;
    }

    /** Returns the Document Type Definition (DTD) of the current document. */
    DocumentType doctype()
    {
        return _doctype;
    }

    /** Returns the Element that is a direct child of the document. For HTML documents, this is normally the HTMLHtmlElement object representing the document's <html> element. */
    Element documentElement()
    {
        return _documentElement;
    }

    /** Returns the document location as a string. */
    string documentURI()
    {
        return  _documentURI;
    }

    /** Returns a list of the embedded <embed> elements within the current document. */
    HTMLCollection embeds()
    {
        Element[] elements;

        for ( auto node = _firstChild; node !is null; node = node.nextSibling )
        {
            if ( node.nodeType == ELEMENT_NODE )
            if ( ( cast ( Element ) node ).tagName == "embed" )
            {
                elements ~= cast ( Element ) node;
            }
        }

        return new HTMLCollection( elements );
    }

    /** Returns the first child element of the current document. */
    Element firstElementChild()
    {
        if ( _firstChild !is null )
        for ( auto node = _firstChild; node !is null; node = node.nextSibling )
        {
            if ( node.nodeType == ELEMENT_NODE )
            {
                return node;
            }
        }

        return null;
    }

    /** Returns the FontFaceSet interface of the current document. */
    FontFaceSet fonts()
    {
        return _fonts;
    }

    /** Returns a list of the <form> elements within the current document. */
    HTMLCollection forms()
    {
        Element[] elements;

        for ( auto node = _firstChild; node !is null; node = node.nextSibling )
        {
            if ( node.nodeType == ELEMENT_NODE )
            if ( ( cast ( Element ) node ).tagName == "form" )
            {
                elements ~= cast ( Element ) node;
            }
        }

        return new HTMLCollection( elements );
    }

    /** The element that's currently in full screen mode for this document. */
    Element fullscreenElement()
    {
        return _fullscreenElement;
    }

    /** Returns the <head> element of the current document. */
    Element head()
    {
        return _head;
    }

    /** Returns a Boolean value indicating if the page is considered hidden or not. */
    bool hidden()
    {
        return _hidden;
    }

    /** Returns a list of the images in the current document. */
    HTMLCollection images()
    {
        Element[] elements;

        for ( auto node = _firstChild; node !is null; node = node.nextSibling )
        {
            if ( node.nodeType == ELEMENT_NODE )
            if ( ( cast ( Element ) node ).tagName == "img" )
            {
                elements ~= cast ( Element ) node;
            }
        }

        return new HTMLCollection( elements );
    }

    /** Returns the DOM implementation associated with the current document. */
    DOMImplementation implementation()
    {
        return _implementation;
    }

    /** Returns the last child element of the current document. */
    Element lastElementChild()
    {
        if ( _documentElement !is null )
            return _documentElement.lastElementChild();
        else
            return null;
    }

    /** Returns a list of all the hyperlinks in the document. */
    HTMLCollection links()
    {
        Element[] elements;

        for ( auto node = _firstChild; node !is null; node = node.nextSibling )
        {
            if ( node.nodeType == ELEMENT_NODE )
            if ( ( cast ( Element ) node ).tagName == "area"  ||
                 ( cast ( Element ) node ).tagName == "a" )
            {
                elements ~= cast ( Element ) node;
            }
        }

        return new HTMLCollection( elements );
    }

    /** Returns the Element currently being presented in picture-in-picture mode in this document. */
    void pictureInPictureElement()
    {
        return _pictureInPictureElement;
    }

    /** Returns true if the picture-in-picture feature is enabled. */
    bool pictureInPictureEnabled()
    {
        return _pictureInPictureEnabled;
    }

    /** Returns a list of the available plugins. */
    HTMLCollection plugins()
    {
        Element[] elements;

        for ( auto node = _firstChild; node !is null; node = node.nextSibling )
        {
            if ( node.nodeType == ELEMENT_NODE )
            if ( ( cast ( Element ) node ).tagName == "embed" )
            {
                elements ~= cast ( Element ) node;
            }
        }

        return new HTMLCollection( elements );
    }

    /** Returns the element set as the target for mouse events while the pointer is locked. null if lock is pending, pointer is unlocked, or if the target is in another document. */
    Element pointerLockElement()
    {
        return _pointerLockElement;
    }

    /** Returns the FeaturePolicy interface which provides a simple API for introspecting the feature policies applied to a specific document. */
    FeaturePolicy featurePolicy()
    {
        return null;
    }

    /** Returns all the <script> elements on the document. */
    HTMLCollection scripts()
    {
        Element[] elements;

        for ( auto node = _firstChild; node !is null; node = node.nextSibling )
        {
            if ( node.nodeType == ELEMENT_NODE )
            if ( ( cast ( Element ) node ).tagName == "script" )
            {
                elements ~= cast ( Element ) node;
            }
        }

        return new HTMLCollection( elements );
    }

    /** Returns a reference to the Element that scrolls the document. */
    Element scrollingElement()
    {
        return _scrollingElement;
    }

    /** Returns a StyleSheetList of CSSStyleSheet objects for stylesheets explicitly linked into, or embedded in a document. */
    StyleSheetList styleSheets()
    {
        return new StyleSheetList();
    }

    /** Returns timeline as a special instance of DocumentTimeline that is automatically created on page load. */
    DocumentTimeline timeline()
    {
        return new DocumentTimeline();
    }

    /** Returns a string denoting the visibility state of the document. Possible values are visible, hidden, prerender, and unloaded. */
    VisibilityState visibilityState()
    {
        return _visibilityState;
    }

    // Event handlers
    mixin EventHandler!"onfullscreenchange";   // Is an EventHandler representing the code to be called when the fullscreenchange event is raised.
    mixin EventHandler!"onfullscreenerror";    // Is an EventHandler representing the code to be called when the fullscreenerror event is raised.
    mixin EventHandler!"onreadystatechange";   // Represents the event handling code for the readystatechange event.
    mixin EventHandler!"onselectionchange";    // Is an EventHandler representing the code to be called when the selectionchange event is raised.
    mixin EventHandler!"onvisibilitychange";   // Is an EventHandler representing the code to be called when the visibilitychange event is raised.

    // GlobalEventHandlers
    mixin EventHandler!"onabort";              // Is an EventHandler representing the code to be called when the abort event is raised.
    mixin EventHandler!"onblur";               // Is an EventHandler representing the code to be called when the blur event is raised.
    mixin EventHandler!"onerror";              // Is an OnErrorEventHandler representing the code to be called when the error event is raised.
    mixin EventHandler!"onfocus";              // Is an EventHandler representing the code to be called when the focus event is raised.
    mixin EventHandler!"oncancel";             // Is an EventHandler representing the code to be called when the cancel event is raised.
    mixin EventHandler!"oncanplay";            // Is an EventHandler representing the code to be called when the canplay event is raised.
    mixin EventHandler!"oncanplaythrough";     // Is an EventHandler representing the code to be called when the canplaythrough event is raised.
    mixin EventHandler!"onchange";             // Is an EventHandler representing the code to be called when the change event is raised.
    mixin EventHandler!"onclick";              // Is an EventHandler representing the code to be called when the click event is raised.
    mixin EventHandler!"onclose";              // Is an EventHandler representing the code to be called when the close event is raised.
    mixin EventHandler!"oncontextmenu";        // Is an EventHandler representing the code to be called when the contextmenu event is raised.
    mixin EventHandler!"oncuechange";          // Is an EventHandler representing the code to be called when the cuechange event is raised.
    mixin EventHandler!"ondblclick";           // Is an EventHandler representing the code to be called when the dblclick event is raised.
    mixin EventHandler!"ondrag";               // Is an EventHandler representing the code to be called when the drag event is raised.
    mixin EventHandler!"ondragend";            // Is an EventHandler representing the code to be called when the dragend event is raised.
    mixin EventHandler!"ondragenter";          // Is an EventHandler representing the code to be called when the dragenter event is raised.
    mixin EventHandler!"ondragleave";          // Is an EventHandler representing the code to be called when the dragleave event is raised.
    mixin EventHandler!"ondragover";           // Is an EventHandler representing the code to be called when the dragover event is raised.
    mixin EventHandler!"ondragstart";          // Is an EventHandler representing the code to be called when the dragstart event is raised.
    mixin EventHandler!"ondrop";               // Is an EventHandler representing the code to be called when the drop event is raised.
    mixin EventHandler!"ondurationchange";     // Is an EventHandler representing the code to be called when the durationchange event is raised.
    mixin EventHandler!"onemptied";            // Is an EventHandler representing the code to be called when the emptied event is raised.
    mixin EventHandler!"onended";              // Is an EventHandler representing the code to be called when the ended event is raised.
    mixin EventHandler!"onformdata";           // Is an EventHandler for processing formdata events, fired after the entry list representing the form's data is constructed.
    mixin EventHandler!"ongotpointercapture";  // Is an EventHandler representing the code to be called when the gotpointercapture event type is raised.
    mixin EventHandler!"oninput";              // Is an EventHandler representing the code to be called when the input event is raised.
    mixin EventHandler!"oninvalid";            // Is an EventHandler representing the code to be called when the invalid event is raised.
    mixin EventHandler!"onkeydown";            // Is an EventHandler representing the code to be called when the keydown event is raised.
    mixin EventHandler!"onkeypress";           // Is an EventHandler representing the code to be called when the keypress event is raised.
    mixin EventHandler!"onkeyup";              // Is an EventHandler representing the code to be called when the keyup event is raised.
    mixin EventHandler!"onload";               // Is an EventHandler representing the code to be called when the load event is raised.
    mixin EventHandler!"onloadeddata";         // Is an EventHandler representing the code to be called when the loadeddata event is raised.
    mixin EventHandler!"onloadedmetadata";     // Is an EventHandler representing the code to be called when the loadedmetadata event is raised.
    mixin EventHandler!"onloadend";            // Is an EventHandler representing the code to be called when the loadend event is raised (when progress has stopped on the loading of a resource.)
    mixin EventHandler!"onloadstart";          // Is an EventHandler representing the code to be called when the loadstart event is raised (when progress has begun on the loading of a resource.)
    mixin EventHandler!"onlostpointercapture"; // Is an EventHandler representing the code to be called when the lostpointercapture event type is raised.
    mixin EventHandler!"onmousedown";          // Is an EventHandler representing the code to be called when the mousedown event is raised.
    mixin EventHandler!"onmouseenter";         // Is an EventHandler representing the code to be called when the mouseenter event is raised.
    mixin EventHandler!"onmouseleave";         // Is an EventHandler representing the code to be called when the mouseleave event is raised.
    mixin EventHandler!"onmousemove";          // Is an EventHandler representing the code to be called when the mousemove event is raised.
    mixin EventHandler!"onmouseout";           // Is an EventHandler representing the code to be called when the mouseout event is raised.
    mixin EventHandler!"onmouseover";          // Is an EventHandler representing the code to be called when the mouseover event is raised.
    mixin EventHandler!"onmouseup";            // Is an EventHandler representing the code to be called when the mouseup event is raised.
    mixin EventHandler!"onwheel";              // Is an EventHandler representing the code to be called when the wheel event is raised.
    mixin EventHandler!"onpause";              // Is an EventHandler representing the code to be called when the pause event is raised.
    mixin EventHandler!"onplay";               // Is an EventHandler representing the code to be called when the play event is raised.
    mixin EventHandler!"onplaying";            // Is an EventHandler representing the code to be called when the playing event is raised.
    mixin EventHandler!"onpointerdown";        // Is an EventHandler representing the code to be called when the pointerdown event is raised.
    mixin EventHandler!"onpointermove";        // Is an EventHandler representing the code to be called when the pointermove event is raised.
    mixin EventHandler!"onpointerup";          // Is an EventHandler representing the code to be called when the pointerup event is raised.
    mixin EventHandler!"onpointercancel";      // Is an EventHandler representing the code to be called when the pointercancel event is raised.
    mixin EventHandler!"onpointerover";        // Is an EventHandler representing the code to be called when the pointerover event is raised.
    mixin EventHandler!"onpointerout";         // Is an EventHandler representing the code to be called when the pointerout event is raised.
    mixin EventHandler!"onpointerenter";       // Is an EventHandler representing the code to be called when the pointerenter event is raised.
    mixin EventHandler!"onpointerleave";       // Is an EventHandler representing the code to be called when the pointerleave event is raised.
    mixin EventHandler!"onpointerlockchange";  // Is an EventHandler representing the code to be called when the pointerlockchange event is raised.
    mixin EventHandler!"onpointerlockerror";   // Is an EventHandler representing the code to be called when the pointerlockerror event is raised.
    mixin EventHandler!"onprogress";           // Is an EventHandler representing the code to be called when the progress event is raised.
    mixin EventHandler!"onratechange";         // Is an EventHandler representing the code to be called when the ratechange event is raised.
    mixin EventHandler!"onreset";              // Is an EventHandler representing the code to be called when the reset event is raised.
    mixin EventHandler!"onresize";             // Is an EventHandler representing the code to be called when the resize event is raised.
    mixin EventHandler!"onscroll";             // Is an EventHandler representing the code to be called when the scroll event is raised.
    mixin EventHandler!"onseeked";             // Is an EventHandler representing the code to be called when the seeked event is raised.
    mixin EventHandler!"onseeking";            // Is an EventHandler representing the code to be called when the seeking event is raised.
    mixin EventHandler!"onselect";             // Is an EventHandler representing the code to be called when the select event is raised.
    mixin EventHandler!"onselectstart";        // Is an EventHandler representing the code to be called when the selectionchange event is raised, i.e. when the user starts to make a new text selection on a web page.
    /* EventHandler onselectionchange;    // Is an EventHandler representing the code to be called when the selectionchange event is raised, i.e. when the text selected on a web page changes. */
    mixin EventHandler!"onsort";               // Is an EventHandler representing the code to be called when the sort event is raised.
    mixin EventHandler!"onstalled";            // Is an EventHandler representing the code to be called when the stalled event is raised.
    mixin EventHandler!"onsubmit";             // Is an EventHandler representing the code to be called when the submit event is raised.
    mixin EventHandler!"onsuspend";            // Is an EventHandler representing the code to be called when the suspend event is raised.
    mixin EventHandler!"ontimeupdate";         // Is an EventHandler representing the code to be called when the timeupdate event is raised.
    mixin EventHandler!"onvolumechange";       // Is an EventHandler representing the code to be called when the volumechange event is raised.
    mixin EventHandler!"ontransitioncancel";   // An EventHandler called when a transitioncancel event is sent, indicating that a CSS transition has been cancelled.
    mixin EventHandler!"ontransitionend";      // An EventHandler called when a transitionend event is sent, indicating that a CSS transition has finished playing.
    mixin EventHandler!"ontransitionrun";      // An EventHandler called when a transitionrun event is sent, indicating that a CSS transition is running, though not nessarilty started.
    mixin EventHandler!"ontransitionstart";    // An EventHandler called when a transitionstart event is sent, indicating that a CSS transition has started transitioning.
    mixin EventHandler!"onwaiting";            // Is an EventHandler representing the code to be called when the waiting event is raised.

    // Methods
    /** Adopt node from an external document. */
    Node adoptNode( Node externalNode )
    {
        return null;
    }

    /** Inserts a set of Node objects or DOMString objects after the last child of the document. */
    void append( Node node )
    {
        Element.append( node );
    }
    void append( string s )
    {
        Element.append( s );
    }

    /** Returns a CaretPosition object containing the DOM node containing the caret, and caret's character offset within that node. */
    CaretPosition caretPositionFromPoint( int x, int y )
    {
        return new CaretPosition();
    }

    // XPathEvaluator
    /** Compiles an XPathExpression which can then be used for (repeated) evaluations. */
    XPathExpression createExpression( string xpathText, NamespaceURLMapper namespaceURLMapper=null )
    {
        return new XPathExpression();
    }

    /** Creates an XPathNSResolver object. */
    XPathNSResolver createNSResolver( Node node )
    {
        return new XPathNSResolver();
    }

    /** Evaluates an XPath expression. */
    XPathResult evaluate( string xpathExpression, Node contextNode, XPathNSResolver namespaceResolver,
        XPathResultType resultType, XPathResult result=null )
    {
        return new XPathResult();
    }


protected:
    Element         _activeElement;
    Element         _body;
    string          _characterSet = "UTF-8";
    CompatMode      _compatMode;
    string          _contentType;
    DocumentType    _doctype;
    Element         _documentElement;
    string          _documentURI;
    FontFaceSet     _fonts;
    Element         _fullscreenElement;
    Element         _head;
    bool            _hidden;
    DOMImplementation _implementation;
    Element         _pictureInPictureElement;
    bool            _pictureInPictureEnabled;
    Element         _pointerLockElement;
    Element         _scrollingElement;
    VisibilityState _visibilityState;
}

/** */
mixin template EventHandler( string ENAME )
{
    //
}

/** */
class XPathNSResolver
{
    string resolve( Node node, string ns )
    {
        return "";
    }
}

/** */
class XPathExpression
{
    /** Evaluates the XPath expression on the given node or document. */
    XPathResult evaluate( Node contextNode, XPathResultType type, XPathResult result=null )
    {
        return new XPathResult();
    }
}

/** */
enum XPathResultType
{
    ANY_TYPE                     = 0, // A result set containing whatever type naturally results from evaluation of the expression. Note that if the result is a node-set then UNORDERED_NODE_ITERATOR_TYPE is always the resulting type.
    STRING_TYPE                  = 2, // A result containing a single string.
    NUMBER_TYPE                  = 1, // A result containing a single number. This is useful for example, in an XPath expression using the count() function.
    BOOLEAN_TYPE                 = 3, // A result containing a single boolean value. This is useful for example, in an XPath expression using the not() function.
    UNORDERED_NODE_ITERATOR_TYPE = 4, // A result node-set containing all the nodes matching the expression. The nodes may not necessarily be in the same order that they appear in the document.
    ORDERED_NODE_ITERATOR_TYPE   = 5, // A result node-set containing all the nodes matching the expression. The nodes in the result set are in the same order that they appear in the document.
    UNORDERED_NODE_SNAPSHOT_TYPE = 6, // A result node-set containing snapshots of all the nodes matching the expression. The nodes may not necessarily be in the same order that they appear in the document.
    ORDERED_NODE_SNAPSHOT_TYPE   = 7, // A result node-set containing snapshots of all the nodes matching the expression. The nodes in the result set are in the same order that they appear in the document.
    ANY_UNORDERED_NODE_TYPE      = 8, // A result node-set containing any single node that matches the expression. The node is not necessarily the first node in the document that matches the expression.
    FIRST_ORDERED_NODE_TYPE      = 9, // A result node-set containing the first node in the document that matches the expression.    //
}

/** */
class XPathResult
{
    //
}

/** */
alias NamespaceURLMapper = string function( string prefix );

/** */
class CaretPosition
{
    /** Returns a Node containing the found node at the caret's position. */
    Node offsetNode()
    {
        return _offsetNode;
    }

    /** Returns a long representing the character offset in the caret position node. */
    size_t offset()
    {
        return _offset;
    }

    /** */
    Rect getClientRect()
    {
        return Rect();
    }

protected:
    Node _offsetNode;
    size_t _offset;
}

/** */
struct Rect
{
    //
}

/** */
class HTMLDocument : Document
{
    /** Returns a semicolon-separated list of the cookies for that document or sets a single cookie. */
    string cookie()
    {
        return _cookie;
    }

    /** Returns a reference to the window object. */
    Window defaultView()
    {
        return _defaultView;
    }

    /** Gets/sets the ability to edit the whole document. */
    DesignMode designMode()
    {
        return _designMode;
    }

    /** Gets/sets directionality (rtl/ltr) of the document. */
    Dir dir()
    {
        return _dir;
    }

    /** Returns the date on which the document was last modified. */
    string lastModified()
    {
        return _lastModified;
    }

    /** Returns the URI of the current document. */
    Location location()
    {
        return _location;
    }

    /** Returns loading status of the document. */
    ReadyState readyState()
    {
        return _readyState;
    }

    /** Returns the URI of the page that linked to this page. */
    string referrer()
    {
        return _referrer;
    }

    /** Sets or gets the title of the current document. */
    string title()
    {
        return _title;
    }

    /** Returns the document location as a string. */
    string URL()
    {
        return location.toString();
    }

    /** Closes a document stream for writing. */
    void close()
    {
        _opened = false;
    }

    /** Returns a list of elements with the given name. */
    NodeList getElementsByName( string name )
    {
        Element[] elements;

        for ( auto node = _firstChild; node !is null; node = node.nextSibling )
        {
            if ( node.nodeType == ELEMENT_NODE )
            if ( ( cast ( Element ) node ).name == name )
            {
                elements ~= cast ( Element ) node;
            }
        }

        return new NodeList( elements );
    }

    /** Returns true if the focus is currently located anywhere inside the specified document. */
    bool hasFocus()
    {
        return _hasFocus;
    }

    /** Opens a document stream for writing. */
    void open()
    {
        _opened = true;
    }

    /** Writes text in a document. */
    void write( string markup )
    {
        //
    }

    /** Writes a line of text in a document. */
    void writeln( string line )
    {
        //
    }

    // Events
    enum Events
    {
        scroll,             // Fired when the document view or an element has been scrolled.
        visibilitychange,   // Fired when the content of a tab has become visible or has been hidden.
        wheel,              // Fired when the user rotates a wheel button on a pointing device (typically a mouse).
        // Animation events
        animationcancel,    // Fired when an animation unexpectedly aborts.
        animationend,       // Fired when an animation has completed normally.
        animationiteration, // Fired when an animation iteration has completed.
        animationstart,     // Fired when an animation starts.
        // Clipboard events
        copy,               // Fired when the user initiates a copy action through the browser's user interface.
        cut,                // Fired when the user initiates a cut action through the browser's user interface.
        paste,              // Fired when the user initiates a paste action through the browser's user interface.
        // Drag & drop events
        drag,               // Fired every few hundred milliseconds as an element or text selection is being dragged by the user.
        dragend,            // Fired when a drag operation is being ended (by releasing a mouse button or hitting the escape key).
        dragenter,          // Fired when a dragged element or text selection enters a valid drop target.
        dragleave,          // Fired when a dragged element or text selection leaves a valid drop target.
        dragover,           // Fired when an element or text selection is being dragged over a valid drop target (every few hundred milliseconds).
        dragstart,          // Fired when the user starts dragging an element or text selection.
        drop,               // Fired when an element or text selection is dropped on a valid drop target.
        // Fullscreen events
        fullscreenchange,   // Fired when the Document transitions into or out of full-screen mode.
        fullscreenerror,    // Fired if an error occurs while attempting to switch into or out of full-screen mode.
        // Keyboard events
        keydown,            // Fired when a key is pressed.
        keyup,              // Fired when a key is released.
        // Load & unload events
        DOMContentLoaded,   // Fired when the document has been completely loaded and parsed, without waiting for stylesheets, images, and subframes to finish loading.
        readystatechange,   // Fired when the readyState attribute of a document has changed.
        // Pointer events
        gotpointercapture,  // Fired when an element captures a pointer using setPointerCapture().
        lostpointercapture, // Fired when a captured pointer is released.
        pointercancel,      // Fired when a pointer event is canceled.
        pointerdown,        // Fired when a pointer becomes active.
        pointerenter,       // Fired when a pointer is moved into the hit test boundaries of an element or one of its descendants.
        pointerleave,       // Fired when a pointer is moved out of the hit test boundaries of an element.
        pointerlockchange,  // Fired when the pointer is locked/unlocked.
        pointerlockerror,   // Fired when locking the pointer failed.
        pointermove,        // Fired when a pointer changes coordinates.
        pointerout,         // Fired when a pointer is moved out of the hit test boundaries of an element (among other reasons).
        pointerover,        // Fired when a pointer is moved into an element's hit test boundaries.
        pointerup,          // Fired when a pointer is no longer active.
        // Selection events
        selectionchange,    // Fired when the current text selection on a document is changed.
        selectstart,        // Fired when the user begins a new selection.
        // Touch events
        touchcancel,        // Fired when one or more touch points have been disrupted in an implementation-specific manner (for example, too many touch points are created).
        touchend,           // Fired when one or more touch points are removed from the touch surface.
        touchmove,          // Fired when one or more touch points are moved along the touch surface.
        touchstart,         // Fired when one or more touch points are placed on the touch surface.
        // Transition events
        transitioncancel,   // Fired when a CSS transition is canceled.
        transitionend,      // Fired when a CSS transition has completed.
        transitionrun,      // Fired when a CSS transition is first created.
        transitionstart,    // Fired when a CSS transition has actually started.
    }
    mixin EventMixin!"scroll";
    mixin EventMixin!"visibilitychange";
    mixin EventMixin!"wheel";
    // Animation events
    mixin EventMixin!"animationcancel";
    mixin EventMixin!"animationend";
    mixin EventMixin!"animationiteration";
    mixin EventMixin!"animationstart";
    // Clipboard events
    mixin EventMixin!"copy";
    mixin EventMixin!"cut";
    mixin EventMixin!"paste";
    // Drag & drop events
    mixin EventMixin!"drag";
    mixin EventMixin!"dragend";
    mixin EventMixin!"dragenter";
    mixin EventMixin!"dragleave";
    mixin EventMixin!"dragover";
    mixin EventMixin!"dragstart";
    mixin EventMixin!"drop";
    // Fullscreen events
    mixin EventMixin!"fullscreenchange";
    mixin EventMixin!"fullscreenerror";
    // Keyboard events
    mixin EventMixin!"keydown";
    mixin EventMixin!"keyup";
    // Load & unload events
    mixin EventMixin!"DOMContentLoaded";
    mixin EventMixin!"readystatechange";
    // Pointer events
    mixin EventMixin!"gotpointercapture";
    mixin EventMixin!"lostpointercapture";
    mixin EventMixin!"pointercancel";
    mixin EventMixin!"pointerdown";
    mixin EventMixin!"pointerenter";
    mixin EventMixin!"pointerleave";
    mixin EventMixin!"pointerlockchange";
    mixin EventMixin!"pointerlockerror";
    mixin EventMixin!"pointermove";
    mixin EventMixin!"pointerout";
    mixin EventMixin!"pointerover";
    mixin EventMixin!"pointerup";
    // Selection events
    mixin EventMixin!"selectionchange";
    mixin EventMixin!"selectstart";
    // Touch events
    mixin EventMixin!"touchcancel";
    mixin EventMixin!"touchend";
    mixin EventMixin!"touchmove";
    mixin EventMixin!"touchstart";
    // Transition events
    mixin EventMixin!"transitioncancel";
    mixin EventMixin!"transitionend";
    mixin EventMixin!"transitionrun";
    mixin EventMixin!"transitionstart";


protected:
    string     _cookie;
    Window     _defaultView;
    Dir        _dir;
    string     _lastModified;
    Location   _location;
    ReadyState _readyState;
    string     _referrer;
    string     _title;
    bool       _hasFocus;
    bool       _opened;
}

/** */
enum ReadyState
{
    loading,
    interactive,
    complete
}

/** */
class Location
{
    /** Is a static DOMStringList containing, in reverse order, the origins of all ancestor browsing contexts of the document associated with the given Location object. */
    DOMStringList ancestorOrigins()
    {
        return new DOMStringList();
    }

    /** Is a stringifier that returns a USVString containing the entire URL. If changed, the associated document navigates to the new page. It can be set from a different origin than the associated document. */
    string href()
    {
        return _href;
    }

    /** Is a USVString containing the protocol scheme of the URL, including the final ':'. */
    string protocol()
    {
        return _protocol;
    }

    /** Is a USVString containing the host, that is the hostname, a ':', and the port of the URL. */
    string host()
    {
        return _host;
    }

    /** Is a USVString containing the domain of the URL. */
    string hostname()
    {
        return _hostname;
    }

    /** Is a USVString containing the port number of the URL. */
    string port()
    {
        return _port;
    }

    /** Is a USVString containing an initial '/' followed by the path of the URL, not including the query string or fragment. */
    string pathname()
    {
        return _pathname;
    }

    /** Is a USVString containing a '?' followed by the parameters or "querystring" of the URL. Modern browsers provide URLSearchParams and URL.searchParams to make it easy to parse out the parameters from the querystring. */
    string search()
    {
        return _search;
    }

    /** Is a USVString containing a '#' followed by the fragment identifier of the URL. */
    string hash()
    {
        return _hash;
    }

    /** Returns a USVString containing the canonical form of the origin of the specific location. */
    string origin()
    {
        return _origin;
    }

    //
    /** Loads the resource at the URL provided in parameter. */
    void assign( string url )
    {
        //
    }

    /** Reloads the current URL, like the Refresh button. */
    void reload()
    {
        //
    }

    /** Replaces the current resource with the one at the provided URL (redirects to the provided URL). The difference from the assign() method and setting the href property is that after using replace() the current page will not be saved in session History, meaning the user won't be able to use the back button to navigate to it. */
    void replace( string url )
    {
        //
    }

    /** Returns a USVString containing the whole URL. It is a synonym for HTMLAnchorElement.href, though it can't be used to modify the value. */
    string toString()
    {
        return "";
    }

protected:
    string _url;
    string _href;
    string _protocol;
    string _host;
    string _hostname;
    string _port;
    string _pathname;
    string _search;
    string _hash;
    string _origin;
}

/** */
enum Dir
{
    ltr,
    rtl,
    auto_
}

/** */
class Window : EventTarget
{
    /** DOMParser can parse XML or HTML source stored in a string into a DOM Document. DOMParser is specified in DOM Parsing and Serialization. */
    static
    Document DOMParser( string s )
    {
        auto parser = new DOMParser();
        return parser.parseFromString( s );
    }

    /** Used for creating an HTMLImageElement. */
    static
    HTMLImageElement Image( int width, int height )
    {
        return new HTMLImageElement();
    }

    /** Used for creating an HTMLOptionElement. */
    HTMLOptionElement Option( string text, string value, bool defaultSelected, bool selected )
    {
        return new Option();
    }

    /** Returns a StaticRange() constructor which creates a StaticRange object. */
    static
    StaticRange StaticRange()
    {
        StaticRangeInit rangeSpec;
        return new StaticRange( rangeSpec );
    }

    /** Used for creating a Web worker. */
    Worker Worker( string aURL, WorkerOptions options )
    {
        return new Worker( aURL, options );
    }

    /** Converts a DOM tree into XML or HTML source. */
    XMLSerializer XMLSerializer()
    {
        return new XMLSerializer();
    }

    // Properties
    /** This property indicates whether the current window is closed or not. */
    bool closed()
    {
        return _closed;
    }

    /** Returns a reference to the console object which provides access to the browser's debugging console. */
    void console( T )( T someObject )
    {
        writeln( someObject );
    }

    /** Returns a reference to the CustomElementRegistry object, which can be used to register new custom elements and get information about previously registered custom elements. */
    CustomElementRegistry customElements()
    {
        return customElementRegistry;
    }

    /** Returns the browser crypto object. */
    Crypto crypto()
    {
        return .crypto;
    }

    /** Returns the ratio between physical pixels and device independent pixels in the current display. */
    uint devicePixelRatio()
    {
        return _devicePixelRatio ;
    }

    /** Returns a reference to the document that the window contains. */
    Document document()
    {
        return _document;
    }

    /** Returns the element in which the window is embedded, or null if the window is not embedded. */
    Element frameElement()
    {
        for ( auto node = _firstChild; node !is null; node = node.nextSibling )
        {
            if ( node.nodeType == ELEMENT_NODE )
            if (
                ( cast ( Element ) node ).tagName == "iframe" ||
                ( cast ( Element ) node ).tagName == "object" ||
                ( cast ( Element ) node ).tagName == "embed"
               )
            {
                return cast ( Element ) node;
            }
        }

        return null;
    }

    /** Returns an array of the subframes in the current window. */
    Window[] frames()
    {
        Window[] wins;

        for ( auto node = _firstChild; node !is null; node = node.nextSibling )
        {
            if ( node.nodeType == ELEMENT_NODE )
            if (
                ( cast ( Element ) node ).tagName == "iframe" ||
                ( cast ( Element ) node ).tagName == "frame"
               )
            {
                wins != ( cast ( Element ) node ).defaultView;
            }
        }

        return wins;
    }

    /** This property indicates whether the window is displayed in full screen or not. */
    bool fullScreen()
    {
        return _fullScreen;
    }

    /** Returns a reference to the history object. */
    History history()
    {
        return _history;
    }

protected:
    bool     _closed;
    uint     _devicePixelRatio;
    Document _document;
    bool     _fullScreen;
    History  _history;
}

/** */
class History
{
    /** Returns an Integer representing the number of elements in the session history, including the currently loaded page. For example, for a page loaded in a new tab this property returns 1. */
    size_t length()
    {
        return _arr.length;
    }

    /** Allows web applications to explicitly set default scroll restoration behavior on history navigation. This property can be either auto or manual. */
    ScrollRestoration scrollRestoration()
    {
        return _scrollRestoration;
    }

    /** Returns an any value representing the state at the top of the history stack. This is a way to look at the state without having to wait for a popstate event. */
    auto state()
    {
        return _arr.front;
    }

    /** This asynchronous method goes to the previous page in session history, the same action as when the user clicks the browser's Back button. Equivalent to history.go(-1). */
    void back()
    {
        //
    }

    /** This asynchronous method goes to the next page in session history, the same action as when the user clicks the browser's Forward button; this is equivalent to history.go(1). */
    void forward()
    {
        //
    }

    /** Asynchronously loads a page from the session history, identified by its relative location to the current page, for example -1 for the previous page or 1 for the next page. If you specify an out-of-bounds value (for instance, specifying -1 when there are no previously-visited pages in the session history), this method silently has no effect. Calling go() without parameters or a value of 0 reloads the current page. Internet Explorer lets you specify a string, instead of an integer, to go to a specific URL in the history list. */
    void go( int delta )
    {
        if ( delta < 0 )
            _pos += delta;
        else
            _pos += delta;
    }

    /** Pushes the given data onto the session history stack with the specified title (and, if provided, URL). The data is treated as opaque by the DOM; you may specify any JavaScript object that can be serialized.  Note that all browsers but Safari currently ignore the title parameter. For more information, see Working with the History API. */
    void pushState( HistoryState state, string title )
    {
        //
    }
    void pushState( HistoryState state, string title, string  url )
    {
        //
    }

    /** Updates the most recent entry on the history stack to have the specified data, title, and, if provided, URL. The data is treated as opaque by the DOM; you may specify any JavaScript object that can be serialized.  Note that all browsers but Safari currently ignore the title parameter. For more information, see Working with the History API. */
    void replaceState( HistoryState state, string title )
    {
        //
    }
    void replaceState( HistoryState state, string title, string  url )
    {
        //
    }

    /** Gets the height of the content area of the browser window including, if rendered, the horizontal scrollbar. */
    int innerHeight()
    {
        return _layoutViewport.height;
    }

    /** Gets the width of the content area of the browser window including, if rendered, the vertical scrollbar. */
    int innerWidth()
    {
        return _layoutViewport.width;
    }

    /** Indicates whether a context is capable of using features that require secure contexts. */
    bool isSecureContext()
    {
        return _isSecureContext;
    }

    /** Returns the number of frames in the window. See also window.frames. */
    size_t length()
    {
        size_t l;

        for ( auto node = _firstChild; node !is null; node = node.nextSibling )
        {
            if ( node.nodeType == ELEMENT_NODE )
            if (
                ( cast ( Element ) node ).tagName == "iframe" ||
                ( cast ( Element ) node ).tagName == "frame"
               )
            {
                l += 1;
            }
        }

        return l;
    }

    /** Gets/sets the location, or current URL, of the window object. */
    Location location()
    {
        return _location;
    }
    Location location( string loc )
    {
        return _location;
    }

    /** Returns the locationbar object, whose visibility can be toggled in the window. */
    Locationbar locationbar()
    {
        return _locationbar;
    }

    /** Returns a reference to the local storage object used to store data that may only be accessed by the origin that created it. */
    Storage localStorage()
    {
        return _localStorage;
    }

    /** Returns the menubar object, whose visibility can be toggled in the window. */
    Menubar menubar()
    {
        return _menubar;
    }

    /** Gets/sets the name of the window. */
    string name()
    {
        return _name;
    }
    void name( string s )
    {
        _name = s;
    }

    /** Returns a reference to the navigator object. */
    Navigator navigator()
    {
        return _navigator;
    }

    /** Returns a reference to the window that opened this current window. */
    Window opener()
    {
        return _opener;
    }

    /** Gets the height of the outside of the browser window. */
    int outerHeight()
    {
        return 0;
    }

    /** Gets the width of the outside of the browser window. */
    int outerWidth()
    {
        return 0;
    }

    /** An alias for window.scrollX. */
    alias pageXOffset = scrollX;

    /** An alias for window.scrollY */
    alias pageYOffset = scrollY;

    /** Returns a reference to the parent of the current window or subframe. */
    Window parent()
    {
        return _parent;
    }

    /** Returns a Performance object, which includes the timing and navigation attributes, each of which is an object providing performance-related data. See also Using Navigation Timing for additional information and examples. */
    Performance performance()
    {
        return _performance;
    }

    /** Returns the personalbar object, whose visibility can be toggled in the window. */
    Personalbar personalbar()
    {
        return _personalbar;
    }

    /** Returns a reference to the screen object associated with the window. */
    Screen screen()
    {
        return _screen;
    }

    /** Both properties return the horizontal distance from the left border of the user's browser viewport to the left side of the screen. */
    int screenX()
    {
        return 0;
    }
    alias screenLeft = screenX;

    /** Both properties return the vertical distance from the top border of the user's browser viewport to the top side of the screen. */
    int screenY()
    {
        return 0;
    }
    alias screenTop = screenY;

    /** Returns the scrollbars object, whose visibility can be toggled in the window. */
    Scrollbars scrollbars()
    {
        return _scrollbars;
    }

    /** Returns the number of pixels that the document has already been scrolled horizontally. */
    int scrollX()
    {
        return _scrollX;
    }

    /** Returns the number of pixels that the document has already been scrolled vertically. */
    int scrollY()
    {
        return _scrollY;
    }

    /** Returns an object reference to the window object itself. */
    WindowProxy self()
    {
        return new WindowProxy( this );
    }

    /** Returns a reference to the session storage object used to store data that may only be accessed by the origin that created it. */
    Storage sessionStorage()
    {
        return _sessionStorage;
    }

    /** Returns a SpeechSynthesis object, which is the entry point into using Web Speech API speech synthesis functionality. */
    SpeechSynthesis speechSynthesis()
    {
        return new SpeechSynthesis();
    }

    /** Returns the statusbar object, whose visibility can be toggled in the window. */
    Statusbar statusbar()
    {
        return _statusbar;
    }

    /** Returns the toolbar object, whose visibility can be toggled in the window. */
    Toolbar toolbar()
    {
        return _toolbar;
    }

    /** Returns a reference to the topmost window in the window hierarchy. This property is read only. */
    Window top()
    {
        auto win = this;

        while ( win.parent !is null )
        {
            win = win.parent;
        }

        return win;
    }

    /** Returns a VisualViewport object which represents the visual viewport for a given window. */
    VisualViewport visualViewport()
    {
        return _visualViewport;
    }

    /** Returns a reference to the current window. */
    Window window()
    {
        return this;
    }

    /** window[0], window[1], etc. */
    Window opIndex( size_t i )
    {
        return frames[ i ];
    }

    /** Returns the CacheStorage object associated with the current context. This object enables functionality such as storing assets for offline use, and generating custom responses to requests. */
    CacheStorage caches()
    {
        return _caches;
    }

    /** Provides a mechanism for applications to asynchronously access capabilities of indexed databases; returns an IDBFactory object. */
    IDBFactory indexedDB()
    {
        return new IDBFactory();
    }

    /** Returns a boolean indicating whether the current context is secure (true) or not (false). */
    bool isSecureContext()
    {
        return _isSecureContext;
    }

    /** Returns the global object's origin, serialized as a string. (This does not yet appear to be implemented in any browser.) */
    string origin()
    {
        return _origin;
    }

    //
    /** Displays an alert dialog. */
    void alert( string message )
    {
        //
    }

    /** Sets focus away from the window. */
    void blur()
    {
        //
    }

    /** Enables you to cancel a callback previously scheduled with Window.requestAnimationFrame. */
    void cancelAnimationFrame( int requestID )
    {
        //
    }

    /** Enables you to cancel a callback previously scheduled with Window.requestIdleCallback. */
    void cancelIdleCallback( IdleCallback handle )
    {
        //
    }

    /** Cancels the repeated execution set using setImmediate. */
    void clearImmediate( int immediateID  )
    {
        //
    }

    /** Closes the current window. */
    void close()
    {
        //
    }

    /** Displays a dialog with a message that the user needs to respond to. */
    bool confirm( string message )
    {
        return false;
    }

    /** Searches for a given string in a window. */
    bool find( string aString, bool aCaseSensitive, bool aBackwards, bool aWrapAround,
               bool aWholeWord, bool aSearchInFrames, bool aShowDialog )
    {
        return false;
    }

    /** Sets focus on the current window. */
    void focus()
    {
        //
    }

    /** Gets computed style for the specified element. Computed style indicates the computed values of all CSS properties of the element. */
    ComputedStyle getComputedStyle( Element element, string pseudoElt )
    {
        return ComputedStyle();
    }
    ComputedStyle getComputedStyle( Element element )
    {
        return ComputedStyle();
    }

    /** Returns the selection object representing the selected item(s). */
    Selection getSelection()
    {
        return _selection;
    }

    /** Returns a MediaQueryList object representing the specified media query string. */
    MediaQueryList matchMedia( string mediaQueryString )
    {
        return new MediaQueryList();
    }

    /** Maximize window */
    void maximize()
    {
        //
    }

    /** Minimizes the window. */
    void minimize()
    {
        //
    }

    /** Moves the current window by a specified amount. */
    void moveBy( int deltaX, int deltaY )
    {
        //
    }

    /** Moves the window to the specified coordinates. */
    void moveTo( int x, int y )
    {
        //
    }

    /** Opens a new window. */
    static
    Window open( string url, string windowName, string windowFeatures )
    {
        _open();
        return new Window();
    }
    static
    Window open( string url, string windowName )
    {
        _open();
        return new Window();
    }

    private _open()
    {
        surface = SDL_SetVideoMode( 640, 480, 32, SDL_HWSURFACE | SDL_DOUBLEBUF );

        if ( surface == NULL ) 
        {
            return;
        }

        // test
        string fileName = "test.bmp";
        SDL_Surface* tempSurface = NULL;
        SDL_Surface* testSurface  = NULL;
     
        if ( ( tempSurface = SDL_LoadBMP( fileName ) ) == NULL ) 
        {
            return NULL;
        }
     
        testSurface = SDL_DisplayFormat( tempSurface );
        SDL_FreeSurface( tempSurface );             
    }

    /** Provides a secure means for one window to send a string of data to another window, which need not be within the same domain as the first. */
    void postMessage( WindowMessage message, string targetOrigin, Transferable transfer )
    {
        //
    }
    void postMessage( WindowMessage message, string targetOrigin )
    {
        //
    }

    /** Opens the Print Dialog to print the current document. */
    void print()
    {
        //
    }

    /** Returns the text entered by the user in a prompt dialog. */
    string prompt( string message, string  default_ )
    {
        //
    }

    /** Tells the browser that an animation is in progress, requesting that the browser schedule a repaint of the window for the next animation frame. */
    long requestAnimationFrame( void function( DOMHighResTimeStamp timestamp ) callback )
    {
        //
    }

    /** Enables the scheduling of tasks during a browser's idle periods. */
    void* requestIdleCallback( void function( IdleDeadline idleDeadline ) callback, bool timeout )
    {
        //
    }

    /** Resizes the current window by a certain amount. */
    void resizeBy( int xDelta, int yDelta )
    {
        //
    }

    /** Dynamically resizes window. */
    void resizeTo(width, height)
    {
        //
    }

    /** Scrolls the window to a particular place in the document. */
    void scroll( int x_coord, int y_coord )
    {
        //
    }
    void scroll( ScrollToOptions options )
    {
        //
    }

    /** Scrolls to a particular set of coordinates in the document. */
    void scrollBy( int xDelta, int yDelta )
    {
        //
    }
    void scrollBy( ScrollToOptions options )
    {
        //
    }

    void scrollTo( int xDelta, int yDelta )
    {
        //
    }
    void scrollTo( ScrollToOptions options )
    {
        //
    }

    /** Executes a function after the browser has finished other heavy tasks */
    int setImmediate( void function() func )
    {
        int immediateID;
        return immediateID;
    }
    int setImmediate( ARGS... )( void function(), ARGS args )
    {
        int immediateID;
        return immediateID;
    }

    /** Shows a file picker that allows a user to select a file or multiple files. */
    FileSystemHandle[] showOpenFilePicker()
    {
        FileSystemHandle h;
        FileSystemHandle[] handles;
        return handles;
    }
    FileSystemHandle[] showOpenFilePicker( ShowOpenFilePickerOptions options )
    {
        FileSystemHandle h;
        FileSystemHandle[] handles;
        return handles;
    }

    /** Shows a file picker that allows a user to save a file. */
    FileSystemFileHandle showSaveFilePicker()
    {
        FileSystemFileHandle h;
        return h;
    }
    FileSystemFileHandle showSaveFilePicker( SaveFileOptions options )
    {
        FileSystemFileHandle h;
        return h;
    }

    /** Displays a directory picker which allows the user to select a directory. */
    FileSystemDirectoryHandle showDirectoryPicker()
    {
        FileSystemDirectoryHandle h;
        return h;
    }

    /** This method stops window loading. */
    void stop()
    {
        //
    }

    // WindowOrWorkerGlobalScope
    /** Decodes a string of data which has been encoded using base-64 encoding. */
    ubyte[] atob( const(char)[] encodedData )
    {
        import std.base4;
        return Base64.decode( encodedData );
    }

    /** Creates a base-64 encoded ASCII string from a string of binary data. */
    const(char)[]  btoa( ubyte[] stringToEncode )
    {
        import std.base4;
        return Base64.encode( stringToEncode );
    }

    /** Cancels the repeated execution set using WindowOrWorkerGlobalScope.setInterval(). */
    void clearInterval( int intervalID )
    {
        //
    }

    /** Cancels the delayed execution set using WindowOrWorkerGlobalScope.setTimeout(). */
    void clearTimeout( int timeoutID )
    {
        //
    }

    /** Accepts a variety of different image sources, and returns a Promise which resolves to an ImageBitmap. Optionally the source is cropped to the rectangle of pixels originating at (sx, sy) with width sw, and height sh. */
    Promise createImageBitmap( Element image )
    {
        void function( ImageBitmap imageBitmap ) resolve;
        void function( string reason )           reject;
        return new Promise( resolve, reject );
    }
    Promise createImageBitmap( Element image, CreateImageBitmapOptions options )
    {
        void function( ImageBitmap imageBitmap ) resolve;
        void function( string reason )           reject;
        return new Promise( resolve, reject );
    }
    Promise createImageBitmap( Element image, int sx, int sy, int sw, int sh )
    {
        void function( ImageBitmap imageBitmap ) resolve;
        void function( string reason )           reject;
        return new Promise( resolve, reject );
    }
    Promise createImageBitmap( Element image, int sx, int sy, int sw, int sh, CreateImageBitmapOptions options )
    {
        void function( ImageBitmap imageBitmap ) resolve;
        void function( string reason )           reject;
        return new Promise( resolve, reject );
    }

    /** Starts the process of fetching a resource from the network. */
    Promise fetch( string resource )
    {
        void function( Request request ) resolve;
        void function( string reason )   reject;
        return new Promise( resolve, reject );
    }
    Promise fetch( string resource, FetchOptions init )
    {
        void function( Request request ) resolve;
        void function( string reason )   reject;
        return new Promise( resolve, reject );
    }
    Promise fetch( Request resource )
    {
        void function( Request request ) resolve;
        void function( string reason )   reject;
        return new Promise( resolve, reject );
    }
    Promise fetch( Request resource, FetchOptions init )
    {
        void function( Request request ) resolve;
        void function( string reason )   reject;
        return new Promise( resolve, reject );
    }

    /** Schedules a function to execute every time a given number of milliseconds elapses.  */
    int setInterval( void function() )
    {
        int intervalID;
        return intervalID;
    }
    int setInterval( ARGS... )( void function(), ARGS args )
    {
        int intervalID;
        return intervalID;
    }
    int setInterval( void function(), long delay )
    {
        int intervalID;
        return intervalID;
    }
    int setInterval( ARGS... )( void function(), long delay, ARGS args )
    {
        int intervalID;
        return intervalID;
    }
    int setInterval( string CODE )( long delay )
    {
        mixin CODE;
        int intervalID;
        return intervalID;
    }

    /** Schedules a function to execute in a given amount of time. */
    int setTimeout( void function() )
    {
        int timeoutID;
        return timeoutID;
    }
    int setTimeout( ARGS... )( void function(), ARGS args )
    {
        int timeoutID;
        return timeoutID;
    }
    int setTimeout( void function(), long delay )
    {
        int timeoutID;
        return timeoutID;
    }
    int setTimeout( ARGS... )( void function(), long delay, ARGS args )
    {
        int timeoutID;
        return timeoutID;
    }
    int setTimeout( string CODE )( long delay )
    {
        mixin CODE;
        int timeoutID;
        return timeoutID;
    }

    // Event handlers
	mixin EventHandler!"onappinstalled";            // Called when the page is installed as a webapp. See appinstalled event.
    mixin EventHandler!"onbeforeinstallprompt";     // An event handler property dispatched before a user is prompted to save a web site to a home screen on mobile.
    mixin EventHandler!"ondevicemotion";            // Called if accelerometer detects a change (For mobile devices)
    mixin EventHandler!"ondeviceorientation";       // Called when the orientation is changed (For mobile devices)
    mixin EventHandler!"ongamepadconnected";        // Represents an event handler that will run when a gamepad is connected (when the gamepadconnected event fires).
    mixin EventHandler!"ongamepaddisconnected";     // Represents an event handler that will run when a gamepad is disconnected (when the gamepaddisconnected event fires).
    mixin EventHandler!"onmozbeforepaint";          // An event handler property for the MozBeforePaint event, which is sent before repainting the window if the event has been requested by a call to the window.requestAnimationFrame method.
    mixin EventHandler!"onpaint";                   // An event handler property for paint events on the window.
    mixin EventHandler!"onrejectionhandled";        // An event handler for handled Promise rejection events.
    mixin EventHandler!"onvrdisplayconnect";        // Represents an event handler that will run when a compatible VR device has been connected to the computer (when the vrdisplayconnected event fires).
    mixin EventHandler!"onvrdisplaydisconnect";     // Represents an event handler that will run when a compatible VR device has been disconnected from the computer (when the vrdisplaydisconnected event fires).
    mixin EventHandler!"onvrdisplayactivate";       // Represents an event handler that will run when a display is able to be presented to (when the vrdisplayactivate event fires), for example if an HMD has been moved to bring it out of standby, or woken up by being put on.
    mixin EventHandler!"onvrdisplaydeactivate";     // Represents an event handler that will run when a display can no longer be presented to (when the vrdisplaydeactivate event fires), for example if an HMD has gone into standby or sleep mode due to a period of inactivity.
    mixin EventHandler!"onvrdisplayblur";           // Represents an event handler that will run when presentation to a display has been paused for some reason by the browser, OS, or VR hardware (when the vrdisplayblur event fires) — for example, while the user is interacting with a system menu or browser, to prevent tracking or loss of experience.
	mixin EventHandler!"onabort";                   // Called when the loading of a resource has been aborted, such as by a user canceling the load while it is still in progress
	mixin EventHandler!"onafterprint";              // Called when the print dialog box is closed. See afterprint event.
	mixin EventHandler!"onbeforeprint";             // Called when the print dialog box is opened. See beforeprint event.
	mixin EventHandler!"onbeforeunload";            // An event handler property for before-unload events on the window.
	mixin EventHandler!"onblur";                    // Called after the window loses focus, such as due to a popup.
	mixin EventHandler!"onchange";                  // An event handler property for change events on the window.
	mixin EventHandler!"onclick";                   // Called after the ANY mouse button is pressed & released
	mixin EventHandler!"ondblclick";                // Called when a double click is made with ANY mouse button.
	mixin EventHandler!"onclose";                   // Called after the window is closed
	mixin EventHandler!"oncontextmenu";             // Called when the RIGHT mouse button is pressed
	mixin EventHandler!"onerror";                   // Called when a resource fails to load OR when an error occurs at runtime. See error event.
	mixin EventHandler!"onfocus";                   // Called after the window receives or regains focus. See focus events.
	mixin EventHandler!"onhashchange";              // An event handler property for hashchange events on the window; called when the part of the URL after the hash mark ("#") changes.
	mixin EventHandler!"oninput";                   // Called when the value of an <input> element changes
	mixin EventHandler!"onkeydown";                 // Called when you begin pressing ANY key. See keydown event.
	mixin EventHandler!"onkeypress";                // Called when a key (except Shift, Fn, and CapsLock) is in pressed position. See keypress event.
	mixin EventHandler!"onkeyup";                   // Called when you finish releasing ANY key. See keyup event.
	mixin EventHandler!"onlanguagechange";          // An event handler property for languagechange events on the window.
	mixin EventHandler!"onload";                    // Called after all resources and the DOM are fully loaded. WILL NOT get called when the page is loaded from cache, such as with back button.
	mixin EventHandler!"onmessage";                 // Is an event handler representing the code to be called when the message event is raised.
	mixin EventHandler!"onmousedown";               // Called when ANY mouse button is pressed.
	mixin EventHandler!"onmousemove";               // Called continously when the mouse is moved inside the window.
	mixin EventHandler!"onmouseout";                // Called when the pointer leaves the window.
	mixin EventHandler!"onmouseover";               // Called when the pointer enters the window
	mixin EventHandler!"onmouseup";                 // Called when ANY mouse button is released
	mixin EventHandler!"onoffline";                 // Called when network connection is lost. See offline event.
	mixin EventHandler!"ononline";                  // Called when network connection is established. See online event.
	mixin EventHandler!"onpagehide";                // Called when the user navigates away from the page, before the onunload event. See pagehide event.
	mixin EventHandler!"onpageshow";                // Called after all resources and the DOM are fully loaded. See pageshow event.
	mixin EventHandler!"onpopstate";                // Called when a back button is pressed.
	mixin EventHandler!"onreset";                   // Called when a form is reset
	mixin EventHandler!"onresize";                  // Called continuously as you are resizing the window.
	mixin EventHandler!"onscroll";                  // Called when the scroll bar is moved via ANY means. If the resource fully fits in the window, then this event cannot be invoked
	mixin EventHandler!"onwheel";                   // Called when the mouse wheel is rotated around any axis
	mixin EventHandler!"onselect";                  // Called after text in an input field is selected
	mixin EventHandler!"onselectionchange";         // Is an event handler representing the code to be called when the selectionchange event is raised.
	mixin EventHandler!"onstorage";                 // Called when there is a change in session storage or local storage. See storage event
	mixin EventHandler!"onsubmit";                  // Called when a form is submitted
	mixin EventHandler!"onunhandledrejection";      // An event handler for unhandled Promise rejection events.
	mixin EventHandler!"onunload";                  // Called when the user navigates away from the page.
    mixin EventHandler!"onvrdisplayfocus";          // Represents an event handler that will run when presentation to a display has resumed after being blurred (when the vrdisplayfocus event fires).
    mixin EventHandler!"onvrdisplaypresentchange";  // represents an event handler that will run when the presenting state of a VR device changes — i.e. goes from presenting to not presenting, or vice versa (when the vrdisplaypresentchange event fires).


    // Events
    enum Events
    {
        error, 				// Fired when a resource failed to load, or can't be used. For example, if a script has an execution error or an image can't be found or is invalid.
		languagechange, 	// Fired at the global scope object when the user's preferred language changes.
		devicemotion,		// Fired at a regular interval, indicating the amount of physical force of acceleration the device is receiving and the rate of rotation, if available.
        deviceorientation,  // Fired when fresh data is available from the magnetometer orientation sensor about the current orientation of the device as compared to the Earth coordinate frame.
        resize,             // Fired when the window has been resized.
        storage,            // Fired when a storage area (localStorage or sessionStorage) has been modified in the context of another document.
        // Animation events
        animationcancel,    // Fired when an animation unexpectedly aborts.
        animationend,       // Fired when an animation has completed normally.
        animationiteration, // Fired when an animation iteration has completed.
        animationstart,     // Fired when an animation starts.
        // Clipboard events
        copy,               // Fired when the user initiates a copy action through the browser's user interface.
        cut,                // Fired when the user initiates a cut action through the browser's user interface.
        paste,              // Fired when the user initiates a paste action through the browser's user interface.
        // Connection events
        offline,            // Fired when the browser has lost access to the network and the value of navigator.onLine has switched to false.
        online,             // Fired when the browser has gained access to the network and the value of navigator.onLine has switched to true.
        // Focus events
        blur,               // Fired when an element has lost focus.
        focus,              // Fired when an element has gained focus.
        // Gamepad events
        gamepadconnected,   // Fired when the browser detects that a gamepad has been connected or the first time a button/axis of the gamepad is used.
        gamepaddisconnected, // Fired when the browser detects that a gamepad has been disconnected.
        // History events
        hashchange,         // Fired when the fragment identifier of the URL has changed (the part of the URL beginning with and following the # symbol).
        pagehide,           // Sent when the browser hides the current document while in the process of switching to displaying in its place a different document from the session's history. This happens, for example, when the user clicks the Back button or when they click the Forward button to move ahead in session history.
        pageshow,           // Sent when the browser makes the document visible due to navigation tasks, including not only when the page is first loaded, but also situations such as the user navigating back to the page after having navigated to another within the same tab.
        popstate,           // Fired when the active history entry changes.
        // Load & unload events
        beforeunload,       // Fired when the window, the document and its resources are about to be unloaded.
        DOMContentLoaded,   // Fired when the document has been completely loaded and parsed, without waiting for stylesheets, images, and subframes to finish loading.
        load,               // Fired when the whole page has loaded, including all dependent resources such as stylesheets images.
        unload,             // Fired when the document or a child resource is being unloaded.
        // Manifest events
        appinstalled,       // Fired when the browser has successfully installed a page as an application.
        beforeinstallprompt, // Fired when a user is about to be prompted to install a web application.
        // Messaging events
        message,            // Fired when the window receives a message, for example from a call to Window.postMessage() from another browsing context.
        messageerror,       // Fired when a Window object receives a message that can't be deserialized.
        // Print events
        afterprint,         // Fired after the associated document has started printing or the print preview has been closed.
        beforeprint,        // Fired when the associated document is about to be printed or previewed for printing.
        // Promise rejection events
        rejectionhandled,   // Sent every time a JavaScript Promise is rejected, regardless of whether or not there is a handler in place to catch the rejection.
        nhandledrejection,  // Sent when a JavaScript Promise is rejected but there is no handler in place to catch the rejection.
        // Transition events
        transitioncancel,   // Fired when a CSS transition is canceled.
        transitionend,      // Fired when a CSS transition has completed.
        transitionrun,      // Fired when a CSS transition is first created.
        transitionstart,    // Fired when a CSS transition has actually started.
        // WebVR events
        vrdisplayactivate,  // Fired when a VR display becomes available to be presented to, for example if an HMD has been moved to bring it out of standby, or woken up by being put on.
        vrdisplayblur,      // Fired when presentation to a VR display has been paused for some reason by the browser, OS, or VR hardware.
        vrdisplayconnect,   // Fired when a compatible VR display is connected to the computer.
        vrdisplaydeactivate, // Fired when a VR display can no longer be presented to, for example if an HMD has gone into standby or sleep mode due to a period of inactivity.
        vrdisplaydisconnect, // Fired when a compatible VR display is disconnected from the computer.
        vrdisplayfocus,     // Fired when presentation to a VR display has resumed after being blurred.
        vrdisplaypresentchange, // Fired when the presenting state of a VR display changes — i.e. goes from presenting to not presenting, or vice versa.
        vrdisplaypointerrestricted, // Fired when the VR display's pointer input is restricted to consumption via a pointerlocked element.
        vrdisplaypointerunrestricted, // Fired when the VR display's pointer input is no longer restricted to consumption via a pointerlocked element.

    }



protected:
    void[]            _arr;
    size_t            _pos;
    ScrollRestoration _scrollRestoration;
    LayoutViewport    _layoutViewport;
    bool              _isSecureContext;
    Location          _location;
    Locationbar       _locationbar;
    Storage           _localStorage;
    string            _name;
    Navigator         _navigator;
    Window            _opener;
    Window            _parent;
    Performance       _performance;
    Personalbar       _personalbar;
    Screen            _screen;
    Scrollbars        _scrollbars;
    int               _scrollX;
    int               _scrollY;
    Storage           _sessionStorage;
    Statusbar         _statusbar;
    Toolbar           _toolbar;
    VisualViewport    _visualViewport;
    CacheStorage      _caches;
    bool              _isSecureContext;
    string            _origin;
    Selection         _selection;

private:
    SDL_Surface* surface;
    SDL_Surface* testSurface;
}

/** */
struct FetchOptions
{
    //
}

/** */
class Request
{
    //
}

/** */
struct CreateImageBitmapOptions
{
    ImageOrientation     imageOrientation;
    PremultiplyAlpha     premultiplyAlpha;
    ColorSpaceConversion colorSpaceConversion;
    long                 resizeWidth;
    long                 resizeHeight;
    ResizeQuality        resizeQuality;
}

/** */
enum ImageOrientation
{
    none,
    flipY
}

/** */
enum PremultiplyAlpha
{
    default_,
    none,
    premultiply,
}

/** */
enum ColorSpaceConversion
{
    default_,
    none
}

/** */
enum ResizeQuality
{
    pixelated,
    low,
    medium,
    high
}

/** */
class ImageBitmap
{
    /** Is an unsigned long representing the height, in CSS pixels, of the ImageData. */
    int height;

    /** Is an unsigned long representing the width, in CSS pixels, of the ImageData. */
    int width;

    /** Disposes of all graphical resources associated with an ImageBitmap. */
    void close()
    {
        //
    }
}

/** */
struct FileSystemDirectoryHandle
{
    //
}

/** */
struct SaveFileOptions
{
    bool           excludeAcceptAllOption;
    OpenFileType[] types;
}

/** */
struct ShowOpenFilePickerOptions
{
    bool           multiple;
    bool           excludeAcceptAllOption;
    OpenFileType[] types;
}

/** */
struct OpenFileType
{
    string           description; // 'Images',
    string[ string ] accept;      // 'image/*': ['.png', '.gif', '.jpeg', '.jpg']
}

/** */
class FileSystemFileHandle
{
    /** Returns a file object representing the state on disk of the entry represented by the handle. */
    File getFile()
    {
        return FileObject;
    }

    /** Creates a FileSystemWritableFileStream that can be used to write to a file. */
    Promise createWritable()
    {
        // FileSystemWritableFileStream
        return new Promise();
    }
}

/** */
class FileSystemWritableFileStream
{
    //
}

/** */
class File
{
    //
}

/** */
class IdleDeadline
{
    //
}

/** */
alias DOMHighResTimeStamp = ulong;

/** */
struct WindowMessage
{
    //
}

/** */
class Transferable
{
    //
}

/** */
class MediaQueryList
{
    //
}

/** */
class Selection
{
    //
}

/** */
struct ComputedStyle
{
    //
}

/** */
alias IdleCallback = void function();

/** */
class IDBFactory
{
    //
}

/** */
class CacheStorage
{
    //
}

/** */
class VisualViewport
{
    //
}

/** */
class Toolbar
{
    //
}

/** */
class Statusbar
{
    //
}

/** */
class WindowProxy
{
    //
}

/** */
class Screen
{
    //
}

/** */
class Performance
{
    //
}

/** */
class Navigator
{
    //
}

/** */
class Menubar
{
    //
}

/** */
class Storage
{
    /** Returns an integer representing the number of data items stored in the Storage object. */
    size_t length()
    {
        //
    }

    /** When passed a number n, this method will return the name of the nth key in the storage. */
    string  key( size_t index )
    {
        //
    }

    /** When passed a key name, will return that key's value. */
    string getItem( string keyName )
    {
        //
    }

    /** When passed a key name and value, will add that key to the storage, or update that key's value if it already exists. */
    void setItem( string keyName, string keyValue )
    {
        //
    }

    /** When passed a key name, will remove that key from the storage. */
    void removeItem()
    {
        //
    }

    /** When invoked, will empty all keys out of the storage. */
    void clear()
    {
        //
    }
}

/** */
class Locationbar
{
    //
}

/** */
class HistoryState
{
    //
}

/** */
enum ScrollRestoration
{
    auto_,
    manual
}

/** */
class XMLSerializer
{
    /** Returns the serialized subtree of a string. */
    string serializeToString( Node rootNode )
    {
        return "";
    }
}

/** */
class Worker
{
    this( string aURL, WorkerOptions options )
    {
        //
    }
}

/** */
struct WorkerOptions
{
    //
}

/** */
class StaticRange
{
    this( StaticRangeInit rangeSpec )
    {
        //
    }
}

/** */
struct StaticRangeInit
{
    //
}

/** */
class HTMLImageElement : HTMLElement
{
    //
}

/** */
class HTMLOptionElement : HTMLElement
{
    //
}

/** */
class HTMLElement : Element
{
    //
}

/** */
class DOMParser
{
    /** Parses a string using either the HTML parser or the XML parser, returning an HTMLDocument or XMLDocument. */
    Document parseFromString( string s, string mimeType="text/html" )
    {
        // text/html
        // text/xml
        // application/xml
        // application/xhtml+xml
        // image/svg+xml
        return new Document();
    }
}

/** */
enum DesignMode
{
    on,
    off
}

/** */
enum VisibilityState
{
    visible,
    hidden
}

/** */
class DocumentTimeline
{
    this()
    {
        //
    }

    /** Returns the time value in milliseconds for this timeline or null if it is inactive. */
    float currentTime()
    {
        return 0;
    }
}

/** */
class StyleSheetList
{
    StyleSheet[] _lst;
    alias _lst this;
}

/** */
class StyleSheet
{
    bool       disabled;         // Is a Boolean representing whether the current stylesheet has been applied or not.
    string     href;             // Returns a DOMString representing the location of the stylesheet.
    MediaList  media;            // Returns a MediaList representing the intended destination medium for style information.
    Node       ownerNode;        // Returns a Node associating this style sheet with the current document.
    StyleSheet parentStyleSheet; // Returns a StyleSheet including this one, if any; returns null if there aren't any.
    string     title;            // Returns a DOMString representing the advisory title of the current style sheet.
    string     type;             // Returns a DOMString representing the style sheet language for this style sheet.
}

/** */
class MediaList
{
    /** A stringifier that returns a DOMString representing the MediaList as text, and also allows you to set a new MediaList. */
    string mediaText()
    {
        //
    }

    /** Returns the number of media queries in the MediaList. */
    size_t length()
    {
        return _items.length;
    }

    /** Adds a media query to the MediaList. */
    void appendMedium( string a )
    {
        _items ~= a;
    }

    /** Removes a media query from the MediaList. */
    void deleteMedium()
    {
        //
    }

    /** A getter that returns a CSSOMString representing a media query as text, given the media query's index value inside the MediaList. */
    string item( size_t index )
    {
        return _items[ index ];
    }

protected:
    string[] _items;
}

/** */
class FeaturePolicy
{
    /** Returns a Boolean that indicates whether or not a particular feature is enabled in the specified context. */
    bool allowsFeature( string feature )
    {
        return false;
    }
    bool allowsFeature( string feature, string origin )
    {
        return false;
    }

    /** Returns a list of names of all features supported by the User Agent. Feature whose name appears on the list might not be allowed by the Feature Policy of the current execution context and/or might not be accessible because of user's permissions. */
    string[] features()
    {
        return [];
    }

    /** Returns the Allow list for the specified feature. */
    string[] getAllowlistForFeature( string feature )
    {
        return [];
    }

}

/** */
class DOMImplementation
{
    /** Creates and returns an XMLDocument. */
    XMLDocument createDocument( string namespaceURI, string qualifiedNameStr, string documentType )
    {
        return new XMLDocument();
    }

    /** Creates and returns a DocumentType. */
    DocumentType createDocumentType( string qualifiedNameStr, string publicId, string systemId )
    {
        return new DocumentType();
    }

    /** Creates and returns an HTML Document. */
    Document createHTMLDocument( string title )
    {
        return new Document();
    }

    /** Returns a Boolean indicating if a given feature is supported or not. This function is unreliable and kept for compatibility purpose alone: except for SVG-related queries, it always returns true. Old browsers are very inconsistent in their behavior. */
    bool hasFeature( string feature, string version_ )
    {
        //
    }
}

/** */
class XMLDocument
{
    //
}

/** */
enum CompatMode
{
    BackCompat,
    CSS1Compat
}

/** */
class FontFaceSet
{
    // Properties
    /** Indicates the font-face's loading status. It will be one of 'loading' or 'loaded'. */
    FontFaceStatus status()
    {
        return _fontFaceStatus;
    }

    /** Promise which resolves once font loading and layout operations have completed. */
    Promise ready()
    {
        return _ready;
    }

    // Events
    // onloading      // An EventListener called whenever an event of type loading is fired, indicating a font-face set has started loading.
    // onloadingdone  // An EventListener called whenever an event of type loadingdone is fired, indicating that a font face set has finished loading.
    // onloadingerror // An EventListener called whenever an event of type loadingerror is fired, indicating that an error occurred whilst loading a font-face set.

    // Methods
    /** A Boolean that indicates whether a font is loaded, but doesn't initiate a load when it isn't. */
    bool check()
    {
        return ( _fontFaceStatus == FontFaceStatus.loaded );
    }

    /** Removes all manually-added fonts from the font set. CSS-connected fonts are unaffected. */
    void clear()
    {
        //
    }

    /** Removes a manually-added font from the font set. CSS-connected fonts are unaffected. */
    void delete_()
    {
        //
    }

    /** Returns a Promise which resolves to a list of font-faces for a requested font. */
    Promise!string load( string font )
    {
        // font: "italic bold 16px Roboto"
        return
            new Promise!string(
                ( success, failure )
                {
                    //
                }
            );
    }
    Promise!string load( string font, string text )
    {
        return
            new Promise!string(
                ( success, failure )
                {
                    //
                }
            );
    }

protected:
    FontFaceStatus _fontFaceStatus;
    Promise        _ready;
    Promise        _load;
}

/** */
enum FontFaceStatus
{
    loading,
    loaded
}

/** */
interface INode : IEventTarget
{
    // Properties
    string    baseURI();
    NodeList  childNodes();
    Node      firstChild();
    bool      isConnected();
    Node      lastChild();
    Node      nextSibling();
    ushort    nodeType();
    string    nodeName();
    Value     nodeValue();
    void      nodeValue( Value value);
    Document  ownerDocument();
    Node      parentNode();
    Element   parentElement();
    Node      previousSibling();
    // Methods
    Node   appendChild( Node childNode );
    Node   cloneNode( bool deep );
    uint   compareDocumentPosition( Node otherNode );
    bool   contains( Node otherNode );
    void   getBoxQuads();
    Node   getRootNode( bool composed );
    bool   hasChildNodes();
    bool   hasChildNodes();
    Node   insertBefore( Node newNode, Node referenceNode );
    bool   isDefaultNamespace( string namespaceURI );
    bool   isEqualNode( Node otherNode );
    bool   isSameNode( Node otherNode );
    string lookupNamespaceURI( string prefix );
    string lookupPrefix();
    void   normalize();
    Node   insertBefore( Node newNode, Node referenceNode );
    Node   replaceChild( Node newChild, Node oldChild );
}

/** */
class Node : EventTarget, INode
{
    this()
    {
        //
    }

    this( ushort nodeType )
    {
        this._nodeType = nodeType;
    }

    /** Returns a DOMString representing the base URL of the document containing the Node. */
    string baseURI()
    {
        return "";
    }

    /** Returns a live NodeList containing all the children of this node (including elements, text and comments). NodeList being live means that if the children of the Node change, the NodeList object is automatically updated. */
    NodeList childNodes()
    {
        return new NodeList( _firstChild );
    }

    /** Returns a Node representing the first direct child node of the node, or null if the node has no child. */
    Node firstChild()
    {
        return _firstChild;
    }

    /** A boolean indicating whether or not the Node is connected (directly or indirectly) to the context object, e.g. the Document object in the case of the normal DOM, or the ShadowRoot in the case of a shadow DOM. */
    bool isConnected()
    {
        return _isConnected;
    }

    /** Returns a Node representing the last direct child node of the node, or null if the node has no child. */
    Node lastChild()
    {
        return _lastChild;
    }

    /** Returns a Node representing the next node in the tree, or null if there isn't such node. */
    Node nextSibling()
    {
        return _nextSibling;
    }

    /** Returns a DOMString containing the name of the Node. */
    string nodeName()
    {
        if ( nodeType == ELEMENT )
            return tagName;
        else
        if ( nodeType == ATTRIBUTE_NODE )
            return "#attribute";
        else
        if ( nodeType == TEXT_NODE )
            return "#text";
        else
        if ( nodeType == CDATA_SECTION_NODE )
            return "#cdata";
        else
        if ( nodeType == ENTITY_REFERENCE_NODE )
            return "#entity_reference";
        else
        if ( nodeType == ENTITY_NODE )
            return "#entity";
        else
        if ( nodeType == PROCESSING_INSTRUCTION_NODE )
            return "#processing_instruction";
        else
        if ( nodeType == COMMENT_NODE )
            return "#comment";
        else
        if ( nodeType == DOCUMENT_NODE )
            return "#document";
        else
        if ( nodeType == DOCUMENT_TYPE_NODE )
            return "#document_type";
        else
        if ( nodeType == DOCUMENT_FRAGMENT_NODE )
            return "#document_fragment";
        else
        if ( nodeType == NOTATION_NODE )
            return "#notation";
        else
            assert( 0, "unsupported" );
    }

    /** Returns an unsigned short representing the type of the node. Possible values are: */
    ushort nodeType()
    {
        return _nodeType;
    }

    /** Returns / Sets the value of the current node. */
    Value nodeValue()
    {
        return _nodeValue;
    }

    /** Returns / Sets the value of the current node. */
    void nodeValue( Value value)
    {
        _nodeValue = value;
    }

    /** Returns the Document that this node belongs to. If the node is itself a document, returns null. */
    Document ownerDocument()
    {
        return _ownerDocument;
    }

    /** Returns a Node that is the parent of this node. */
    Node parentNode()
    {
        return _parentNode;
    }

    /** Returns an Element that is the parent of this node. If the node has no parent, or if that parent is not an Element, this property returns null. */
    Element parentElement()
    {
        if ( _parentNode !is null )
        {
            if ( _parentNode.cleanClassName == "Element" )
            {
                return _parentNode;
            }
        }

        return null;
    }

    /** Returns a Node representing the previous node in the tree, or null if there isn't such node. */
    Node previousSibling()
    {
        return _previousSibling;
    }

    /** Returns / Sets the textual content of an element and all its descendants. */
    void textContent( string s )
    {
        nodeValue = s;
    }

    /** Returns / Sets the textual content of an element and all its descendants. */
    string textContent()
    {
        switch ( _nodeType )
        {
            case DOCUMENT_NODE:
            case DOCUMENT_TYPE_NODE:
                return null;

            case CDATA_SECTION_NODE:
            case COMMENT_NODE:
            case TEXT_NODE:
                return _nodeValue;

            default:
                return concatenate_textContent_of_every_child( this );
        }

        return s;
    }

    /** Adds the specified childNode argument as the last child to the current node. */
    Node appendChild( Node childNode )
    {
        // Remove from parent
        if ( childNode.parentNode !is null )
        {
            childNode.parentNode.removeChild( childNode );
        }

        childNode.parentNode = this;

        // Add
        if ( _firstChild is null )
        {
            _firstChild = childNode;
            _lastChild  = childNode;
        }
        else // firstChild !is null
        {
            childNode.previousSibling = _lastChild;
            _lastChild.nextSibling    = childNode;
            _lastChild                = childNode;
        }

        return childNode;
    }

    /** */
    Node cloneNode( bool deep )
    {
        auto newClone = new Node( _nodeType );
        newClone.value = _nodeValue;

        if ( deep )
        {
            foreach ( child; childNodes )
            {
                newClone.appendChild( child.cloneNode( true ) );
            }
        }

        return newClone ;
    }

    /** Compares the position of the current node against another node in any other document. */
    uint compareDocumentPosition( Node otherNode )
    {
        uint bitmask;

        //
        if ( this is otherNode )
        {
            return bitmask; // 0
        }

        // DOCUMENT_POSITION_DISCONNECTED
        if ( ! otherNode.isConnected )
        {
            bitmask |= DOCUMENT_POSITION_DISCONNECTED;
            return bitmask;
        }

        // DOCUMENT_POSITION_CONTAINED_BY
        auto parent = this.parentNode;
        while ( parent !is null )
        {
            if ( parent is otherNode )
            {
                bitmask |= DOCUMENT_POSITION_CONTAINED_BY;
                return bitmask;
            }

            parent = parent.parentNode;
        }

        // DOCUMENT_POSITION_CONTAINS
        if ( bitmask == 0 )
        {
            if ( contains( otherNode ) )
            {
                bitmask |= DOCUMENT_POSITION_CONTAINS;
                return bitmask;
            }
        }

        // DOCUMENT_POSITION_PRECEDING
        // DOCUMENT_POSITION_FOLLOWING
        if ( bitmask == 0 )
        {
            foreach ( child; _parentNode.childNodes )
            {
                if ( child is otherNode )
                {
                    bitmask |= DOCUMENT_POSITION_PRECEDING;
                    return bitmask;
                }

                if ( child is this )
                {
                    bitmask |= DOCUMENT_POSITION_FOLLOWING;
                    return bitmask;
                }
            }
        }

        // DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC
        if ( bitmask == 0 )
        {
            //
        }

        return bitmask;
    }

    /** Returns a Boolean value indicating whether or not a node is a descendant of the calling node. */
    bool contains( Node otherNode )
    {
        auto parent = otherNode.parentNode;

        while ( parent !is null )
        {
            if ( parent is this )
            {
                return true;
            }

            parent = parent.parentNode;
        }

        return false;
    }

    /** Returns a list of the node's CSS boxes relative to another node. */
    void getBoxQuads()
    {
        assert( 0, "unsupported" );
    }

    /** Returns the context object's root which optionally includes the shadow root if it is available.  */
    Node getRootNode( bool composed )
    {
        auto parent = this._parentNode;

        while ( parent !is null )
        {
            if ( parent.parentNode is null )
            {
                return parent;
            }

            parent = parent.parentNode;
        }

        return null;
    }

    /** Returns a Boolean indicating whether or not the element has any child nodes. */
    bool hasChildNodes()
    {
        return _firstChild is null;
    }

    /** Inserts a Node before the reference node as a child of a specified parent node. */
    Node insertBefore( Node newNode, Node referenceNode )
    {
        // Remove from parent
        if ( newNode.parentNode !is null )
        {
            newNode.parentNode.removeChild( newNode );
        }

        // Validate
        assert( referenceNode.parent is this );

        // Insert
        auto prev = referenceNode.previousSibling;

        newNode.prevSibling       = prev;
        newNode.nextSibling       = referenceNode;
        referenceNode.prevSibling = newNode;
        newNode.parent            = this;

        if ( prev !is null )
        {
            prev.nextSibling = newNode;
        }

        //
        if ( referenceNode is _firstChild )
        {
            _firstChild = newNode;
        }

        return newNode;
    }

    /** Accepts a namespace URI as an argument and returns a Boolean with a value of true if the namespace is the default namespace on the given node or false if not. */
    bool isDefaultNamespace( string namespaceURI )
    {
        return ( namespaceURI == _namespaceURI );
    }

    /** Returns a Boolean which indicates whether or not two nodes are of the same type and all their defining data points match. */
    bool isEqualNode( Node otherNode )
    {
        // same type
        if ( _nodeType == otherNode.nodeType )

        foreach ( child; childNodes )
        {
            // ATTRIBUTE
            if ( child.nodeType == ATTRIBUTE_NODE )
            {
                // find name
                foreach ( otherChild; otherNode.childNodes )
                {
                    // name, value  == name, value
                    if ( otherChild.nodeType == ATTRIBUTE_NODE )
                    if ( otherChild.name == child.name )
                    if ( otherChild.value == child.value )
                    {
                        // attr OK
                        goto attr_OK;
                    }
                }
                // FAIL
                attr_FAIL:
                    return false;
                // OK
                attr_OK:
                    continue;
            }
            else

            // ELEMENT
            if ( child.nodeType == ELEMENT_NODE )
            {
                //
            }
            else

            // TEXT
            if ( child.nodeType == TEXT_NODE )
            {
                //
            }
            else

            // CDATA
            if ( child.nodeType == CDATA_SECTION_NODE )
            {
                //
            }
        }
    }

    /** Returns a Boolean value indicating whether or not the two nodes are the same (that is, they reference the same object). */
    bool isSameNode( Node otherNode )
    {
        return ( otherNode is this );
    }

    /** Returns a DOMString containing the prefix for a given namespace URI, if present, and null if not. When multiple prefixes are possible, the result is implementation-dependent. */
    string lookupPrefix()
    {
        return null;
    }

    /** Accepts a prefix and returns the namespace URI associated with it on the given node if found (and null if not). Supplying null for the prefix will return the default namespace. */
    string lookupNamespaceURI( string prefix )
    {
        return null;
    }

    /** Clean up all the text nodes under this element (merge adjacent, remove empty). */
    void normalize()
    {
        assert( 0, "unsupported" );
    }

    /** Removes a child node from the current element, which must be a child of the current node. */
    Node removeChild( Node child )
    {
        if ( child.parentNode != thils )
        {
            Log.error( "Uncaught TypeError: Failed to execute 'removeChild' on 'Node': parameter 1 is not of type 'Node'." );
        }
        else
        {
            //{
            //    // FAIL
            //    Log.error( "Uncaught NotFoundError: Failed to execute 'removeChild' on 'Node': The node to be removed is not a child of this node." );
            //}

            // Parent
            child.parentNode = null;

            // Siblings
            auto prev = child.prevSibling;
            auto next = child.nextSibling;

            if ( prev !is null )
            {
                prev.nextSibling = next;
            }

            if ( next !is null )
            {
                next.prevSibling = prev;
            }

            // Childs
            if ( _firstChild == child )
            {
                _firstChild = next;
            }

            if ( _lastChild == child )
            {
                _lastChild = prev;
            }

            //
            child.prevSibling = null;
            child.nextSibling = null;
        }

        return child;
    }

    /** Replaces one child Node of the current one with the second one given in parameter. */
    Node replaceChild( Node newChild, Node oldChild )
    {
        auto node = _firstChild;

        while ( node !is null )
        {
            if ( node is oldChild )
            {
                newChild.previousSibling = oldChild.previousSibling;
                newChild.nextSibling     = oldChild.nextSibling;
                newChild.parentNode      = oldChild.parentNode;

                oldChild.prevSibling = null;
                oldChild.nextSibling = null;
                oldChild.parentNode  = null;

                break;
            }
        }

        return oldChild;
    }

protected:
    bool      _isConnected;
    ushort    _nodeType;
    Value     _nodeValue;
    Document  _ownerDocument;
    Node      _parentNode;
    Node      _previousSibling;
    Node      _nextSibling;
    Node      _firstChild;
    Node      _lastChild;
    string    _namespaceURI;
}

//
string concatenate_textContent_of_every_child( Node node )
{
    import std.array : join;

    if ( ! node.childNodes.empty )
    {
        string[] ss;
        string s;

        foreach ( child; node.childNodes )
        {
            if ( child.nodeType == COMMENT_NODE )
                continue;
            else
            if ( child.nodeType == PROCESSING_INSTRUCTION_NODE )
                continue;
            else
            {
                s = child.textContent;

                if ( ! s.empty )
                {
                    ss ~= child.textContent;
                }
            }
        }

        return ss.join( " " );
    }
    else
    {
        return "";
    }

    //
    enum uint DOCUMENT_POSITION_DISCONNECTED            = 1;
    enum uint DOCUMENT_POSITION_PRECEDING               = 2;
    enum uint DOCUMENT_POSITION_FOLLOWING               = 4;
    enum uint DOCUMENT_POSITION_CONTAINS                = 8;
    enum uint DOCUMENT_POSITION_CONTAINED_BY            = 16;
    enum uint DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC = 32;
}

//
enum ushort ELEMENT_NODE                = 1;
enum ushort ATTRIBUTE_NODE              = 2;
enum ushort TEXT_NODE                   = 3;
enum ushort CDATA_SECTION_NODE          = 4;
enum ushort ENTITY_REFERENCE_NODE       = 5;
enum ushort ENTITY_NODE                 = 6;
enum ushort PROCESSING_INSTRUCTION_NODE = 7;
enum ushort COMMENT_NODE                = 8;
enum ushort DOCUMENT_NODE               = 9;
enum ushort DOCUMENT_TYPE_NODE          = 10;
enum ushort DOCUMENT_FRAGMENT_NODE      = 11;
enum ushort NOTATION_NODE               = 12;


/** */
interface IElement : INode
{
    //
}

/** */
class Element : Node, IElement
{
    /** Returns a HTMLSlotElement representing the <slot> the node is inserted in. */
    HTMLSlotElement assignedSlot()
    {
        return null;
    }

    /** Returns a NamedNodeMap object containing the assigned attributes of the corresponding HTML element. */
    NamedNodeMap attributes()
    {
        return _attrs;
    }

    /** Returns the number of child elements of this element. */
    size_t childElementCount()
    {
        size_t count;

        foreach ( c; childNodes )
        {
            if ( c.nodeType == ELEMENT_NODE )
            {
                count += 1;
            }
        }

        return count;
    }

    /** Returns the child elements of this element. */
    HTMLCollection children()
    {
        Element[] elements;

        for ( auto node = _first; node !is null; node = node.nextSibling )
        {
            if ( node.nodeType == ELEMENT_NODE )
            {
                elements ~= cast ( Element ) node;
            }
        }

        return new HTMLCollection( elements );
    }

    /** Returns a DOMTokenList containing the list of class attributes. */
    DOMTokenList classList()
    {
        return new DOMTokenList( _classes );
    }

    /** Is a DOMString representing the class of the element. */
    string className()
    {
        auto clss = _attrs.getNamedItem( "class" );
        if ( clss !is null )
            return clss.value.type == ValueType.String ? clss.value._string : "";
        else
            return "";
    }

    /** Returns a Number representing the inner height of the element. */
    Number clientHeight()
    {
        // no CSS => 0
        // inline => 0
        // inner height of element in pixels
        //
        // clientHeight can be calculated as: CSS height + CSS padding - height of horizontal scrollbar (if present).
        //
        // if root element => viewport's height

        if ( computed.innerDisplay == Display.inline )
        {
            return 0;
        }
        else
        if ( _parentNode is null )
        {
            return viewport.height;
        }
        else
        {
            return computed.contentHeight + computed.paddingTopWidth + computed.paddingBottomWidth;
        }
    }

    /** Returns a Number representing the width of the left border of the element. */
    Number clientLeft()
    {
        return computed.clientLeft.round();
    }

    /** Returns a Number representing the width of the top border of the element. */
    Number clientTop()
    {
        return computed.clientTop.round();
    }

    /** Returns a Number representing the inner width of the element. */
    Number clientWidth()
    {
        if ( computed.innerDisplay == Display.inline )
        {
            return 0;
        }
        else
        if ( _parentNode is null )
        {
            return viewport.width;
        }
        else
        {
            return computed.contentWidth + computed.paddingLeftWidth + computed.paddingRightWidth;
        }
    }

    /** Returns the first child element of this element. */
    Element firstElementChild()
    {
        if ( _firstChild !is null )
        for ( auto node = _firstChild; node !is null; node = node.nextSibling )
        {
            if ( node.nodeType == ELEMENT_NODE )
            {
                return node;
            }
        }

        return null;
    }

    /** Is a DOMString representing the id of the element. */
    string id()
    {
        auto s = _attrs.getNamedItem( "id" );
        if ( s !is null && s.value.type == ValueType.String )
            return s.value._string;
        else
            return "";
    }

    void id( string newId )
    {
        auto a = new Attr( "id" );
        a.value = Value( ValueType.String, newId );
        _attrs.setNamedItem( a );
    }

    /** Is a DOMString representing the markup of the element's content. */
    string innerHTML()
    {
        string s;

        foreach ( c; children )
            s ~= c.outerHTML;

        return s;
    }

    void innerHTML( string s )
    {
        //
    }

    /** Returns the last child element of this element. */
    Element lastElementChild()
    {
        if ( _lastChild !is null )
        for ( auto node = _lastChild; node !is null; node = node.previousSibling )
        {
            if ( node.nodeType == ELEMENT_NODE )
            {
                return node;
            }
        }

        return null;
    }

    /** A DOMString representing the local part of the qualified name of the element. */
    string localName()
    {
        // prefix:localName
        return _name;
    }

    /** The namespace URI of the element, or null if it is no namespace. */
    string namespaceURI()
    {
        return _ns;
    }

    /** Is an Element, the element immediately following the given one in the tree, or null if there's no sibling node. */
    Element nextElementSibling()
    {
        if ( _nextSibling !is null )
        for ( auto node = _nextSibling; node !is null; node = node.nextSibling )
        {
            if ( node.nodeType == ELEMENT_NODE )
            {
                return node;
            }
        }

        return null;
    }

    /** Is a DOMString representing the markup of the element including its content. When used as a setter, replaces the element with nodes parsed from the given string. */
    string outerHTML()
    {
        auto attrsString = _attrsAsString;

        if ( ! attrsString.empty  )
            return "<" ~ _tagName ~ " " ~ attrsString ~ ">" ~ innerHTML ~ "</" ~ _tagName ~ ">";
        else
            return "<" ~ _tagName ~ ">" ~ innerHTML ~ "</" ~ _tagName ~ ">";

    }

    /** Represents the part identifier(s) of the element (i.e. set using the part attribute), returned as a DOMTokenList. */
    DOMTokenList part()
    {
        return new DOMTokenList();
    }

    /** A DOMString representing the namespace prefix of the element, or null if no prefix is specified. */
    string prefix()
    {
        return _prefix;
    }

    /** Is a Element, the element immediately preceding the given one in the tree, or null if there is no sibling element. */
    Element previousElementSibling()
    {
        if ( _previousSibling !is null )
        for ( auto node = _previousSibling; node !is null; node = node.previousSibling )
        {
            if ( node.nodeType == ELEMENT_NODE )
            {
                return node;
            }
        }

        return null;
    }

    /** Returns a Number representing the scroll view height of an element. */
    Number scrollHeight()
    {
        //
    }

    /** Is a Number representing the left scroll offset of the element. */
    Number scrollLeft()
    {
        //
    }

    /** Returns a Number representing the maximum left scroll offset possible for the element. */
    Number scrollLeftMax()
    {
        //
    }

    /** A Number representing number of pixels the top of the document is scrolled vertically. */
    Number scrollTop()
    {
        //
    }

    /** Returns a Number representing the maximum top scroll offset possible for the element. */
    Number scrollTopMax()
    {
        //
    }

    /** Returns a Number representing the scroll view width of the element. */
    Number scrollWidth()
    {
        //
    }

    /** Returns the open shadow root that is hosted by the element, or null if no open shadow root is present. */
    Element shadowRoot()
    {
        return null;
    }

    /** Returns the shadow root that is hosted by the element, regardless if its open or closed. Available only to WebExtensions. */
    Element openOrClosedShadowRoot()
    {
        return null;
    }

    /** Returns the name of the shadow DOM slot the element is inserted in. */
    string slot()
    {
        return null;
    }

    /** Returns a String with the name of the tag for the given element. */
    string tagName()
    {
        return _tagName;
    }

    // Enevts
    /** An event handler for the fullscreenchange event, which is sent when the element enters or exits full-screen mode. This can be used to watch both for successful expected transitions, but also to watch for unexpected changes, such as when your app is running in the background. */
    void onfullscreenchange()
    {
        //
    }

    /** An event handler for the fullscreenerror event, which is sent when an error occurs while attempting to change into full-screen mode. */
    void onfullscreenerror()
    {
        //
    }

    // Methods
    /** Attaches a shadow DOM tree to the specified element and returns a reference to its ShadowRoot. */
    Element attachShadow( string[ string ] shadowRootInit )
    {
        Element shadowroot;
        return shadowroot;
    }

    /** A shortcut method to create and run an animation on an element. Returns the created Animation object instance. */
    Animation animate( Keyframe2[] keyframes, AnimateOptions options )
    {
        return new Animation();
    }
    Animation animate( Keyframe2 keyframe, AnimateOptions options )
    {
        return new Animation();
    }

    /** Inserts a set of Node objects or DOMString objects after the last child of the element. */
    void append( Node[] args ... )
    {
        foreach ( node; args )
        {
            appendChild( node );
        }
    }
    void append( string[] args ... )
    {
        foreach ( s; args )
        {
            //auto e = createElement( s );
            //appendChild( e );
        }
    }
    void append( ARGS... )( ARGS args )
    {
        static
        foreach ( T; ARGS )
        {
            static
            if ( is ( T == Node ) )
            {
                appendChild( node );
            }
            else

            static
            if ( is ( T == string ) )
            {
                //auto e = createElement( s );
                //appendChild( e );
            }
        }
    }

    /** Returns the Element which is the closest ancestor of the current element (or the current element itself) which matches the selectors given in parameter. */
    Element closest( string selectors )
    {
        return null;
    }

    /** Returns a StylePropertyMapReadOnly interface which provides a read-only representation of a CSS declaration block that is an alternative to CSSStyleDeclaration. */
    StylePropertyMapReadOnly computedStyleMap()
    {
        return _computedStyleMap;
    }

    /** Returns an array of Animation objects currently active on the element. */
    Animation[] getAnimations()
    {
        return _animations;
    }

    /** Retrieves the value of the named attribute from the current node and returns it as an Object. */
    string getAttribute( string attributeName )
    {
        return _attrs.getNamedItem( attributeName ).value.asString;
    }

    /** Returns an array of attribute names from the current element. */
    string[] getAttributeNames()
    {
        string[] names;

        foreach ( a; _attrs )
        {
            names ~= a.name;
        }

        return names;
    }

    /** Retrieves the node representation of the named attribute from the current node and returns it as an Attr. */
    Attr getAttributeNode( string attrName )
    {
        return _attrs.getNamedItem( attributeName );
    }

    /** Retrieves the node representation of the attribute with the specified name and namespace, from the current node and returns it as an Attr. */
    Attr getAttributeNodeNS()
    {
        return null;
    }

    /** Retrieves the value of the attribute with the specified name and namespace, from the current node and returns it as an Object. */
    string getAttributeNS()
    {
        return "";
    }

    /** Returns the size of an element and its position relative to the viewport. */
    DOMRect getBoundingClientRect()
    {
        return DOMRect();
    }

    /** Returns a collection of rectangles that indicate the bounding rectangles for each line of text in a client. */
    DOMRect[] getClientRects()
    {
        return [];
    }

    /** Returns a live HTMLCollection that contains all descendants of the current element that possess the list of classes given in the parameter. */
    HTMLCollection getElementsByTagName( string tagName )
    {
        Element[] elements;

        foreach ( child; children )
        {
            if ( child.tagName == tagName )
            {
                elements ~= child;
            }
        }

        return new HTMLCollection( elements );
    }

    /** Returns a live HTMLCollection containing all descendant elements, of a particular tag name and namespace, from the current element. */
    HTMLCollection getElementsByTagNameNS( string namespaceURI, string localName )
    {
        return null;
    }

    /** Returns a Boolean indicating if the element has the specified attribute or not. */
    bool hasAttribute( string name )
    {
        return ( _attrs.getNamedItem( name ) !is null );
    }

    /** Returns a Boolean indicating if the element has the specified attribute, in the specified namespace, or not. */
    bool hasAttributeNS( string namespaceURI, string localName )
    {
        return null;
    }

    /** Returns a Boolean indicating if the element has one or more HTML attributes present. */
    bool hasAttributes()
    {
        return ( _attrs.length > 0 );
    }

    /** Indicates whether the element on which it is invoked has pointer capture for the pointer identified by the given pointer ID. */
    bool hasPointerCapture()
    {
        return _pointerCapture;
    }

    /** Inserts a given element node at a given position relative to the element it is invoked upon. */
    Element insertAdjacentElement( InsertAdjacent position, Element element )
    {
        final
        switch ( position )
        {
            case InsertAdjacent.beforebegin:
                return this.insertBefore( element, this );

            case InsertAdjacent.afterbegin:
                if ( this._firstChild !is null )
                    return this.insertBefore( element, this._firstChild );
                else
                    return this.appendChild( element );

            case InsertAdjacent.beforeend:
                return this.appendChild( element );

            case InsertAdjacent.afterend:
                if ( this._nextSibling !is null )
                    return this.insertBefore( element, this._nextSibling );
                else
                if ( _this.parentNode !is null )
                    return this._parentNode.appendChild( element );
                else
                    assert( 0, "unsupported: no parent" );
        }

        return null;
    }

    /** Parses the text as HTML or XML and inserts the resulting nodes into the tree in the position given. */
    void insertAdjacentHTML( InsertAdjacent position, string text )
    {
        assert( 0, "unsupported" );
    }

    /** Inserts a given text node at a given position relative to the element it is invoked upon. */
    void insertAdjacentText( InsertAdjacent position, string text )
    {
        assert( 0, "unsupported" );
    }

    /** Returns a Boolean indicating whether or not the element would be selected by the specified selector string. */
    bool matches( string selectorString )
    {
        return false;
    }

    /** Inserts a set of Node objects or DOMString objects before the first child of the element. */
    void prepend( Node[] args ... )
    {
        foreach ( node; args )
        {
            insertBefore( node, _firstChild );
        }
    }
    void prepend( string[] args ... )
    {
        foreach ( s; args )
        {
            //auto e = createElement( s );
            //insertBefore( node, _firstChild );
        }
    }
    void prepend( ARGS... )( ARGS args )
    {
        static
        foreach ( T; ARGS )
        {
            static
            if ( is ( T == Node ) )
            {
                insertBefore( node, _firstChild );
            }
            else

            static
            if ( is ( T == string ) )
            {
                //auto e = createElement( s );
                //insertBefore( node, _firstChild );
        }
        }
    }

    /** Returns the first Node which matches the specified selector string relative to the element. */
    Element querySelector( string selectors )
    {
        return null;
    }

    /** Returns a NodeList of nodes which match the specified selector string relative to the element. */
    NodeList querySelectorAll( string selectors )
    {
        return new NodeList();
    }

    /** Releases (stops) pointer capture that was previously set for a specific pointer event. */
    void releasePointerCapture( int pointerId )
    {
        //
    }

    /** Removes the element from the children list of its parent. */
    void remove()
    {
        if ( _parentNode !is null )
            _parentNode.removeChild( this );
    }

    /** Removes the named attribute from the current node. */
    void removeAttribute( string attrName )
    {
        _attrs.removeNamedItem( attrName );
    }

    /** Removes the node representation of the named attribute from the current node. */
    void removeAttributeNode( Attr attributeNode )
    {
        _attrs.removeNamedItem( attributeNode.name );
    }

    /** Removes the attribute with the specified name and namespace, from the current node. */
    void removeAttributeNS( string ns, string attrName )
    {
        _attrs.removeNamedItemNS( ns, attrName );
    }

    /** Replaces the existing children of a Node with a specified new set of children. */
    void replaceChildren( Node[] args ... )
    {
        _removeAllChilds();

        foreach ( node; args )
        {
            appendChild( node, _firstChild );
        }
    }
    void replaceChildren( string[] args ... )
    {
        _removeAllChilds();

        foreach ( s; args )
        {
            //auto e = createElement( s );
            //replaceChildren( e, _firstChild );
        }
    }
    void replaceChildren( ARGS... )( ARGS args )
    {
        _removeAllChilds();

        static
        foreach ( T; ARGS )
        {
            static
            if ( is ( T == Node ) )
            {
                appendChild( node );
            }
            else

            static
            if ( is ( T == string ) )
            {
                //auto e = createElement( s );
                //appendChild( node );
            }
        }
    }

    /** Asynchronously asks the browser to make the element full-screen. */
    Promise requestFullscreen()
    {
        //return new Promise( fullscreenComplette, fullscreenFail );
        return null;
    }

    /** Allows to asynchronously ask for the pointer to be locked on the given element. */
    void requestPointerLock()
    {
        //
    }

    /** Scrolls to a particular set of coordinates inside a given element. */
    void scroll( int x_coord, int y_coord )
    {
        //
    }
    void scroll( ScrollToOptions options )
    {
        //
    }

    /** Scrolls an element by the given amount. */
    void scrollBy( int x_coord, int y_coord )
    {
        //
    }
    void scrollBy( ScrollToOptions options )
    {
        //
    }

    /** Scrolls the page until the element gets into the view. */
    void scrollIntoView()
    {
        //
    }
    void scrollIntoView( bool alignToTop )
    {
        //
    }
    void scrollIntoView( ScrollIntoViewOptions scrollIntoViewOptions )
    {
        //
    }

    /** Scrolls to a particular set of coordinates inside a given element. */
    void scrollTo( int x_coord, int y_coord )
    {
        //
    }
    void scrollTo( ScrollToOptions options )
    {
        //
    }

    /** Sets the value of a named attribute of the current node. */
    void setAttribute( string name, string value )
    {
        _attrs.setNamedItem( new Attr( name, value ) );
    }

    /** Sets the node representation of the named attribute from the current node. */
    Attr setAttributeNode( Attr attribute )
    {
        return _attrs.setNamedItem( attribute );
    }

    /** Sets the node representation of the attribute with the specified name and namespace, from the current node. */
    Attr setAttributeNodeNS( Attr attribute )
    {
        return _attrs.setNamedItemNS( attribute );
    }

    /** Sets the value of the attribute with the specified name and namespace, from the current node. */
    void setAttributeNS( string namespace, string name, string value )
    {
        _attrs.setNamedItemNS( new Attr( ns, name, value ) );
    }

    /** Designates a specific element as the capture target of future pointer events. */
    void setPointerCapture( int pointerId )
    {
        //
    }

    /** Toggles a boolean attribute, removing it if it is present and adding it if it is not present, on the specified element. */
    bool toggleAttribute( string name )
    {
        return false;
    }
    bool toggleAttribute( string name, bool force )
    {
        return false;
    }

    // Events
    enum EventTypes
    {
        cancel,  // Fires on a <dialog> when the user instructs the browser that they wish to dismiss the current open dialog. For example, the browser might fire this event when the user presses the Esc key or clicks a "Close dialog" button which is part of the browser's UI.
        error,   // Fired when a resource failed to load, or can't be used. For example, if a script has an execution error or an image can't be found or is invalid.
        scroll,  // Fired when the document view or an element has been scrolled.
        select,  // Fired when some text has been selected.
        show,    // Fired when a contextmenu event was fired on/bubbled to an element that has a contextmenu attribute.
        wheel,   // Fired when the user rotates a wheel button on a pointing device (typically a mouse).
        // Clipboard events
        copy,    // Fired when the user initiates a copy action through the browser's user interface.
        cut,     // Fired when the user initiates a cut action through the browser's user interface.
        paste,   // Fired when the user initiates a paste action through the browser's user interface.
        // Composition events
        compositionend,    // Fired when a text composition system such as an input method editor completes or cancels the current composition session.
        compositionstart,  // Fired when a text composition system such as an input method editor starts a new composition session.
        compositionupdate, // Fired when a new character is received in the context of a text composition session controlled by a text composition system such as an input method editor.
        // Focus events
        blur,     // Fired when an element has lost focus.
        focus,    // Fired when an element has gained focus.
        focusin,  // Fired when an element is about to gain focus.
        focusout, // Fired when an element is about to lose focus.
        // Fullscreen events
        fullscreenchange, // Sent to an Element when it transitions into or out of full-screen mode.
        fullscreenerror,  // Sent to an Element if an error occurs while attempting to switch it into or out of full-screen mode.
        // Keyboard events
        keydown,  // Fired when a key is pressed.
        keypress, // Fired when a key that produces a character value is pressed down.
        keyup,    // Fired when a key is released.
        // Mouse events
        auxclick,                  // Fired when a non-primary pointing device button (e.g., any mouse button other than the left button) has been pressed and released on an element.
        click,                     // Fired when a pointing device button (e.g., a mouse's primary button) is pressed and released on a single element.
        contextmenu,               // Fired when the user attempts to open a context menu.
        dblclick,                  // Fired when a pointing device button (e.g., a mouse's primary button) is clicked twice on a single element.
        mousedown,                 // Fired when a pointing device button is pressed on an element.
        mouseenter,                // Fired when a pointing device (usually a mouse) is moved over the element that has the listener attached.
        mouseleave,                // Fired when the pointer of a pointing device (usually a mouse) is moved out of an element that has the listener attached to it.
        mousemove,                 // Fired when a pointing device (usually a mouse) is moved while over an element.
        mouseout,                  // Fired when a pointing device (usually a mouse) is moved off the element to which the listener is attached or off one of its children.
        mouseover,                 // Fired when a pointing device is moved onto the element to which the listener is attached or onto one of its children.
        mouseup,                   // Fired when a pointing device button is released on an element.
        webkitmouseforcechanged,   // Fired each time the amount of pressure changes on the trackpadtouchscreen.
        webkitmouseforcedown,      // Fired after the mousedown event as soon as sufficient pressure has been applied to qualify as a "force click".
        webkitmouseforcewillbegin, // Fired before the mousedown event.
        webkitmouseforceup,        // Fired after the webkitmouseforcedown event as soon as the pressure has been reduced sufficiently to end the "force click".
        // Touch events
        touchcancel, // Fired when one or more touch points have been disrupted in an implementation-specific manner (for example, too many touch points are created).
        touchend,    // Fired when one or more touch points are removed from the touch surface.
        touchmove,   // Fired when one or more touch points are moved along the touch surface.
        touchstart,  // Fired when one or more touch points are placed on the touch surface.
    }

    mixin EventMixin!"cancel";
    mixin EventMixin!"error";
    mixin EventMixin!"scroll";
    mixin EventMixin!"select";
    mixin EventMixin!"show";
    mixin EventMixin!"wheel";
    // Clipboard events
    mixin EventMixin!"copy";
    mixin EventMixin!"cut";
    mixin EventMixin!"paste";
    // Composition events
    mixin EventMixin!"compositionend";
    mixin EventMixin!"compositionstart";
    mixin EventMixin!"compositionupdate";
    // Focus events
    mixin EventMixin!"blur";
    mixin EventMixin!"focus";
    mixin EventMixin!"focusin";
    mixin EventMixin!"focusout";
    // Fullscreen events
    mixin EventMixin!"fullscreenchange";
    mixin EventMixin!"fullscreenerror";
    // Keyboard events
    mixin EventMixin!"keydown";
    mixin EventMixin!"keypress";
    mixin EventMixin!"keyup";
    // Mouse events
    mixin EventMixin!"auxclick";
    mixin EventMixin!"click";
    mixin EventMixin!"contextmenu";
    mixin EventMixin!"dblclick";
    mixin EventMixin!"mousedown";
    mixin EventMixin!"mouseenter";
    mixin EventMixin!"mouseleave";
    mixin EventMixin!"mousemove";
    mixin EventMixin!"mouseout";
    mixin EventMixin!"mouseover";
    mixin EventMixin!"mouseup";
    mixin EventMixin!"webkitmouseforcechanged";
    mixin EventMixin!"webkitmouseforcedown";
    mixin EventMixin!"webkitmouseforcewillbegin";
    mixin EventMixin!"webkitmouseforceup";
    // Touch events
    mixin EventMixin!"touchcancel";
    mixin EventMixin!"touchend";
    mixin EventMixin!"touchmove";
    mixin EventMixin!"touchstart";

protected:
    NamedNodeMap             _attrs;
    StylePropertyMapReadOnly _computedStyleMap;
    string                   _ns;
    string                   _prefix;
    string                   _name;
    string                   _tagName;
    Animation[]              _animations;
    bool                     _pointerCapture;
    int                      _pointerId;

    /** _attrs.getNamedItem( "class" ).value.split( ' ' ) */
    string[] _classes()
    {
        auto clss = _attrs.getNamedItem( "class" );

        if ( clss !is null )
        {
            auto s = clss.value.type == ValueType.String ? clss.value._string : "";
            auto splits = s.split( ' ' );
            return splits;
        }
        else
        {
            return [];
        }
    }

    /** */
    string _attrsAsString()
    {
        import std.array : join;

        string[] ss;

        foreach ( a; _attrs )
        {
            ss ~= format!"%s = %s"( a.name, a.value );
        }

        return ss.join( ' ' );
    }

    /** */
    void _removeAllChilds()
    {
        while ( _firstChild !is null )
        {
            removeChild( _firstChild );
        }
    }
}

/** */
mixin template EventMixin( string NAME )
{
    enum EventMixin =
    format!q{
        EventListener on%s()
        {
            //
        }
        void on%s( EventListener listener )
        {
            //
        }
    }
    (
        NAME,
        NAME,
    );
}

/** */
struct ScrollIntoViewOptions
{
    ScrollBehavior      behavior; // Defines the transition animation.
    VerticalAlignment   block;    // Defines vertical alignment.
    HorizontalAlignment inline;   // Defines horizontal alignment.
}

/** */
enum VerticalAlignment
{
    start,
    center,
    end,
    nearest
}

/** */
enum HorizontalAlignment
{
    start,
    center,
    end,
    nearest
}

/** */
struct ScrollToOptions
{
    int            top;      // Specifies the number of pixels along the Y axis to scroll the window or element.
    int            left;     // Specifies the number of pixels along the X axis to scroll the window or element.
    ScrollBehavior behavior; // Specifies whether the scrolling should animate smoothly, or happen instantly in a single jump. This is actually defined on the ScrollOptions dictionary, which is implemented by ScrollToOptions.
}

/** */
enum ScrollBehavior
{
    smooth, // The scrolling animates smoothly.
    auto_    // The scrolling happens in a single jump.
}

/** */
struct RemoveEventListenerOptions
{
    bool capture;
}

/** */
enum InsertAdjacent
{
    beforebegin, // Before the targetElement itself.
    afterbegin,  // Just inside the targetElement, before its first child.
    beforeend,   // Just inside the targetElement, after its last child.
    afterend     // After the targetElement itself.
}


/** */
struct DOMRect
{
    Rect _rect;
    alias _rect this;
}

/** */
class StylePropertyMapReadOnly
{
    /** Returns an unsinged long integer containing the size of the StylePropertyMapReadOnly object. */
    size_t size()
    {
        return 0;
    }

    /** Returns an array of a given object's own enumerable property [key, value] pairs, in the same order as that provided by a for...in loop (the difference being that a for-in loop enumerates properties in the prototype chain as well). */
    CSSStyleValue[ string ] entries()
    {
        return _map;
    }

    /** Executes a provided function once for each element of StylePropertyMapReadOnly. */
    void forEach( KeyValueForEachCallback1 callback, void* This=null )
    {
        foreach ( ref property, ref value; _map )
        {
            callback( value );
        }
    }

    void forEach( KeyValueForEachCallback2 callback, void* This=null )
    {
        foreach ( ref property, ref value; _map )
        {
            callback( value, property );
        }
    }

    void forEach( KeyValueForEachCallback3 callback, void* This=null )
    {
        foreach ( ref property, ref value; _map )
        {
            callback( value, property, _map );
        }
    }

    /** Returns the value of the specified property. */
    CSSStyleValue get( string property )
    {
        return _map.get( property, null );
    }

    /** Returns an array of CSSStyleValue objects containing the values for the provided property. */
    CSSStyleValue[] getAll()
    {
        return _map;
    }

    /** Indicates whether the specified property is in the StylePropertyMapReadOnly object. */
    bool has( string property )
    {
        return ( property in _map ) !is null;
    }

    /** Returns a new Array Iterator containing the keys for each item in StylePropertyMapReadOnly. */
    string[] keys()
    {
        return _map.keys();
    }

    /** Returns a new Array Iterator containing the values for each index in the StylePropertyMapReadOnly object. */
    CSSStyleValue[] values()
    {
        return _map.values();
    }

protected:
    CSSStyleValue[ string ] _map;
}

/** */
class StylePropertyMap : StylePropertyMapReadOnly
{
    void set( string property, CSSStyleValue[] values ... )
    {
        foreach ( value; values )
        {
            _map[ property ] = value;
        }
    }
    void set( string property, string[] values ... )
    {
        foreach ( value; values )
        {
            _map[ property ] = CSSStyleValue.parse( property, value );
        }
    }

    void append( string property, CSSStyleValue[] values ... )
    {
        foreach ( value; values )
        {
            _map[ property ] = value;
        }
    }
    void append( string property, string[] values ... )
    {
        foreach ( value; values )
        {
            _map[ property ] = CSSStyleValue.parse( property, value );
        }
    }

    void delete_( string property)
    {
        _map.remove( property );
    }

    void clear()
    {
        _map.clear();
    }
}

/** */
struct CSSStyleValue
{
    Value _value;
    alias _value this;

    const
    string[] validCSSProperties =
        [ // sorted
            "border", "borderLeft", "borderTop",
        ];

    static
    CSSStyleValue parse( string property, string cssText )
    {
        // 1. -- custom property
        // 2. valid CSS property

        import std.string : startsWith;

        if ( property.startsWith( "--" ) )
        {
            return parse_custom_css_property( property, cssText );
        }
        else

        if ( is_valid_css_property( property ) )
        {
            return parse_valid_css_property( property, cssText );
        }

        return CSSStyleValue();
    }

    static
    CSSStyleValue[] parseAll( string property, string cssText )
    {
        return [ CSSStyleValue() ];
    }

    //
    bool is_valid_css_property( string property )
    {
        import std.range : assumeSorted;
        return assumeSorted( validCSSProperties ).contains( property );
    }

    //
    CSSStyleValue parse_custom_css_property( string property, string cssText )
    {
        return CSSStyleValue();
    }

    CSSStyleValue parse_valid_css_property( string property, string cssText )
    {
        return CSSStyleValue();
    }
}

/** */
alias KeyValueForEachCallback1 = void delegate( CSSStyleValue value );
alias KeyValueForEachCallback2 = void delegate( CSSStyleValue value, string property );
alias KeyValueForEachCallback3 = void delegate( CSSStyleValue value, string property, CSSStyleValue[ string ] array );

/** */
struct KeyValue
{
    string key;
    string value;
}

/** */
struct CSSStyleDeclaration
{
    //
}

/** */
struct AnimateOptions
{
    string            id ;            // A property unique to animate(): a DOMString with which to reference the animation.
    float             delay;          // The number of milliseconds to delay the start of the animation. Defaults to 0.
    PlaybackDirection direction;      // Whether the animation runs forwards (normal), backwards (reverse), switches direction after each iteration (alternate), or runs backwards and switches direction after each iteration (alternate-reverse). Defaults to "normal".
    float             duration;       // The number of milliseconds each iteration of the animation takes to complete. Defaults to 0. Although this is technically optional, keep in mind that your animation will not run if this value is 0.
    string            easing;         // The rate of the animation's change over time. Accepts the pre-defined values "linear", "ease", "ease-in", "ease-out", and "ease-in-out", or a custom "cubic-bezier" value like "cubic-bezier(0.42, 0, 0.58, 1)". Defaults to "linear".
    float             endDelay;       // The number of milliseconds to delay after the end of an animation. This is primarily of use when sequencing animations based on the end time of another animation. Defaults to 0.
    FillMode          fill;           // Dictates whether the animation's effects should be reflected by the element(s) prior to playing ("backwards"), retained after the animation has completed playing ("forwards"), or both. Defaults to "none".
    float             iterationStart; // Describes at what point in the iteration the animation should start. 0.5 would indicate starting halfway through the first iteration for example, and with this value set, an animation with 2 iterations would end halfway through a third iteration. Defaults to 0.0.
    float             iterations;     // The number of times the animation should repeat. Defaults to 1, and can also take a value of Infinity to make it repeat for as long as the element exists.
}

/** */
struct Options
{
    bool        capture;
    bool        once;
    bool        passive;
    AbortSignal signal;
}

/** */
class Animation
{
    /** Creates a new Animation object instance. */
    this()
    {
        //
    }

    /** The current time value of the animation in milliseconds, whether running or paused. If the animation lacks a timeline, is inactive or hasn't been played yet, its value is null. */
    float currentTime()
    {
        return _animationTimeline.currentTime;
    }

    /** The current time value of the animation in milliseconds, whether running or paused. If the animation lacks a timeline, is inactive or hasn't been played yet, its value is null. */
    void currentTime( float newTime )
    {
        return _animationTimeline.currentTime = newTime;
    }

    /** Gets and sets the AnimationEffect associated with this animation. This will usually be a KeyframeEffect object. */
    AnimationEffect effect()
    {
        return _animationEffect;
    }

    /** Returns the current finished Promise for this animation. */
    AnimationsPromise finished()
    {
        return _finishedPromise;
    }

    /** Gets and sets the String used to identify the animation. */
    string id()
    {
        return _id;
    }
    void id( string id )
    {
        _id = id;
    }

    /** Indicates whether the animation is currently waiting for an asynchronous operation such as initiating playback or pausing a running animation. */
    bool pending()
    {
        return _pending;
    }

    /** Returns an enumerated value describing the playback state of an animation. */
    PlayState playState()
    {
        return _playState;
    }

    /** Gets or sets the playback rate of the animation. */
    float playbackRate()
    {
        return _playbackRate;
    }
    void playbackRate( float newRate )
    {
        _playbackRate = newRate;
    }

    /** Returns the current ready Promise for this animation. */
    AnimationsPromise ready()
    {
        return _readyPromise;
    }

    /** Returns the replace state of the animation. This will be active if the animation has been replaced, or persisted if Animation.persist() has been invoked on it.*/
    ReplaceState replaceState()
    {
        return _replaceState;
    }
    void replaceState( ReplaceState newState )
    {
        _replaceState = newState;
    }

    /** Gets or sets the scheduled time when an animation's playback should begin. */
    float startTime()
    {
        return _startTime;
    }
    void startTime( float newTime )
    {
        _startTime = newTime;
    }

    /** Gets or sets the timeline associated with this animation. */
    AnimationTimeline timeline()
    {
        return _animationTimeline;
    }
    void timeline( AnimationTimeline newTimeline )
    {
        _animationTimeline = newTimeline;
    }

    // Events
    /** Gets and sets the event handler for the cancel event. */
    void oncancel()
    {
        //
    }

    /** Gets and sets the event handler for the finish event. */
    void onfinish()
    {
        //
    }

    /** Allows you to set and run an event handler that fires when the animation is removed (i.e., put into an active replace state). */
    void onremove()
    {
        //
    }

    // Methods
    /** Clears all keyframeEffects caused by this animation and aborts its playback. */
    void cancel()
    {
        oncancel();
        _playState = PlayState.idle;
    }

    /** Commits the end styling state of an animation to the element being animated, even after that animation has been removed. It will cause the end styling state to be written to the element being animated, in the form of properties inside a style attribute. */
    void commitStyles()
    {
        //
    }

    /** Seeks either end of an animation, depending on whether the animation is playing or reversing. */
    void finish()
    {
        onfinish();
        _playState = PlayState.finished;
    }

    /** Suspends playing of an animation. */
    void pause()
    {
        _playState = PlayState.paused;
    }

    /** Explicitly persists an animation, when it would otherwise be removed due to the browser's Automatically removing filling animations behavior. */
    void persist()
    {
        //
    }

    /** Starts or resumes playing of an animation, or begins the animation again if it previously finished. */
    void play()
    {
        _playState = PlayState.running;
    }

    /** Reverses playback direction, stopping at the start of the animation. If the animation is finished or unplayed, it will play from end to beginning. */
    void reverse()
    {
        //
    }

    /** Sets the speed of an animation after first synchronizing its playback position. */
    void updatePlaybackRate( float playbackRate )
    {
        _playbackRate = playbackRate;
    }

protected:
    AnimationTimeline _animationTimeline;
    AnimationEffect   _animationEffect;
    AnimationsPromise _finishedPromise;
    string            _id;
    bool              _pending;
    PlayState         _playState;
    float             _playbackRate;
    AnimationsPromise _readyPromise;
    ReplaceState      _replaceState;
    float             _startTime;
}

/** */
enum ReplaceState
{
    active,    // The initial value of the animation's replace state; when the animation has been removed by the browser's Automatically removing filling animations behavior.
    persisted, // The animation has been explicitly persisted by invoking Animation.persist() on it.
    removed    // The animation has been explicitly removed.
}

/** */
enum PlayState
{
    idle,
    running,
    paused,
    finished,
}

/** */
class AnimationsPromise
{
    this( PromiseExecutor executor )
    {
        this._executor = executor;
    }
    this( ResolutionFunc resolutionFunc, RejectionFunc rejectionFunc )
    {
        this._executor = new PromiseExecutor( resolutionFunc, rejectionFunc );
    }

protected:
    PromiseExecutor _executor;
}

/** */
class AnimationTimeline
{
    /** */
    float currentTime()
    {
        return _currentTime;
    }

    /** */
    TimelinePhase phase()
    {
        return _phase;
    }

protected:
    float         _currentTime;
    TimelinePhase _phase;
}

/** */
enum TimelinePhase
{
    inactive,
    before,
    active,
    after
 }

/** */
class AnimationEffect
{
    /** Returns the EffectTiming object associated with the animation containing all the animation's timing values. */
    EffectTiming getTiming()
    {
        return _effectTiming;
    }

    /** Returns the calculated timing properties for this AnimationEffect. */
    EffectTiming getComputedTiming()
    {
        return _computedTiming;
    }

    /** Updates the specified timing properties of this AnimationEffect. */
    void updateTiming( EffectTiming timing )
    {
        //
    }

protected:
    EffectTiming _effectTiming;
    EffectTiming _computedTiming;
}

/** */
class KeyframeEffect
{
    /** */
    this( Element targetElement, Keyframe2[] keyframeBlock, KeyframeOptions timingOptions )
    {
        this._target = targetElement;
    }
    this( Element targetElement, Keyframe2 keyframeBlock, KeyframeOptions timingOptions )
    {
        this._target = targetElement;
    }
    this( KeyframeEffect sourceKeyFrames )
    {
        //
    }

    /** Gets and sets the element, or originating element of the pseudo-element, being animated by this object. This may be null for animations that do not target a specific element or pseudo-element. */
    Element target()
    {
        return _target;
    }
    void target( Element target )
    {
        _target = target;
    }

    /** Gets and sets the selector of the pseudo-element being animated by this object. This may be null for animations that do not target a pseudo-element.  */
    Element pseudoElement()
    {
        return null;
    }
    void pseudoElement( Element element )
    {
        return null;
    }

    /** Gets and sets the iteration composite operation for resolving the property value changes of this keyframe effect. */
    IterationCompositeOperation iterationComposite()
    {
        return _iterationComposite;
    }
    void iterationComposite( IterationCompositeOperation iterationCompositeOperation )
    {
        _iterationComposite = iterationCompositeOperation;
    }

    /** Gets and sets the composite operation property for resolving the property value changes between this and other keyframe effects. */
    CompositeOperation composite()
    {
        return _composite;
    }
    void composite( CompositeOperation composite )
    {
        _composite = composite;
    }

    // Methods
    /** Returns the calculated, current timing values for this keyframe effect. */
    ComputedTiming getComputedTiming()
    {
        return ComputedTiming();
    }

    /** Returns the computed keyframes that make up this effect along with their computed keyframe offsets. */
    Keyframe[] getKeyframes()
    {
        return _keyframes;
    }

    /** The EffectTiming object associated with the animation containing all the animation's timing values. */
    float getTiming()
    {
        return _timing;
    }

    /** Replaces the set of keyframes that make up this effect. */
    void setKeyframes( Keyframe2[] keyframes )
    {
        //
    }
    void setKeyframes( Keyframe2 keyframes )
    {
        //
    }

    /** Updates the specified timing properties. */
    void updateTiming( float timing )
    {
        _timing = timing;
    }

protected:
    Element                     _target;
    IterationCompositeOperation _iterationComposite;
    CompositeOperation          _composite;
    Keyframe[]                  _keyframes;
    float                       _timing;
}

/** */
struct KeyframeOptions
{
    float              delay;              // The number of milliseconds to delay the start of the animation. Defaults to 0.
    PlaybackDirection  direction;          // Whether the animation runs forwards (normal), backwards (reverse), switches direction after each iteration (alternate), or runs backwards and switches direction after each iteration (alternate-reverse). Defaults to "normal".
    float              duration;           // The number of milliseconds each iteration of the animation takes to complete. Defaults to 0. Although this is technically optional, keep in mind that your animation will not run if this value is 0.
    string             easing;             // The rate of the animation's change over time. Accepts the pre-defined values "linear", "ease", "ease-in", "ease-out", and "ease-in-out", or a custom "cubic-bezier" value like "cubic-bezier(0.42, 0, 0.58, 1)". Defaults to "linear".
    float              endDelay;           // The number of milliseconds to delay after the end of an animation. This is primarily of use when sequencing animations based on the end time of another animation. Defaults to 0.
    FillMode           fill;               // Dictates whether the animation's effects should be reflected by the element(s) prior to playing ("backwards"), retained after the animation has completed playing ("forwards"), or both. Defaults to "none".
    float              iterationStart;     // Describes at what point in the iteration the animation should start. 0.5 would indicate starting halfway through the first iteration for example, and with this value set, an animation with 2 iterations would end halfway through a third iteration. Defaults to 0.0.
    float              iterations;         // The number of times the animation should repeat. Defaults to 1, and can also take a value of Infinity to make it repeat for as long as the element exists.
    CompositeOperation composite;          // Determines how values are combined between this animation and the element's underlying values.
    CompositeOperation iterationComposite; // Determines how values build from iteration to iteration in the current animation.
}

/** */
struct Keyframe2
{
    // CSS properties
}

/** */
struct Keyframe
{
    /** The offset of the keyframe specified as a number between 0.0 and 1.0 inclusive or null. This is equivalent to specifying start and end states in percentages in CSS stylesheets using @keyframes. This will be null if the keyframe is automatically spaced using KeyframeEffect.spacing. */
    float              offset;
    /** The computed offset for this keyframe, calculated when the list of computed keyframes was produced according to KeyframeEffect.spacing. Unlike offset, above, the computedOffset is never null. */
    float              computedOffset;
    /** The easing function used from this keyframe until the next keyframe in the series. */
    string             easing;
    /** The KeyframeEffect.composite operation used to combine the values specified in this keyframe with the underlying value. This will be absent if the composite operation specified on the effect is being used. */
    CompositeOperation composite;
}

/** */
struct ComputedTiming
{
    /** The end time of the animation in milliseconds from the animation's start (if the KeyframeEffect is associated with an Animation). (Also includes EffectTiming.endDelay in that calculation.) */
    float endTime;
    /** The length of time in milliseconds that the animation's effects will run. This is equal to the iteration duration multiplied by the iteration count. */
    float activeDuration;
    /** The current time of the animation in milliseconds. If the KeyframeEffect is not associated with an Animation, its value is null. */
    float localTime;
    /** Indicates how far along the animation is through its current iteration with values between 0 and 1. Returns null if the animation is not running or its KeyframeEffect isn't associated with an Animation. */
    float progress;
    /** The number of times this animation has looped, starting from 0. Returns null if the animation is not running or its KeyframeEffect isn't associated with an Animation. */
    float currentIteration;
}

/** */
enum CompositeOperation
{
    replace,
    add,
    accumulate
}

/** */
enum IterationCompositeOperation
{
    replace,
    accumulate
}

/** */
struct EffectTiming
{
    /** The number of milliseconds to delay the start of the animation. Defaults to 0. */
    float             delay;
    /** Whether the animation runs forwards (normal), backwards (reverse), switches direction after each iteration (alternate), or runs backwards and switches direction after each iteration (alternate-reverse). Defaults to "normal". */
    PlaybackDirection direction;
    /** The number of milliseconds each iteration of the animation takes to complete. Defaults to 0. Although this is technically optional, keep in mind that your animation will not run if this value is 0. */
    float             duration; // float.min+1 = auto
    /** The rate of the animation's change over time. Accepts the pre-defined values "linear", "ease", "ease-in", "ease-out", and "ease-in-out", or a custom "cubic-bezier" value like "cubic-bezier(0.42, 0, 0.58, 1)". Defaults to "linear". */
    string            easing;
    /** The number of milliseconds to delay after the end of an animation. This is primarily of use when sequencing animations based on the end time of another animation. Defaults to 0.  */
    float             endDeiay;
    /** Dictates whether the animation's effects should be reflected by the element(s) prior to playing ("backwards"), retained after the animation has completed playing ("forwards"), or both. Defaults to "none". */
    FillMode          fill;
    /** Describes at what point in the iteration the animation should start. 0.5 would indicate starting halfway through the first iteration for example, and with this value set, an animation with 2 iterations would end halfway through a third iteration. Defaults to 0.0. */
    float             iterationStart;
    /** The number of times the animation should repeat. Defaults to 1, and can also take a value of Infinity to make it repeat for as long as the element exists. */
    float             iterations;
}

/** */
enum PlaybackDirection
{
    normal,
    reverse,
    alternate,
    alternate_reverse,
}

/** */
enum FillMode
{
     none,
     forwards,
     backwards,
     both,
     auto_,
}

/** */
//alias void function() EasingFunction;


/** */
struct Computed
{
    Display innerDisplay;
    Display outerDisplay;
    Number  contentHeight;
    Number  contentwidth;
    // padding
    Number  paddingTopWidth;
    Number  paddingBottomWidth;
    Number  paddingLeftWidth;
    Number  paddingRightWidth;
    // client Left/Top
    Number clientLeft;
    Number clientTop;
}

/** */
class EventListener
{
    void handleEvent( Event event );
}

/** */
class Event
{
    EventType type;
    Element   target;

    void preventDefault()
    {
        //
    }
}

/** */
enum EventType
{
    none
}

/** */
alias Number = float;

/** */
Number Number( string s )
{
    return s.to!Number;
}

/** */
enum Display
{
    inline,
    block,
}

/** */
class Viewport
{
    int width;
    int height;
}


/** */
class HTMLSlotElement
{
    //
}

/** */
class HTMLCollection
{
    this( Element[] elements )
    {
        this._elements = elements;
    }

    size_t length()
    {
        return _elements.length;
    }

    /** */
    Node item( size_t index )
    {
        if ( index < _elements.length )
            return _elements[ index ];
        else
            return null;
    }

    /** Returns the specific node whose ID or, as a fallback, name matches the string specified by name. */
    Node namedItem( string name )
    {
        foreach ( ref node; _elements )
        {
            if ( node.nodeType == ELEMENT_NODE )
            {
                auto element = cast( Element ) node;

                if ( element.id == name )
                {
                    return node;
                }
                else
                if ( element.name == name )
                {
                    return node;
                }
            }
        }

        return null;
    }

protected:
    Node      _first;
    Element[] _elements;
}

/** */
class DOMTokenList
{
    /** */
    this( string[] tokens )
    {
        this._tokens = tokens;
    }

    /** Is an integer representing the number of objects stored in the object. */
    size_t length()
    {
        return _tokens.length;
    }

    /** A stringifier property that returns the value of the list as a DOMString. */
    string value()
    {
        return _tokens.to!string;
    }

    /** Returns the item in the list by its index, or undefined if index is greater than or equal to the list's length. */
    string item( size_t index )
    {
        return _tokens[ index ];
    }

    /** Returns true if the list contains the given token, otherwise false. */
    bool contains( string token )
    {
        return ! _tokens.find( token ).empty;
    }

    /** Adds the specified token(s) to the list. */
    void add( string[] ags ... )
    {
        foreach ( a; args )
        {
            _tokens ~= a;
        }
    }

    /** Removes the specified token(s) from the list. */
    void remove( string[] ags ... )
    {
        import std.algorithm.mutation : remove;
        _tokens.remove( args );
    }

    /** Replaces token with newToken. */
    string replace( string oldToken, string newToken )
    {
        import std.array : replace;
        _tokens = _tokens.replace( oldToken, newToken );
        return oldToken;
    }

    /** Returns true if a given token is in the associated attribute's supported tokens. */
    bool supports( string token )
    {
        // token - A DOMString containing the token to query for.
        import std.algorithm.searching : canFind;
        return _tokens.canFind( token );
    }

    /** Removes token from the list if it exists, or adds token to the list if it doesn't. Returns a boolean indicating whether token is in the list after the operation. */
    bool toggle( string token, bool force=false )
    {
        import std.algorithm.searching : canFind;
        auto has = _tokens.canFind( token );

        // remove
        if ( has )
        {
            remove( token );
            return false;
        }
        else
        // append
        {
            _tokens ~= token;
            return true;
        }
    }

    /** Returns an iterator, allowing you to go through all key/value pairs contained in this object. */
    TokensIterator entries()
    {
        return new TokensIterator( _tokens );
    }

    /** Executes a provided callback function once per DOMTokenList element. */
    void forEach( TokenForEachCallback1 callback, void* This=null )
    {
        foreach ( token; _tokens )
        {
            callback( token );
        }
    }

    void forEach( TokenForEachCallback2 callback, void* This=null )
    {
        foreach ( i, token; _tokens )
        {
            callback( token, i );
        }
    }

    void forEach( TokenForEachCallback3 callback, void* This=null )
    {
        foreach ( i, token; _tokens )
        {
            callback( token, i, this );
        }
    }

    /** Returns an iterator, allowing you to go through all keys of the key/value pairs contained in this object. */
    TokenKeyIterator keys()
    {
        return new TokenKeyIterator( _tokens );
    }

    /** Returns an iterator, allowing you to go through all values of the key/value pairs contained in this object. */
    TokenValueIterator values()
    {
        return new TokenValueIterator( _tokens );
    }

protected:
    string[] _tokens;
}

/** */
alias TokenForEachCallback1 = void delegate( string currentValue );
alias TokenForEachCallback1 = void delegate( string currentValue, size_t currentIndex );
alias TokenForEachCallback3 = void delegate( string currentValue, size_t currentIndex, DOMTokenList listObj );

/** */
class TokenKeyIterator : IIterator
{
    this( string[] tokens )
    {
        this._tokens = tokens;
    }

    TokenIteratorItem next()
    {
        // OK
        if ( _i < _tokens.length )
        {
            auto i = _i;
            _i += 1;
            return new TokenIteratorItem( false, Value( ValueType.Size_t, i ) );
        }
        else
        // FINISH
        {
            return new TokenIteratorItem( true, Value( ValueType.undefined ) );
        }
    }

protected:
    string[] _tokens;
    size_t   _i;
}

/** */
class TokenValueIterator : IIterator
{
    this( string[] tokens )
    {
        this._tokens = tokens;
    }

    TokenIteratorItem next()
    {
        // OK
        if ( ! _tokens.empty )
        {
            auto tok = _tokens.front;
            _tokens.popFront();
            return new TokenIteratorItem( false, Value( ValueType.String, tok ) );
        }
        else
        // FINISH
        {
            return new TokenIteratorItem( true, Value( ValueType.undefined ) );
        }
    }

protected:
    string[] _tokens;
}

/** */
class TokensIterator : IIterator
{
    this( string[] tokens )
    {
        this._tokens = tokens;
    }

    TokenIteratorItem next()
    {
        // OK
        if ( ! _tokens.empty )
        {
            auto tok = _tokens.front;
            _tokens.popFront();
            return new TokenIteratorItem( false, Value( ValueType.String, tok ) );
        }
        else
        // FINISH
        {
            return new TokenIteratorItem( true, Value( ValueType.undefined ) );
        }
    }

protected:
    string[] _tokens;
}

class TokenIteratorItem : IIteratorItem
{
    this( bool done, Value value )
    {
        this._done  = done;
        this._value = value;
    }

    bool done()
    {
        return _done;
    }

    Value value()
    {
        return _value;
    }

protected:
    bool  _done;
    Value _value;
}

/** */
interface INodeList
{
    size_t         length();
    Node           item( size_t index );
    NodeIterator   entries();
    void           forEach( ForEachCallback1 callback, void* This=null );
    void           forEach( ForEachCallback2 callback, void* This=null );
    void           forEach( ForEachCallback3 callback, void* This=null );
    KeysIterator   keys();
    ValuesIterator values();
}

/** */
class NodeList : INodeList
{
    this( Node first )
    {
        this._first = first;
    }

    /** The number of nodes in the NodeList. */
    size_t length()
    {
        auto node = _first;
        size_t l = 0;

        while ( node !is null )
        {
            l += 1;
            node = node.nextSibling;
        }

        return l;
    }

    /** Returns an item in the list by its index, or null if the index is out-of-bounds. */
    Node item( size_t index )
    {
        auto node = _first;
        size_t i = 0;

        while ( node !is null )
        {
            if ( i = index )
            {
                return node;
            }

            i += 1;
            scan = scan.nextSibling;
        }

        return null;
    }

    /** Returns an iterator, allowing code to go through all key/value pairs contained in the collection. (In this case, the keys are numbers starting from 0 and the values are nodes.) */
    NodeIterator entries()
    {
        return new NodeIterator( _firstChild );
    }

    /** Executes a provided function once per NodeList element, passing the element as an argument to the function. */
    void forEach( ForEachCallback1 callback, void* This=null )
    {
        auto node = _first;

        while ( node !is null )
        {
            callback( node );

            node = node.nextSibling;
        }
    }

    void forEach( ForEachCallback2 callback, void* This=null )
    {
        auto node = _first;
        size_t l = 0;

        while ( node !is null )
        {
            callback( node, i );

            l += 1;
            node = node.nextSibling;
        }
    }

    void forEach( ForEachCallback3 callback, void* This=null )
    {
        auto node = _first;
        size_t l = 0;

        while ( node !is null )
        {
            callback( node, i, this );

            l += 1;
            node = node.nextSibling;
        }
    }

    /** Returns an iterator, allowing code to go through all the keys of the key/value pairs contained in the collection. (In this case, the keys are numbers starting from 0.) */
    KeysIterator keys()
    {
        return new KeysIterator( _firstChild );
    }

    /** Returns an iterator allowing code to go through all values (nodes) of the key/value pairs contained in the collection. */
    ValuesIterator values()
    {
        return new ValuesIterator( _firstChild );
    }

    // foreach suppport
    int opApply( int delegate( ref Node currentValue ) dg ) const
    {
        int  result = 0;
        auto currentValue = _first;

        while ( currentValue !is null )
        {
            result = dg( currentValue );

            if ( result )
            {
                break;
            }

            currentValue = currentValue.nextSibling;
        }

        return result;
    }

    int opApply( int delegate( ref Node currentValue, ref size_t currentIndex ) dg ) const
    {
        int    result       = 0;
        auto   currentValue = _first;
        size_t currentIndex = 0;

        while ( currentValue !is null )
        {
            result = dg( currentValue, currentIndex );

            if ( result )
            {
                break;
            }

            currentValue = currentValue.nextSibling;
            currentIndex += 1;
        }

        return result;
    }

    int opApply( int delegate( ref Node currentValue, ref size_t currentIndex, ref NodeList nodeList ) dg ) const
    {
        int    result       = 0;
        auto   currentValue = _first;
        size_t currentIndex = 0;

        while ( currentValue !is null )
        {
            result = dg( currentValue, currentIndex, this );

            if ( result )
            {
                break;
            }

            currentValue = currentValue.nextSibling;
            currentIndex += 1;
        }

        return result;
    }

    // Range support
    bool empty()
    {
        return ( _first is null );
    }

    Node front()
    {
        return _first;
    }

    Node back()
    {
        if ( _first.parentNode !is null )
        {
            return _first.parentNode.lastChild;
        }
        else
        {
            for ( auto node = _first; node !is null; node = node.nextSibling )
            {
                if ( node.nextSibling is null )
                {
                    return node;
                }
            }

            return _first;
        }
    }

    //bool popFront()
    //{
    //    _front = _front.nextSibling;
    //}

protected:
    Node _first;
}

/** */
class KeysIterator : IIterator
{
    this( Node first )
    {
        this._node = first;
    }

    IIteratorItem next()
    {
        // OK
        if ( _node !is null )
        {
            auto ii = new NodeIteratorItem( false, Value( ValueType.Size_t, _pos ) );
            _pos += 1;
            _node = _node.nextSibling;
            return ii;
        }
        else

        // FINISH
        {
            return new NodeIteratorItem( true, Value( ValueType.undefined ) );
        }
    }

protected:
    Node   _node;
    size_t _pos = -1;
}

/** */
class ValuesIterator : IIterator
{
    this( Node first )
    {
        this._node = first;
    }

    IIteratorItem next()
    {
        // OK
        if ( _node !is null )
        {
            auto ii = new NodeIteratorItem( false, Value( ValueType.Node, _node ) );
            _node = _node.nextSibling;
            return ii;
        }
        else

        // FINISH
        {
            return new NodeIteratorItem( true, Value( ValueType.undefined ) );
        }
    }

protected:
    Node _node;
}

/** */
alias ForEachCallback1 = void delegate( Node currentValue );
alias ForEachCallback1 = void delegate( Node currentValue, size_t currentIndex );
alias ForEachCallback3 = void delegate( Node currentValue, size_t currentIndex, NodeList listObj );

/** */
class NodeIterator : IIterator
{
    this( Node first )
    {
        this._node = first;
    }

    IIteratorItem next()
    {
        // OK
        if ( _node !is null )
        {
            auto ii = new NodeIteratorItem( false, Value( ValueType.Node, _node ) );
            _node = _node.nextSibling;
            return ii;
        }
        else

        // FINISH
        {
            return new NodeIteratorItem( true, Value( ValueType.undefined ) );
        }
    }

protected:
    Node _node;
}

/** */
class NodeIteratorItem : IIteratorItem
{
    this( bool done, Value value )
    {
        this._done  = done;
        this._value = value;
    }


    /** Has the value false if the iterator was able to produce the next value in the sequence. (This is equivalent to not specifying the done property altogether.) */
    bool done()
    {
        return _done;
    }

    /** Any JavaScript value returned by the iterator. Can be omitted when done is true. */
    Value value()
    {
        return _value;
    }

protected:
    bool  _done;
    Value _value;
}


/** */
interface IIterator
{
    void next();
}

/** */
class Iterator : IIterator
{
    /** A zero-argument function that returns an object with at least the following two properties: done, value */
    IIteratorItem next()
    {
        return new IteratorItem();
    }
}

/** */
interface IIteratorItem
{
    bool  done();
    Value value();
}

/** */
class IteratorItem : IIteratorItem
{
    /** Has the value false if the iterator was able to produce the next value in the sequence. (This is equivalent to not specifying the done property altogether.) */
    bool done()
    {
        return true;
    }

    /** Any JavaScript value returned by the iterator. Can be omitted when done is true. */
    Value value()
    {
        return Value();
    }
}

/** */
struct Value
{
    ValueType type;
    union
    {
        string _string;
        float  _float;
        int    _int;
        size_t _size_t;
        bool   _bool;
        Node   _node;
    }

    string asString()
    {
        final
        switch ( type )
        case ValueType.String : return _string;
        case ValueType.Float  : return _float.to!string;
        case ValueType.Int    : return _int.to!string;
        case ValueType.Size_t : return _size_t.to!string;
        case ValueType.Bool   : return _bool.to!string;
        case ValueType.Node   : return _node.to!string;
    }
}

/** */
enum ValueType
{
    undefined,
    String,
    Float,
    Int,
    Size_t,
    Bool,
    Node,
}

/** */
interface IDocumentType : INode
{
    NamedNodeMap  entities();
    string        internalSubset();
    string        name();
    NamedNodeMap  notations();
    string        publicId();
    void          ChildNode_remove();
}


/** */
class DocumentType : Node, IDocumentType
{
    /**  NamedNodeMap of entities declared in the DTD. Every node in this map implements the Entity interface. */
    NamedNodeMap entities()
    {
        return _entities;
    }

    /** A DOMString of the internal subset, or null if there is none. Eg "<!ELEMENT foo (bar)>". */
    string internalSubset()
    {
        return "";
    }

    /** A DOMString, eg "html" for <!DOCTYPE HTML>. */
    string name()
    {
        return _name;
    }

    /** A NamedNodeMap with notations declared in the DTD. Every node in this map implements the Notation interface. */
    NamedNodeMap notations()
    {
        return _notations;
    }

    /** A DOMString, eg "-//W3C//DTD HTML 4.01//EN", empty string for HTML5. */
    string publicId()
    {
        return _publicId;
    }

    /** A DOMString, eg "http://www.w3.org/TR/html4/strict.dtd", empty string for HTML5. */
    string systemId()
    {
        return _systemId;
    }

    /** Removes the object from its parent children list. */
    void ChildNode_remove()
    {
        //
    }

protected:
    NamedNodeMap _entities;
    string       _name = "html";
    NamedNodeMap _notations;
    string       _publicId = "-//W3C//DTD HTML 4.01//EN";
    string       _systemId = "http://www.w3.org/TR/html4/strict.dtd";
}

/**
 https://developer.mozilla.org/en-US/docs/Web/API/NamedNodeMap
*/
interface INamedNodeMap
{
    size_t length();
    Attr   getNamedItem( string name );
    Attr   setNamedItem( Attr attr );
    Attr   removeNamedItem( string name );
    Attr   item( size_t index );
    Attr   getNamedItemNS( string ns, string name );
    Attr   setNamedItemNS( Attr attr );
    Attr   removeNamedItemNS( string ns, string name );
}

/** */
class NamedNodeMap : INamedNodeMap
{
    /** */
    size_t length()
    {
        return _attrs.length;
    }

    /** Returns the Attr corresponding to the given name, or null if there is no corresponding attribute. */
    Attr getNamedItem( string name )
    {
        auto r = _attrs.find!( a => ( a.localName == name ) )();

        if ( ! r.empty )
            return r.front;
        else
            return null;
    }

    /** Replaces, or adds, the Attr identified in the map by the given name. */
    Attr setNamedItem( Attr attr )
    {
        auto name = attr.localName;
        auto r = _attrs.find!( a => ( a.localName == name ) )();

        if ( ! r.empty )
        {
            auto pos = _attrs.length - r.length;
            auto replaced = r.front;
            _attrs[ pos ] = attr;
            return replaced;
        }
        else
        {
            _attrs ~= attr;
            return null;
        }
    }

    /** Removes the Attr identified by the given map */
    Attr removeNamedItem( string name )
    {
        auto r = _attrs.find!( a => ( a.localName == name ) )();

        if ( ! r.empty )
        {
            auto pos = _attrs.length - r.length;
            _attrs[ pos .. $-1 ] = _attrs[ pos+1 .. $ ]; // remove in-place
            _attrs.length -= 1;
            return r.front;
        }
        else
        {
            return null;
        }
    }

    /** Returns the Attr at the given index, or null if the index is higher or equal to the number of nodes. */
    Attr item( size_t index )
    {
        if ( index < _attrs.length )
            return _attrs[ index ];
        else
            return null;
    }

    /** Returns a Attr identified by a namespace and related local name. */
    Attr getNamedItemNS( string ns, string name )
    {
        auto r = _attrs.find!( ( a, b ) => ( a.namespaceURI == ns && a.localName == name ) )();

        if ( ! r.empty )
            return r.front;
        else
            return null;
    }

    /** Replaces, or adds, the Attr identified in the map by the given namespace and related local name. */
    Attr setNamedItemNS( string ns, Attr attr )
    {
        auto name = attr.localName;
        auto r = _attrs.find!( a => ( a.namespaceURI == ns && a.localName == name ) )();

        if ( ! r.empty )
        {
            auto pos = _attrs.length - r.length;
            auto replaced = r.front;
            _attrs[ pos ] = attr;
            return replaced;
        }
        else
        {
            _attrs ~= attr;
            return null;
        }
    }

    /** Removes the Attr identified by the given namespace and related local name. */
    Attr removeNamedItemNS( string ns, string name )
    {
        auto r = _attrs.find!( a => ( a.namespaceURI == ns && a.localName == name ) )();

        if ( ! r.empty )
        {
            auto pos = _attrs.length - r.length;
            _attrs[ pos .. $-1 ] = _attrs[ pos+1 .. $ ]; // remove in-place
            _attrs.length -= 1;
            return r.front;
        }
        else
        {
            return null;
        }
    }

    // Range support
    // foreach suppport
    int opApply( int delegate( ref Attr a ) dg ) const
    {
        int  result = 0;

        foreach ( a; _attrs )
        {
            result = dg( a );

            if ( result )
            {
                break;
            }
        }

        return result;
    }


protected:
    Attr[] _attrs;
}

/**
 https://developer.mozilla.org/en-US/docs/Web/API/Attr
*/
interface IAttr : INode
{
    // Properties
    string name();
    string namespaceURI();
    string localName();
    string prefix();
    bool   specified();
    string value();
}

/** */
class Attr : Node, IAttr
{
    this()
    {
        //
    }

    this( string name )
    {
        this._name = name;
    }

    /** The attribute's name. */
    string name()         { return _name; }
    /** A string representing the namespace URI of the attribute, or null if there is no namespace. */
    string namespaceURI() { return _namespaceURI; }
    /** A string representing the local part of the qualified name of the attribute. */
    string localName()    { return _localName; }
    /** A string representing the namespace prefix of the attribute, or null if no prefix is specified. */
    string prefix()       { return _prefix; }
    /** This property always returns true. */
    bool   specified()    { return _specified; }
    /** The attribute's value. */
    string value()        { return _value; }

protected:
    string _name;
    string _namespaceURI;
    string _localName;
    string _prefix;
    bool   _specified;
    string _value;
}

/** */
class Promise( TS )
{
    alias PromiseCallback( T ) = T delegate( T value );
    alias SuccessCallback      = PromiseCallback!TS;
    alias FailureCallback      = PromiseCallback!string;
    alias FinallyCallback      = void delegate();
    alias Executor             = void delegate( SuccessCallback success, FailureCallback failure );

    this( Executor executor )
    {
        this._executor = executor;
    }

    // static
    /** Wait for all promises to be resolved, or for any to be rejected. */
    static
    Promise all( T )( T[] iterable )
    {
        return null;
    }

    /** Wait until all promises have settled (each may resolve or reject). */
    static
    Promise allSettled( T )( T[] iterable )
    {
        return null;
    }

    /** Takes an iterable of Promise objects and, as soon as one of the promises in the iterable fulfills, returns a single promise that resolves with the value from that promise. */
    static
    Promise any( T )( T[] iterable )
    {
        return null;
    }

    /** Wait until any of the promises is resolved or rejected. */
    static
    Promise race( T )( T[] iterable )
    {
        return null;
    }

    /** Returns a new Promise object that is rejected with the given reason. */
    static
    Promise reject( T )( T reason )
    {
        return null;
    }

    /** Returns a new Promise object that is resolved with the given value. If the value is a thenable (i.e. has a then method), the returned promise will "follow" that thenable, adopting its eventual state; otherwise, the returned promise will be fulfilled with the value. */
    static
    Promise resolve( T )( T value )
    {
        return
            new Promise(
                ( success, failure )
                {
                    if ( success !is null )
                        success( value );
                }
            );
    }

    // Methods
    /** Appends a rejection handler callback to the promise, and returns a new promise resolving to the return value of the callback if it is called, or to its original fulfillment value if the promise is instead fulfilled. */
    auto catch_( FailureCallback failure )
    {
        then( null, failure );
        return this;
    }

    /** Appends fulfillment and rejection handlers to the promise, and returns a new promise resolving to the return value of the called handler, or to its original settled value if the promise was not handled (i.e. if the relevant handler onFulfilled or onRejected is not a function). */
    auto then( SuccessCallback success, FailureCallback failure=null )
    {
        _callbacks ~= CallbackRec( success, failure );
        return this;
    }

    /** Appends a handler to the promise, and returns a new promise that is resolved when the original promise is resolved. The handler is called when the promise is settled, whether fulfilled or rejected. */
    auto finally_( FinallyCallback onfinally )
    {
        _onfinally = onfinally;
        return this;
    }


    // D addon
    void run()
    {
        _executor( &_success, &_failure );
    }

private:
    TS _success( TS value )
    {
        foreach ( rec; _callbacks )
        {
            value = rec.success( value );
        }

        if ( _onfinally !is null )
            _onfinally();

        return value;
    }

    string _failure( string reason )
    {
        foreach ( rec; _callbacks )
        {
            reason = rec.failure( reason );
        }

        if ( _onfinally !is null )
            _onfinally();

        return reason;
    }

private:
    Executor        _executor;
    CallbackRec[]   _callbacks;
    FinallyCallback _onfinally;

    struct CallbackRec
    {
        SuccessCallback success;
        FailureCallback failure;
    }
}

/** */
class CustomElementRegistry
{
    /** Defines a new custom element. */
    void define( string name, CustomElementConstructor constructor, CustomElementOptios options )
    {
        //
    }

    /** Returns the constructor for the named custom element, or undefined if the custom element is not defined. */
    CustomElementConstructor get( string name )
    {
        return _constructors.get( name, null );
    }

    /** Upgrades a custom element directly, even before it is connected to its shadow root. */
    void upgrade( root )
    {
        //
    }

    /** Returns an empty promise that resolves when a custom element becomes defined with the given name. If such a custom element is already defined, the returned promise is immediately fulfilled. */
    Promise whenDefined( string name )
    {
        return new Promise( ( success, failure ) {} );
    }

protected:
    CustomElementConstructor[ name ] _constructors;
}

/** */
alias CustomElementConstructor = void function();

/** */
struct CustomElementOptios
{
    string extends; // extends: String specifying the name of a built-in element to extend. Used to create a customized built-in element.
}

/** */
alias PromiseCallback = void function();
alias PromiseExecutor =  void function( PromiseCallback successCallback, PromiseCallback failureCallback );


/** */
class Crypto
{
    /** Returns a SubtleCrypto object providing access to common cryptographic primitives, like hashing, signing, encryption, or decryption. */
    SubtleCrypto subtle()
    {
        return new SubtleCrypto();
    }

    /** Fills the passed TypedArray with cryptographically sound random values. */
    T[] getRandomValues( T )( T[] arr )
    {
        import std.random : Random;
        import std.random : uniform;

        auto rnd = Random( unpredictableSeed );

        foreach ( ref a; arr )
        {
            a = uniform( 0, T.max, rnd ).to!T;
        }

        return arr;
    }

}

/** */
class SubtleCrypto
{
    //
}

/** */
CustomElementRegistry customElementRegistry;
Viewport              viewport;
Window                window;
Crypto                crypto;

static
this()
{
    customElementRegistry = new CustomElementRegistry();
    viewport              = new Viewport();
    window                = new Window();
    crypto                = new Crypto();
}

