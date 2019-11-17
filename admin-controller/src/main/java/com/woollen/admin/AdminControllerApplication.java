package com.woollen.admin;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.support.SpringBootServletInitializer;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.transaction.annotation.EnableTransactionManagement;

/*
@SpringBootApplication
@MapperScan("com.woollen.admin.dao.mapper")
public class AdminControllerApplication {

	public static void main(String[] args) {
		SpringApplication.run(AdminControllerApplication.class, args);
	}

}

*/

@SpringBootApplication
@EnableScheduling
@EnableTransactionManagement
@MapperScan("com.woollen.admin.dao.mapper")
public class AdminControllerApplication extends SpringBootServletInitializer {

	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
		return builder.sources(AdminControllerApplication.class);
	}

}