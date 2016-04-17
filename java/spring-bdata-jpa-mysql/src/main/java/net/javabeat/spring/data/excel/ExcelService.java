package net.javabeat.spring.data.excel;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.Serializable;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import net.javabeat.spring.data.domain.Book;
import net.javabeat.spring.data.service.BookRepository;
import net.javabeat.spring.data.service.BookService;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;


public class ExcelService {

	public static final String packageName = "net.javabeat.spring.data.domain.";

//	@Autowired
//	private  BookRepository bookRepository;
	
	@Autowired
	private BookService bookService;
	
	public static List<Object> readExcel(File file, int sheet) {

		return null;
	}

	/**
	 * 读取 office 2003 excel
	 * 
	 * @param <T>
	 * 
	 * @throws IOException
	 * @throws FileNotFoundException
	 */
	private <Book> void read2003Excel(File file,BookService bookservie) throws IOException {
		List<Book> list = new ArrayList<Book>();
		HSSFWorkbook hwb = new HSSFWorkbook(new FileInputStream(file));
		HSSFSheet sheet = hwb.getSheetAt(0);

		// 不同的cell 需要取不同的CellValue类型，这里需要再次抽象。建议集成CellValue
		HSSFRow row = null;
		HSSFCell cell = null;
		int counter = 0;

		List<DBRelationInfo> relations = ExcelService
				.getRelationInfoByFileNameAndSheetId(file.getName(), 0);

		List<String> xNames = new ArrayList<String>();
		
		for (int i = sheet.getFirstRowNum(); counter < sheet
				.getPhysicalNumberOfRows(); i++) {
			row = sheet.getRow(i);
			if (row == null) {
				continue;
			} else {
				counter++;
			}

			// 新建一个实体
			net.javabeat.spring.data.domain.Book model = ExcelService.getModelFromRelation(relations.get(0));

			// 读取第一行的表头 
			if (counter == 1) {
				for (int j = row.getFirstCellNum(); j <= row.getLastCellNum(); j++) {
					cell = row.getCell(j);
					if (cell == null) {// null代表到达表尾
						continue;
					}
					xNames.add(cell.getStringCellValue());
				}
				continue;
			}
			
			// 读取新的一行
			List<Object> linked = new LinkedList<Object>();
			for (int j = row.getFirstCellNum(); j <= row.getLastCellNum(); j++) {
				cell = row.getCell(j);
				if (cell == null) {
					continue;
				}

				// 定义日期，数字的输出类型
				DecimalFormat df = new DecimalFormat("0");// 整型格式
				DecimalFormat nf = new DecimalFormat("0");// 两位小数格式
				SimpleDateFormat sdf = new SimpleDateFormat(
						"yyyy-MM-dd HH:mm:ss");// 日期格式
				CellInfo value = new CellInfo();

				switch (cell.getCellType()) {
				case XSSFCell.CELL_TYPE_STRING:
					System.out.println(i + "行" + j + " 列 is String type");
					value.value = cell.getStringCellValue();
					value.xName = xNames.get(j);
					break;
				case XSSFCell.CELL_TYPE_NUMERIC:
					System.out.println(i + "行" + j
							+ " 列 is Number type ; DateFormt:"
							+ cell.getCellStyle().getDataFormatString());
					if ("@".equals(cell.getCellStyle().getDataFormatString())) {
						value.value = df.format(cell.getNumericCellValue());
						value.xName = xNames.get(j);
					} else if ("General".equals(cell.getCellStyle()
							.getDataFormatString())) {
						value.value = nf.format(cell.getNumericCellValue());
						value.xName = xNames.get(j).replace(".00", "");
					} else {
						value.value = sdf.format(HSSFDateUtil.getJavaDate(cell
								.getNumericCellValue()));
						value.xName = xNames.get(j);
					}
					break;
				case XSSFCell.CELL_TYPE_BOOLEAN:
					System.out.println(i + "行" + j + " 列 is Boolean type");
					value.value = cell.getBooleanCellValue();
					value.xName = xNames.get(j);
					break;
				case XSSFCell.CELL_TYPE_BLANK:
					System.out.println(i + "行" + j + " 列 is Blank type");
					value.value = "";
					value.xName = xNames.get(j);
					break;
				default:
					System.out.println(i + "行" + j + " 列 is default type");
					value.value = cell.toString();
					value.xName = xNames.get(j);
				}

				// TODO：空值需要处理
				if (value == null || "".equals(value)) {
					continue;
				}

				// 将每行的值保存到list
				linked.add(value);

			}
			// 一行读取完毕, 将该行的所有value注入到当前实体
			model = ExcelService.setFieldValue(model, relations.get(0), linked);
			
			Book b = (Book)model;
			list.add(b);
		}

		// 将该sheet的内容插入到数据库
		// 1. 获取单例
		Class modelClass = MyClassUtil.getClassByName(ExcelService
				.getClassNameByRelation(relations.get(0)));
//		JpaRepository<Book, Serializable> repo = MyBeanUtil.getBean(Book.class);
		// 2. 保存
		System.out.print("1");
		bookService.batchInsert((List<net.javabeat.spring.data.domain.Book>) list);
//		bookervice.batchInsert((List<net.javabeat.spring.data.domain.Book>) list);
		System.out.print("1");
	}

	public  void readExcel(File file,BookService bookS) throws IOException {
		String fileName = file.getName();
		String extension = fileName.lastIndexOf(".") == -1 ? "" : fileName
				.substring(fileName.lastIndexOf(".") + 1);
		if ("xls".equals(extension)) {
			read2003Excel(file,bookS);
		} else if ("xlsx".equals(extension)) {
			// read2007Excel(file);
		} else {
			throw new IOException("不支持的文件类型");
		}
	}

	// excel和原始表的映射模型： file -- sheet -- column -- table -- field
	// filed id | filed name | table id | table name | file id | file name
	// |sheet id| column id|

	public static List<DBRelationInfo> getRelationInfoByFileNameAndSheetId(
			String fileName, int sheetid) {

		List<DBRelationInfo> relations = new ArrayList<DBRelationInfo>();

		DBRelationInfo relation0 = new DBRelationInfo();
		relation0.fieldId = 0;
		relation0.fieldName = "id";
		relation0.columnId = 0;
		relation0.columnName = "no";

		relation0.tableId = 0;
		relation0.tableName = "Book";
		relation0.sheetId = 0;
		relation0.sheetName = "sheet1";
		relation0.fileId = 0;
		relation0.fileName = "student_info.xls";

		DBRelationInfo relation1 = new DBRelationInfo();
		relation1.fieldId = 1;
		relation1.fieldName = "name";
		relation1.columnId = 1;
		relation1.columnName = "name";

		relation1.tableId = 0;
		relation1.tableName = "Book";
		relation1.sheetId = 0;
		relation1.sheetName = "sheet1";
		relation1.fileId = 0;
		relation1.fileName = "student_info.xls";

		DBRelationInfo relation2 = new DBRelationInfo();
		relation2.fieldId = 2;
		relation2.fieldName = "author";
		relation2.columnId = 2;
		relation2.columnName = "age";

		relation2.tableId = 0;
		relation2.tableName = "Book";
		relation2.sheetId = 0;
		relation2.sheetName = "sheet1";
		relation2.fileId = 0;
		relation2.fileName = "student_info.xls";

		DBRelationInfo relation3 = new DBRelationInfo();
		relation3.fieldId = 3;
		relation3.fieldName = "price";
		relation3.columnId = 3;
		relation3.columnName = "score";

		relation3.tableId = 0;
		relation3.tableName = "Book";
		relation3.sheetId = 0;
		relation3.sheetName = "sheet1";
		relation3.fileId = 0;
		relation3.fileName = "student_info.xls";

		relations.add(relation0);
		relations.add(relation1);
		relations.add(relation2);
		relations.add(relation3);

		return relations;
	}

	// 获取每个sheet对应的表名
	public static Book getModelFromRelation(DBRelationInfo relationInfo) {

		// 获取表名对应的实体名称
		String modelName = getModelNameByRelation(relationInfo);

		// 获取类
		String className = packageName + modelName;
		Class modelClass = null;
		try {
			modelClass = Class.forName(className);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			System.out.println("表名有误，无法实例化类。表名:" + relationInfo.tableName);
			e.printStackTrace();
		}

		// 获取类实例
		Book model = null;
		try {
			model = (Book) modelClass.newInstance();// ?? why cast it again ??
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			System.out.println("类名有误，无法实例化类。类名:" + className);
			e.printStackTrace();
		}

		return model;
	}

	public static String getFieldNameByColumeName(String columnName) {
		String fieldName = "";
		if (columnName.equals("no")) {
			fieldName = "id";
		} else if (columnName.equals("name")) {
			fieldName = "name";
		} else if (columnName.equals("age")) {
			fieldName = "author";
		} else if (columnName.equals("score")) {
			fieldName = "price";
		}

		return fieldName;
	}

	public static String getClassNameByRelation(DBRelationInfo relation) {
		String className = packageName + getModelNameByRelation(relation);
		return className;
	}

	// 获取每个表对应的model. 此处约定：model层的类名和表名应保持一致。
	public static String getModelNameByRelation(DBRelationInfo info) {
		// info.tableName 首字母大写
		String modelName = info.tableName.substring(0, 1).toUpperCase()
				+ info.tableName.substring(1);
		return modelName;
		// return "Book";
	}

	// 获取每个表对应的model的属性名。此处约定：属性名和表的列名应保持一致。
	public static String getModelFieldNameByRelation(DBRelationInfo info) {
		return info.columnName;
	}

	public static <T> T setFieldValue(T model, DBRelationInfo relationInfo,
			List<Object> value) {
		String modelName = getModelNameByRelation(relationInfo);

		// String fieldName = getModelFieldNameByRelation(relationInfo);
		for (Object temp : value) {
			CellInfo a = (CellInfo)temp;
			System.out.print(a.xName);
			MyClassUtil.setClassFieldByValue(model, temp);
		}

		// model
		return model;
	}

	public static Object buildModelFromCell(Object cell) {
		return null;
	}
}
