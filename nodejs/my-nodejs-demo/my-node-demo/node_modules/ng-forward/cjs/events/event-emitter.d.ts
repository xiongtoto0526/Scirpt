import Subject from '@reactivex/rxjs/dist/es6/Subject';
export default class EventEmitter<T> extends Subject<T> {
    _isAsync: boolean;
    constructor(isAsync?: boolean);
    subscribe(generatorOrNext?: any, error?: any, complete?: any): any;
}
export { Subject };
