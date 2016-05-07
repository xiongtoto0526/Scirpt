export declare const componentHooks: {
    _after: any[];
    _extendDDO: any[];
    _beforeCtrlInvoke: any[];
    _afterCtrlInvoke: any[];
    after(fn: (target: any, name: string, injects: string[], ngModule: ng.IModule) => any): void;
    extendDDO(fn: (ddo: any, target: any, name: string, injects: string[], ngModule: ng.IModule) => any): void;
    beforeCtrlInvoke(fn: (caller: any, injects: string[], controller: any, ddo: any, $injector: any, locals: any) => any): void;
    afterCtrlInvoke(fn: (caller: any, injects: string[], controller: any, ddo: any, $injector: any, locals: any) => any): void;
};
export declare function Component({selector, controllerAs, template, templateUrl, providers, inputs, outputs, pipes, directives}: {
    selector: string;
    controllerAs?: string;
    template?: string;
    templateUrl?: string;
    providers?: any[];
    inputs?: string[];
    outputs?: string[];
    pipes?: any[];
    directives?: any[];
}): (t: any) => void;
export declare function View({selector, template, templateUrl, pipes, directives}: {
    selector: string;
    template?: string;
    templateUrl?: string;
    pipes?: any[];
    directives?: any[];
}): (t: any) => void;
