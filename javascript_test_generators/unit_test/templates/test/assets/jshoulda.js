/*  jShoulda, version 1.0.1
 *  (c) 2008 Choan Galvez
 *
 *  jShoulda is freely distributable under
 *  the terms of an MIT-style license.
 *  For details, see the web site: http://jshoulda.scriptia.net
 *
 *--------------------------------------------------------------------------*/

var context, should;
(function() {
  // the test runner
  var tr;

  function dummy() {
  };

  function runQueue(queue, name, before, after) {
    var i, tests;
    for (i = 0; i < queue.length; i += 1) {
      tests = queue[i](name, before, after);
      if (tests)
        tr.tests.push(tests);
    }
    before.pop();
    after.pop();
  }

  function makeBatch(fn_a) {
    var copy = fn_a.slice(0);
    return function() {
      for (var i = 0; i < copy.length; i += 1) {
        copy[i].call(this);
      }
    };
  }

  context = function(name, obj) {
    obj.before = obj.setup || obj.before || dummy;
    obj.after = obj.teardown || obj.after || dummy;
    var queue = Array.prototype.slice.call(arguments, 2);
    var beforeQueue;
    var afterQueue;
    return function(outerName, before, after) {
      // the root context gets no outerName or a configuration object
      // as its first argument
      var prefix = outerName;
      var is_root = !!(outerName == undefined || typeof outerName == 'object');
      if (is_root) {
        tr = new Test.Unit.Runner({}, outerName || {});
        prefix = '';
      }
      beforeQueue = before ? before.push(obj.before) && before : [obj.before];
      afterQueue = after ? after.push(obj.after) && after : [obj.after];
      runQueue(queue, [prefix, name].join(' '), beforeQueue, afterQueue);
      if (is_root) {
        return tr;
      }
      return false; // do not add to the tests queue
    };
  };

  should = function(name, fn) {
    return function(prefix, before, after) {
      var beforeBatch = makeBatch(before);
      var afterBatch = makeBatch(after);
      return new Test.Unit.Testcase([prefix, name].join(' ' + should.connector + ' '), fn, beforeBatch, afterBatch);
    };
  };

  should.connector = 'should';


})();