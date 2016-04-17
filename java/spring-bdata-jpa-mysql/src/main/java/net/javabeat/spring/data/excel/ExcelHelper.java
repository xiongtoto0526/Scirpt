package net.javabeat.spring.data.excel;

import net.javabeat.spring.data.excel.MyBeanUtil;
import net.javabeat.spring.data.excel.MyClassUtil;
import net.javabeat.spring.data.service.CellService;

import org.springframework.data.jpa.repository.JpaRepository;

public class ExcelHelper {
	
	public static final String domainPackageName = "net.javabeat.spring.data.domain.";
	public static final String servicePackageName = "net.javabeat.spring.data.service.";


	public static String getModelClassName(String tableName) {
		return domainPackageName
		+ getModelName(tableName);
	}
	
	public static String getModelName(String tableName) {
		// todo: 从DB中查找到tableName
	    tableName = "Book_table";
	    
		if (tableName.equals("book_table")) {
			return "Book";
		}
		return null;
	}
	
	public static CellService getCellServiceObject(String modelClassName){
		String cellServiceClassName = servicePackageName + modelClassName
				+ "cellServiceImpl";
		Class cellServiceClass = MyClassUtil
				.getClassByName(cellServiceClassName);
		CellService cellService = (CellService) MyBeanUtil
				.getBean(cellServiceClass);
		return cellService;
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
