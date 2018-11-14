; 设 x,y 分别是两个区间中间值，e,r 分别为精度
; 有
; (x-xe, x+xe)  (y-yr, y+yr)
; 相乘得 (假设所有数为正数)
; ((x-xe)(y-yr), (x+xe)(y+yr))
; 由 p = 1 - lower / c 得
; p = 1 - (x-xe)(y-yr) / {[(x-xe)(y-yr) + (x+xe)(y+yr)] / 2}
; p = 1 - 2(1-e)(1-r) / [(1-e)(1-r) + (1+e)(1+r)]
