package com.woollen.admin;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.woollen.admin.dao.mapper")
public class AdminControllerApplication {

	public static void main(String[] args) {
		SpringApplication.run(AdminControllerApplication.class, args);
	}

}
