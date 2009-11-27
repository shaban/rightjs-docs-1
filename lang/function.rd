= Intro

There are several conventional extensions over the <tt>Function</tt> class
that provides the standard functionality like binding, working with 
timeouts etc.

### Function#bind

== Semantic
  bind(Object scope[, argument,...]) -> Function new

== Description
  Binds the function to be executed in the specified context. Additionally can 
  take optional curry arguments

== Example
  var object = {
    attr: 'value'
  };
  var func = function(arg1, arg2) {
    return this.attr + ': '+arg1 + ': '+ arg2;
  };
  
  var bind = func.bind(object, 'argument1');
  
  var result = bind('argument2');
  
  // -> 'value: argument1: argument2'


### Function#bindAsEventListener

== Semantic
  bindAsEventListener(Object scope[, argument, ...]) -> Function new

== Description
  Binds the function to the given scope the way that it was handled the first 
  argument as an event

== Example
  var object = {
    attr: 'value'
  };
  var func = function(event, arg1, arg2) {
    return this.attr +' > '+ event.eventName +' > '+ arg1 +' > '+ arg2;
  };
  
  var observer = new Observer();
  observer.observe('foo', func.bindAsEventListener('argument1', 'argument2'));
  observer.fire('foo');
  
  // -> 'value > foo > argument1 > argument2'



### Function#curry

== Semantic
  curry(mixed value[, mixed value, ...]) -> Function new

== Description
  Standard functional approach currying feature

== Example
  var multiplier = function(x, y) {
    return x * y
  };
  var double = multiplier.curry(2);
  
  double(2); // 4
  double(4); // 8
  double(8); // 16
  

### Function#rcurry

== Semantic
  rcurry(mixed value[, value, ...]) -> Function new

== Description
  Functional approach right currying feature

== Example
  var callback = function() { return $A(arguments); };
  
  var with_one = callback.rcurry(1);
  var with_two = callback.rcurry(1,2);
  
  
  with_one(1);     // -> [1,1]
  with_one(1,2);   // -> [1,2,1]
  
  with_two(1);     // -> [1,1,2]
  with_two(1,2,3); // -> [1,2,3,1,2]



### Function#delay

== Semantic
  delay(Integer timeout) -> Integer timeout marker

== Description
  Schedules a delayed execution for the function.
  
  Additionally, the timeout pointer will have the <tt>'cancel'</tt> method
  by calling which the timeout can be canceled.

== Example
  var func = function() {
    alert('boo');
  };
  
  var timeout = func.delay(2000);
  
  // should see the boo in 2 seconds
  // you can cancel the delayed execution
  
  window.clearTimeout(timeout);
  
  // or
  timeout.cancel();



### Function#periodical

== Semantic
  periodical(Integer timeout) -> Integer timeout marker

== Description
  Makes the function be periodically executed with the given timeout.
  
  Additionally, the timeout marker will have the <tt>'stop'</tt> method by
  calling which you can stop the function being called periodically.

== Example
  var func = function() {
    // check something
  };
  
  var marker = func.periodical(4000);
  
  // now the function will get executed every 4 seconds
  
  // to stop it just pass it to the standard clearInterval method
  window.clearInterval(marker);
  
  // or call the 'stop' method
  marker.stop();


### Function#chain
== Semantic
  chain(Function func[, value, ...]) -> Function new
  
== Description
  Schedules the argument function to be called immediately after
  the main function. Optionally with some prebinded arguments
  
== Example
  var f1 = function(list, num) { list.push(num); };
  var f2 = function(list, num) { list.push(num); };
  var f3 = function(list, num) { list.push(num); };
  
  var list = []; // <- will track the calls
  
  var f = f1.chain(f2, list, 2).chain(f3, list, 3);
  
  f(list, 1); // calls the first function
  
  list // -> [1, 2, 3]