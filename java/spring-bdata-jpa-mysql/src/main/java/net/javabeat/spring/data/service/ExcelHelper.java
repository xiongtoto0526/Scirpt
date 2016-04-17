package net.javabeat.spring.data.service;

import net.javabeat.spring.data.excel.MyBeanUtil;
import net.javabeat.spring.data.excel.MyClassUtil;

import org.springframework.data.jpa.repository.JpaRepository;

public class ExcelHelper {


	public static final String domainPackageName = "net.javabeat.spring.data.domain.";
	public static final String servicePackageName = "net.javabeat.spring.data.service.";

	
	// 可能为空，当返回为空时，说明该cell的key值不唯一，需要在service层确定。
	public static String getCellkey(String tableName){
		return null;
	}
	

	public static String getTableName(String sheetName) {
		// todo: 从DB中查找到tableName
		 sheetName = "Book_sheet";

		if (sheetName.equals("Book_sheet")) {
			return "book_table";
		}
		return null;
	}

	public static String getModleClassName(String tableName) {
		return domainPackageName
		+ getModleName(tableName);
	}
	
	public static String getModleName(String tableName) {
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

	// 需要忽略updateTime和createTime
	public static String[] getTableFields(String tableName) {
		return null;
	}

	// 通过反射，新建一个实例
	public Object getModelInstance(String tableName) {
		return null;
	}

}
