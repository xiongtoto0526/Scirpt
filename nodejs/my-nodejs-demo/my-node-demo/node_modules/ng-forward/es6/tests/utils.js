var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") return Reflect.decorate(decorators, target, key, desc);
    switch (arguments.length) {
        case 2: return decorators.reduceRight(function(o, d) { return (d && d(o)) || o; }, target);
        case 3: return decorators.reduceRight(function(o, d) { return (d && d(target, key)), void 0; }, void 0);
        case 4: return decorators.reduceRight(function(o, d) { return (d && d(target, key, o)) || o; }, desc);
    }
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
import { ng } from './angular';
import '../util/jqlite-extensions';
import * as tcb from '../testing/test-component-builder';
import { Component } from '../decorators/component';
export function quickFixture({ providers = [], directives = [], template = '<div></div>' }) {
    ng.useReal();
    let Test = class {
    };
    Test = __decorate([
        Component({ selector: 'test', template, directives, providers }), 
        __metadata('design:paramtypes', [])
    ], Test);
    let builder = new tcb.TestComponentBuilder();
    return builder.create(Test);
}
;

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbImxpYi90ZXN0cy91dGlscy50cyJdLCJuYW1lcyI6WyJxdWlja0ZpeHR1cmUiLCJxdWlja0ZpeHR1cmUuVGVzdCJdLCJtYXBwaW5ncyI6Ijs7Ozs7Ozs7Ozs7T0FBTyxFQUFDLEVBQUUsRUFBQyxNQUFNLFdBQVc7T0FDckIsMkJBQTJCO09BQzNCLEtBQUssR0FBRyxNQUFNLG1DQUFtQztPQUNqRCxFQUFDLFNBQVMsRUFBQyxNQUFNLHlCQUF5QjtBQUVqRCw2QkFBNkIsRUFDdkIsU0FBUyxHQUFDLEVBQUUsRUFDWixVQUFVLEdBQUMsRUFBRSxFQUNiLFFBQVEsR0FBQyxhQUFhLEVBQ3ZCO0lBRUhBLEVBQUVBLENBQUNBLE9BQU9BLEVBQUVBLENBQUNBO0lBRWJBO0lBQ1lDLENBQUNBO0lBRGJEO1FBQUNBLFNBQVNBLENBQUNBLEVBQUVBLFFBQVFBLEVBQUVBLE1BQU1BLEVBQUVBLFFBQVFBLEVBQUVBLFVBQVVBLEVBQUVBLFNBQVNBLEVBQUVBLENBQUNBOzthQUNwREE7SUFFYkEsSUFBSUEsT0FBT0EsR0FBSUEsSUFBSUEsR0FBR0EsQ0FBQ0Esb0JBQW9CQSxFQUFFQSxDQUFDQTtJQUU5Q0EsTUFBTUEsQ0FBQ0EsT0FBT0EsQ0FBQ0EsTUFBTUEsQ0FBQ0EsSUFBSUEsQ0FBQ0EsQ0FBQ0E7QUFDOUJBLENBQUNBO0FBQUEsQ0FBQyIsImZpbGUiOiJsaWIvdGVzdHMvdXRpbHMuanMiLCJzb3VyY2VzQ29udGVudCI6WyJpbXBvcnQge25nfSBmcm9tICcuL2FuZ3VsYXInO1xuaW1wb3J0ICcuLi91dGlsL2pxbGl0ZS1leHRlbnNpb25zJztcbmltcG9ydCAqIGFzIHRjYiBmcm9tICcuLi90ZXN0aW5nL3Rlc3QtY29tcG9uZW50LWJ1aWxkZXInO1xuaW1wb3J0IHtDb21wb25lbnR9IGZyb20gJy4uL2RlY29yYXRvcnMvY29tcG9uZW50JztcblxuZXhwb3J0IGZ1bmN0aW9uIHF1aWNrRml4dHVyZSh7XG4gICAgICBwcm92aWRlcnM9W10sXG4gICAgICBkaXJlY3RpdmVzPVtdLFxuICAgICAgdGVtcGxhdGU9JzxkaXY+PC9kaXY+J1xuICAgIH0pe1xuXG4gIG5nLnVzZVJlYWwoKTtcblxuICBAQ29tcG9uZW50KHsgc2VsZWN0b3I6ICd0ZXN0JywgdGVtcGxhdGUsIGRpcmVjdGl2ZXMsIHByb3ZpZGVycyB9KVxuICBjbGFzcyBUZXN0IHt9XG5cbiAgbGV0IGJ1aWxkZXIgPSAgbmV3IHRjYi5UZXN0Q29tcG9uZW50QnVpbGRlcigpO1xuICBcbiAgcmV0dXJuIGJ1aWxkZXIuY3JlYXRlKFRlc3QpO1xufTsiXSwic291cmNlUm9vdCI6Ii9zb3VyY2UvIn0=
