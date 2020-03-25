package com.woollen.admin.newjava8;

import com.alibaba.fastjson.JSONObject;
import org.junit.Test;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * @Info: StreamTest
 * @ClassName: StreamTest
 * @Author: weiyang
 * @Data: 2020/2/1 10:06 AM
 * @Version: V1.0
 **/
public class Java8Test_Stream {

    List<Employee> emps = Arrays.asList(
            new Employee(102, "李四", 59, 6666.66, Status.BUSY),
            new Employee(101, "张三", 18, 9999.99, Status.FREE),
            new Employee(103, "王五", 28, 3333.33, Status.VOCATION),
            new Employee(104, "赵六", 8, 7777.77, Status.BUSY),
            new Employee(105, "田七", 38, 5555.55, Status.BUSY)
    );

    /*
     * Stream的三步操作
     * 1。创建Stream
     * 2。中间操作
     * 3。终止操作（终端操作）
     */

    //创建流
    @Test
    public void test01(){
        List<String> list = new ArrayList<>();
        //1. 可以通过Collection系列集合提供的stream()或parallelStream(),前面是串行流，后面是并行流
        //创建流01
        Stream<String> stream = list.stream();
        //02
        Employee[] emps = new Employee[10];
        Stream<Employee> stream1 = Arrays.stream(emps);
        //03
        Stream<String> stream2 = Stream.of("aa", "bb", "cc");
        //04.创建无限流--迭代
        Stream<Integer> stream3 = Stream.iterate(0, (x) -> x + 2);
        //04.创建无限流--生成
        Stream<Integer> stream4 = Stream.generate(() -> (int) Math.random() * 100);
        //终止操作
        stream2.forEach(System.out::println);
    }

    //stream中间操作
    /*
	  筛选与切片
		filter——接收 Lambda ， 从流中排除某些元素。
		limit——截断流，使其元素不超过给定数量。
		skip(n) —— 跳过元素，返回一个扔掉了前 n 个元素的流。若流中元素不足 n 个，则返回一个空流。与 limit(n) 互补
		distinct——筛选，通过流所生成元素的 hashCode() 和 equals() 去除重复元素
	 */
    @Test
    public void test02() {
        //筛选与切片

    }

    /*
     *  map:映射，接收lambad，将元素转换成其他形式或者提取信息。接收一个函数作为参数，该函数会被应用到每个元素上，并将其映射成一个新元素
     *  flatMap--接收一个函数作为参数，将流中到每一个值都转换成另外一个流，然后把所有流连接成一个流
     *  sort--排序
     */
    @Test
    public void test03() {
        //map
        emps.stream().map(item -> item.getName()).forEach(System.out::println);
        List<String> list = Arrays.asList("aaa","bbb","ccc");
        list.stream().map(String::toUpperCase).forEach(System.out::println);

        //flatMap
        list.stream().flatMap(Java8Test_Stream::filterCharacter).forEach(System.out::println);
    }

    public static Stream<Character> filterCharacter(String str){
        List<Character> list = new ArrayList<>();
        for (Character cha : str.toCharArray()){
            list.add(cha);
        }
        return list.stream();
    }

    /*
     * 终止操作
     * 查找与匹配
     * allMatch--检查是否匹配所有元素
     * anyMatch--检查是否匹配至少一个元素
     * noneMatch--检查是否没有匹配所有元素
     * findFirst--返回第一个元素
     * findAny--返回当前流中都任意元素
     * count--返回流中元素都总个数
     * max--返回流中都最大值
     * min--返回流中都最小值
     */
    @Test
    public void test04() {
        boolean b = emps.stream().allMatch(item -> item.getName().equals("张三"));
        System.out.println(b);
        b = emps.stream().anyMatch(item -> item.getName().equals("张三"));
        System.out.println(b);
        b = emps.stream().noneMatch(item -> item.getName().equals("三"));
        System.out.println(b);
        Optional<Employee> first = emps.stream().findFirst();
        System.out.println(JSONObject.toJSONString(first.get()));
        //获取工资最多的人
        Optional<Employee> max1 = emps.stream().max((x, y) -> Double.compare(x.getSalary(), y.getSalary()));
        System.out.println(JSONObject.toJSONString(max1.get()));
        //获取最大工资
        Optional<Double> max = emps.stream().map(Employee::getSalary).max(Double::compare);
        System.out.println(max.get());

    }

    /*
     * 规约
     *  reduce(T identity, BinaryOperator)/ reduce(BinaryOperator) --可以将流中元素反复结合起来，得到一个值
     */
    @Test
    public void test05() {
        List<Integer> list = Arrays.asList(1,2,3,4,5,6,7,8,9,10);
        //list求和,0是起始值
        Integer sum = list.stream().reduce(0, (x, y) -> x + y);
        System.out.println(sum);

        //计算员工工资总和
        Double reduce = emps.stream().map(Employee::getSalary).reduce(0d, (x, y) -> x + y);
        System.out.println(reduce);
        //不带起始值
        Optional<Double> reduce1 = emps.stream().map(Employee::getSalary).reduce((x, y) -> x + y);
        System.out.println(reduce1.get());
        //等价于
        Optional<Double> reduce2 = emps.stream().map(Employee::getSalary).reduce(Double::sum);
        System.out.println(reduce2.get());

    }

    /*
     * 收集
     *  collect --可以将流转换为其他形式。接收一个Collector接口的实现，用于给Stream中元素做汇总的方法
     */
    @Test
    public void test06() {
        //搜集到list
        List<Double> collect = emps.stream().map(Employee::getSalary).collect(Collectors.toList());
        System.out.println(JSONObject.toJSONString(collect));

        //搜集到其他特殊集合，比如HastSet
        HashSet<String> collect1 = emps.stream().map(Employee::getName).collect(Collectors.toCollection(HashSet::new));
        System.out.println(JSONObject.toJSONString(collect1));

        //总数
        Long collect2 = emps.stream().map(Employee::getName).collect(Collectors.counting());
        System.out.println(collect2);

        //平均值
        Double avg = emps.stream().map(Employee::getSalary).collect(Collectors.averagingDouble(Double::valueOf));
        //等价于
        avg = emps.stream().collect(Collectors.averagingDouble(Employee::getSalary));
        System.out.println(avg);
        //总和
        avg = emps.stream().collect(Collectors.summingDouble(Employee::getSalary));
        //最小值
        emps.stream().collect(Collectors.minBy((x,y)->Double.compare(x.getSalary(),y.getSalary())));
        //最大值
        emps.stream().collect(Collectors.maxBy((x,y)->Double.compare(x.getSalary(),y.getSalary())));
        //获取上述到综合
        DoubleSummaryStatistics collect6 = emps.stream().collect(Collectors.summarizingDouble(Employee::getSalary));
        System.out.println(JSONObject.toJSONString(collect6));


        //分组
        Map<Status, List<Employee>> collect3 = emps.stream().collect(Collectors.groupingBy(Employee::getStatus));
        System.out.println(JSONObject.toJSONString(collect3));

        //多列分组
        emps.stream().collect(Collectors.groupingBy(Employee::getStatus,Collectors.groupingBy(Employee::getName)));

        //自定分组
        Map<String, List<Employee>> collect4 = emps.stream().collect(Collectors.groupingBy((e) -> {
            Employee item = (Employee) e;
            if (item.getAge() <= 35) {
                return "青年";
            } else if (item.getAge() > 35 && item.getAge() <= 45) {
                return "中年";
            } else {
                return "老年";
            }
        }));
        System.out.println(JSONObject.toJSONString(collect4));

        //分片，或者叫做分区
        Map<Boolean, List<Employee>> collect5 = emps.stream().collect(Collectors.partitioningBy((e) -> e.getAge() >= 30));
        System.out.println(JSONObject.toJSONString(collect5));

        //连接
        String collect7 = emps.stream().map(Employee::getName).collect(Collectors.joining(","));
        System.out.println(collect7);

        String collect8 = emps.stream().map(Employee::getName).collect(Collectors.joining(",","==","=="));
        System.out.println(collect8);
    }


}
