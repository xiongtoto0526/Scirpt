package com.xht.myApp.service;

import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

/**
 * Created by xionghaitao on 16/4/22.
 */

@Component("maleStudent")// both @Component("maleStudent") and @Service("maleStudent") is ok.
public class MaleStudentService implements StudentService {
    @Override
    public void sayHi() {
        System.out.println("male say hi");
    }
}
