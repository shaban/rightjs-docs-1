# Resizable

`Resizable` is a simple widget that will help you to create elements on your
page what can be resized by the user.

<%= partial '/ui/head', :locals => {:name => 'resizable'} %>

<%= anchors_index %>


## Features List, :features

* Easy and flexible usage
* Can work with any direction
* Fully CSS based design
* Tiny (3.6k) build file
* No drag-n-drop dependencies


## Usage Basics, :usage

First, copy in place one of the files above, as you usually do. Then copy
[this image](/images/rightjs-ui/resizable.png) to the same location on your
server. (check the [styles section](#styles) for more options on this regard)

After that you have three ways to create resizable blocks. First, you can
simply define an HTML structure like that

    <div class="right-resizable">
      <div class="right-resizable-content">
        // your content goes in here
      </div>
      <div class="right-resizable-handle"></div>
    </div>

In this case RightJS will use lazy initialization of the widget on demand.
Or you can turn any element on your page into resizable widget 
programmatically like that.

    <div id="my-element">
      // Some content in here
    </div>
    
    $('my-element').makeResizable();

In this case RightJS will initialize a resizable unit instantly. To switch the
functionality off use the `undoResizable()` method.

And finally you can use the `Resizable` unit as a class

    var resizable = new Resizable('my-element', {
      direction: 'bottom'
    });
    
    resizable.setSize(200, 200);
    
    resizable.destroy(); // the destructor


## Defining Directions, :directions

By default your resizables will be bidirectional, with a handle at the right 
bottom corner. But this widget can work with any of the four directions 
specifically.

If you create your resizable as a HTML structure, then simply use css classes,
like `right-resizable-right`, `right-resizable-bottom`, and so one.

    <div class="right-resizable-bottom">
      // the rest of the stuff in here
    </div>

If you create your resizable programmatically then use the `direction` option

    $('my-element').makeResizable({direction: 'right'});

It will automatically assign necessary classes for you.


## Defining Boundaries, :boundaries

This widget will automatically respect your CSS level settings like 
`min-width`, `max-height`, etc.

    <div class="right-resizable" style="min-width: 10em">
      // the rest of the construction in here
    </div>

And you also can define the limits with the options, like that

    $('my-element').makeResizable({
      minWidth:  100,
      maxHeight: '20em'
    });

__NOTE__: You can use any type of values, numbers, sizes with dimensions, even
percents.


## Options List, :options

The list of options is pretty short and we went through all of them in the
previous two chapters

Name      | Default | Description
----------|---------|-----------------------------------------------------
direction | null | `top`, `left`, `right`, `bottom` or `null` for bidirectional
minWidth  | null | minimal width limit
maxWidth  | null | maximal width limit
minHeight | null | minimal height limit
maxHeight | null | maximal height limit

As usual you can use any of those options with constructor, the 
`makeResizable` method or with the `data-resizable-options` HTML5 attribute.


## Events List, :options

There is a simple list of events this widget supports

Name       | Description
-----------|------------------------------------------
start      | when the resize starts
resize     | when the widget is resized by the user
release    | when the resize ends
initialize | when the widget is initialized
destroy    | when the widget is destroyed

All the event listeners will receive two arguments: current resizable unit
instance and a reference to the dom-event that caused the event


## Style Alterations, :styles

Resizables have a pretty simple structure, which you can create by yourself
or let the script to create it for you

    <div class="right-resizable">
      <div class="right-resizable-content">
        // your content goes in here
      </div>
      <div class="right-resizable-handle"></div>
    </div>

__NOTE:__ this widget has an image dependency which is used as the background
for the handle elements. You can grab it 
[over here](/images/rightjs-ui/resizable.png) and save to the same location
on your server. Or you can use your own image and define it in your CSS layer
like that

    .right-resizable-handle {
      background-image: url(/url/to/my-image.png);
    }


