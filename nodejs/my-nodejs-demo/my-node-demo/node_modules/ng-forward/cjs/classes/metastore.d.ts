export default class Metastore {
    private namespace;
    constructor(namespace: string);
    private _map(obj, key?);
    get(key: any, obj: any, prop?: string): any;
    set(key: any, value: any, obj: any, prop?: string): void;
    has(key: any, obj: any, prop?: string): boolean;
    push(key: any, value: any, obj: any, prop?: string): void;
    merge(key: any, value: any, obj: any, prop?: string): void;
    forEach(callbackFn: (value: any, index: any, map: Map<any, any>) => void, obj: any, prop?: string): void;
}
