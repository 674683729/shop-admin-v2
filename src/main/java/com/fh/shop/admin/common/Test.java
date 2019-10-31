package com.fh.shop.admin.common;

public class Test {
     public static void main(String[] args) {
         //求阶乘
         //int a=jieCheng(5);
         //System.out.println(a);

         //斐波那契
         int a=fbnq(7);
         System.out.println(a);

    }


    //斐波那契数列的是这样一个数列：1、1、2、3、5、8、13、21、34....，
    // 即第一项 f(1) = 1,第二项 f(2) = 1.....,第 n 项目为 f(n) = f(n-1) + f(n-2)
    public static int fbnq(int n){
        //显然，当 n = 1 或者 n = 2 ,我们可以轻易着知道结果 f(1) = f(2) = 1。
        // 所以递归结束条件可以为 n <= 2
        if(n <= 2){
            return 1;
        }
                //接着写等价关系式
         return fbnq(n-1)+fbnq(n-2);
    }



    //求n的阶乘
    public static int jieCheng(int n){
        if(n == 0 || n == 1){
            return 1;
        }
        // 把 jieCheng(n) 的等价操作写进去
        return jieCheng(n-1) * n;
    }


}
