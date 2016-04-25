package com.xht.myApp.service;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

/**
 * Created by xionghaitao on 16/4/22.
 */

@Scope("singleton") // 若改为@Scope("prototype") ,则创建多个实例.
@Component("maleStudent")// both @Component("maleStudent") and @Service("maleStudent") is ok.
public class MaleStudentService implements StudentService {
    @Override
    public void sayHi() {
        System.out.println("male say hi");
    }
}
