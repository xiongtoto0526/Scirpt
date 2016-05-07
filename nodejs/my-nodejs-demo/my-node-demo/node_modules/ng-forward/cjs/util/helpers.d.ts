export declare function ucFirst(word: string): string;
export declare function dashToCamel(dash: string): string;
export declare function dasherize(name: string, separator?: string): string;
export declare function snakeCase(name: string, separator?: string): string;
export declare function flatten(items: any[]): any[];
export interface INamed {
    name: string;
}
export declare function createConfigErrorMessage(target: INamed, ngModule: ng.IModule, message: string): string;
