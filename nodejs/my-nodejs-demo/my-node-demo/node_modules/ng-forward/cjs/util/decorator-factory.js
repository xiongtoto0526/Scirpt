'use strict';

Object.defineProperty(exports, '__esModule', {
    value: true
});

var _writers = require('../writers');

var randomInt = function randomInt() {
    return Math.floor(Math.random() * 100);
};

exports['default'] = function (type) {
    var strategyType = arguments.length <= 1 || arguments[1] === undefined ? 'provider' : arguments[1];

    var names = new Set();
    function createUniqueName(_x2) {
        var _again = true;

        _function: while (_again) {
            var name = _x2;
            _again = false;

            if (names.has(name)) {
                _x2 = '' + name + randomInt();
                _again = true;
                continue _function;
            } else {
                return name;
            }
        }
    }
    ;
    var NAME_TAKEN_ERROR = function NAME_TAKEN_ERROR(name) {
        return new Error('A provider with type ' + type + ' and name ' + name + ' has already been registered');
    };
    return (function () {
        var d = function d(maybeT) {
            var writeWithUniqueName = function writeWithUniqueName(t) {
                var name = createUniqueName(t.name);
                _writers.providerStore.set('type', type, t);
                _writers.providerStore.set('name', name, t);
                names.add(name);
            };
            if (typeof maybeT === 'string') {
                if (names.has(maybeT)) {
                    throw NAME_TAKEN_ERROR(maybeT);
                }
                return function (t) {
                    _writers.providerStore.set('type', type, t);
                    _writers.providerStore.set('name', maybeT, t);
                    names.add(maybeT);
                };
            } else if (maybeT === undefined) {
                return function (t) {
                    return writeWithUniqueName(t);
                };
            }
            writeWithUniqueName(maybeT);
        };
        d.clearNameCache = function () {
            return names.clear();
        };
        return d;
    })();
};

;
module.exports = exports['default'];
//# sourceMappingURL=decorator-factory.js.map
