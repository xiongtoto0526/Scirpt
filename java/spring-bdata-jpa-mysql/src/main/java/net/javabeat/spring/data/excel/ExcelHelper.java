package net.javabeat.spring.data.excel;

import net.javabeat.spring.data.excel.MyBeanUtil;
import net.javabeat.spring.data.excel.MyClassUtil;
import net.javabeat.spring.data.service.SheetService;

import org.springframework.data.jpa.repository.JpaRepository;

public class ExcelHelper {
	
	public static final String domainPackageName = "net.javabeat.spring.data.domain.";
	public static final String servicePackageName = "net.javabeat.spring.data.service.";


	public static String getModelClassName(String tableName) {
		return getModelName(tableName);
	}
	
	public static String getModelName(String tableName) {
		// todo: 从DB中查找到tableName
	    tableName = "Book_table";
	    
		if (tableName.equals("Book_table")) {
			return "Book";
		}
		return null;
	}
	
	public static SheetService getSheetServiceObject(String modelClassName){
		String sheetServiceClassName = servicePackageName + modelClassName
				+ "SheetServiceImpl";
		SheetService sheetService = (SheetService)MyClassUtil.getInstanceByClassName(sheetServiceClassName);
		return sheetService;
	}
	
	public static JpaRepository getRepositoryObject(String modelClassName) {
		String repoClassName = servicePackageName + modelClassName
				+ "Repository";
		Class reClass = MyClassUtil.getClassByName(repoClassName);
		JpaRepository rep = (JpaRepository) MyBeanUtil.getBean(reClass);
		return rep;
	}

	public static Object getModelObject(String modelClassName) {
		String modelFullClassName = domainPackageName + modelClassName;
		Object model = MyClassUtil.getInstanceByClassName(modelFullClassName);
		return model;
	}

}
