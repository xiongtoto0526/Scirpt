//package net.javabeat.spring.data.excel;
//
//import java.io.File;
//import java.io.FileInputStream;
//import java.io.FileNotFoundException;
//import java.io.IOException;
//import java.io.Serializable;
//import java.text.DecimalFormat;
//import java.text.SimpleDateFormat;
//import java.util.LinkedList;
//import java.util.List;
//
//import org.apache.poi.hssf.usermodel.HSSFCell;
//import org.apache.poi.hssf.usermodel.HSSFDateUtil;
//import org.apache.poi.hssf.usermodel.HSSFRow;
//import org.apache.poi.hssf.usermodel.HSSFSheet;
//import org.apache.poi.hssf.usermodel.HSSFWorkbook;
//import org.apache.poi.xssf.usermodel.XSSFCell;
//import org.apache.poi.xssf.usermodel.XSSFRow;
//import org.apache.poi.xssf.usermodel.XSSFSheet;
//import org.apache.poi.xssf.usermodel.XSSFWorkbook;
//import org.springframework.data.jpa.repository.JpaRepository;
//
//public class ExcelTest {
//	/**
//	 * 对外提供读取excel 的方法
//	 * */
//	public static void readExcel(File file) throws IOException {
//		String fileName = file.getName();
//		String extension = fileName.lastIndexOf(".") == -1 ? "" : fileName
//				.substring(fileName.lastIndexOf(".") + 1);
//		if ("xls".equals(extension)) {
//			 read2003Excel(file);
//		} else if ("xlsx".equals(extension)) {
//			 read2007Excel(file);
//		} else {
//			throw new IOException("不支持的文件类型");
//		}
//	}
//
//	/**
//	 * 读取 office 2003 excel
//	 * @param <T>
//	 * 
//	 * @throws IOException
//	 * @throws FileNotFoundException
//	 */
//	private static <T> void read2003Excel(File file)
//			throws IOException {
//		List<T> list = new LinkedList<T>();
//		HSSFWorkbook hwb = new HSSFWorkbook(new FileInputStream(file));
//		HSSFSheet sheet = hwb.getSheetAt(0);
//
//		Object value = null;
//		HSSFRow row = null;
//		HSSFCell cell = null;
//		int counter = 0;
//
//		List<DBRelationInfo> relations = ExcelHelper
//				.getRelationInfoByFileNameAndSheetId(file.getName(), 1);
//		
//		
//		for (int i = sheet.getFirstRowNum(); counter < sheet
//				.getPhysicalNumberOfRows(); i++) {
//			row = sheet.getRow(i);
//			if (row == null) {
//				continue;
//			} else {
//				counter++;
//			}
//
//			// 新建一个实体
//			T model = ExcelHelper.getModelFromRelation(relations.get(0));
//
//			// 读取新的一行
//			List<Object> linked = new LinkedList<Object>();
//			for (int j = row.getFirstCellNum(); j <= row.getLastCellNum(); j++) {
//				cell = row.getCell(j);
//				if (cell == null) {
//					continue;
//				}
//				DecimalFormat df = new DecimalFormat("0");// 格式化 number String
//															// 字符
//				SimpleDateFormat sdf = new SimpleDateFormat(
//						"yyyy-MM-dd HH:mm:ss");// 格式化日期字符串
//				DecimalFormat nf = new DecimalFormat("0.00");// 格式化数字
//				switch (cell.getCellType()) {
//				case XSSFCell.CELL_TYPE_STRING:
//					System.out.println(i + "行" + j + " 列 is String type");
//					value = cell.getStringCellValue();
//					break;
//				case XSSFCell.CELL_TYPE_NUMERIC:
//					System.out.println(i + "行" + j
//							+ " 列 is Number type ; DateFormt:"
//							+ cell.getCellStyle().getDataFormatString());
//					if ("@".equals(cell.getCellStyle().getDataFormatString())) {
//						value = df.format(cell.getNumericCellValue());
//					} else if ("General".equals(cell.getCellStyle()
//							.getDataFormatString())) {
//						value = nf.format(cell.getNumericCellValue());
//					} else {
//						value = sdf.format(HSSFDateUtil.getJavaDate(cell
//								.getNumericCellValue()));
//					}
//					break;
//				case XSSFCell.CELL_TYPE_BOOLEAN:
//					System.out.println(i + "行" + j + " 列 is Boolean type");
//					value = cell.getBooleanCellValue();
//					break;
//				case XSSFCell.CELL_TYPE_BLANK:
//					System.out.println(i + "行" + j + " 列 is Blank type");
//					value = "";
//					break;
//				default:
//					System.out.println(i + "行" + j + " 列 is default type");
//					value = cell.toString();
//				}
//				if (value == null || "".equals(value)) {
//					continue;
//				}
//
//				// 将每行的值保存到list
//				linked.add(value);
//
//			}
//			// 一行读取完毕, 将该行的所有value注入到当前实体
//			model = ExcelHelper.setFieldValue(model,relations.get(0), linked);
//			list.add(model);
//		}
//		
//		// 将该sheet的内容插入到数据库
//		// 1. 获取单例
//		Class modelClass = MyClassUtil.getClassByName(ExcelHelper.getClassNameByRelation(relations.get(0)));
//		JpaRepository<T, Serializable> repo =  MyBeanUtil.getBean(modelClass);
//		// 2. 保存
//		repo.save(list);
//	}
//
//	/**
//	 * 读取Office 2007 excel
//	 * */
//	private static void read2007Excel(File file)
//			throws IOException {
//		List<List<Object>> list = new LinkedList<List<Object>>();
//		// 构造 XSSFWorkbook 对象，strPath 传入文件路径
//		XSSFWorkbook xwb = new XSSFWorkbook(new FileInputStream(file));
//		// 读取第一章表格内容
//		XSSFSheet sheet = xwb.getSheetAt(0);
//		Object value = null;
//		XSSFRow row = null;
//		XSSFCell cell = null;
//		int counter = 0;
//		for (int i = sheet.getFirstRowNum(); counter < sheet
//				.getPhysicalNumberOfRows(); i++) {
//			row = sheet.getRow(i);
//			if (row == null) {
//				continue;
//			} else {
//				counter++;
//			}
//			List<Object> linked = new LinkedList<Object>();
//			for (int j = row.getFirstCellNum(); j <= row.getLastCellNum(); j++) {
//				cell = row.getCell(j);
//				if (cell == null) {
//					continue;
//				}
//				DecimalFormat df = new DecimalFormat("0");// 格式化 number String
//															// 字符
//				SimpleDateFormat sdf = new SimpleDateFormat(
//						"yyyy-MM-dd HH:mm:ss");// 格式化日期字符串
//				DecimalFormat nf = new DecimalFormat("0.00");// 格式化数字
//				switch (cell.getCellType()) {
//				case XSSFCell.CELL_TYPE_STRING:
//					System.out.println(i + "行" + j + " 列 is String type");
//					value = cell.getStringCellValue();
//					break;
//				case XSSFCell.CELL_TYPE_NUMERIC:
//					System.out.println(i + "行" + j
//							+ " 列 is Number type ; DateFormt:"
//							+ cell.getCellStyle().getDataFormatString());
//					if ("@".equals(cell.getCellStyle().getDataFormatString())) {
//						value = df.format(cell.getNumericCellValue());
//					} else if ("General".equals(cell.getCellStyle()
//							.getDataFormatString())) {
//						value = nf.format(cell.getNumericCellValue());
//					} else {
//						value = sdf.format(HSSFDateUtil.getJavaDate(cell
//								.getNumericCellValue()));
//					}
//					break;
//				case XSSFCell.CELL_TYPE_BOOLEAN:
//					System.out.println(i + "行" + j + " 列 is Boolean type");
//					value = cell.getBooleanCellValue();
//					break;
//				case XSSFCell.CELL_TYPE_BLANK:
//					System.out.println(i + "行" + j + " 列 is Blank type");
//					value = "";
//					break;
//				default:
//					System.out.println(i + "行" + j + " 列 is default type");
//					value = cell.toString();
//				}
//				if (value == null || "".equals(value)) {
//					continue;
//				}
//				linked.add(value);
//			}
//			list.add(linked);
//		}
//	}
//
//	
//	public static void deleteOldData(String excelName){
//		// 删除当前时间1天内的所有已导入数据，注：每个原始表中都需要增加标示字段：excel名称+当前时间，且
//		// excelName需要建立索引。
//	}
//	
//	public static void main(String[] args) {
//		
//		/* 
//		 * 讨论：是否需要插入一条记录，标示当前sheet已执行.待后续重复导入时，避免再次插入。
//		 * 建议：不考虑以上方案，简单处理，先删除所有重复记录再插入。
//		 */
//	   deleteOldData("/Users/xionghaitao/Documents/manage-billing/student_info.xls");
//		
//		
//		try {
//			readExcel(new File(
//					"/Users/xionghaitao/Documents/manage-billing/student_info.xls"));
//			// readExcel(new File("D:\\test.xls"));
//		} catch (IOException e) {
//			e.printStackTrace();
//		}
//	}
//}
