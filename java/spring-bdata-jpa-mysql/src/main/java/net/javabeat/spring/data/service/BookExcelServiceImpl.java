package net.javabeat.spring.data.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import net.javabeat.spring.data.excel.CellInfo;
import net.javabeat.spring.data.excel.MyBeanUtil;
import net.javabeat.spring.data.excel.MyClassUtil;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.springframework.data.jpa.repository.JpaRepository;

public class BookExcelServiceImpl implements MyExcelService {

	@Override
	public void readExcel(File file) {
		String fileName = file.getName();
		String extension = fileName.lastIndexOf(".") == -1 ? "" : fileName
				.substring(fileName.lastIndexOf(".") + 1);
		try {
			if ("xls".equals(extension)) {
				read2003Excel(file);
			} else if ("xlsx".equals(extension)) {
				// read2007Excel(file);
			} else {
				throw new IOException("不支持的文件类型");
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 读取 office 2003 excel
	 */
	private void read2003Excel(File file) throws IOException {
		List<Object> list = new ArrayList<Object>();
		HSSFWorkbook hwb = new HSSFWorkbook(new FileInputStream(file));
		HSSFSheet sheet = hwb.getSheetAt(0);

		HSSFRow row = null;
		HSSFCell cell = null;

		Map<Integer, Object> xValues = new HashMap<Integer, Object>();// 横轴对应的id集合
		Map<Integer, Object> yValues = new HashMap<Integer, Object>();// 纵轴对应的id集合

		// 0.获取表名
		String tableName = ExcelHelper.getTableName("book_sheet");

		// 2. 获取实体类名
		String modelClassName = ExcelHelper.getModleClassName(tableName);

		// 1. 获取db对象
		JpaRepository rep = ExcelHelper.getRepositoryObject(modelClassName);

		// 1.1 获取service
		CellService cellService = ExcelHelper
				.getCellServiceObject(modelClassName);

		// 3. 获取横轴和纵轴对应的table列名
		String xHeaderKey = cellService.getXkey();
		String yHeaderKey = cellService.getXkey();

		// 4. 读取第一行的所有列名,行名Id。
		xValues = cellService.getXvalues(sheet);
		yValues = cellService.getYvalues(sheet);

		// 6. 获取extMap的属性。如模板Id，年，月
		Map<String, Object> extMap = cellService.buildExtMap(null, null,
				"book_sheet");

		// 7. todo:将sheet进行分三块。比例，金额，人数。重复提取才能入库

		// 逐行读取。
		int counter = 0;
		for (int i = sheet.getFirstRowNum(); counter < sheet
				.getPhysicalNumberOfRows(); i++) {

			Object model = MyClassUtil.getInstanceByClassName(modelClassName);
			row = sheet.getRow(i);

			// 到达行尾则返回
			if (row == null) {
				continue;
			} else {
				counter++;
			}

			for (int j = row.getFirstCellNum(); j <= row.getLastCellNum(); j++) {
				cell = row.getCell(j);
				// 到达列尾则返回
				if (cell == null) {
					continue;
				}

				// 定义日期，数字的输出类型
				DecimalFormat df = new DecimalFormat("0");// 整型格式
				DecimalFormat nf = new DecimalFormat("0");// 两位小数格式
				SimpleDateFormat sdf = new SimpleDateFormat(
						"yyyy-MM-dd HH:mm:ss");// 日期格式
				
				CellInfo cellInfo = new CellInfo();
				cellInfo.setxHeaderKey(xHeaderKey);
				cellInfo.setxHeaderKey(yHeaderKey);
				cellInfo.setColumnId(cell.getColumnIndex());
				cellInfo.setRowId(cell.getRowIndex());
				
				switch (cell.getCellType()) {
				case XSSFCell.CELL_TYPE_STRING:
					System.out.println(i + "行" + j + " 列 is String type");
					cellInfo.setValue(cell.getStringCellValue());
					break;
				case XSSFCell.CELL_TYPE_NUMERIC:
					System.out.println(i + "行" + j
							+ " 列 is Number type ; DateFormt:"
							+ cell.getCellStyle().getDataFormatString());
					if ("@".equals(cell.getCellStyle().getDataFormatString())) {
						cellInfo.setValue(df.format(cell.getNumericCellValue()));
					} else if ("General".equals(cell.getCellStyle()
							.getDataFormatString())) {
						cellInfo.setValue(nf.format(cell.getNumericCellValue()));
					} else {
						cellInfo.setValue(sdf.format(HSSFDateUtil.getJavaDate(cell
								.getNumericCellValue())));
					}
					break;
				case XSSFCell.CELL_TYPE_BOOLEAN:
					System.out.println(i + "行" + j + " 列 is Boolean type");
					cellInfo.setValue(cell.getBooleanCellValue());
					break;
				case XSSFCell.CELL_TYPE_BLANK:
					System.out.println(i + "行" + j + " 列 is Blank type");
					cellInfo.setValue("");
					;
					break;
				default:
					System.out.println(i + "行" + j + " 列 is default type");
					cellInfo.setValue(cell.toString());
				}

				// TODO：空值需要处理
				if (cellInfo == null || "".equals(cellInfo)) {
					continue;
				}

				// 构建一个model
				String cellKey = cellService.getCellkey(cell,null);
				cellInfo.setCellKey(cellKey);
				Object newModelInstance = buildModelFromCell(model,xValues, yValues,
						extMap,cellInfo);

				// 将每行的值保存到list
				list.add(newModelInstance);
			}
		}


		// 2. 保存
		System.out.print("1...");
		// 选择入库策略：没个sheet读取所有的数据后，一次性插入。内存中驻留的数据最大是，number_x * number_y 。
		int importMode = 1; // 1: 全sheet一次性入库。目前可以直接入 ,// 2: 一次入库最大条1000. 
		rep.save(list);
		System.out.print("2...");
	}

	/*
	 * 根据输入，输出一个可直接入库的model模型对象
	 */
	public Object buildModelFromCell(Object model,Map<Integer, Object> xValues,
			Map<Integer, Object> yValues,Map<String, Object> extMap, CellInfo cellInfo) {
		
		Map<String,Object> destMap = new HashMap<String,Object>();
		destMap.put(cellInfo.getxHeaderKey(), xValues.get(Integer.valueOf(cellInfo.getColumnId())));
		destMap.put(cellInfo.getyHeaderKey(), yValues.get(Integer.valueOf(cellInfo.getRowId())));
		destMap.put(cellInfo.getCellKey(), cellInfo.getValue());
		destMap.putAll(extMap);
		
        MyClassUtil.setClassFieldByMap(model, destMap);
		return model;
	}
}
