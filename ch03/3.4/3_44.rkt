; https://sicp.readthedocs.io/en/latest/chp3/44.html

; Louis 的话只是对了一半， transfer 的确需要更使用更复杂精细的方法去处理，但并不是在处理交换问题时的做法(使用两个串行化来保证正确性)。
; 将 W 定义表达式 ((from-account 'withdraw) amount) ，将 D 定义为 ((to-account 'deposit) amount) ， Others 定义为在转帐过程中可能并行运行的一条或多条表达式，那么对于 W 、 D 和 Others 三个定义，有以下可能的并发执行序列：
; W -> D -> Others
; W -> Others -> D
; 对于以上的执行序列， transfer 都总能完成 W 和 D ，而 W 和 D 都已经进行了串行化以保证单个操作可以正确执行，因此，我们没有必要再给 transfer 加上其他串行化设置。
; 至于为什么要用两个串行化来保证 exchange 的安全性而 transfer 不用？答案是因为 transfer 不需要计算两个帐号之间的中间值 difference ，它只需要分别对两个帐号执行 W 和 D 操作就行了。
; 不过，即便 transfer 能完成执行指定表达式的工作，它仍然不适合用于实际的银行系统中，因为这个 transfer 不是一个原子性操作，它也不能保证持久性。
; 举个例子，假设现在使用 (transfer peter-account mary-account 100) ，从 peter 账户向 mary 账户转帐 100 块，假设在执行 ((peter-account 'withdraw) 100) 之后，系统崩溃，这时候不但 peter 被白白扣了钱，而 mary 的钱也没有到帐。
; 要编写一个健壮的、正确的 transfer 过程，单纯的串行化是不够的，还必须要用到事务，或者其他类似的系统。
