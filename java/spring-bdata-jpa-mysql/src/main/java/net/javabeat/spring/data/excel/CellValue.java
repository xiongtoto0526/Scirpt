package net.javabeat.spring.data.excel;

// 每个cell对应的实体
public class CellValue {

	Long xId;
	String xName;
	Long yId;
	String yName;
    Object value;
	
	public Object getValue() {
		return value;
	}
	public void setValue(Object value) {
		this.value = value;
	}
	public Long getxId() {
		return xId;
	}
	public void setxId(Long xId) {
		this.xId = xId;
	}
	public String getxName() {
		return xName;
	}
	public void setxName(String xName) {
		this.xName = xName;
	}
	public Long getyId() {
		return yId;
	}
	public void setyId(Long yId) {
		this.yId = yId;
	}
	public String getyName() {
		return yName;
	}
	public void setyName(String yName) {
		this.yName = yName;
	}
	
	
}
