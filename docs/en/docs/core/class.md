# Class
[Prototype]: http://prototypejs.org
[Mootools]:  http://mootools.net
[Ruby]:      http://www.ruby-lang.org

RightJS is an object-oriented framework and therefore provides extensive
object-oriented programming features, which are basically a mix of ideas
from [Prototype][] JavaScript framework and [Ruby][] programming language.


## Basic Definition

A basic class definition is the same as you might see in [Prototype][] or
[Mootools][]

    var Klass = new Class({
      initialize: function() {
        // constructor
      },

      method1: function() {},
      method2: function() {}
    });


## Inheritance

Inheritance looks the same way it does in [Prototype][], except in RightJS you
refer to a super method by calling the `this.$super` variable

    var Girl = new Class({
      sayHello: function() {
        return "Hello there";
      }
    });

    var SexyGirl = new Class(Girl, {
      sayHello: function() {
        return "Well "+ this.$super() + "!";
      }
    });


## Ruby-style Mixins

[Ruby][] takes advantages of multiple-inheritance by allowing developers to
define shared modules and then inject them in classes when needed. RightJS
monkeys this feature in its `Class` unit.

    var Module = {
      method: function() {}
    };

    var Klass = new Class({
      include: Module, // <- adds it on the instance level
      extend:  Module, // <- adds it on the class level

      // the rest of the class
    });

You can specify several modules by using arrays:

    var Klass = new Class({
      include: [Module1, Module2, ...],

      // or on the class level
      extend:  [Module1, Module2, ...]
    });

You can also define class-level methods in-line with all the rest of the
class:

    var Klass = new Class({
      extend: {
        CLASS_LEVEL_CONST_1: 1,
        CLASS_LEVEL_CONST_2: 2,

        classLevelMethod: function() {}
      },

      // instance level methods
    });

And you can call the `include()` and `extend()` methods after a class was
defined:

    var Klass = new Class({
      // ....
    });

    Klass.include(Module, Module, ...);
    Klass.extend(Module, Module, ...);

__NOTE:__ The mixins follow the same priority principles as they do on
[Ruby][]. If you inject your modules _with_ a class definition, then the
class' own methods will overwrite methods from the modules. But if you
inject your modules _after_ a class was defined by using the `include()` and
`extend()` methods, then methods from the modules will overwrite methods in
the class.


## Mixin Callbacks

As RightJS monkeys the modules system from [Ruby][], it also supports the post
injection callbacks the same way [Ruby][] does. The names of the callback
methods are similar: `selfIncluded` and `selfExtended`. Or in their
underscored version `self_included` and `self_extened`.

    var Module = {
      selfIncluded: function(klass) {
        klass.prototype.foo = 'bar';
      },

      selfExtended: function(klass) {
        klass.FOO = 'BAR';
      }
    };

    var Klass = new Class({
      include: Module,
      extend:  Module
    });

    Klass.prototype.foo; // -> 'bar'
    Klass.FOO;           // -> 'BAR'


You might also check the
[OOP tutorial page](/tutorials/object-oriented-programming) for more detailed
information on this topic.
