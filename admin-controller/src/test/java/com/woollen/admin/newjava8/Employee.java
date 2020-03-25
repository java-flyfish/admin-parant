package com.woollen.admin.newjava8;

import lombok.Data;

/**
 * @Info: 员工类
 * @ClassName: Employee
 * @Author: weiyang
 * @Data: 2020/1/31 9:16 AM
 * @Version: V1.0
 **/
@Data
public class Employee {
    private int id;
    private String name;
    private int age;
    private double salary;
    private Status status;

    public Employee(){}

    public Employee(int id, String name, int age, double salary, Status status) {
        this.id = id;
        this.name = name;
        this.age = age;
        this.salary = salary;
        this.status = status;
    }
}



