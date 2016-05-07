'use strict';

Object.defineProperty(exports, '__esModule', {
    value: true
});

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

var Metastore = (function () {
    function Metastore(namespace) {
        _classCallCheck(this, Metastore);

        this.namespace = namespace;
    }

    _createClass(Metastore, [{
        key: '_map',
        value: function _map(obj, key) {
            if (!Reflect.hasOwnMetadata(this.namespace, obj, key)) {
                Reflect.defineMetadata(this.namespace, new Map(), obj, key);
            }
            return Reflect.getOwnMetadata(this.namespace, obj, key);
        }
    }, {
        key: 'get',
        value: function get(key, obj, prop) {
            return this._map(obj, prop).get(key);
        }
    }, {
        key: 'set',
        value: function set(key, value, obj, prop) {
            this._map(obj, prop).set(key, value);
        }
    }, {
        key: 'has',
        value: function has(key, obj, prop) {
            return this._map(obj, prop).has(key);
        }
    }, {
        key: 'push',
        value: function push(key, value, obj, prop) {
            if (!this.has(key, obj, prop)) {
                this.set(key, [], obj, prop);
            }
            var store = this.get(key, obj, prop);
            if (!Array.isArray(store)) {
                throw new Error('Metastores can only push metadata to array values');
            }
            store.push(value);
        }
    }, {
        key: 'merge',
        value: function merge(key, value, obj, prop) {
            var previous = this.get(key, obj, prop) || {};
            var mergedObj = Object.assign({}, previous, value);
            this.set(key, mergedObj, obj, prop);
        }
    }, {
        key: 'forEach',
        value: function forEach(callbackFn, obj, prop) {
            this._map(obj, prop).forEach(callbackFn);
        }
    }]);

    return Metastore;
})();

exports['default'] = Metastore;
module.exports = exports['default'];
//# sourceMappingURL=metastore.js.map
