LuaMemStats（Lua内存统计，数据计数）
========

首先膜拜一下云大的Lua内存泄漏检查工具[lua-snapshot](https://github.com/cloudwu/lua-snapshot)，在很多时候这个工具会更直接准确的看到占用的内存（内存泄漏点）。  
本人的工具适用于另外一些情况，例如内存数据繁杂、泄漏不明显、需要按模块优化内存等等。

基本例子
--------
执行：

    require("mem_stats").List()

输出：

    path:   _G
    index:  1
    PCT.T:  100.0%
    value:  table: 04F712D0
    
    index   key                             count   PCT.P   PCT.T   value
    18      Trigger                         46841   41.8%   41.8%   table: 04F82F98
    196     .LoadTriggers                   46821   100.0%  41.8%   function: 05EAF210
    1215    ..Triggers                      46804   100.0%  41.8%   table: 05EAF1C0
    1216    ..CTypeID                       12      0.0%    0.0%    table: 05EAF490
    198     .CheckTriggersOnly              5       0.0%    0.0%    function: 05EA2CA8
    1217    ..checkTriggers                 3       60.0%   0.0%    function: 059C0908
    199     .CheckTriggers                  3       0.0%    0.0%    function: 059C0DD0
    200     .GetTypes                       2       0.0%    0.0%    function: 04F82FE8
    ……

其中：
  * index 数据索引，用于进一步检查
  * key 为数据名（table的key或upvalue名称等等），前面的"."表示层级
  * count 包含的数据数量
  * PCT.P 当前层次下的占比
  * PCT.T 总占比
  * value 把值执行tostring的结果

接口说明
--------

* List(index, level, percent, count)  
  列出数据占用情况
  * index 数据索引，默认1表示_G，具体值参考List输出
  * level 展开的层级，默认3
  * percent 输出项目至少占用的总百分比（PCT.T），默认0
  * count 最多输出的项目数，默认100

* Clear()  
  清空缓存的数据（用于释放内存或重新检测）

特别说明
--------

* 本工具并不能计算真实的内存占用，只是计算数据数量，可以间接反映内存占用情况
* List在首次调用时会遍历全部Lua内存数据，可能会比较耗时，并且会占用大量内存
* 如果手动释放了内存，需要调用Clear()来同步释放检测工具占用的内存
* 多次调用List不会看到最新的数据，需要调用Clear()来强制刷新
* 某些metatable可能导致本工具报错或统计不准确（这是一个TODO）
* 对于简单类型（string、number等），不会详细列出，请根据count进行估算
