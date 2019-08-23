; 假设①存在 halts? 可以判断 p 对 a 的终止


; 运行(try try),

; 假设② (halts? try try) 为真。
; 执行 (run-forever) 永远运行，过程 try 无法终止, 与假设②矛盾

; 假设③ (halts? try try) 为假。
; 返回 halted，过程 try 无法终止, 与假设③矛盾


; 假设②③都矛盾，假设①则不成立
; 所以无论任何结果都将违背所确定的 halts? 行为。
