package net.javabeat.spring.data.service;

import java.util.HashMap;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;

public class BookCellServiceImpl implements CellService {

	@Override
	public String getXkey() {
		// TODO :每个表不一样，有的是month，有的是shareItemId
		return "columnId";
	}

	@Override
	public Object getXValue(String xKey) {
		// TODO :每个表不一样，有的是直接读列名，有的是根据列名从数据库查Id
		int x = (int) (Math.random() * 20);
		return xKey + x;
	}

	@Override
	public String getYkey() {
		// TODO :每个表不一样，有的是，有的是shareItemId,有的是projectId
		return "rowId";
	}

	@Override
	public Object getYValue(String yKey) {
		// TODO :每个表不一样，有的是直接读行名，有的是根据行名从数据库查Id,有的是根据第一和第二列联合查询id
		int y = (int) (Math.random() * 20);
		return yKey + y;
	}

	@Override
	public String getCellkey(Object cellValue, Object... ext) {
		// TODO :每个表不一样，有的表连续两行的属性值不一样.如百分比和整形值。根据传入的value类型，或传入的额外参数来判断CellKey
		if (cellValue instanceof Integer) {
			return "shareAmount";
		} else if (cellValue instanceof String) {
			return "sharePro";
		}
		return "defaultCellKey";
	}

	@Override
	public Map<String, Object> buildExtMap(String sheetName, Object... ext) {
		// TODO :根据 sheet 的属性获取其他扩展属性.如模板id，月份，年，项目id
		Map<String, Object> extMap = new HashMap<String, Object>();
		extMap.put("templeId", 1);
		extMap.put("projectName", "testProject");
		return extMap;
	}

	@Override
	public Map<Integer, Object> getXvalues(HSSFSheet sheet) {
		// 列名Id一般是直接查询即可。后续可以抽象再一层以复用代码。
		Map<Integer, Object> xValues = new HashMap<Integer, Object>();
		int counter = 0;
		HSSFRow row;
		HSSFCell cell;
		for (int i = sheet.getFirstRowNum(); counter < sheet
				.getPhysicalNumberOfRows(); i++) {
			row = sheet.getRow(i);
			// 到达行尾则返回
			if (row == null) {
				break;
			} else {
				counter++;
			}
			// 读取第一行的表头
			if (counter == 1) {
				for (int j = row.getFirstCellNum(); j <= row.getLastCellNum(); j++) {
					cell = row.getCell(j);
					if (cell == null) {// null代表到达行列尾
						break;
					}
					Object xValue = getXValue(cell.getStringCellValue());
					if (xValue != null) {
						xValues.put(cell.getColumnIndex(), xValue);
					} else {
						System.out.println("error!!! 找不到对应的横轴值。");
					}

				}
				break;
			}
		}
		return xValues;
	}

	@Override
	public Map<Integer, Object> getYvalues(HSSFSheet sheet) {
		HSSFRow row;
		HSSFCell cell;
		int counter = 0;
		int maxYscanNumber = 1;		// 行名Id根据有时取前两列，有时取第一列。有变化
		Map<Integer, Object> yValues = new HashMap<Integer, Object>();

		for (int i = sheet.getFirstRowNum(); counter < sheet
				.getPhysicalNumberOfRows(); i++) {
			row = sheet.getRow(i);
			// 到达行尾则返回
			if (row == null) {
				break;
			} else {
				counter++;
			}
			// 读取第一行的表头
			int rowIndex = 0;
			Object yValue = null;
			for (int j = row.getFirstCellNum(); j < maxYscanNumber; j++) {
				cell = row.getCell(j);
				// null代表到达列尾
				if (cell == null) {
					break;
				}
				yValue = getYValue(cell.getStringCellValue());
				// 若找到了value值则停止列检索，否则继续检索
				if (yValue != null) {
					rowIndex = cell.getRowIndex();
					break;
				}
			}

			// 检查结果
			if (yValue != null) {
				yValues.put(rowIndex, yValue);
			} else {
				System.out.println("error!!! 找不到对应的纵轴值。");
			}
		}
		return yValues;
	}
}
