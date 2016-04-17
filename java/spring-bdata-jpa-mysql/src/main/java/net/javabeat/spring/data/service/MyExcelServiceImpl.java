package net.javabeat.spring.data.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import net.javabeat.spring.data.domain.Book;
import net.javabeat.spring.data.excel.CellInfo;
import net.javabeat.spring.data.excel.DBRelationInfo;
import net.javabeat.spring.data.excel.MyBeanUtil;
import net.javabeat.spring.data.service.MyExcelService;
import net.javabeat.spring.data.excel.MyClassUtil;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class MyExcelServiceImpl implements MyExcelService {

	public static final String domainPackageName = "net.javabeat.spring.data.domain.";
	public static final String servicePackageName = "net.javabeat.spring.data.service.";
	

	@Autowired
	private BookRepository bookRepository;
	
	@Override
	public void readExcel(File file) {
		String fileName = file.getName();
		String extension = fileName.lastIndexOf(".") == -1 ? "" : fileName
				.substring(fileName.lastIndexOf(".") + 1);
		if ("xls".equals(extension)) {
			try {
				read2003Excel(file);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} else if ("xlsx".equals(extension)) {
			// read2007Excel(file);
		} else {
			try {
				throw new IOException("不支持的文件类型");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

	}

	

	/**
	 * 读取 office 2003 excel
	 * 
	 * @param <T>
	 * 
	 * @throws IOException
	 * @throws FileNotFoundException
	 */
	private void read2003Excel(File file) throws IOException {
		List<Object> list = new ArrayList<Object>();
		HSSFWorkbook hwb = new HSSFWorkbook(new FileInputStream(file));
		HSSFSheet sheet = hwb.getSheetAt(0);

		// 不同的cell 需要取不同的CellValue类型，这里需要再次抽象。建议集成CellValue
		HSSFRow row = null;
		HSSFCell cell = null;
		int counter = 0;

		List<DBRelationInfo> relations = getRelationInfoByFileNameAndSheetId(file.getName(), 0);
        String modelClassName = getModelNameByRelation(relations.get(0));
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
			Object model = getModelFromRelation(relations.get(0));

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
					value.setValue( cell.getStringCellValue());
					value.setxName(xNames.get(j));
					break;
				case XSSFCell.CELL_TYPE_NUMERIC:
					System.out.println(i + "行" + j
							+ " 列 is Number type ; DateFormt:"
							+ cell.getCellStyle().getDataFormatString());
					if ("@".equals(cell.getCellStyle().getDataFormatString())) {
						value.setValue(df.format(cell.getNumericCellValue()));
						value.setxName(xNames.get(j));
					} else if ("General".equals(cell.getCellStyle()
							.getDataFormatString())) {
						value.setValue(nf.format(cell.getNumericCellValue()));
						value.setxName(xNames.get(j).replace(".00", ""));
					} else {
						value.setValue(sdf.format(HSSFDateUtil.getJavaDate(cell
								.getNumericCellValue())));
						value.setxName(xNames.get(j));
					}
					break;
				case XSSFCell.CELL_TYPE_BOOLEAN:
					System.out.println(i + "行" + j + " 列 is Boolean type");
					value.setValue(cell.getBooleanCellValue());
					value.setxName(xNames.get(j));
					break;
				case XSSFCell.CELL_TYPE_BLANK:
					System.out.println(i + "行" + j + " 列 is Blank type");
					value.setValue("");;
					value.setxName(xNames.get(j));
					break;
				default:
					System.out.println(i + "行" + j + " 列 is default type");
					value.setValue(cell.toString());
					value.setxName(xNames.get(j));
				}

				// TODO：空值需要处理
				if (value == null || "".equals(value)) {
					continue;
				}

				// 将每行的值保存到list
				linked.add(value);

			}
			// 一行读取完毕, 将该行的所有value注入到当前实体
			model = setFieldValue(model, relations.get(0), linked);
			
			Object b = model;
			list.add(b);
		}

		// 将该sheet的内容插入到数据库
		// 1. 获取单例
		Class modelClass = MyClassUtil.getClassByName(getClassNameByRelation(relations.get(0)));
		String repoClassName = getModleRepositoryClassName(relations.get(0));
		Class reClass = MyClassUtil.getClassByName(repoClassName);
		JpaRepository rep =(JpaRepository) MyBeanUtil.getBean(reClass);
		// 2. 保存
		System.out.print("1");
		rep.save(list);
		System.out.print("1");
	}


	private String getModleRepositoryClassName(DBRelationInfo info){
		String repoClassName = servicePackageName+getModelNameByRelation(info)+"Repository";
        return repoClassName;
	}
	
	// excel和原始表的映射模型： file -- sheet -- column -- table -- field
	// filed id | filed name | table id | table name | file id | file name
	// |sheet id| column id|

	public static List<DBRelationInfo> getRelationInfoByFileNameAndSheetId(
			String fileName, int sheetid) {

		List<DBRelationInfo> relations = new ArrayList<DBRelationInfo>();

		DBRelationInfo relation0 = new DBRelationInfo();
		relation0.setFieldId(0);
		relation0.setFieldName("id");
		relation0.setColumnId(0);
		relation0.setColumnName("no");

		relation0.setTableId(0); 
		relation0.setTableName("book");
		relation0.setSheetId(0); 
		relation0.setSheetName("sheet1");
		relation0.setFieldId(0); 
		relation0.setFileName("student_info.xls"); 
		relations.add(relation0);

		return relations;
	}

	// 获取每个sheet对应的表名
	public Object getModelFromRelation(DBRelationInfo relationInfo) {

		// 获取表名对应的实体名称
		String modelName = getModelNameByRelation(relationInfo);

		// 获取类
		String className = domainPackageName + modelName;
		Class modelClass = null;
		try {
			modelClass = Class.forName(className);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			System.out.println("表名有误，无法实例化类。表名:" + relationInfo.getTableName());
			e.printStackTrace();
		}

		// 获取类实例
		Object model = null;
		try {
			model = modelClass.newInstance();// ?? why cast it again ??
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

	public String getFieldNameByColumeName(String columnName) {
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

	public String getClassNameByRelation(DBRelationInfo relation) {
		String className = domainPackageName + getModelNameByRelation(relation);
		return className;
	}

	// 获取每个表对应的model. 此处约定：model层的类名和表名应保持一致。
	public String getModelNameByRelation(DBRelationInfo info) {
		// info.tableName 首字母大写
		String modelName = info.getTableName().substring(0, 1).toUpperCase()
				+ info.getTableName().substring(1);
		return modelName;
		// return "Book";
	}

	// 获取每个表对应的model的属性名。此处约定：属性名和表的列名应保持一致。
	public String getModelFieldNameByRelation(DBRelationInfo info) {
		return info.getColumnName();
	}

	public <T> T setFieldValue(T model, DBRelationInfo relationInfo,
			List<Object> value) {
		String modelName = getModelNameByRelation(relationInfo);

		// String fieldName = getModelFieldNameByRelation(relationInfo);
		for (Object temp : value) {
			CellInfo a = (CellInfo)temp;
			System.out.print(a.getxName());
			MyClassUtil.setClassFieldByValue(model, temp);
		}

		// model
		return model;
	}

	/*
	 * 特别注意：cell的这种入库方式，只适合使用id抽离之后。
	 * 根据cell的输入信息构建model
	 * cellKey: cell的key值
	 * cellValue: cell的真实值
	 * xKey: 横坐标的Key值（id，月份值）
	 * xValue: 横坐标的值（id，月份值）
	 * yKey: 纵坐标的Key值（id）
	 * yValue: 纵坐标的值（id）
	 * extValues: 其他属性的值（年，月，分摊比例，分摊人数）
	 * */
	public  CellInfo buildModelFromCell(String cellKey,Object cellValue,String xKey,Object xValue,String yKey,Object yValue,Map<String,Object>extValues) {
		return null;
	}

}