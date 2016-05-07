export interface UniqueNameDecorator {
    (maybeT: any): any;
    clearNameCache(): void;
}
export default function (type: string, strategyType?: string): UniqueNameDecorator;
