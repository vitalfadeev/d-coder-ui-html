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


void main()
{
	writeln("Edit source/app.d to start your project.");
}

/** */
interface IEventTarget
{
    //
}

/** */
class EventTarget : IEventTarget
{
    //
}

/** */
interface IDocument
{
    string characterSet();
}

/** */
class Document : IDocument
{
    //
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
    bool   isSameNode( Node otherNode )s;
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
        return new HTMLCollection( this._firstChild );
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
            return "<" ~ _tagName ~ " " ~ attrsString ~ "">" ~ innerHTML ~ "</" ~ _tagName ~ ">";
        else
            return "<" ~ _tagName ~ "">" ~ innerHTML ~ "</" ~ _tagName ~ ">";

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
    /** Registers an event handler to a specific event type on the element. */
    void addEventListener( string type, EventListener listener, Options options, bool useCapture=false )
    {
        EventTarget.addEventListener();
    }

    void addEventListener( string type, EventListener listener, Options options )
    {
        EventTarget.addEventListener();
    }

    void addEventListener( string type, EventListener listener, bool useCapture=false )
    {
        EventTarget.addEventListener();
    }

    void addEventListener( string type, EventListener listener )
    {
        EventTarget.addEventListener();
    }

    /** Attaches a shadow DOM tree to the specified element and returns a reference to its ShadowRoot. */
    Element attachShadow( string[ string ] shadowRootInit )
    {
        Element shadowroot;
        return shadowroot;
    }

    /** A shortcut method to create and run an animation on an element. Returns the created Animation object instance. */
    Animation animate( keyframes, options ) 
    {
        return new Animation();
    }

    /** Inserts a set of Node objects or DOMString objects after the last child of the element. */
    void append( Node node )
    {
        //
    }

    void append( string s )
    {
        //
    }

    /** Returns the Element which is the closest ancestor of the current element (or the current element itself) which matches the selectors given in parameter. */
    void closest()
    {
        //
    }

protected:
    NamedNodeMap _attrs;
    Computed     _computed;
    string       _ns;
    string       _prefix;
    string       _name;
    string       _tagName;

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
alias void function( ResolutionFunc resolutionFunc, RejectionFunc rejectionFunc ) PromiseExecutor;
alias void function() ResolutionFunc;
alias void function() RejectionFunc;

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
     auto,
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
    //
}

/** */
alias float Number;

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
    this( Element first )
    {
        this._first = first;
    }

    size_t length()
    {
        size_t count;

        for ( auto node = _first; node !is null; node = node.nextSibling )
        {
            if ( node.nodeType == ELEMENT_NODE )
            {
                count += 1;
            }
        }

        return count;
    }

    /** */
    Node item( size_t index )
    {
        auto node = _first;
        size_t i;

        for ( auto node = _first; node !is null; node = node.nextSibling )
        {
            if ( node.nodeType == ELEMENT_NODE )
            {
                if ( i == index )
                {
                    return node;
                }

                i += 1;
            }
        }

        return null;
    }

    /** Returns the specific node whose ID or, as a fallback, name matches the string specified by name. */
    Node namedItem( string name )
    {
        auto node = _first;

        for ( auto node = _first; node !is null; node = node.nextSibling )
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
    Node _first;
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
alias void delegate( string currentValue                                            ) TokenForEachCallback1;
alias void delegate( string currentValue, size_t currentIndex                       ) TokenForEachCallback1;
alias void delegate( string currentValue, size_t currentIndex, DOMTokenList listObj ) TokenForEachCallback3;

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
alias void delegate( Node currentValue                                        ) ForEachCallback1;
alias void delegate( Node currentValue, size_t currentIndex                   ) ForEachCallback1;
alias void delegate( Node currentValue, size_t currentIndex, NodeList listObj ) ForEachCallback3;

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
class Attr : IAttr
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
Viewport viewport;

static
this()
{
    viewport = new Viewport();
}