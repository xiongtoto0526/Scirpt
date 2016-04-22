package com.xht.myApp.service;

import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * Created by xionghaitao on 16/4/22.
 */

@Service("femaleStudent")// both @Component and @Service is ok.  if no need , delete the "femalStudent",then spring will auto-math by type.
public class FemaleStudentService implements StudentService {
    @Override
    public void sayHi() {
        System.out.println("female say hi");
    }
}
