LuaMemStats��Lua�ڴ�ͳ�ƣ����ݼ�����
========

����Ĥ��һ���ƴ��Lua�ڴ�й©��鹤��[lua-snapshot](https://github.com/cloudwu/lua-snapshot)���ںܶ�ʱ��������߻��ֱ��׼ȷ�Ŀ���ռ�õ��ڴ棨�ڴ�й©�㣩��  
���˵Ĺ�������������һЩ����������ڴ����ݷ��ӡ�й©�����ԡ���Ҫ��ģ���Ż��ڴ�ȵȡ�

��������
--------
ִ�У�

    require("mem_stats").List()

�����

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
    ����

���У�
  * index �������������ڽ�һ�����
  * key Ϊ��������table��key��upvalue���Ƶȵȣ���ǰ���"."��ʾ�㼶
  * count ��������������
  * PCT.P ��ǰ����µ�ռ��
  * PCT.T ��ռ��
  * value ��ִֵ��tostring�Ľ��

�ӿ�˵��
--------

* List(index, level, percent, count)  
  �г�����ռ�����
  * index ����������Ĭ��1��ʾ_G������ֵ�ο�List���
  * level չ���Ĳ㼶��Ĭ��3
  * percent �����Ŀ����ռ�õ��ܰٷֱȣ�PCT.T����Ĭ��0
  * count ����������Ŀ����Ĭ��100

* Clear()  
  ��ջ�������ݣ������ͷ��ڴ�����¼�⣩

�ر�˵��
--------

* �����߲����ܼ�����ʵ���ڴ�ռ�ã�ֻ�Ǽ����������������Լ�ӷ�ӳ�ڴ�ռ�����
* List���״ε���ʱ�����ȫ��Lua�ڴ����ݣ����ܻ�ȽϺ�ʱ�����һ�ռ�ô����ڴ�
* ����ֶ��ͷ����ڴ棬��Ҫ����Clear()��ͬ���ͷż�⹤��ռ�õ��ڴ�
* ��ε���List���ῴ�����µ����ݣ���Ҫ����Clear()��ǿ��ˢ��
* ĳЩmetatable���ܵ��±����߱����ͳ�Ʋ�׼ȷ������һ��TODO��
* ���ڼ����ͣ�string��number�ȣ���������ϸ�г��������count���й���
