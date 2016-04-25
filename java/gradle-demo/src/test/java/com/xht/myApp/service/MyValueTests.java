package com.xht.myApp.service;

import com.xht.myApp.Application;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import static org.hamcrest.Matchers.is;
import static org.junit.Assert.assertThat;

/**
 * Created by xionghaitao on 16/4/25.
 */
@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(Application.class)
@ActiveProfiles("dev")
public class MyValueTests {


    @Value("${myTestValue}")
    private String myTestValue;

    @Test
    public void testConifgValue(){
        assertThat(myTestValue, is("hello"));
    }

}
