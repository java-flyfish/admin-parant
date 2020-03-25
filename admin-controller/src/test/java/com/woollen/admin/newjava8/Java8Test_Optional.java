package com.woollen.admin.newjava8;

/**
 * @Info:
 * @ClassName: Java8Test_Optional
 * @Author: weiyang
 * @Data: 2020/2/2 3:48 PM
 * @Version: V1.0
 **/
public class Java8Test_Optional {
    /*
     * Optional 容器类常用方法
     * Optional.of(T t) : 创建一个Optional实例
     * Optional.empty() : 创建一个空的Optional实例
     * Optional.ofNullAble(T t) : 若t不为null，创建Optional实例，否则创建空实例
     * isPresent() : 判断是否包含值
     * orElse(T t) : 如果调用对象包含值，返回该值，否则返回t
     * orElseGet(Supplier s) : 如果调用对象包含值，返回该值，否则返回s获取的值
     * map(Function f) : 如果有值对其处理，返回处理后的Optional，否则返回Optional.empty()
     * flatMap(Function mapper)与map类似，要求返回值必须是Optional
     **/
}
