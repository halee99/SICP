; https://sicp.readthedocs.io/en/latest/chp3/49.html

; 关联帐号的其中一种状况产生的死锁无法使用 练习 3.48 的机制来防止。
; 假设 peter 和 mary 是两夫妇，他们各自拥有自己的帐号 peter-acc 和 mary-acc ，并且这两个帐号都将对方的帐号设置成了关联帐号，
; 也即是，当 peter-acc 的余额不足以支付的时候，它会去提取 mary-acc 的余额；
; 而当 mary-acc 的余额不足以支付的时候，它也回去提取 peter-acc 的余额。
;
; 现在，考虑这样一种情况， peter 和 mary 分别在不同的地方消费，
; 然后各自账户的余额都不足以支付订单，于是 peter-acc 尝试访问关联帐号 mary-acc,
; 而 mary-acc 也在同一时间访问 peter-acc ，
; 因为两个帐号都已经被打开，而且两个帐号都试图访问关联帐号，
; 这样就造成了一个死锁：除非 peter 或 mary 的其中一个主动退出账户，否则支付永远都无法完成。
