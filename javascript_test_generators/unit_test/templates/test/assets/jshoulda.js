/*  jShoulda, version 1.2.1
 *  (c) 2008 Choan Galvez
 *
 *  jShoulda is freely distributable under
 *  the terms of an MIT-style license.
 *  For details, see the web site: http://jshoulda.scriptia.net
 *
 *--------------------------------------------------------------------------*/

var jShoulda = function() {
  // the test runner
  var tr,
  // handle all testcases with the same testrunner
  unique = false,
  // styles definitions
  styles = {};

  function dummy() {
  };

  function runQueue(queue, name, before, after, ext) {
    var i, tests;
    for (i = 0; i < queue.length; i += 1) {
      tests = queue[i](name, before, after, ext);
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

  function getContextAlias(prefix) {
    if (prefix) prefix += ' ';
    return function (name, config, args) {
      var queue = Array.prototype.slice.call(arguments, 0);
      var cName = '';
      var obj = {};
      // shift arguments if the first one is a string
      if (typeof queue[0] == 'string') {
        if (name) { cName += prefix; }
        cName += queue.shift();
      }
      if (typeof queue[0] === 'object') {
        obj = queue.shift();
      }

      obj.before = obj.setup || obj.before || dummy;
      obj.after = obj.teardown || obj.after || dummy;
      var beforeQueue;
      var afterQueue;
      var extensions = merge({}, obj || {});

      return function(outerName, before, after, ext) {
        // the root context gets no outerName or a configuration object
        // as its first argument
        var prefix = outerName;
        var is_root = !!(outerName == undefined || typeof outerName == 'object');
        if (is_root) {
          tr = (tr && unique) ? tr : new Test.Unit.Runner({}, outerName || {});
          prefix = '';
        }
        // shift arguments if the second one is a
        // configuration object
        beforeQueue = before ? before.push(obj.before) && before : [obj.before];
        afterQueue = after ? after.push(obj.after) && after : [obj.after];
        runQueue(queue, [prefix, cName].join(' ').replace(/^\s+/, ''), beforeQueue, afterQueue, merge(extensions, ext));
        if (is_root) {
          return tr;
        }
        return false; // do not add to the tests queue
      };
    };
  };

  function merge(sub, sup) {
    for (var i in sup) {
      if (i.search(/^(before|after|setup|teardown)$/) != -1) continue;
      if (sup.hasOwnProperty(i)) {
        sub[i] = sup[i];
      }
    }
    return sub;
  }


  function getShouldAlias(connector) {
    return function (name, fn) {
      return function(prefix, before, after, extensions) {
        var beforeBatch = makeBatch(before);
        var afterBatch = makeBatch(after);
        var unit = new Test.Unit.Testcase([prefix, name].join(' ' + connector + ' '), fn, beforeBatch, afterBatch);
        merge(unit, extensions);
        return unit;
      };
    };
  }

  function setShouldAlias(name, host) {
    var connector = name;
    if (typeof host == 'string') {
      connector = host;
      host = arguments[2];
    }
    host = host || window;
    host[name] = getShouldAlias(connector);
    return jShoulda;
  }

  function setContextAlias(name, host) {
    var prefix = '';
    if (typeof host == 'string') {
      prefix = host;
      host = arguments[2];
    }
    host = host || window;
    host[name] = getContextAlias(prefix);
    return jShoulda;
  }

  function useStyle(name) {
    var style, i;
    if (name in styles) {
      style = styles[name];
      if ('context' in style) {
        for (i = 0; i < style.context.length; i += 2) {
          setContextAlias(style.context[i], style.context[i+1]);
        }
      }
      if ('should' in style) {
        for (i = 0; i < style.should.length; i += 2) {
          setShouldAlias(style.should[i], style.should[i+1]);
        }
      }
      if (style.unify) unifyRunners();
    }
    else throw { name: 'UndefinedStyle', message: 'There is not "'+name+'" style defined' };
    return jShoulda;
  }

  function defineStyle(name, opts, aliases) {
    styles[name] = opts;
    for (var i = 2; i < arguments.length; i += 1) {
      styles[arguments[i]] = opts;
    }
    return jShoulda;
  }

  function unifyRunners (options) {
    if (options) {
      tr = options instanceof Test.Unit.Runner ? options : new Test.Unit.Runner({}, options || {});
    }
    unique = true;
    return jShoulda;
  }

  return {
    setShouldAlias : setShouldAlias,
    setContextAlias : setContextAlias,
    unifyRunners : unifyRunners,
    useStyle : useStyle,
    defineStyle: defineStyle
  };

}();

jShoulda
  .defineStyle('describe', {
    context: [ 'describe', '' ],
    should: [ 'it', '' ],
    unify: false
  }, 'it')
  .defineStyle('context', {
    context : [ 'context', '' ],
    should : [ 'should', 'should' ],
    unify : false
  }, 'should')
  .useStyle('should');