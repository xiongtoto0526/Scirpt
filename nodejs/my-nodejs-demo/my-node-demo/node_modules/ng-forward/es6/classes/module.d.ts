export declare class DecoratedModule {
    name: string;
    private _module;
    private _dependencies;
    constructor(name: string, modules?: any);
    add(...providers: any[]): DecoratedModule;
    publish(): ng.IModule;
    moduleList(modules: any[]): void;
    config(configFunc: any): DecoratedModule;
    run(runFunc: any): DecoratedModule;
    value(name: string, value: any): DecoratedModule;
    constant(name: string, value: any): DecoratedModule;
}
declare let Module: any;
export default Module;
