package com.woollen.admin.algorithm;

import com.alibaba.fastjson.JSONObject;
import org.junit.Test;

/**
 * @Info: 排序算法
 * @ClassName: SortAlgorithm
 * @Author: weiyang
 * @Data: 2019/11/30 4:24 PM
 * @Version: V1.0
 **/
public class SortAlgorithm {
    /*
     * title 冒泡排序
     * 原理：每次遍历找到最小的一个放到前面
     * @Author weiyang
     * @Date 5:16 PM 2019/11/30
     * @Param
     * @return void
     **/
    @Test
    public void bubbleSorting(){
        Integer[] sort = {3,9,-1,10,-2};
        for (int i=0;i<sort.length;i++){
            Boolean flag = true;
            for (int j=i+1;j<sort.length;j++){
                if (sort[i]>sort[j]){
                    int temp = sort[i];
                    sort[i] = sort[j];
                    sort[j] = temp;
                    flag = false;
                }
            }
            if (flag){
                break;
            }
        }
        System.out.println(JSONObject.toJSONString(sort));
    }

    /*
     * title 选择排序
     * 原理：冒泡排序的稍微优化版
     * --每次遍历找到最小元素的下标，一遍遍历完后再进行交换
     * @Author weiyang
     * @Date 5:17 PM 2019/11/30
     * @Param
     * @return void
     **/
    @Test
    public void chooseSorting(){
        Integer[] sort = {3,9,-1,10,-2};
        for (int i=0;i<sort.length; i++){
            int a = i;
            for (int j=i+1;j<sort.length; j++){
                if (sort[a]> sort[j]){
                    a=j;
                }
            }
            if (a!=i){
                int temp = sort[i];
                sort[i] = sort[a];
                sort[a] = temp;
            }
        }
        System.out.println(JSONObject.toJSONString(sort));
    }

    /*
     * title 插入排序
     * 原理：
     * --1.将数组分为两个数组，左边看成有序数组，右边看成无序数组
     * --2.刚开始的时候左边只有一个元素，所以是有序的
     * --3.从无序数组中取出一个元素，和有序数组的最后一个元素比较
     * --4.找到无序数组中的哪个元素在有序数组中我位置
     * @Author weiyang
     * @Date 5:31 PM 2019/11/30
     * @Param
     * @return void
     **/
    @Test
    public void insertSorting(){
        Integer[] sort = {3,9,-1,10,-2};
        for (int i=0; i<sort.length-1; i++){
            //先获取原始数据
            int insertVal = sort[i+1];
            //获取要排序的数据索引
            int insertIndex = i;
            while(insertIndex>=0 && sort[insertIndex]>insertVal){
                sort[insertIndex+1] = sort[insertIndex];
                sort[insertIndex] = insertVal;
                insertIndex --;
            }
        }
        System.out.println(JSONObject.toJSONString(sort));
    }

    /*
     * title 希尔排序算法，交换法
     * @Author weiyang
     * @Date 4:21 PM 2020/1/4
     * @Param
     * @return void
     **/
    @Test
    public void shellSorting(){

        Integer[] arr = {8,9,1,7,2,3,5,4,6,0};
        for (int grap=arr.length/2; grap>0; grap = grap/2){
            for (int i=grap;i<arr.length; i++){
                for (int j = i-grap;j>=0; j-=grap){
                    if (arr[j] > arr[j+grap]){
                        //交换
                        int temp = arr[j];
                        arr[j] = arr[j+grap];
                        arr[j+grap] = temp;
                    }
                }
            }

        }
        System.out.println(JSONObject.toJSONString(arr));


        /*这里是推倒代码
        //交换法,第一轮
        for (int i=5;i<arr.length; i++){
            for (int j = i-5;j>=0; j-=5){
                if (arr[j] > arr[j+5]){
                    //交换
                    int temp = arr[j];
                    arr[j] = arr[j+5];
                    arr[j+5] = temp;
                }
            }
        }
        System.out.println(JSONObject.toJSONString(arr));

        //交换法，第二轮
        for (int i=2; i<arr.length; i++){
            for (int j=i-2; j>=0; j-=2){
                if (arr[j] > arr[j+2]){
                    //交换
                    int temp = arr[j];
                    arr[j] = arr[j+2];
                    arr[j+2] = temp;
                }
            }
        }
        System.out.println(JSONObject.toJSONString(arr));

        //交换法，第三轮
        for (int i=1; i<arr.length; i++){
            for (int j=i-1; j>=0; j-=1){
                if (arr[j] > arr[j+1]){
                    //交换
                    int temp = arr[j];
                    arr[j] = arr[j+1];
                    arr[j+1] = temp;
                }
            }
        }
        System.out.println(JSONObject.toJSONString(arr));
        */
    }


    /*
     * title 希尔排序算法，移位法
     * 其实就是在内部使用插入排序
     * @Author weiyang
     * @Date 4:21 PM 2020/1/4
     * @Param 1，2，3，5，4
     * @return void
     **/
    @Test
    public void shellInsertSorting(){

        Integer[] arr = {8,9,1,7,2,3,5,4,6,0};
        //步长
        for (int grap=arr.length/2; grap>0; grap = grap/2){
            for (int i=grap; i< arr.length; i++){
                int j = i;
                int temp = arr[i];
                while( j-grap>=0 && temp <  arr[j-grap]){
                    arr[j] = arr[j-grap];
                    j -=grap;
                }
                //循环结束的时候就找到了temp的位置
                arr[j] = temp;
            }
        }
        System.out.println(JSONObject.toJSONString(arr));

    }


    /*
     * title 快速排序，实际上是把数组用一个数分为2部分，左边都笔这个数小，右边都笔这个数大，
     * 接下来就是递归左边都和递归右边都
     * @Author weiyang
     * @Date 4:54 PM 2020/1/15
     * @Param 
     * @return void
     **/
    @Test
    public void quickSorting(){

//        Integer[] arr = {8,9,1,7,2,3,5,4,6,0};
        Integer[] arr = {6,3,4,5,8,9};
//        int
        doQuickSorting(arr,0,arr.length-1);
        System.out.println(JSONObject.toJSONString(arr));
    }

    /*
     * title 6,3,4,5,8,9
     * @Author weiyang
     * @Date 6:56 PM 2020/1/15
     * @Param array:要排序等数组；left:数组分割后等左边；right:数组分割后等右边
     * @return void
     **/
    void doQuickSorting(Integer[] arr,int left,int right){
        //中间值
        int l = left;
        int r = right;
        int middleIndex = (left+right) / 2;
        int pivot = arr[middleIndex];
        int temp = 0;
        while(l<r) {
            while (arr[l] < pivot) {
                l++;
            }
            while (arr[r] > pivot) {
                r--;
            }
            if (l>=r){
                break;
            }
            temp = arr[l];
            arr[l] = arr[r];
            arr[r] = temp;

            /*if (arr[r] == pivot){
                l++;
            }

            if (arr[l] == pivot){
                r--;
            }*/

        }
    }
}
