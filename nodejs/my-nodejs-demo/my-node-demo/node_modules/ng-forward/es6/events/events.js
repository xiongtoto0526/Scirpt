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
import { Directive } from '../decorators/directive';
import { Inject } from '../decorators/inject';
import parseSelector from '../util/parse-selector';
import { dasherize } from '../util/helpers';
let events = new Set([
    'click',
    'dblclick',
    'mousedown',
    'mouseup',
    'mouseover',
    'mouseout',
    'mousemove',
    'mouseenter',
    'mouseleave',
    'keydown',
    'keyup',
    'keypress',
    'submit',
    'focus',
    'blur',
    'copy',
    'cut',
    'paste',
    'change',
    'dragstart',
    'drag',
    'dragenter',
    'dragleave',
    'dragover',
    'drop',
    'dragend',
    'error',
    'input',
    'load',
    'wheel',
    'scroll'
]);
function resolve() {
    let directives = [];
    events.forEach(event => {
        const selector = `[(${dasherize(event)})]`;
        let EventHandler = class {
            constructor($parse, $element, $attrs, $scope) {
                this.$element = $element;
                this.$scope = $scope;
                let { name: attrName } = parseSelector(selector);
                this.expression = $parse($attrs[attrName]);
                $element.on(event, e => this.eventHandler(e));
                $scope.$on('$destroy', () => this.onDestroy());
            }
            eventHandler($event = {}) {
                let detail = $event.detail;
                if (!detail && $event.originalEvent && $event.originalEvent.detail) {
                    detail = $event.originalEvent.detail;
                }
                else if (!detail) {
                    detail = {};
                }
                this.expression(this.$scope, Object.assign(detail, { $event }));
                this.$scope.$applyAsync();
            }
            onDestroy() {
                this.$element.off(event);
            }
        };
        EventHandler = __decorate([
            Directive({ selector }),
            Inject('$parse', '$element', '$attrs', '$scope'), 
            __metadata('design:paramtypes', [Function, Object, Object, Object])
        ], EventHandler);
        directives.push(EventHandler);
    });
    return directives;
}
function add(...customEvents) {
    customEvents.forEach(event => events.add(event));
}
export default { resolve, add };

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbImxpYi9ldmVudHMvZXZlbnRzLnRzIl0sIm5hbWVzIjpbInJlc29sdmUiLCJyZXNvbHZlLkV2ZW50SGFuZGxlciIsInJlc29sdmUuRXZlbnRIYW5kbGVyLmNvbnN0cnVjdG9yIiwicmVzb2x2ZS5FdmVudEhhbmRsZXIuZXZlbnRIYW5kbGVyIiwicmVzb2x2ZS5FdmVudEhhbmRsZXIub25EZXN0cm95IiwiYWRkIl0sIm1hcHBpbmdzIjoiOzs7Ozs7Ozs7OztPQUFPLEVBQUMsU0FBUyxFQUFDLE1BQU0seUJBQXlCO09BQzFDLEVBQUMsTUFBTSxFQUFDLE1BQU0sc0JBQXNCO09BQ3BDLGFBQWEsTUFBTSx3QkFBd0I7T0FDM0MsRUFBQyxTQUFTLEVBQUMsTUFBTSxpQkFBaUI7QUFFekMsSUFBSSxNQUFNLEdBQUcsSUFBSSxHQUFHLENBQUM7SUFDbkIsT0FBTztJQUNQLFVBQVU7SUFDVixXQUFXO0lBQ1gsU0FBUztJQUNULFdBQVc7SUFDWCxVQUFVO0lBQ1YsV0FBVztJQUNYLFlBQVk7SUFDWixZQUFZO0lBQ1osU0FBUztJQUNULE9BQU87SUFDUCxVQUFVO0lBQ1YsUUFBUTtJQUNSLE9BQU87SUFDUCxNQUFNO0lBQ04sTUFBTTtJQUNOLEtBQUs7SUFDTCxPQUFPO0lBQ1AsUUFBUTtJQUNSLFdBQVc7SUFDWCxNQUFNO0lBQ04sV0FBVztJQUNYLFdBQVc7SUFDWCxVQUFVO0lBQ1YsTUFBTTtJQUNOLFNBQVM7SUFDVCxPQUFPO0lBQ1AsT0FBTztJQUNQLE1BQU07SUFDTixPQUFPO0lBQ1AsUUFBUTtDQUNULENBQUMsQ0FBQztBQUVIO0lBQ0VBLElBQUlBLFVBQVVBLEdBQVVBLEVBQUVBLENBQUNBO0lBRTNCQSxNQUFNQSxDQUFDQSxPQUFPQSxDQUFDQSxLQUFLQTtRQUNsQkEsTUFBTUEsUUFBUUEsR0FBR0EsS0FBS0EsU0FBU0EsQ0FBQ0EsS0FBS0EsQ0FBQ0EsSUFBSUEsQ0FBQ0E7UUFDM0NBO1lBS0VDLFlBQVlBLE1BQXdCQSxFQUFTQSxRQUFnQkEsRUFBRUEsTUFBc0JBLEVBQVNBLE1BQWlCQTtnQkFBbEVDLGFBQVFBLEdBQVJBLFFBQVFBLENBQVFBO2dCQUFpQ0EsV0FBTUEsR0FBTkEsTUFBTUEsQ0FBV0E7Z0JBRTdHQSxJQUFJQSxFQUFFQSxJQUFJQSxFQUFFQSxRQUFRQSxFQUFFQSxHQUFHQSxhQUFhQSxDQUFDQSxRQUFRQSxDQUFDQSxDQUFDQTtnQkFDakRBLElBQUlBLENBQUNBLFVBQVVBLEdBQUdBLE1BQU1BLENBQUNBLE1BQU1BLENBQUNBLFFBQVFBLENBQUNBLENBQUNBLENBQUNBO2dCQUMzQ0EsUUFBUUEsQ0FBQ0EsRUFBRUEsQ0FBQ0EsS0FBS0EsRUFBRUEsQ0FBQ0EsSUFBSUEsSUFBSUEsQ0FBQ0EsWUFBWUEsQ0FBQ0EsQ0FBQ0EsQ0FBQ0EsQ0FBQ0EsQ0FBQ0E7Z0JBQzlDQSxNQUFNQSxDQUFDQSxHQUFHQSxDQUFDQSxVQUFVQSxFQUFFQSxNQUFNQSxJQUFJQSxDQUFDQSxTQUFTQSxFQUFFQSxDQUFDQSxDQUFDQTtZQUNqREEsQ0FBQ0E7WUFFREQsWUFBWUEsQ0FBQ0EsTUFBTUEsR0FBUUEsRUFBRUE7Z0JBQzNCRSxJQUFJQSxNQUFNQSxHQUFHQSxNQUFNQSxDQUFDQSxNQUFNQSxDQUFDQTtnQkFFM0JBLEVBQUVBLENBQUFBLENBQUNBLENBQUNBLE1BQU1BLElBQUlBLE1BQU1BLENBQUNBLGFBQWFBLElBQUlBLE1BQU1BLENBQUNBLGFBQWFBLENBQUNBLE1BQU1BLENBQUNBLENBQUFBLENBQUNBO29CQUNqRUEsTUFBTUEsR0FBR0EsTUFBTUEsQ0FBQ0EsYUFBYUEsQ0FBQ0EsTUFBTUEsQ0FBQ0E7Z0JBQ3ZDQSxDQUFDQTtnQkFDREEsSUFBSUEsQ0FBQ0EsRUFBRUEsQ0FBQUEsQ0FBQ0EsQ0FBQ0EsTUFBTUEsQ0FBQ0EsQ0FBQUEsQ0FBQ0E7b0JBQ2ZBLE1BQU1BLEdBQUdBLEVBQUVBLENBQUNBO2dCQUNkQSxDQUFDQTtnQkFFREEsSUFBSUEsQ0FBQ0EsVUFBVUEsQ0FBQ0EsSUFBSUEsQ0FBQ0EsTUFBTUEsRUFBRUEsTUFBTUEsQ0FBQ0EsTUFBTUEsQ0FBQ0EsTUFBTUEsRUFBRUEsRUFBRUEsTUFBTUEsRUFBRUEsQ0FBQ0EsQ0FBQ0EsQ0FBQ0E7Z0JBQ2hFQSxJQUFJQSxDQUFDQSxNQUFNQSxDQUFDQSxXQUFXQSxFQUFFQSxDQUFDQTtZQUM1QkEsQ0FBQ0E7WUFFREYsU0FBU0E7Z0JBQ1BHLElBQUlBLENBQUNBLFFBQVFBLENBQUNBLEdBQUdBLENBQUNBLEtBQUtBLENBQUNBLENBQUNBO1lBQzNCQSxDQUFDQTtRQUNISCxDQUFDQTtRQTlCREQ7WUFBQ0EsU0FBU0EsQ0FBQ0EsRUFBRUEsUUFBUUEsRUFBRUEsQ0FBQ0E7WUFDdkJBLE1BQU1BLENBQUNBLFFBQVFBLEVBQUVBLFVBQVVBLEVBQUVBLFFBQVFBLEVBQUVBLFFBQVFBLENBQUNBOzt5QkE2QmhEQTtRQUVEQSxVQUFVQSxDQUFDQSxJQUFJQSxDQUFDQSxZQUFZQSxDQUFDQSxDQUFDQTtJQUNoQ0EsQ0FBQ0EsQ0FBQ0EsQ0FBQ0E7SUFFSEEsTUFBTUEsQ0FBQ0EsVUFBVUEsQ0FBQ0E7QUFDcEJBLENBQUNBO0FBRUQsYUFBYSxHQUFHLFlBQXNCO0lBQ3BDSyxZQUFZQSxDQUFDQSxPQUFPQSxDQUFDQSxLQUFLQSxJQUFJQSxNQUFNQSxDQUFDQSxHQUFHQSxDQUFDQSxLQUFLQSxDQUFDQSxDQUFDQSxDQUFDQTtBQUNuREEsQ0FBQ0E7QUFFRCxlQUFlLEVBQUUsT0FBTyxFQUFFLEdBQUcsRUFBRSxDQUFDIiwiZmlsZSI6ImxpYi9ldmVudHMvZXZlbnRzLmpzIiwic291cmNlc0NvbnRlbnQiOlsiaW1wb3J0IHtEaXJlY3RpdmV9IGZyb20gJy4uL2RlY29yYXRvcnMvZGlyZWN0aXZlJztcbmltcG9ydCB7SW5qZWN0fSBmcm9tICcuLi9kZWNvcmF0b3JzL2luamVjdCc7XG5pbXBvcnQgcGFyc2VTZWxlY3RvciBmcm9tICcuLi91dGlsL3BhcnNlLXNlbGVjdG9yJztcbmltcG9ydCB7ZGFzaGVyaXplfSBmcm9tICcuLi91dGlsL2hlbHBlcnMnO1xuXG5sZXQgZXZlbnRzID0gbmV3IFNldChbXG4gICdjbGljaycsXG4gICdkYmxjbGljaycsXG4gICdtb3VzZWRvd24nLFxuICAnbW91c2V1cCcsXG4gICdtb3VzZW92ZXInLFxuICAnbW91c2VvdXQnLFxuICAnbW91c2Vtb3ZlJyxcbiAgJ21vdXNlZW50ZXInLFxuICAnbW91c2VsZWF2ZScsXG4gICdrZXlkb3duJyxcbiAgJ2tleXVwJyxcbiAgJ2tleXByZXNzJyxcbiAgJ3N1Ym1pdCcsXG4gICdmb2N1cycsXG4gICdibHVyJyxcbiAgJ2NvcHknLFxuICAnY3V0JyxcbiAgJ3Bhc3RlJyxcbiAgJ2NoYW5nZScsXG4gICdkcmFnc3RhcnQnLFxuICAnZHJhZycsXG4gICdkcmFnZW50ZXInLFxuICAnZHJhZ2xlYXZlJyxcbiAgJ2RyYWdvdmVyJyxcbiAgJ2Ryb3AnLFxuICAnZHJhZ2VuZCcsXG4gICdlcnJvcicsXG4gICdpbnB1dCcsXG4gICdsb2FkJyxcbiAgJ3doZWVsJyxcbiAgJ3Njcm9sbCdcbl0pO1xuXG5mdW5jdGlvbiByZXNvbHZlKCk6IGFueVtde1xuICBsZXQgZGlyZWN0aXZlczogYW55W10gPSBbXTtcblxuICBldmVudHMuZm9yRWFjaChldmVudCA9PiB7XG4gICAgY29uc3Qgc2VsZWN0b3IgPSBgWygke2Rhc2hlcml6ZShldmVudCl9KV1gO1xuICAgIEBEaXJlY3RpdmUoeyBzZWxlY3RvciB9KVxuICAgIEBJbmplY3QoJyRwYXJzZScsICckZWxlbWVudCcsICckYXR0cnMnLCAnJHNjb3BlJylcbiAgICBjbGFzcyBFdmVudEhhbmRsZXJ7XG4gICAgICBwdWJsaWMgZXhwcmVzc2lvbjogYW55O1xuXG4gICAgICBjb25zdHJ1Y3RvcigkcGFyc2U6IG5nLklQYXJzZVNlcnZpY2UsIHB1YmxpYyAkZWxlbWVudDogSlF1ZXJ5LCAkYXR0cnM6IG5nLklBdHRyaWJ1dGVzLCBwdWJsaWMgJHNjb3BlOiBuZy5JU2NvcGUpe1xuXG4gICAgICAgIGxldCB7IG5hbWU6IGF0dHJOYW1lIH0gPSBwYXJzZVNlbGVjdG9yKHNlbGVjdG9yKTtcbiAgICAgICAgdGhpcy5leHByZXNzaW9uID0gJHBhcnNlKCRhdHRyc1thdHRyTmFtZV0pO1xuICAgICAgICAkZWxlbWVudC5vbihldmVudCwgZSA9PiB0aGlzLmV2ZW50SGFuZGxlcihlKSk7XG4gICAgICAgICRzY29wZS4kb24oJyRkZXN0cm95JywgKCkgPT4gdGhpcy5vbkRlc3Ryb3koKSk7XG4gICAgICB9XG5cbiAgICAgIGV2ZW50SGFuZGxlcigkZXZlbnQ6IGFueSA9IHt9KXtcbiAgICAgICAgbGV0IGRldGFpbCA9ICRldmVudC5kZXRhaWw7XG4gICAgICAgIFxuICAgICAgICBpZighZGV0YWlsICYmICRldmVudC5vcmlnaW5hbEV2ZW50ICYmICRldmVudC5vcmlnaW5hbEV2ZW50LmRldGFpbCl7XG4gICAgICAgICAgZGV0YWlsID0gJGV2ZW50Lm9yaWdpbmFsRXZlbnQuZGV0YWlsO1xuICAgICAgICB9XG4gICAgICAgIGVsc2UgaWYoIWRldGFpbCl7XG4gICAgICAgICAgZGV0YWlsID0ge307XG4gICAgICAgIH1cbiAgICAgICAgXG4gICAgICAgIHRoaXMuZXhwcmVzc2lvbih0aGlzLiRzY29wZSwgT2JqZWN0LmFzc2lnbihkZXRhaWwsIHsgJGV2ZW50IH0pKTtcbiAgICAgICAgdGhpcy4kc2NvcGUuJGFwcGx5QXN5bmMoKTtcbiAgICAgIH1cblxuICAgICAgb25EZXN0cm95KCl7XG4gICAgICAgIHRoaXMuJGVsZW1lbnQub2ZmKGV2ZW50KTtcbiAgICAgIH1cbiAgICB9XG5cbiAgICBkaXJlY3RpdmVzLnB1c2goRXZlbnRIYW5kbGVyKTtcbiAgfSk7XG5cbiAgcmV0dXJuIGRpcmVjdGl2ZXM7XG59XG5cbmZ1bmN0aW9uIGFkZCguLi5jdXN0b21FdmVudHM6IHN0cmluZ1tdKXtcbiAgY3VzdG9tRXZlbnRzLmZvckVhY2goZXZlbnQgPT4gZXZlbnRzLmFkZChldmVudCkpO1xufVxuXG5leHBvcnQgZGVmYXVsdCB7IHJlc29sdmUsIGFkZCB9O1xuIl0sInNvdXJjZVJvb3QiOiIvc291cmNlLyJ9
