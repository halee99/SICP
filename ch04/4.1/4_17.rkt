; 1. 因为变换后的内部多了个 let, 最后 let 又会变换为 lambda, 而 lambda 就会生成一个新的框架
; 2. let 创建新的环境框架不会改变外部框架的值
; 3. 把 define 放在过程内部的顶部
