package com.woollen.admin.newjava8;

import org.junit.Test;

import java.util.Comparator;
import java.util.function.*;

/**
 * @Info: java8新特性
 * @ClassName: Java8Test
 * @Author: weiyang
 * @Data: 2020/1/30 11:18 AM
 * @Version: V1.0
 **/
public class Java8Test_Lambad {

    //函数式Lambad表达式语法
    @Test
    public void testLambad01(){
        //语法格式一：无参，无返回值
        //()-> System.out.println("Hello World!");
        Runnable r = ()->System.out.println("Hello World!");
        r.run();
        //语法格式二：有参数，无返回值，
        Consumer<String> con = (x) -> {System.out.println(x);System.out.println(x+1);};
        con.accept("Hello Lambad!");
    }

    /*
     * title java8内置四大函数式接口
     * --Consumer<T>：消费型接口
     *     void accept(T t);
     * --Supplier<T>：供给型接口
     *     T get();
     * --Function<T, R>：函数型接口
     *     R apply(T t);
     * --Predicate<T>：判断(断言)型接口
     *     boolean test(T t);
     * @Author weiyang
     * @Date 8:02 PM 2020/1/30
     * @Param
     * @return void
     **/
    @Test
    public void testLambad02(){

    }

    /*
     * title 方法引用
     * --对象::实例方法名
     * --类::静态方法名
     * --类::实例方法名
     * @Author weiyang
     * @Date 9:08 AM 2020/1/31
     * @Param
     * @return void
     **/
    @Test
    public void testLambad03(){
        //--对象::实例方法名
        //等效于
        //Consumer<String> con1 = (x)-> System.out.println(x);
        //意思是创建一个Consumer实例，重写其中的accept(String x)方法
        Consumer<String> con = System.out::println;

        //调用实例方法，其实就是打印
        con.accept("abc");

        //--对象::实例方法名
        Employee employee = new Employee();
        employee.setName("张三");
        Supplier<String> sup = employee::getName;
        con.accept(sup.get());

        //--类::静态方法名
        Comparator<Integer> com = Integer::compare;
        int compare = com.compare(1, 2);
        System.out.println(compare);

        //--类::实例方法名
        BiPredicate<String,String> bi = (x,y)->x.equals(y);
        //等效于
        BiPredicate<String,String> bi1 = String::equals;

        System.out.println(bi1.test("a","a"));

        //构造器引用 类名::new；注意：构造器引用同样要遵循lambad表达式的函数式传递要求，及引用的方法返回值必须和函数式接口中方法的返回值和参数列表保持一致

    }
}
