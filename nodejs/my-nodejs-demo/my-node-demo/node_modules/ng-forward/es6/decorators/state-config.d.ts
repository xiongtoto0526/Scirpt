import IState = ng.ui.IState;
export interface IComponentState extends IState {
    component: any;
}
export declare function StateConfig(stateConfigs: IComponentState[]): (t: any) => void;
export declare function Resolve(resolveName?: string): (target: any, resolveFnName: string, {value: resolveFn}: {
    value: any;
}) => void;
