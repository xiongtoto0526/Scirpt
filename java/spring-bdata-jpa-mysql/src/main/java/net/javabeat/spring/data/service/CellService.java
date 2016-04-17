package net.javabeat.spring.data.service;

import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFSheet;



// 对于x-y-value类型的入库方式，可以使用下面service
public interface CellService {
	
	public String getXkey();
	public Object getXValue(String xKey);
	public String getYkey();
	public Object getYValue(String yKey);
	public String getCellkey(Object cellValue,Object... ext);
	
	public Map<Integer, Object> getXvalues(HSSFSheet sheet);
	public Map<Integer, Object> getYvalues(HSSFSheet sheet);
	
	
	public Map<String,Object> buildExtMap(Long xId,Long yId,String sheetName,Object... ext);
	
}
