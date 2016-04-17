package net.javabeat.spring.data.excel;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Date;
import java.util.Map;

public class MyClassUtil {

	public static Object setClassFieldByMap(Object model, Map<String,Object> destMap) {
		

		Field[] field = model.getClass().getDeclaredFields(); // 获取实体类的所有属性，返回Field数组

		try {
			for (int j = 0; j < field.length; j++) {
				
				// 获取属性的名字
				String name = field[j].getName();
				
				for (String key : destMap.keySet()) {  
					  
				    System.out.println("Key = " + key);  
				    // 匹配到正确的field才继续
					if (!name.equalsIgnoreCase(key)) {
						continue;
					}

					Object cellValue = destMap.get(key);
					// 将属性的首字符大写，方便构造get，set方法
					name = name.substring(0, 1).toUpperCase() + name.substring(1);

					// 获取属性的类型
					String type = field[j].getGenericType().toString();
					
					// 如果type是类类型，则前面包含"class "，后面跟类名
					if (type.equals("class java.lang.String")) {
						Method m = model.getClass().getMethod("set" + name,
								String.class);
						m.invoke(model, (String)cellValue);// todo: 设置之前需要设计下destValue
					} else if (type.equals("class java.lang.Integer")) {
						Method m = model.getClass().getMethod("set" + name,
								Integer.class);
						m.invoke(model, Integer.valueOf((String)cellValue));
					} else if (type.equals("class java.lang.Boolean")) {
						Method m = model.getClass().getMethod("set" + name,
								Boolean.class);
						m.invoke(model, (Boolean)cellValue);// todo: string类型转换

					} else if (type.equals("class java.util.Date")) {
						Method m = model.getClass().getMethod("set" + name,
								Date.class);
						m.invoke(model, (Date)cellValue);// todo: string类型转换
					} else if (type.equals("long")) {
						Method m = model.getClass().getMethod("set" + name,
								long.class);
						m.invoke(model, Long.valueOf((String)cellValue).longValue());
					}
					// 在此增加对其它类型的判断...
				}  

			}
		} catch (NoSuchMethodException e) {
			e.printStackTrace();
		} catch (SecurityException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		return model;
	}
	

	public static Object getInstanceByClassName(String className) {

		Class modelClass = null;
		try {
			modelClass = Class.forName(className);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			System.out.println("表名有误，无法实例化类:" + className);
			e.printStackTrace();
		}

		// 获取类实例
		Object model = null;
		try {
			model = modelClass.newInstance();
		} catch (InstantiationException e) {
			System.out.println("类名有误，无法实例化类名:" + className);
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			System.out.println("类名有误，无法实例化类名:" + className);
			e.printStackTrace();
		}

		return model;
	}

	
	public static Class getClassByName(String className) {
		Class modelClass = null;
		try {
			modelClass = Class.forName(className);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		return modelClass;

	}

}