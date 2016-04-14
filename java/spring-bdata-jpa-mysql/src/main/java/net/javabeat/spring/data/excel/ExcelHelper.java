package net.javabeat.spring.data.excel;

import java.io.File;
import java.util.List;

public class ExcelHelper {

	public static List<Object> readExcel(File file, int sheet) {

		return null;
	}

	// excel和原始表的映射模型： file -- sheet -- column -- table -- field
	// filed id | filed name | table id | table name | file id | file name
	// |sheet id| column id|

	public static RelationInfo getRelationInfoByFileNameAndSheetId(
			String fileName, int sheetid) {
		return null;
	}

	// 获取每个sheet对应的表名
	public static Object getTableBySheetId(String sheetName) {
		// 从db查询sheet对应的表名
		return new Student();
	}

	public static Object getFieldNameByColumeName(String columnName) {
		// 从db查询sheet对应的表名
		return "feild name 1";
	}

	// 获取每个表对应的model
	public static String getModelNameByTableId(int tableId) {
		return null;
	}

	// 获取每个表对应的model
	public static String getModelFieldNameByTableFieldId(int tableFieldId) {
		return null;
	}

	public static Object setFieldValue(RelationInfo relationInfo, Object value) {
		String modelName = getModelNameByTableId(relationInfo.tableId);
		String fieldName = getModelFieldNameByTableFieldId(relationInfo
				.getFieldId());

		 String className = "org.test."+modelName;
		Class modelClass = null;
		try {
			modelClass = Class.forName("org.test.GetClass");
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			System.out.println("表名有误，无法实例化类。表名:" + relationInfo.tableName);
			e.printStackTrace();
		}

		Object model = null;
		try {
			model = modelClass.newInstance();
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			System.out.println("类名有误，无法实例化类。类名:" + className);
			e.printStackTrace();
		}

		// model
		return null;
	}

	public static Object buildModelFromCell(Object cell) {
		return null;
	}

}
