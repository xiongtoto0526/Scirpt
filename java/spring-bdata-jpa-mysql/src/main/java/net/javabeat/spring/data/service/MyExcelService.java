package net.javabeat.spring.data.service;

import java.io.File;
import java.util.List;

import net.javabeat.spring.data.domain.Book;

public interface MyExcelService {
	public void readExcel(File file);
}
