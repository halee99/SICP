; 显式分派： 这种策略在增加新操作时需要使用者避免命名冲突。
;          而且每当增加新类型时，所有通用操作都需要做相应的改动，
;          这种策略不具有可加性。
;          因此无论是增加新操作还是增加新类型，这种策略都不适合。

; 数据导向：数据导向可以很方便地通过包机制增加新类型和新的通用操作，
;         因此无论是增加新类型还是增加新操作，这种策略都很适合。

; 消息传递：消息传递将数据对象和数据对象所需的操作整合在一起，
;         因此它可以很方便地增加新类型，
;         但是这种策略不适合增加新操作，因为每次为某个数据对象增加新操作之后，这个数据对象已有的实例全部都要重新实例化才能使用新操作。