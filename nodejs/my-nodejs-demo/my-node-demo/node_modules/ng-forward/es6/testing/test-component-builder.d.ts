import { INgForwardJQuery } from "../util/jqlite-extensions";
import IInjectorService = angular.auto.IInjectorService;
export interface ngClass {
    new (...any: any[]): any;
    name?: string;
}
export declare class TestComponentBuilder {
    private create(rootComponent);
    createAsync(rootComponent: ngClass): Promise<ComponentFixture>;
    overrideTemplate(component: ngClass, template: string): TestComponentBuilder;
    overrideProviders(component: ngClass, providers: (ngClass | string)[]): TestComponentBuilder;
    overrideView(component: ngClass, config: {
        template?: string;
        templateUrl?: string;
        pipes?: any[];
        directives?: ngClass[];
    }): TestComponentBuilder;
    overrideDirective(): void;
    overrideViewBindings(): void;
}
export declare class ComponentFixture {
    debugElement: INgForwardJQuery;
    componentInstance: any;
    nativeElement: any;
    private rootTestScope;
    constructor({debugElement, rootTestScope, $injector}: {
        debugElement: INgForwardJQuery;
        rootTestScope: ng.IScope;
        $injector: IInjectorService;
    });
    detectChanges(): void;
}
export declare function compileComponent(ComponentClass: ngClass): ComponentFixture;
export declare function compileHtmlAndScope({html, initialScope, selector}: {
    html: any;
    initialScope: any;
    selector: any;
}): {
    parentScope: any;
    element: any;
    controller: any;
    isolateScope: any;
};
