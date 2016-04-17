package net.javabeat.spring.data.excel;

// 每个cell对应的实体
public class CellInfo {

	int columnId;
	int rowId;
	String cellKey;
    Object value;
    String xHeaderKey;
    String yHeaderKey;
    
	public int getColumnId() {
		return columnId;
	}
	public void setColumnId(int columnId) {
		this.columnId = columnId;
	}
	public int getRowId() {
		return rowId;
	}
	public void setRowId(int rowId) {
		this.rowId = rowId;
	}
	public String getCellKey() {
		return cellKey;
	}
	public void setCellKey(String cellKey) {
		this.cellKey = cellKey;
	}
	public Object getValue() {
		return value;
	}
	public void setValue(Object value) {
		this.value = value;
	}
	public String getxHeaderKey() {
		return xHeaderKey;
	}
	public void setxHeaderKey(String xHeaderKey) {
		this.xHeaderKey = xHeaderKey;
	}
	public String getyHeaderKey() {
		return yHeaderKey;
	}
	public void setyHeaderKey(String yHeaderKey) {
		this.yHeaderKey = yHeaderKey;
	}
    
	
	
}
