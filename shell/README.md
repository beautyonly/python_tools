# 主机初始化
``` bash
wget https://raw.githubusercontent.com/mds1455975151/tools/master/shell/host_init.sh
sh host_init.sh
```

# 常用变量
``` bash
$BASH_SOURCE-输出脚本名称
$0: 执行脚本的名字
$*和$@: 将所有参数返回
$#:参数的个数
$_:代表上一个命令的最后一个参数
$$:代表所在命令的PID
$!:代表最后执行的后台命令的PID
$?:代表上一个命令执行是否成功的标志，如果执行成功则$? 为0，否则不为0
```

- shell退出
    - exit 退出脚本

    - return 退出函数

    - break 中断整个循环

    - continue 退出本次循环

# 资料
- https://github.com/dylanaraps/pure-bash-bible


8 脚本{

    #!/bin/sh         # 在脚本第一行脚本头 # sh为当前系统默认shell,可指定为bash等shell
    shopt             # 显示和设置shell中的行为选项
    sh -x             # 执行过程
    sh -n             # 检查语法
    (a=bbk)           # 括号创建子shell运行
    basename /a/b/c   # 从全路径中保留最后一层文件名或目录
    dirname           # 取路径
    $RANDOM           # 随机数
    $$                # 进程号
    source FileName   # 在当前bash环境下读取并执行FileName中的命令  # 等同 . FileName
    sleep 5           # 间隔睡眠5秒
    trap              # 在接收到信号后将要采取的行动
    trap "" 2 3       # 禁止ctrl+c
    $PWD              # 当前目录
    $HOME             # 家目录
    $OLDPWD           # 之前一个目录的路径
    cd -              # 返回上一个目录路径
    local ret         # 局部变量
    yes               # 重复打印
    yes |rm -i *      # 自动回答y或者其他
    ls -p /home       # 区分目录和文件夹
    ls -d /home/      # 查看匹配完整路径
    time a.sh         # 测试程序执行时间
    echo -n aa;echo bb                    # 不换行执行下一句话 将字符串原样输出
    echo -e "s\tss\n\n\n"                 # 使转义生效
    echo $a | cut -c2-6                   # 取字符串中字元
    echo {a,b,c}{a,b,c}{a,b,c}            # 排列组合(括号内一个元素分别和其他括号内元素组合)
    echo $((2#11010))                     # 二进制转10进制
    echo aaa | tee file                   # 打印同时写入文件 默认覆盖 -a追加
    echo {1..10}                          # 打印10个字符
    printf '%10s\n'|tr " " a              # 打印10个字符
    pwd | awk -F/ '{ print $2 }'          # 返回目录名
    tac file |sed 1,3d|tac                # 倒置读取文件  # 删除最后3行
    tail -3 file                          # 取最后3行
    outtmp=/tmp/$$`date +%s%N`.outtmp     # 临时文件定义
    :(){ :|:& };:                         # 著名的 fork炸弹,系统执行海量的进程,直到系统僵死
    echo -e "\e[32m颜色\e[0m"             # 打印颜色
    echo -e "\033[32m颜色\033[m"          # 打印颜色
    echo -e "\033[0;31mL\033[0;32mO\033[0;33mV\033[0;34mE\t\033[0;35mY\033[0;36mO\033[0;32mU\e[m"    # 打印颜色

    正则表达式{

        ^              # 行首定位
        $              # 行尾定位
        .              # 匹配除换行符以外的任意字符
        *              # 匹配0或多个重复字符
        +              # 重复一次或更多次
        ?              # 重复零次或一次
        ?              # 结束贪婪因子 .*? 表示最小匹配
        []             # 匹配一组中任意一个字符
        [^]            # 匹配不在指定组内的字符
        \              # 用来转义元字符
        <              # 词首定位符(支持vi和grep)  <love
        >              # 词尾定位符(支持vi和grep)  love>
        x\{m\}         # 重复出现m次
        x\{m,\}        # 重复出现至少m次
        x\{m,n\}       # 重复出现至少m次不超过n次
        X?             # 匹配出现零次或一次的大写字母 X
        X+             # 匹配一个或多个字母 X
        ()             # 括号内的字符为一组
        (ab|de)+       # 匹配一连串的（最少一个） abc 或 def；abc 和 def 将匹配
        [[:alpha:]]    # 代表所有字母不论大小写
        [[:lower:]]    # 表示小写字母
        [[:upper:]]    # 表示大写字母
        [[:digit:]]    # 表示数字字符
        [[:digit:][:lower:]]    # 表示数字字符加小写字母

        元字符{

            \d       # 匹配任意一位数字
            \D       # 匹配任意单个非数字字符
            \w       # 匹配任意单个字母数字下划线字符，同义词是 [:alnum:]
            \W       # 匹配非数字型的字符

        }

        字符类:空白字符{

            \s       # 匹配任意的空白符
            \S       # 匹配非空白字符
            \b       # 匹配单词的开始或结束
            \n       # 匹配换行符
            \r       # 匹配回车符
            \t       # 匹配制表符
            \b       # 匹配退格符
            \0       # 匹配空值字符

        }

        字符类:锚定字符{

            \b       # 匹配字边界(不在[]中时)
            \B       # 匹配非字边界
            \A       # 匹配字符串开头
            \Z       # 匹配字符串或行的末尾
            \z       # 只匹配字符串末尾
            \G       # 匹配前一次m//g离开之处

        }

        捕获{

            (exp)                # 匹配exp,并捕获文本到自动命名的组里
            (?<name>exp)         # 匹配exp,并捕获文本到名称为name的组里，也可以写成(?'name'exp)
            (?:exp)              # 匹配exp,不捕获匹配的文本，也不给此分组分配组号

        }

        零宽断言{

            (?=exp)              # 匹配exp前面的位置
            (?<=exp)             # 匹配exp后面的位置
            (?!exp)              # 匹配后面跟的不是exp的位置
            (?<!exp)             # 匹配前面不是exp的位置
            (?#comment)          # 注释不对正则表达式的处理产生任何影响，用于注释

        }

        特殊字符{

            http://en.wikipedia.org/wiki/Ascii_table
            ^H  \010 \b
            ^M  \015 \r
            匹配特殊字符: ctrl+V ctrl不放在按H或M 即可输出^H,用于匹配

        }

    }

    流程结构{

        if判断{

            if [ $a == $b ]
            then
                echo "等于"
            else
                echo "不等于"
            fi

        }

        case分支选择{

            case $xs in
            0) echo "0" ;;
            1) echo "1" ;;
            *) echo "其他" ;;
            esac

        }

        while循环{

            # while true  等同   while :
            # 读文件为整行读入
            num=1
            while [ $num -lt 10 ]
            do
            echo $num
            ((num=$num+2))
            done
            ###########################
            grep a  a.txt | while read a
            do
                echo $a
            done
            ###########################
            while read a
            do
                echo $a
            done < a.txt

        }

        for循环{

            # 读文件已空格分隔
            w=`awk -F ":" '{print $1}' c`
            for d in $w
            do
                $d
            done
            ###########################
            for ((i=0;i<${#o[*]};i++))
            do
            echo ${o[$i]}
            done

        }

        until循环{

            #  当command不为0时循环
            until command
            do
                body
            done

        }

        流程控制{

            break N     #  跳出几层循环
            continue N  #  跳出几层循环，循环次数不变
            continue    #  重新循环次数不变

        }

    }

    变量{

        A="a b c def"           # 将字符串复制给变量
        A=`cmd`                 # 将命令结果赋给变量
        A=$(cmd)                # 将命令结果赋给变量
        eval a=\$$a             # 间接调用
        i=2&&echo $((i+3))      # 计算后打印新变量结果
        i=2&&echo $[i+3]        # 计算后打印新变量结果
        a=$((2>6?5:8))          # 判断两个值满足条件的赋值给变量
        $1  $2  $*              # 位置参数 *代表所有
        env                     # 查看环境变量
        env | grep "name"       # 查看定义的环境变量
        set                     # 查看环境变量和本地变量
        read name               # 输入变量
        readonly name           # 把name这个变量设置为只读变量,不允许再次设置
        readonly                # 查看系统存在的只读文件
        export name             # 变量name由本地升为环境
        export name="RedHat"    # 直接定义name为环境变量
        export Stat$nu=2222     # 变量引用变量赋值
        unset name              # 变量清除
        export -n name          # 去掉只读变量
        shift                   # 用于移动位置变量,调整位置变量,使$3的值赋给$2.$2的值赋予$1
        name + 0                # 将字符串转换为数字
        number " "              # 将数字转换成字符串
        a='ee';b='a';echo ${!b} # 间接引用name变量的值
        : ${a="cc"}             # 如果a有值则不改变,如果a无值则赋值a变量为cc

        数组{

            A=(a b c def)         # 将变量定义为数組
            ${#A[*]}              # 数组个数
            ${A[*]}               # 数组所有元素,大字符串
            ${A[@]}               # 数组所有元素,类似列表可迭代
            ${A[2]}               # 脚本的一个参数或数组第三位

        }

        定义变量类型{

            declare 或 typeset
            -r 只读(readonly一样)
            -i 整形
            -a 数组
            -f 函数
            -x export
            declare -i n=0

        }

        系统变量{

            $0   #  脚本启动名(包括路径)
            $n   #  第n个参数,n=1,2,…9
            $*   #  所有参数列表(不包括脚本本身)
            $@   #  所有参数列表(独立字符串)
            $#   #  参数个数(不包括脚本本身)
            $$   #  当前程式的PID
            $!   #  执行上一个指令的PID
            $?   #  执行上一个指令的返回值

        }

        变量引用技巧{

            ${name:+value}        # 如果设置了name,就把value显示,未设置则为空
            ${name:-value}        # 如果设置了name,就显示它,未设置就显示value
            ${name:?value}        # 未设置提示用户错误信息value
            ${name:=value}        # 如未设置就把value设置并显示<写入本地中>
            ${#A}                 # 可得到变量中字节
            ${A:4:9}              # 取变量中第4位到后面9位
            ${A:(-1)}             # 倒叙取最后一个字符
            ${A/www/http}         # 取变量并且替换每行第一个关键字
            ${A//www/http}        # 取变量并且全部替换每行关键字

            定义了一个变量： file=/dir1/dir2/dir3/my.file.txt
            ${file#*/}     # 去掉第一条 / 及其左边的字串：dir1/dir2/dir3/my.file.txt
            ${file##*/}    # 去掉最后一条 / 及其左边的字串：my.file.txt
            ${file#*.}     # 去掉第一个 .  及其左边的字串：file.txt
            ${file##*.}    # 去掉最后一个 .  及其左边的字串：txt
            ${file%/*}     # 去掉最后条 / 及其右边的字串：/dir1/dir2/dir3
            ${file%%/*}    # 去掉第一条 / 及其右边的字串：(空值)
            ${file%.*}     # 去掉最后一个 .  及其右边的字串：/dir1/dir2/dir3/my.file
            ${file%%.*}    # 去掉第一个 .  及其右边的字串：/dir1/dir2/dir3/my
            #   # 是去掉左边(在键盘上 # 在 $ 之左边)
            #   % 是去掉右边(在键盘上 % 在 $ 之右边)
            #   单一符号是最小匹配﹔两个符号是最大匹配

        }

    }

    test条件判断{

        # 符号 [ ] 等同  test命令

        expression为字符串操作{

            -n str   # 字符串str是否不为空
            -z str   # 字符串str是否为空

        }

        expression为文件操作{

            -a     # 并且，两条件为真
            -b     # 是否块文件
            -p     # 文件是否为一个命名管道
            -c     # 是否字符文件
            -r     # 文件是否可读
            -d     # 是否一个目录
            -s     # 文件的长度是否不为零
            -e     # 文件是否存在
            -S     # 是否为套接字文件
            -f     # 是否普通文件
            -x     # 文件是否可执行，则为真
            -g     # 是否设置了文件的 SGID 位
            -u     # 是否设置了文件的 SUID 位
            -G     # 文件是否存在且归该组所有
            -w     # 文件是否可写，则为真
            -k     # 文件是否设置了的粘贴位
            -t fd  # fd 是否是个和终端相连的打开的文件描述符（fd 默认为 1）
            -o     # 或，一个条件为真
            -O     # 文件是否存在且归该用户所有
            !      # 取反

        }

        expression为整数操作{

            expr1 -a expr2   # 如果 expr1 和 expr2 评估为真，则为真
            expr1 -o expr2   # 如果 expr1 或 expr2 评估为真，则为真

        }

        两值比较{

            整数     字符串
            -lt      <         # 小于
            -gt      >         # 大于
            -le      <=        # 小于或等于
            -ge      >=        # 大于或等于
            -eq      ==        # 等于
            -ne      !=        # 不等于

        }

        test 10 -lt 5       # 判断大小
        echo $?             # 查看上句test命令返回状态  # 结果0为真,1为假
        test -n "hello"     # 判断字符串长度是否为0
        [ $? -eq 0 ] && echo "success" || exit　　　# 判断成功提示,失败则退出

    }

    重定向{

        #  标准输出 stdout 和 标准错误 stderr  标准输入stdin
        cmd 1> fiel              # 把 标准输出 重定向到 file 文件中
        cmd > file 2>&1          # 把 标准输出 和 标准错误 一起重定向到 file 文件中
        cmd 2> file              # 把 标准错误 重定向到 file 文件中
        cmd 2>> file             # 把 标准错误 重定向到 file 文件中(追加)
        cmd >> file 2>&1         # 把 标准输出 和 标准错误 一起重定向到 file 文件中(追加)
        cmd < file >file2        # cmd 命令以 file 文件作为 stdin(标准输入)，以 file2 文件作为 标准输出
        cat <>file               # 以读写的方式打开 file
        cmd < file cmd           # 命令以 file 文件作为 stdin
        cmd << delimiter
        cmd; #从 stdin 中读入，直至遇到 delimiter 分界符
delimiter

        >&n    # 使用系统调用 dup (2) 复制文件描述符 n 并把结果用作标准输出
        <&n    # 标准输入复制自文件描述符 n
        <&-    # 关闭标准输入（键盘）
        >&-    # 关闭标准输出
        n<&-   # 表示将 n 号输入关闭
        n>&-   # 表示将 n 号输出关闭

    }

    运算符{

        $[]等同于$(())  # $[]表示形式告诉shell求中括号中的表达式的值
        ~var            # 按位取反运算符,把var中所有的二进制为1的变为0,为0的变为1
        var\<<str       # 左移运算符,把var中的二进制位向左移动str位,忽略最左端移出的各位,最右端的各位上补上0值,每做一次按位左移就有var乘2
        var>>str        # 右移运算符,把var中所有的二进制位向右移动str位,忽略最右移出的各位,最左的各位上补0,每次做一次右移就有实现var除以2
        var&str         # 与比较运算符,var和str对应位,对于每个二进制来说,如果二都为1,结果为1.否则为0
        var^str         # 异或运算符,比较var和str对应位,对于二进制来说如果二者互补,结果为1,否则为0
        var|str         # 或运算符,比较var和str的对应位,对于每个二进制来说,如二都该位有一个1或都是1,结果为1,否则为0

        运算符优先级{
            级别      运算符                                  说明
            1      =,+=,-=,/=,%=,*=,&=,^=,|=,<<=,>>=      # 赋值运算符
            2         ||                                  # 逻辑或 前面不成功执行
            3         &&                                  # 逻辑与 前面成功后执行
            4         |                                   # 按位或
            5         ^                                   # 按位异或
            6         &                                   # 按位与
            7         ==,!=                               # 等于/不等于
            8         <=,>=,<,>                           # 小于或等于/大于或等于/小于/大于
            9        \<<,>>                               # 按位左移/按位右移 (无转意符号)
            10        +,-                                 # 加减
            11        *,/,%                               # 乘,除,取余
            12        ! ,~                                # 逻辑非,按位取反或补码
            13        -,+                                 # 正负
        }
    }
    数学运算{
        $(( ))        # 整数运算
        + - * / **    # 分別为 "加、減、乘、除、密运算"
        & | ^ !       # 分別为 "AND、OR、XOR、NOT" 运算
        %             # 余数运算
        let{
            let # 运算
            let x=16/4
            let x=5**5
        }
        expr{
            expr 14 % 9                    # 整数运算
            SUM=`expr 2 \* 3`              # 乘后结果赋值给变量
            LOOP=`expr $LOOP + 1`          # 增量计数(加循环即可) LOOP=0
            expr length "bkeep zbb"        # 计算字串长度
            expr substr "bkeep zbb" 4 9    # 抓取字串
            expr index "bkeep zbb" e       # 抓取第一个字符数字串出现的位置
            expr 30 / 3 / 2                # 运算符号有空格
            expr bkeep.doc : '.*'          # 模式匹配(可以使用expr通过指定冒号选项计算字符串中字符数)
            expr bkeep.doc : '\(.*\).doc'  # 在expr中可以使用字符串匹配操作，这里使用模式抽取.doc文件附属名
            数值测试{
                #如果试图计算非整数，则会返回错误
                rr=3.4
                expr $rr + 1
                expr: non-numeric argument
                rr=5
                expr $rr + 1
                6
            }
        }
        bc{
            echo "m^n"|bc            # 次方计算
            seq -s '+' 1000 |bc      # 从1加到1000
            seq 1 1000 |tr "\n" "+"|sed 's/+$/\n/'|bc   # 从1加到1000
        }
    }
    grep{
        -c    # 显示匹配到得行的数目，不显示内容
        -h    # 不显示文件名
        -i    # 忽略大小写
        -l    # 只列出匹配行所在文件的文件名
        -n    # 在每一行中加上相对行号
        -s    # 无声操作只显示报错，检查退出状态
        -v    # 反向查找
        -e    # 使用正则表达式
        -w    # 精确匹配
        -wc   # 精确匹配次数
        -o    # 查询所有匹配字段
        -P    # 使用perl正则表达式
        -A3   # 打印匹配行和下三行
        -B3   # 打印匹配行和上三行
        -C3   # 打印匹配行和上下三行
        grep -v "a" txt                              # 过滤关键字符行
        grep -w 'a\>' txt                            # 精确匹配字符串
        grep -i "a" txt                              # 大小写敏感
        grep  "a[bB]" txt                            # 同时匹配大小写
        grep '[0-9]\{3\}' txt                        # 查找0-9重复三次的所在行
        grep -E "word1|word2|word3"   file           # 任意条件匹配
        grep word1 file | grep word2 |grep word3     # 同时匹配三个
        echo quan@163.com |grep -Po '(?<=@.).*(?=.$)'                           # 零宽断言截取字符串  #　63.co
        echo "I'm singing while you're dancing" |grep -Po '\b\w+(?=ing\b)'      # 零宽断言匹配
        echo 'Rx Optical Power: -5.01dBm, Tx Optical Power: -2.41dBm' |grep -Po '(?<=:).*?(?=d)'           # 取出d前面数字 # ?为最小匹配
        echo 'Rx Optical Power: -5.01dBm, Tx Optical Power: -2.41dBm' | grep -Po '[-0-9.]+'                # 取出d前面数字 # ?为最小匹配
        echo '["mem",ok],["hardware",false],["filesystem",false]' |grep -Po '[^"]+(?=",false)'             # 取出false前面的字母
        echo '["mem",ok],["hardware",false],["filesystem",false]' |grep -Po '\w+",false'|grep -Po '^\w+'   # 取出false前面的字母
        grep用于if判断{
            if echo abc | grep "a"  > /dev/null 2>&1
            then
                echo "abc"
            else
                echo "null"
            fi
        }
    }
    tr{
        -c          # 用字符串1中字符集的补集替换此字符集，要求字符集为ASCII
        -d          # 删除字符串1中所有输入字符
        -s          # 删除所有重复出现字符序列，只保留第一个:即将重复出现字符串压缩为一个字符串
        [a-z]       # a-z内的字符组成的字符串
        [A-Z]       # A-Z内的字符组成的字符串
        [0-9]       # 数字串
        \octal      # 一个三位的八进制数，对应有效的ASCII字符
        [O*n]       # 表示字符O重复出现指定次数n。因此[O*2]匹配OO的字符串
        tr中特定控制字符表达方式{
            \a Ctrl-G    \007    # 铃声
            \b Ctrl-H    \010    # 退格符
            \f Ctrl-L    \014    # 走行换页
            \n Ctrl-J    \012    # 新行
            \r Ctrl-M    \015    # 回车
            \t Ctrl-I    \011    # tab键
            \v Ctrl-X    \030
        }
        tr A-Z a-z                             # 将所有大写转换成小写字母
        tr " " "\n"                            # 将空格替换为换行
        tr -s "[\012]" < plan.txt              # 删除空行
        tr -s ["\n"] < plan.txt                # 删除空行
        tr -s "[\015]" "[\n]" < file           # 删除文件中的^M，并代之以换行
        tr -s "[\r]" "[\n]" < file             # 删除文件中的^M，并代之以换行
        tr -s "[:]" "[\011]" < /etc/passwd     # 替换passwd文件中所有冒号，代之以tab键
        tr -s "[:]" "[\t]" < /etc/passwd       # 替换passwd文件中所有冒号，代之以tab键
        echo $PATH | tr ":" "\n"               # 增加显示路径可读性
        1,$!tr -d '\t'                         # tr在vi内使用，在tr前加处理行范围和感叹号('$'表示最后一行)
        tr "\r" "\n"<macfile > unixfile        # Mac -> UNIX
        tr "\n" "\r"<unixfile > macfile        # UNIX -> Mac
        tr -d "\r"<dosfile > unixfile          # DOS -> UNIX  Microsoft DOS/Windows 约定，文本的每行以回车字符(\r)并后跟换行符(\n)结束
        awk '{ print $0"\r" }'<unixfile > dosfile   # UNIX -> DOS：在这种情况下，需要用awk，因为tr不能插入两个字符来替换一个字符
    }
    seq{
        # 不指定起始数值，则默认为 1
        -s   # 选项主要改变输出的分格符, 预设是 \n
        -w   # 等位补全，就是宽度相等，不足的前面补 0
        -f   # 格式化输出，就是指定打印的格式
        seq 10 100               # 列出10-100
        seq 1 10 |tac            # 倒叙列出
        seq -s '+' 90 100 |bc    # 从90加到100
        seq -f 'dir%g' 1 10 | xargs mkdir     # 创建dir1-10
        seq -f 'dir%03g' 1 10 | xargs mkdir   # 创建dir001-010
    }
    trap{
        信号         说明
        HUP(1)     # 挂起，通常因终端掉线或用户退出而引发
        INT(2)     # 中断，通常因按下Ctrl+C组合键而引发
        QUIT(3)    # 退出，通常因按下Ctrl+\组合键而引发
        ABRT(6)    # 中止，通常因某些严重的执行错误而引发
        ALRM(14)   # 报警，通常用来处理超时
        TERM(15)   # 终止，通常在系统关机时发送
        trap捕捉到信号之后，可以有三种反应方式：
            1、执行一段程序来处理这一信号
            2、接受信号的默认操作
            3、忽视这一信号
        第一种形式的trap命令在shell接收到 signal list 清单中数值相同的信号时，将执行双引号中的命令串：
        trap 'commands' signal-list   # 单引号，要在shell探测到信号来的时候才执行命令和变量的替换，时间一直变
        trap "commands" signal-list   # 双引号，shell第一次设置信号的时候就执行命令和变量的替换，时间不变
    }
    awk{
        # 默认是执行打印全部 print $0
        # 1为真 打印$0
        # 0为假 不打印
        -F   # 改变FS值(分隔符)
        ~    # 域匹配
        ==   # 变量匹配
        !~   # 匹配不包含
        =    # 赋值
        !=   # 不等于
        +=   # 叠加
        \b   # 退格
        \f   # 换页
        \n   # 换行
        \r   # 回车
        \t   # 制表符Tab
        \c   # 代表任一其他字符
        -F"[ ]+|[%]+"  # 多个空格或多个%为分隔符
        [a-z]+         # 多个小写字母
        [a-Z]          # 代表所有大小写字母(aAbB...zZ)
        [a-z]          # 代表所有大小写字母(ab...z)
        [:alnum:]      # 字母数字字符
        [:alpha:]      # 字母字符
        [:cntrl:]      # 控制字符
        [:digit:]      # 数字字符
        [:graph:]      # 非空白字符(非空格、控制字符等)
        [:lower:]      # 小写字母
        [:print:]      # 与[:graph:]相似，但是包含空格字符
        [:punct:]      # 标点字符
        [:space:]      # 所有的空白字符(换行符、空格、制表符)
        [:upper:]      # 大写字母
        [:xdigit:]     # 十六进制的数字(0-9a-fA-F)
        [[:digit:][:lower:]]    # 数字和小写字母(占一个字符)
        内建变量{
            $n            # 当前记录的第 n 个字段，字段间由 FS 分隔
            $0            # 完整的输入记录
            ARGC          # 命令行参数的数目
            ARGIND        # 命令行中当前文件的位置 ( 从 0 开始算 )
            ARGV          # 包含命令行参数的数组
            CONVFMT       # 数字转换格式 ( 默认值为 %.6g)
            ENVIRON       # 环境变量关联数组
            ERRNO         # 最后一个系统错误的描述
            FIELDWIDTHS   # 字段宽度列表 ( 用空格键分隔 )
            FILENAME      # 当前文件名
            FNR           # 同 NR ，但相对于当前文件
            FS            # 字段分隔符 ( 默认是任何空格 )
            IGNORECASE    # 如果为真（即非 0 值），则进行忽略大小写的匹配
            NF            # 当前记录中的字段数(列)
            NR            # 当前行数
            OFMT          # 数字的输出格式 ( 默认值是 %.6g)
            OFS           # 输出字段分隔符 ( 默认值是一个空格 )
            ORS           # 输出记录分隔符 ( 默认值是一个换行符 )
            RLENGTH       # 由 match 函数所匹配的字符串的长度
            RS            # 记录分隔符 ( 默认是一个换行符 )
            RSTART        # 由 match 函数所匹配的字符串的第一个位置
            SUBSEP        # 数组下标分隔符 ( 默认值是 /034)
            BEGIN         # 先处理(可不加文件参数)
            END           # 结束时处理
        }
        内置函数{
            gsub(r,s)          # 在整个$0中用s替代r   相当于 sed 's///g'
            gsub(r,s,t)        # 在整个t中用s替代r
            index(s,t)         # 返回s中字符串t的第一位置
            length(s)          # 返回s长度
            match(s,r)         # 测试s是否包含匹配r的字符串
            split(s,a,fs)      # 在fs上将s分成序列a
            sprint(fmt,exp)    # 返回经fmt格式化后的exp
            sub(r,s)           # 用$0中最左边最长的子串代替s   相当于 sed 's///'
            substr(s,p)        # 返回字符串s中从p开始的后缀部分
            substr(s,p,n)      # 返回字符串s中从p开始长度为n的后缀部分
        }
        awk判断{
            awk '{print ($1>$2)?"第一排"$1:"第二排"$2}'      # 条件判断 括号代表if语句判断 "?"代表then ":"代表else
            awk '{max=($1>$2)? $1 : $2; print max}'          # 条件判断 如果$1大于$2,max值为为$1,否则为$2
            awk '{if ( $6 > 50) print $1 " Too high" ;\
            else print "Range is OK"}' file
            awk '{if ( $6 > 50) { count++;print $3 } \
            else { x+5; print $2 } }' file
        }
        awk循环{
            awk '{i = 1; while ( i <= NF ) { print NF, $i ; i++ } }' file
            awk '{ for ( i = 1; i <= NF; i++ ) print NF,$i }' file
        }
        awk '/Tom/' file               # 打印匹配到得行
        awk '/^Tom/{print $1}'         # 匹配Tom开头的行 打印第一个字段
        awk '$1 !~ /ly$/'              # 显示所有第一个字段不是以ly结尾的行
        awk '$3 <40'                   # 如果第三个字段值小于40才打印
        awk '$4==90{print $5}'         # 取出第四列等于90的第五列
        awk '/^(no|so)/' test          # 打印所有以模式no或so开头的行
        awk '$3 * $4 > 500'            # 算术运算(第三个字段和第四个字段乘积大于500则显示)
        awk '{print NR" "$0}'          # 加行号
        awk '/tom/,/suz/'              # 打印tom到suz之间的行
        awk '{a+=$1}END{print a}'      # 列求和
        awk 'sum+=$1{print sum}'       # 将$1的值叠加后赋给sum
        awk '{a+=$1}END{print a/NR}'   # 列求平均值
        awk '!s[$1 $3]++' file         # 根据第一列和第三列过滤重复行
        awk -F'[ :\t]' '{print $1,$2}'           # 以空格、:、制表符Tab为分隔符
        awk '{print "'"$a"'","'"$b"'"}'          # 引用外部变量
        awk '{if(NR==52){print;exit}}'           # 显示第52行
        awk '/关键字/{a=NR+2}a==NR {print}'      # 取关键字下第几行
        awk 'gsub(/liu/,"aaaa",$1){print $0}'    # 只打印匹配替换后的行
        ll | awk -F'[ ]+|[ ][ ]+' '/^$/{print $8}'             # 提取时间,空格不固定
        awk '{$1="";$2="";$3="";print}'                        # 去掉前三列
        echo aada:aba|awk '/d/||/b/{print}'                    # 匹配两内容之一
        echo aada:abaa|awk -F: '$1~/d/||$2~/b/{print}'         # 关键列匹配两内容之一
        echo Ma asdas|awk '$1~/^[a-Z][a-Z]$/{print }'          # 第一个域匹配正则
        echo aada:aaba|awk '/d/&&/b/{print}'                   # 同时匹配两条件
        awk 'length($1)=="4"{print $1}'                        # 字符串位数
        awk '{if($2>3){system ("touch "$1)}}'                  # 执行系统命令
        awk '{sub(/Mac/,"Macintosh",$0);print}'                # 用Macintosh替换Mac
        awk '{gsub(/Mac/,"MacIntosh",$1); print}'              # 第一个域内用Macintosh替换Mac
        awk -F '' '{ for(i=1;i<NF+1;i++)a+=$i  ;print a}'      # 多位数算出其每位数的总和.比如 1234， 得到 10
        awk '{ i=$1%10;if ( i == 0 ) {print i}}'               # 判断$1是否整除(awk中定义变量引用时不能带 $ )
        awk 'BEGIN{a=0}{if ($1>a) a=$1 fi}END{print a}'        # 列求最大值  设定一个变量开始为0，遇到比该数大的值，就赋值给该变量，直到结束
        awk 'BEGIN{a=11111}{if ($1<a) a=$1 fi}END{print a}'    # 求最小值
        awk '{if(A)print;A=0}/regexp/{A=1}'                    # 查找字符串并将匹配行的下一行显示出来，但并不显示匹配行
        awk '/regexp/{print A}{A=$0}'                          # 查找字符串并将匹配行的上一行显示出来，但并不显示匹配行
        awk '{if(!/mysql/)gsub(/1/,"a");print $0}'             # 将1替换成a，并且只在行中未出现字串mysql的情况下替换
        awk 'BEGIN{srand();fr=int(100*rand());print fr;}'      # 获取随机数
        awk '{if(NR==3)F=1}{if(F){i++;if(i%7==1)print}}'       # 从第3行开始，每7行显示一次
        awk '{if(NF<1){print i;i=0} else {i++;print $0}}'      # 显示空行分割各段的行数
        echo +null:null  |awk -F: '$1!~"^+"&&$2!="null"{print $0}'       # 关键列同时匹配
        awk -v RS=@ 'NF{for(i=1;i<=NF;i++)if($i) printf $i;print ""}'    # 指定记录分隔符
        awk '{b[$1]=b[$1]$2}END{for(i in b){print i,b[i]}}'              # 列叠加
        awk '{ i=($1%100);if ( $i >= 0 ) {print $0,$i}}'                 # 求余数
        awk '{b=a;a=$1; if(NR>1){print a-b}}'                            # 当前行减上一行
        awk '{a[NR]=$1}END{for (i=1;i<=NR;i++){print a[i]-a[i-1]}}'      # 当前行减上一行
        awk -F: '{name[x++]=$1};END{for(i=0;i<NR;i++)print i,name[i]}'   # END只打印最后的结果,END块里面处理数组内容
        awk '{sum2+=$2;count=count+1}END{print sum2,sum2/count}'         # $2的总和  $2总和除个数(平均值)
        awk -v a=0 -F 'B' '{for (i=1;i<NF;i++){ a=a+length($i)+1;print a  }}'     # 打印所以B的所在位置
        awk 'BEGIN{ "date" | getline d; split(d,mon) ; print mon[2]}' file        # 将date值赋给d，并将d设置为数组mon，打印mon数组中第2个元素
        awk 'BEGIN{info="this is a test2010test!";print substr(info,4,10);}'      # 截取字符串(substr使用)
        awk 'BEGIN{info="this is a test2010test!";print index(info,"test")?"ok":"no found";}'      # 匹配字符串(index使用)
        awk 'BEGIN{info="this is a test2010test!";print match(info,/[0-9]+/)?"ok":"no found";}'    # 正则表达式匹配查找(match使用)
        awk '{for(i=1;i<=4;i++)printf $i""FS; for(y=10;y<=13;y++)  printf $y""FS;print ""}'        # 打印前4列和后4列
        awk 'BEGIN{for(n=0;n++<9;){for(i=0;i++<n;)printf i"x"n"="i*n" ";print ""}}'                # 乘法口诀
        awk 'BEGIN{info="this is a test";split(info,tA," ");print length(tA);for(k in tA){print k,tA[k];}}'             # 字符串分割(split使用)
        awk '{if (system ("grep "$2" tmp/* > /dev/null 2>&1") == 0 ) {print $1,"Y"} else {print $1,"N"} }' a            # 执行系统命令判断返回状态
        awk  '{for(i=1;i<=NF;i++) a[i,NR]=$i}END{for(i=1;i<=NF;i++) {for(j=1;j<=NR;j++) printf a[i,j] " ";print ""}}'   # 将多行转多列
        netstat -an|awk -v A=$IP -v B=$PORT 'BEGIN{print "Clients\tGuest_ip"}$4~A":"B{split($5,ip,":");a[ip[1]]++}END{for(i in a)print a[i]"\t"i|"sort -nr"}'    # 统计IP连接个数
        cat 1.txt|awk -F" # " '{print "insert into user (user,password,email)values(""'\''"$1"'\'\,'""'\''"$2"'\'\,'""'\''"$3"'\'\)\;'"}' >>insert_1.txt     # 处理sql语句
        awk 'BEGIN{printf "what is your name?";getline name < "/dev/tty" } $1 ~name {print "FOUND" name " on line ", NR "."} END{print "see you," name "."}' file  # 两文件匹配
        取本机IP{
            /sbin/ifconfig |awk -v RS="Bcast:" '{print $NF}'|awk -F: '/addr/{print $2}'
            /sbin/ifconfig |awk '/inet/&&$2!~"127.0.0.1"{split($2,a,":");print a[2]}'
            /sbin/ifconfig |awk -v RS='inet addr:' '$1!="eth0"&&$1!="127.0.0.1"{print $1}'|awk '{printf"%s|",$0}'
            /sbin/ifconfig |awk  '{printf("line %d,%s\n",NR,$0)}'         # 指定类型(%d数字,%s字符)
        }
        查看磁盘空间{
            df -h|awk -F"[ ]+|%" '$5>14{print $5}'
            df -h|awk 'NR!=1{if ( NF == 6 ) {print $5} else if ( NF == 5) {print $4} }'
            df -h|awk 'NR!=1 && /%/{sub(/%/,"");print $(NF-1)}'
            df -h|sed '1d;/ /!N;s/\n//;s/ \+/ /;'    #将磁盘分区整理成一行   可直接用 df -P
        }
        排列打印{
            awk 'END{printf "%-10s%-10s\n%-10s%-10s\n%-10s%-10s\n","server","name","123","12345","234","1234"}' txt
            awk 'BEGIN{printf "|%-10s|%-10s|\n|%-10s|%-10s|\n|%-10s|%-10s|\n","server","name","123","12345","234","1234"}'
            awk 'BEGIN{
            print "   *** 开 始 ***   ";
            print "+-----------------+";
            printf "|%-5s|%-5s|%-5s|\n","id","name","ip";
            }
            $1!=1 && NF==4{printf "|%-5s|%-5s|%-5s|\n",$1,$2,$3" "$11}
            END{
            print "+-----------------+";
            print "   *** 结 束 ***   "
            }' txt
        }
        老男孩awk经典题{
            分析图片服务日志，把日志（每个图片访问次数*图片大小的总和）排行，也就是计算每个url的总访问大小
            说明：本题生产环境应用：这个功能可以用于IDC网站流量带宽很高，然后通过分析服务器日志哪些元素占用流量过大，进而进行优化或裁剪该图片，压缩js等措施。
            本题需要输出三个指标： 【被访问次数】    【访问次数*单个被访问文件大小】   【文件名（带URL）】
            测试数据
            59.33.26.105 - - [08/Dec/2010:15:43:56 +0800] "GET /static/images/photos/2.jpg HTTP/1.1" 200 11299
            awk '{array_num[$7]++;array_size[$7]+=$10}END{for(i in array_num) {print array_num[i]" "array_size[i]" "i}}'
        }
        awk练习题{
            wang     4
            cui      3
            zhao     4
            liu      3
            liu      3
            chang    5
            li       2
            1 通过第一个域找出字符长度为4的
            2 当第二列值大于3时，创建空白文件，文件名为当前行第一个域$1 (touch $1)
            3 将文档中 liu 字符串替换为 hong
            4 求第二列的和
            5 求第二列的平均值
            6 求第二列中的最大值
            7 将第一列过滤重复后，列出每一项，每一项的出现次数，每一项的大小总和
            1、字符串长度
                awk 'length($1)=="4"{print $1}'
            2、执行系统命令
                awk '{if($2>3){system ("touch "$1)}}'
            3、gsub(/r/,"s",域) 在指定域(默认$0)中用s替代r  (sed 's///g')
                awk '{gsub(/liu/,"hong",$1);print $0}' a.txt
            4、列求和
                awk '{a+=$2}END{print a}'
            5、列求平均值
                awk '{a+=$2}END{print a/NR}'
                awk '{a+=$2;b++}END{print a,a/b}'
            6、列求最大值
                awk 'BEGIN{a=0}{if($2>a) a=$2 }END{print a}'
            7、将第一列过滤重复列出每一项，每一项的出现次数，每一项的大小总和
                awk '{a[$1]++;b[$1]+=$2}END{for(i in a){print i,a[i],b[i]}}'
        }
        awk处理复杂日志{
            6.19：
            DHB_014_号百总机服务业务日报：广州 到达数异常！
            DHB_023_号百漏话提醒日报：珠海 到达数异常！
            6.20：
            DHB_014_号百总机服务业务日报：广州 到达数异常！到
            awk -F '[_ ：]+' 'NF>2{print $4,$1"_"$2,b |"sort";next}{b=$1}'
            # 当前行NF小于等于2 只针对{print $4,$1"_"$2,b |"sort";next} 有效 即 6.19：行跳过此操作,  {b=$1} 仍然执行
            # 当前行NF大于2 执行到 next 强制跳过本行，即跳过后面的 {b=$1}
            广州 DHB_014 6.19
        }
    }
    sed{
        # 先读取资料、存入模式空间、对其进行编辑、再输出、再用下一行替换模式空间内容
        # 调试工具sedsed (参数 -d)   http://aurelio.net/sedsed/sedsed-1.0
        -n   # 输出由编辑指令控制(取消默认的输出,必须与编辑指令一起配合)
        -i   # 直接对文件操作
        -e   # 多重编辑
        -r   # 正则可不转移特殊字符
        b    # 跳过匹配的行
        p    # 打印
        d    # 删除
        s    # 替换
        g    # 配合s全部替换
        i    # 行前插入
        a    # 行后插入
        r    # 读
        y    # 转换
        q    # 退出
        &    # 代表查找的串内容
        *    # 任意多个 前驱字符(前导符)
        ?    # 0或1个 最小匹配 没加-r参数需转义 \?
        $    # 最后一行
        .*   # 匹配任意多个字符
        \(a\)   # 保存a作为标签1(\1)
        模式空间{
            # 模式空间(两行两行处理) 模式匹配的范围，一般而言，模式空间是输入文本中某一行，但是可以通过使用N函数把多于一行读入模式空间
            # 暂存空间里默认存储一个空行
            n   # 读入下一行(覆盖上一行)
            h   # 把模式空间里的行拷贝到暂存空间
            H   # 把模式空间里的行追加到暂存空间
            g   # 用暂存空间的内容替换模式空间的行
            G   # 把暂存空间的内容追加到模式空间的行后
            x   # 将暂存空间的内容于模式空间里的当前行互换
            ！  # 对其前面的要匹配的范围取反
            D   # 删除当前模式空间中直到并包含第一个换行符的所有字符(/.*/匹配模式空间中所有内容，匹配到就执行D,没匹配到就结束D)
            N   # 追加下一个输入行到模式空间后面并在第二者间嵌入一个换行符，改变当前行号码,模式匹配可以延伸跨域这个内嵌换行
            p   # 打印模式空间中的直到并包含第一个换行的所有字符
        }
        标签函数{
            : lable # 建立命令标记，配合b，t函数使用跳转
            b lable # 分支到脚本中带有标记的地方，如果分支不存在则分支到脚本的末尾。
            t labe  # 判断分支，从最后一行开始，条件一旦满足或者T,t命令，将导致分支到带有标号的命令出，或者到脚本末尾。与b函数不同在于t在执行跳转前会先检查其前一个替换命令是否成功，如成功，则执行跳转。
            sed -e '{:p1;/A/s/A/AA/;/B/s/B/BB/;/[AB]\{10\}/b;b p1;}'     # 文件内容第一行A第二行B:建立标签p1;两个替换函数(A替换成AA,B替换成BB)当A或者B达到10个以后调用b,返回
            echo 'sd  f   f   [a    b      c    cddd    eee]' | sed ':n;s#\(\[[^ ]*\)  *#\1#;tn'  # 标签函数t使用方法,替换[]里的空格
            echo "198723124.03"|sed -r ':a;s/([0-9]+)([0-9]{3})/\1,\2/;ta'  # 每三个字符加一个逗号
        }
        引用外部变量{
            sed -n ''$a',10p'
            sed -n ""$a",10p"
        }
        sed 10q                                       # 显示文件中的前10行 (模拟"head")
        sed -n '$='                                   # 计算行数(模拟 "wc -l")
        sed -n '5,/^no/p'                             # 打印从第5行到以no开头行之间的所有行
        sed -i "/^$f/d" a     　　                  　# 删除匹配行
        sed -i '/aaa/,$d'                             # 删除匹配行到末尾
        sed -i "s/=/:/" c                             # 直接对文本替换
        sed -i "/^pearls/s/$/j/"                      # 找到pearls开头在行尾加j
        sed '/1/,/3/p' file                           # 打印1和3之间的行
        sed -n '1p' 文件                              # 取出指定行
        sed '5i\aaa' file                             # 在第5行之前插入行
        sed '5a\aaa' file                             # 在第5行之后抽入行
        echo a|sed -e '/a/i\b'                        # 在匹配行前插入一行
        echo a|sed -e '/a/a\b'                        # 在匹配行后插入一行
        echo a|sed 's/a/&\nb/g'                       # 在匹配行后插入一行
        seq 10| sed -e{1,3}'s/./a/'                   # 匹配1和3行替换
        sed -n '/regexp/!p'                           # 只显示不匹配正则表达式的行
        sed '/regexp/d'                               # 只显示不匹配正则表达式的行
        sed '$!N;s/\n//'                              # 将每两行连接成一行
        sed '/baz/s/foo/bar/g'                        # 只在行中出现字串"baz"的情况下将"foo"替换成"bar"
        sed '/baz/!s/foo/bar/g'                       # 将"foo"替换成"bar"，并且只在行中未出现字串"baz"的情况下替换
        echo a|sed -e 's/a/#&/g'                      # 在a前面加#号
        sed 's/foo/bar/4'                             # 只替换每一行中的第四个字串
        sed 's/\(.*\)foo/\1bar/'                      # 替换每行最后一个字符串
        sed 's/\(.*\)foo\(.*foo\)/\1bar\2/'           # 替换倒数第二个字符串
        sed 's/[0-9][0-9]$/&5'                        # 在以[0-9][0-9]结尾的行后加5
        sed -n ' /^eth\|em[01][^:]/{n;p;}'            # 匹配多个关键字
        sed -n -r ' /eth|em[01][^:]/{n;p;}'           # 匹配多个关键字
        echo -e "1\n2"|xargs -i -t sed 's/^/1/' {}    # 同时处理多个文件
        sed '/west/,/east/s/$/*VACA*/'                # 修改west和east之间的所有行，在结尾处加*VACA*
        sed  's/[^1-9]*\([0-9]\+\).*/\1/'             # 取出第一组数字，并且忽略掉开头的0
        sed -n '/regexp/{g;1!p;};h'                   # 查找字符串并将匹配行的上一行显示出来，但并不显示匹配行
        sed -n ' /regexp/{n;p;}'                      # 查找字符串并将匹配行的下一行显示出来，但并不显示匹配行
        sed -n 's/\(mar\)got/\1ianne/p'               # 保存\(mar\)作为标签1
        sed -n 's/\([0-9]\+\).*\(t\)/\2\1/p'          # 保存多个标签
        sed -i -e '1,3d' -e 's/1/2/'                  # 多重编辑(先删除1-3行，在将1替换成2)
        sed -e 's/@.*//g' -e '/^$/d'                  # 删除掉@后面所有字符，和空行
        sed -n -e "{s/文本(正则)/替换的内容/p}"       # 替换并打印出替换行
        sed -n -e "{s/^ *[0-9]*//p}"                  # 打印并删除正则表达式的那部分内容
        echo abcd|sed 'y/bd/BE/'                      # 匹配字符替换
        sed '/^#/b;y/y/P/' 2                          # 非#号开头的行替换字符
        sed '/suan/r 读入文件'                        # 找到含suan的行，在后面加上读入的文件内容
        sed -n '/no/w 写入文件'                       # 找到含no的行，写入到指定文件中
        sed '/regex/G'                                # 在匹配式样行之后插入一空行
        sed '/regex/{x;p;x;G;}'                       # 在匹配式样行之前和之后各插入一空行
        sed 'n;d'                                     # 删除所有偶数行
        sed 'G;G'                                     # 在每一行后面增加两空行
        sed '/^$/d;G'                                 # 在输出的文本中每一行后面将有且只有一空行
        sed 'n;n;n;n;G;'                              # 在每5行后增加一空白行
        sed -n '5~5p'                                 # 只打印行号为5的倍数
        seq 1 30|sed  '5~5s/.*/a/'                    # 倍数行执行替换
        sed -n '3,${p;n;n;n;n;n;n;}'                  # 从第3行开始，每7行显示一次
        sed -n 'h;n;G;p'                              # 奇偶调换
        seq 1 10|sed '1!G;h;$!d'                      # 倒叙排列
        ls -l|sed -n '/^.rwx.*/p'                     # 查找属主权限为7的文件
        sed = filename | sed 'N;s/\n/\t/'             # 为文件中的每一行进行编号(简单的左对齐方式)
        sed 's/^[ \t]*//'                             # 将每一行前导的"空白字符"(空格，制表符)删除,使之左对齐
        sed 's/^[ \t]*//;s/[ \t]*$//'                 # 将每一行中的前导和拖尾的空白字符删除
        sed '/{abc,def\}\/\[111,222]/s/^/00000/'      # 匹配需要转行的字符: } / [
        echo abcd\\nabcde |sed 's/\\n/@/g' |tr '@' '\n'        # 将换行符转换为换行
        cat tmp|awk '{print $1}'|sort -n|sed -n '$p'           # 取一列最大值
        sed -n '{s/^[^\/]*//;s/\:.*//;p}' /etc/passwd          # 取用户家目录(匹配不为/的字符和匹配:到结尾的字符全部删除)
        sed = filename | sed 'N;s/^/      /; s/ *\(.\{6,\}\)\n/\1   /'   # 对文件中的所有行编号(行号在左，文字右端对齐)
        /sbin/ifconfig |sed 's/.*inet addr:\(.*\) Bca.*/\1/g' |sed -n '/eth/{n;p}'   # 取所有IP
        修改keepalive配置剔除后端服务器{
            sed -i '/real_server.*10.0.1.158.*8888/,+8 s/^/#/' keepalived.conf
            sed -i '/real_server.*10.0.1.158.*8888/,+8 s/^#//' keepalived.conf
        }
        模仿rev功能{
            echo 123 |sed '/\n/!G;s/\(.\)\(.*\n\)/&\2\1/;//D;s/.//;'
            /\n/!G;         　　　　　　# 没有\n换行符，要执行G,因为保留空间中为空，所以在模式空间追加一空行
            s/\(.\)\(.*\n\)/&\2\1/;     # 标签替换 &\n23\n1$ (关键在于& ,可以让后面//匹配到空行)
            //D;            　　　　　　# D 命令会引起循环删除模式空间中的第一部分，如果删除后，模式空间中还有剩余行，则返回 D 之前的命令，重新执行，如果 D 后，模式空间中没有任何内容，则将退出。  //D 匹配空行执行D,如果上句s没有匹配到,//也无法匹配到空行, "//D;"命令结束
            s/.//;          　　　　　　# D结束后,删除开头的 \n
        }
    }
    xargs{
        # 命令替换
        -t 先打印命令，然后再执行
        -i 用每项替换 {}
        find / -perm +7000 | xargs ls -l                    # 将前面的内容，作为后面命令的参数
        seq 1 10 |xargs  -i date -d "{} days " +%Y-%m-%d    # 列出10天日期
    }
    dialog菜单{
        # 默认将所有输出用 stderr 输出，不显示到屏幕   使用参数  --stdout 可将选择赋给变量
        # 退出状态  0正确  1错误
        窗体类型{
            --calendar          # 日历
            --checklist         # 允许你显示一个选项列表，每个选项都可以被单独的选择 (复选框)
            --form              # 表单,允许您建立一个带标签的文本字段，并要求填写
            --fselect           # 提供一个路径，让你选择浏览的文件
            --gauge             # 显示一个表，呈现出完成的百分比，就是显示出进度条。
            --infobox           # 显示消息后，（没有等待响应）对话框立刻返回，但不清除屏幕(信息框)
            --inputbox          # 让用户输入文本(输入框)
            --inputmenu         # 提供一个可供用户编辑的菜单（可编辑的菜单框）
            --menu              # 显示一个列表供用户选择(菜单框)
            --msgbox(message)   # 显示一条消息,并要求用户选择一个确定按钮(消息框)
            --password          # 密码框，显示一个输入框，它隐藏文本
            --pause             # 显示一个表格用来显示一个指定的暂停期的状态
            --radiolist         # 提供一个菜单项目组，但是只有一个项目，可以选择(单选框)
            --tailbox           # 在一个滚动窗口文件中使用tail命令来显示文本
            --tailboxbg         # 跟tailbox类似，但是在background模式下操作
            --textbox           # 在带有滚动条的文本框中显示文件的内容  (文本框)
            --timebox           # 提供一个窗口，选择小时，分钟，秒
            --yesno(yes/no)     # 提供一个带有yes和no按钮的简单信息框
        }
        窗体参数{
            --separate-output          # 对于chicklist组件,输出结果一次输出一行,得到结果不加引号
            --ok-label "提交"          # 确定按钮名称
            --cancel-label "取消"      # 取消按钮名称
            --title "标题"             # 标题名称
            --stdout                   # 将所有输出用 stdout 输出
            --backtitle "上标"         # 窗体上标
            --no-shadow                # 去掉窗体阴影
            --menu "菜单名" 20 60 14   # 菜单及窗口大小
            --clear                    # 完成后清屏操作
            --no-cancel                # 不显示取消项
            --insecure                 # 使用星号来代表每个字符
            --begin <y> <x>            # 指定对话框左上角在屏幕的上的做坐标
            --timeout <秒>             # 超时,返回的错误代码255,如果用户在指定的时间内没有给出相应动作,就按超时处理
            --defaultno                # 使选择默认为no
            --default-item <str>       # 设置在一份清单，表格或菜单中的默认项目。通常在框中的第一项是默认
            --sleep 5                  # 在处理完一个对话框后静止(延迟)的时间(秒)
            --max-input size           # 限制输入的字符串在给定的大小之内。如果没有指定，默认是2048
            --keep-window              # 退出时不清屏和重绘窗口。当几个组件在同一个程序中运行时，对于保留窗口内容很有用的
        }
        dialog --title "Check me" --checklist "Pick Numbers" 15 25 3 1 "one" "off" 2 "two" "on"         # 多选界面[方括号]
        dialog --title "title" --radiolist "checklist" 20 60 14 tag1 "item1" on tag2 "item2" off        # 单选界面(圆括号)
        dialog --title "title" --menu "MENU" 20 60 14 tag1 "item1" tag2 "item2"                         # 单选界面
        dialog --title "Installation" --backtitle "Star Linux" --gauge "Linux Kernel"  10 60 50         # 进度条
        dialog --title "标题" --backtitle "Dialog" --yesno "说明" 20 60                                 # 选择yes/no
        dialog --title "公告标题" --backtitle "Dialog" --msgbox "内容" 20 60                            # 公告
        dialog --title "hey" --backtitle "Dialog" --infobox "Is everything okay?" 10 60                 # 显示讯息后立即离开
        dialog --title "hey" --backtitle "Dialog" --inputbox "Is okay?" 10 60 "yes"                     # 输入对话框
        dialog --title "Array 30" --backtitle "All " --textbox /root/txt 20 75                          # 显示文档内容
        dialog --title "Add" --form "input" 12 40 4 "user" 1 1 "" 1 15 15 0 "name" 2 1 "" 2 15 15 0     # 多条输入对话框
        dialog --title  "Password"  --insecure  --passwordbox  "请输入密码"  10  35                     # 星号显示输入--insecure
        dialog --stdout --title "日历"  --calendar "请选择" 0 0 9 1 2010                                # 选择日期
        dialog --title "title" --menu "MENU" 20 60 14 tag1 "item1" tag2 "item2" 2>tmp                   # 取到结果放到文件中(以标准错误输出结果)
        a=`dialog --title "title"  --stdout --menu "MENU" 20 60 14 tag1 "item1" tag2 "item2"`           # 选择操作赋给变量(使用标准输出)
        dialog菜单实例{
            while :
            do
            clear
            menu=`dialog --title "title"  --stdout --menu "MENU" 20 60 14 1 system 2 custom`
            [ $? -eq 0 ] && echo "$menu" || exit         # 判断dialog执行,取消退出
                while :
                do
                    case $menu in
                    1)
                        list="1a "item1" 2a "item2""     # 定义菜单列表变量
                    ;;
                    2)
                        list="1b "item3" 2b "item4""
                    ;;
                    esac
                    result=`dialog --title "title"  --stdout --menu "MENU" 20 60 14 $list`
                    [ $? -eq 0 ] && echo "$result" || break    # 判断dialog执行,取消返回菜单,注意:配合上层菜单循环
                    read
                done
            done
        }
    }
    select菜单{
        # 输入项不在菜单自动会提示重新输入
        select menuitem in pick1 pick2 pick3 退出
        do
            echo $menuitem
            case $menuitem in
            退出)
                exit
            ;;
            *)
                select area in area1 area2 area3 返回
                do
                    echo $area
                    case $area in
                    返回)
                        break
                    ;;
                    *)
                        echo "对$area操作"
                    ;;
                    esac
                done
            ;;
            esac
        done
    }
    shift{
        ./cs.sh 1 2 3
        #!/bin/sh
        until [ $# -eq 0 ]
        do
            echo "第一个参数为: $1 参数个数为: $#"
            #shift 命令执行前变量 $1 的值在shift命令执行后不可用
            shift
        done
    }
    getopts给脚本加参数{
        #!/bin/sh
        while getopts :ab: name
        do
            case $name in
            a)
                aflag=1
            ;;
            b)
                bflag=1
                bval=$OPTARG
            ;;
            \?)
                echo "USAGE:`basename $0` [-a] [-b value]"
                exit  1
            ;;
            esac
        done
        if [ ! -z $aflag ] ; then
            echo "option -a specified"
            echo "$aflag"
            echo "$OPTIND"
        fi
        if [ ! -z $bflag ] ; then
            echo  "option -b specified"
            echo  "$bflag"
            echo  "$bval"
            echo  "$OPTIND"
        fi
        echo "here  $OPTIND"
        shift $(($OPTIND -1))
        echo "$OPTIND"
        echo " `shift $(($OPTIND -1))`  "
    }
    tclsh{
        set foo "a bc"                   # 定义变量
        set b {$a};                      # 转义  b的值为" $a " ,而不是变量结果
        set a 3; incr a 3;               # 数字的自增.  将a加3,如果要减3,则为 incr a –3;
        set c [expr 20/5];               # 计算  c的值为4
        puts $foo;                       # 打印变量
        set qian(123) f;                 # 定义数组
        set qian(1,1,1) fs;              # 多维数组
        parray qian;                     # 打印数组的所有信息
        string length $qian;             # 将返回变量qian的长度
        string option string1 string2;   # 字符相关串操作
        # option 的操作选项:
        # compare           按照字典的排序方式进行比较。根据string1 <,=,>string2分别返回-1,0,1
        # first             返回string2中第一次出现string1的位置，如果没有出现string1则返回-1
        # last              和first相反
        # trim              从string1中删除开头和结尾的出现在string2中的字符
        # tolower           返回string1中的所有字符被转换为小写字符后的新字符串
        # toupper           返回string1中的所有字符串转换为大写后的字符串
        # length            返回string1的长度
        set a 1;while {$a < 3} { set a [incr a 1;]; };puts $a    # 判断变量a小于3既循环
        for {initialization} {condition} {increment} {body}      # 初始化变量,条件,增量,具体操作
        for {set i 0} {$i < 10} {incr i} {puts $i;}              # 将打印出0到9
        if { 表达式 } {
             #运算;
        } else {
             #其他运算;
        }
        switch $x {
            字符串1 { 操作1 ;}
            字符串2 { 操作2 ;}
        }
        foreach element {0 m n b v} {
        # 将在一组变元中进行循环，并且每次都将执行他的循环体
               switch $element {
                     # 判断element的值
             }
        }
        expect交互{
            exp_continue         # 多个spawn命令时并行
            interact             # 执行完成后保持交互状态，把控制权交给控制台
            expect "password:"   # 判断关键字符
            send "passwd\r"      # 执行交互动作，与手工输入密码的动作等效。字符串结尾加"\r"
            ssh后sudo{
                #!/bin/bash
                #sudo注释下行允许后台运行
                #Defaults requiretty
                #sudo去掉!允许远程
                #Defaults !visiblepw
                /usr/bin/expect -c '
                set timeout 5
                spawn ssh -o StrictHostKeyChecking=no xuesong1@192.168.42.128 "sudo grep xuesong1 /etc/passwd"
                expect {
                    "passphrase" {
                        send_user "sshkey\n"
                        send "xuesong\r";
                        expect {
                            "sudo" {
                            send_user "sudo\n"
                            send "xuesong\r"
                            interact
                            }
                            eof {
                            send_user "sudo eof\n"
                            }
                        }
                    }
                    "password:" {
                        send_user "ssh\n"
                        send "xuesong\r";
                        expect {
                            "sudo" {
                            send_user "sudo\n"
                            send "xuesong\r"
                            interact
                            }
                            eof {
                            send_user "sudo eof\n"
                            }
                        }
                    }
                    "sudo" {
                            send_user "sudo\n"
                            send "xuesong\r"
                            interact
                            }
                    eof {
                        send_user "ssh eof\n"
                    }
                }
                '
            }
            ssh执行命令操作{
                /usr/bin/expect -c "
                proc jiaohu {} {
                    send_user expect_start
                    expect {
                        password {
                            send ${RemotePasswd}\r;
                            send_user expect_eof
                            expect {
                                \"does not exist\" {
                                    send_user expect_failure
                                    exit 10
                                }
                                password {
                                    send_user expect_failure
                                    exit 5
                                }
                                Password {
                                    send ${RemoteRootPasswd}\r;
                                    send_user expect_eof
                                    expect {
                                        incorrect {
                                            send_user expect_failure
                                            exit 6
                                        }
                                        eof
                                    }
                                }
                                eof
                            }
                        }
                        passphrase {
                            send ${KeyPasswd}\r;
                            send_user expect_eof
                            expect {
                                \"does not exist\" {
                                    send_user expect_failure
                                    exit 10
                                }
                                passphrase{
                                    send_user expect_failure
                                    exit 7
                                }
                                Password {
                                    send ${RemoteRootPasswd}\r;
                                    send_user expect_eof
                                    expect {
                                        incorrect {
                                            send_user expect_failure
                                            exit 6
                                        }
                                        eof
                                    }
                                }
                                eof
                            }
                        }
                        Password {
                            send ${RemoteRootPasswd}\r;
                            send_user expect_eof
                            expect {
                                incorrect {
                                    send_user expect_failure
                                    exit 6
                                }
                                eof
                            }
                        }
                        \"No route to host\" {
                            send_user expect_failure
                            exit 4
                        }
                        \"Invalid argument\" {
                            send_user expect_failure
                            exit 8
                        }
                        \"Connection refused\" {
                            send_user expect_failure
                            exit 9
                        }
                        \"does not exist\" {
                            send_user expect_failure
                            exit 10
                        }
                        \"Connection timed out\" {
                            send_user expect_failure
                            exit 11
                        }
                        timeout {
                            send_user expect_failure
                            exit 3
                        }
                        eof
                    }
                }
                set timeout $TimeOut
                switch $1 {
                    Ssh_Cmd {
                        spawn ssh -t -p $Port -o StrictHostKeyChecking=no $RemoteUser@$Ip /bin/su - root -c \\\"$Cmd\\\"
                        jiaohu
                    }
                    Ssh_Script {
                        spawn scp -P $Port -o StrictHostKeyChecking=no $ScriptPath $RemoteUser@$Ip:/tmp/${ScriptPath##*/};
                        jiaohu
                        spawn ssh -t -p $Port -o StrictHostKeyChecking=no $RemoteUser@$Ip /bin/su - root -c  \\\"/bin/sh /tmp/${ScriptPath##*/}\\\" ;
                        jiaohu
                    }
                    Scp_File {
                        spawn scp -P $Port -o StrictHostKeyChecking=no -r $ScpPath $RemoteUser@$Ip:${ScpRemotePath};
                        jiaohu
                    }
                }
                "
                state=`echo $?`
            }
            交互双引号引用较长变量{
                #!/bin/bash
                RemoteUser=xuesong12
                Ip=192.168.1.2
                RemotePasswd=xuesong
                Cmd="/bin/echo "$PubKey" > "$RemoteKey"/authorized_keys"
                /usr/bin/expect -c "
                set timeout 10
                spawn ssh -o StrictHostKeyChecking=no $RemoteUser@$Ip {$Cmd};
                expect {
                    password: {
                        send_user RemotePasswd\n
                        send ${RemotePasswd}\r;
                        interact;
                    }
                    eof {
                        send_user eof\n
                    }
                }
                "
            }
            telnet交互{
                #!/bin/bash
                Ip="10.0.1.53"
                a="\{\'method\'\:\'doLogin\'\,\'params\'\:\{\'uName\'\:\'bobbietest\'\}"
                /usr/bin/expect -c"
                        set timeout 15
                        spawn telnet ${Ip} 8000
                        expect "Escape"
                        send "${a}\\r"
                        expect {
                                -re "\"err.*none\"" {
                                        exit 0
                                }
                                timeout {
                                        exit 1
                                }
                                eof {
                                        exit 2
                                }
                        }
                "
                echo $?
            }
            模拟ssh登录{
                #好处:可加载环境变量
                #!/bin/bash
                Ip='192.168.1.6'            # 循环就行
                RemoteUser='user'           # 普通用户
                RemotePasswd='userpasswd'   # 普通用户的密码
                RemoteRootPasswd='rootpasswd'
                /usr/bin/expect -c "
                set timeout -1
                spawn ssh -t -p $Port -o StrictHostKeyChecking=no $RemoteUser@$Ip
                expect {
                    password {
                        send_user RemotePasswd
                        send ${RemotePasswd}\r;
                        expect {
                            \"does not exist\" {
                                send_user \"root user does not exist\n\"
                                exit 10
                            }
                            password {
                                send_user \"user passwd error\n\"
                                exit 5
                            }
                            Last {
                                send \"su - batch\n\"
                                expect {
                                    Password {
                                        send_user RemoteRootPasswd
                                        send ${RemoteRootPasswd}\r;
                                        expect {
                                            \"]#\" {
                                                send \"sh /tmp/update.sh update\n \"
                                                expect {
                                                    \"]#\" {
                                                        send_user ${Ip}_Update_Done\n
                                                    }
                                                    eof
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    \"No route to host\" {
                        send_user \"host not found\n\"
                        exit 4
                    }
                    \"Invalid argument\" {
                        send_user \"incorrect parameter\n\"
                        exit 8
                    }
                    \"Connection refused\" {
                        send_user \"invalid port parameters\n\"
                        exit 9
                    }
                    \"does not exist\" {
                        send_user \"root user does not exist\"
                        exit 10
                    }
                    timeout {
                        send_user \"connection timeout \n\"
                        exit 3
                    }
                    eof
                }
                "
                state=`echo $?`
            }
        }
    }
}
9 实例{
    从1叠加到100{
        echo $[$(echo +{1..100})]
        echo $[(100+1)*(100/2)]
        seq -s '+' 100 |bc
    }
    判断参数是否为空-空退出并打印null{
        #!/bin/sh
        echo $1
        name=${1:?"null"}
        echo $name
    }
    循环数组{
        for ((i=0;i<${#o[*]};i++))
        do
            echo ${o[$i]}
        done
    }
    判断路径{
        if [ -d /root/Desktop/text/123 ];then
            echo "找到了123"
            if [ -d /root/Desktop/text ]
            then echo "找到了text"
            else echo "没找到text"
            fi
        else echo "没找到123文件夹"
        fi
    }
    找出出现次数最多{
        awk '{print $1}' file|sort |uniq -c|sort -k1r
    }
    判断脚本参数是否正确{
        ./test.sh  -p 123 -P 3306 -h 127.0.0.1 -u root
        #!/bin/sh
        if [ $# -ne 8 ];then
            echo "USAGE: $0 -u user -p passwd -P port -h host"
            exit 1
        fi
        while getopts :u:p:P:h: name
        do
            case $name in
            u)
                mysql_user=$OPTARG
            ;;
            p)
                mysql_passwd=$OPTARG
            ;;
            P)
                mysql_port=$OPTARG
            ;;
            h)
                mysql_host=$OPTARG
            ;;
            *)
                echo "USAGE: $0 -u user -p passwd -P port -h host"
                exit 1
            ;;
            esac
        done
        if [ -z $mysql_user ] || [ -z $mysql_passwd ] || [ -z $mysql_port ] || [ -z $mysql_host ]
        then
            echo "USAGE: $0 -u user -p passwd -P port -h host"
            exit 1
        fi
        echo $mysql_user $mysql_passwd $mysql_port  $mysql_host
        #结果 root 123 3306 127.0.0.1
    }
    正则匹配邮箱{
        ^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$
    }
    打印表格{
        #!/bin/sh
        clear
        awk 'BEGIN{
        print "+--------------------+--------------------+";
        printf "|%-20s|%-20s|\n","Name","Number";
        print "+--------------------+--------------------+";
        }'
        a=`grep "^[A-Z]" a.txt |sort +1 -n |awk '{print $1":"$2}'`
        #cat a.txt |sort +1 -n |while read list
        for list in $a
        do
            name=`echo $list |awk -F: '{print $1}'`
            number=`echo $list |awk -F: '{print $2}'`
            awk 'BEGIN{printf "|%-20s|%-20s|\n","'"$name"'","'"$number"'";
            print "+--------------------+--------------------+";
            }'
        done
        awk 'BEGIN{
        print "              *** The End ***              "
        print "                                           "
        }'
    }
    判断日期是否合法{
        #!/bin/sh
        while read a
        do
          if echo $a | grep -q "-" && date -d $a +%Y%m%d > /dev/null 2>&1
          then
            if echo $a | grep -e '^[0-9]\{4\}-[01][0-9]-[0-3][0-9]$'
            then
                break
            else
                echo "您输入的日期不合法，请从新输入！"
            fi
          else
            echo "您输入的日期不合法，请从新输入！"
          fi
        done
        echo "日期为$a"
    }
    打印日期段所有日期{
        #!/bin/bash
        qsrq=20010101
        jsrq=20010227
        n=0
        >tmp
        while :;do
        current=$(date +%Y%m%d -d"$n day $qsrq")
        if [[ $current == $jsrq ]];then
            echo $current >>tmp;break
        else
            echo $current >>tmp
            ((n++))
        fi
        done
        rq=`awk 'NR==1{print}' tmp`
    }
    打印提示{
        cat <<EOF
        #内容
EOF
        }
    登陆远程执行命令{
        # 特殊符号需要 \ 转义
        ssh root@ip << EOF
        #执行命令
EOF
        }
    数学计算的小算法{
        #!/bin/sh
        A=1
        B=1
        while [ $A -le 10 ]
        do
            SUM=`expr $A \* $B`
            echo "$SUM"
            if [ $A = 10 ]
            then
                B=`expr $B + 1`
                A=1
            fi
            A=`expr $A + 1`
        done
    }
    多行合并{
        sed '{N;s/\n//}' file                   # 将两行合并一行(去掉换行符)
        awk '{printf(NR%2!=0)?$0" ":$0" \n"}'   # 将两行合并一行
        awk '{printf"%s ",$0}'                  # 将所有行合并
        awk '{if (NR%4==0){print $0} else {printf"%s ",$0}}' file    # 将4行合并为一行(可扩展)
    }
    横竖转换{
        cat a.txt | xargs           # 列转行
        cat a.txt | xargs -n1       # 行转列
    }
    竖行转横行{
        cat file|tr '\n' ' '
        echo $(cat file)
        #!/bin/sh
        for i in `cat file`
        do
              a=${a}" "${i}
        done
        echo $a
    }
    取用户的根目录{
        #! /bin/bash
        while read name pass uid gid gecos home shell
        do
            echo $home
        done < /etc/passwd
    }
    远程打包{
        ssh -n $ip 'find '$path' /data /opt -type f  -name "*.sh" -or -name "*.py" -or -name "*.pl" |xargs tar zcvpf /tmp/data_backup.tar.gz'
    }
    把汉字转成encode格式{
        echo 论坛 | tr -d "\n" | xxd -i | sed -e "s/ 0x/%/g" | tr -d " ,\n"
        %c2%db%cc%b3
        echo 论坛 | tr -d "\n" | xxd -i | sed -e "s/ 0x/%/g" | tr -d " ,\n" | tr "[a-f]" "[A-F]"  # 大写的
        %C2%DB%CC%B3
    }
    把目录带有大写字母的文件名改为全部小写{
        #!/bin/bash
        for f in *;do
            mv $f `echo $f |tr "[A-Z]" "[a-z]"`
        done
    }
    查找连续多行，在不连续的行前插入{
        #/bin/bash
        lastrow=null
        i=0
        cat incl|while read line
        do
        i=`expr $i + 1`
        if echo "$lastrow" | grep "#include <[A-Z].h>"
        then
            if echo "$line" | grep -v  "#include <[A-Z].h>"
            then
                sed -i ''$i'i\\/\/All header files are include' incl
                i=`expr $i + 1`
            fi
        fi
        lastrow="$line"
        done
    }
    查询数据库其它引擎{
        #/bin/bash
        path1=/data/mysql/data/
        dbpasswd=db123
        #MyISAM或InnoDB
        engine=InnoDB
        if [ -d $path1 ];then
        dir=`ls -p $path1 |awk '/\/$/'|awk -F'/' '{print $1}'`
            for db in $dir
            do
            number=`mysql -uroot -p$dbpasswd -A -S "$path1"mysql.sock -e "use ${db};show table status;" |grep -c $engine`
                if [ $number -ne 0 ];then
                echo "${db}"
                fi
            done
        fi
    }
    批量修改数据库引擎{
        #/bin/bash
        for db in test test1 test3
        do
            tables=`mysql -uroot -pdb123 -A -S /data/mysql/data/mysql.sock -e "use $db;show tables;" |awk 'NR != 1{print}'`
            for table in $tables
            do
                mysql -uroot -pdb123 -A -S /data/mysql/data/mysql.sock -e "use $db;alter table $table engine=MyISAM;"
            done
        done
    }
    将shell取到的数据插入mysql数据库{
        mysql -u$username -p$passwd -h$dbhost -P$dbport -A -e "
        use $dbname;
        insert into data values ('','$ip','$date','$time','$data')
        "
    }
    两日期间隔天数{
        D1=`date -d '20070409' +"%s"`
        D2=`date -d '20070304 ' +"%s"`
        D3=$(($D1 - $D2))
        echo $(($D3/60/60/24))
    }
    while执行ssh只循环一次{
        cat -    # 让cat读连接文件stdin的信息
        seq 10 | while read line; do ssh localhost "cat -"; done        # 显示的9次是被ssh吃掉的
        seq 10 | while read line; do ssh -n localhost "cat -"; done     # ssh加上-n参数可避免只循环一次
    }
    ssh批量执行命令{
        #版本1
        #!/bin/bash
        while read line
        do
        Ip=`echo $line|awk '{print $1}'`
        Passwd=`echo $line|awk '{print $2}'`
        ssh -n localhost "cat -"
        sshpass -p "$Passwd" ssh -n -t -o StrictHostKeyChecking=no root@$Ip "id"
        done<iplist.txt
        #版本2
        #!/bin/bash
        Iplist=`awk '{print $1}' iplist.txt`
        for Ip in $Iplist
        do
        Passwd=`awk '/'$Ip'/{print $2}' iplist.txt`
        sshpass -p "$Passwd" ssh -n -t -o StrictHostKeyChecking=no root@$Ip "id"
        done
    }
    在同一位置打印字符{
        #!/bin/bash
        echo -ne "\t"
        for i in `seq -w 100 -1 1`
        do
            echo -ne "$i\b\b\b";      # 关键\b退格
            sleep 1;
        done
    }
    多进程后台并发简易控制{
        #!/bin/bash
        test () {
            echo $a
            sleep 5
        }
        for a in `seq 1 30`
        do
            test &
            echo $!
            ((num++))
            if [ $num -eq 6 ];then
            echo "wait..."
            wait
            num=0
            fi
        done
        wait
    }
    shell并发{
        #!/bin/bash
        tmpfile=$$.fifo   # 创建管道名称
        mkfifo $tmpfile   # 创建管道
        exec 4<>$tmpfile  # 创建文件标示4，以读写方式操作管道$tmpfile
        rm $tmpfile       # 将创建的管道文件清除
        thred=4           # 指定并发个数
        seq=(1 2 3 4 5 6 7 8 9 21 22 23 24 25 31 32 33 34 35) # 创建任务列表
        # 为并发线程创建相应个数的占位
        {
        for (( i = 1;i<=${thred};i++ ))
        do
            echo;  # 因为read命令一次读取一行，一个echo默认输出一个换行符，所以为每个线程输出一个占位换行
        done
        } >&4      # 将占位信息写入管道
        for id in ${seq}  # 从任务列表 seq 中按次序获取每一个任务
        do
          read  # 读取一行，即fd4中的一个占位符
          (./ur_command ${id};echo >&4 ) &   # 在后台执行任务ur_command 并将任务 ${id} 赋给当前任务；任务执行完后在fd4种写入一个占位符
        done <&4    # 指定fd4为整个for的标准输入
        wait        # 等待所有在此shell脚本中启动的后台任务完成
        exec 4>&-   # 关闭管道
        #!/bin/bash
        FifoFile="$$.fifo"
        mkfifo $FifoFile
        exec 6<>$FifoFile
        rm $FifoFile
        for ((i=0;i<=20;i++));do echo;done >&6
        for u in `seq 1 $1`
        do
            read -u6
            {
                curl -s http://ch.com >>/dev/null
                [ $? -eq 0 ] && echo "${u} 次成功" || echo "${u} 次失败"
                echo >&6
            } &
        done
        wait
        exec 6>&-
    }
    shell并发函数{
        function ConCurrentCmd()
        {
            #进程数
            Thread=30
            #列表文件
            CurFileName=iplist.txt
            #定义fifo文件
            FifoFile="$$.fifo"
            #新建一个fifo类型的文件
            mkfifo $FifoFile
            #将fd6与此fifo类型文件以读写的方式连接起来
            exec 6<>$FifoFile
            rm $FifoFile
            #事实上就是在文件描述符6中放置了$Thread个回车符
            for ((i=0;i<=$Thread;i++));do echo;done >&6
            #此后标准输入将来自fd5
            exec 5<$CurFileName
            #开始循环读取文件列表中的行
            Count=0
            while read -u5 line
            do
                read -u6
                let Count+=1
                # 此处定义一个子进程放到后台执行
                # 一个read -u6命令执行一次,就从fd6中减去一个回车符，然后向下执行
                # fd6中没有回车符的时候,就停在这了,从而实现了进程数量控制
                {
                    echo $Count
                    #这段代码框就是执行具体的操作了
                    function
                    echo >&6
                    #当进程结束以后,再向fd6中追加一个回车符,即补上了read -u6减去的那个
                } &
            done
            #等待所有后台子进程结束
            wait
            #关闭fd6
            exec 6>&-
            #关闭fd5
            exec 5>&-
        }
        并发例子{
            #!/bin/bash
            FifoFile="$$.fifo"
            mkfifo $FifoFile
            exec 6<>$FifoFile
            rm $FifoFile
            for ((i=0;i<=20;i++));do echo;done >&6
            for u in `seq 1 $1`
            do
                read -u6
                {
                    curl -s http://m.chinanews.com/?tt_from=shownews >>/dev/null
                    [ $? -eq 0 ] && echo "${u} 次成功" || echo "${u} 次失败"
                    echo >&6
                } &
            done
            wait
            exec 6>&-
        }
    }
    函数{
        ip(){
            echo "a 1"|awk '$1=="'"$1"'"{print $2}'
        }
        web=a
        ip $web
    }
    检测软件包是否存在{
        rpm -q dialog >/dev/null
        if [ "$?" -ge 1 ];then
            echo "install dialog,Please wait..."
            yum -y install dialog
            rpm -q dialog >/dev/null
            [ $? -ge 1 ] && echo "dialog installation failure,exit" && exit
            echo "dialog done"
            read
        fi
    }
    游戏维护菜单-修改配置文件{
        #!/bin/bash
        conf=serverlist.xml
        AreaList=`awk -F '"' '/<s/{print $2}' $conf`
        select area in $AreaList 全部 退出
        do
            echo ""
            echo $area
            case $area in
            退出)
                exit
            ;;
            *)
                select operate in "修改版本号" "添加维护中" "删除维护中" "返回菜单"
                do
                    echo ""
                    echo $operate
                    case $operate in
                    修改版本号)
                        echo 请输入版本号
                        while read version
                        do
                            if echo $version | grep -w 10[12][0-9][0-9][0-9][0-9][0-9][0-9]
                            then
                                break
                            fi
                            echo 请从新输入正确的版本号
                        done
                        case $area in
                        全部)
                            case $version in
                            101*)
                                echo "请确认操作对 $area 体验区 $operate"
                                read
                                sed -i 's/101[0-9][0-9][0-9][0-9][0-9][0-9]/'$version'/' $conf
                            ;;
                            102*)
                                echo "请确认操作对 $area 正式区 $operate"
                                read
                                sed -i 's/102[0-9][0-9][0-9][0-9][0-9][0-9]/'$version'/' $conf
                            ;;
                            esac
                        ;;
                        *)
                            type=`awk -F '"' '/'$area'/{print $14}' $conf |cut -c1-3`
                            readtype=`echo $version |cut -c1-3`
                            if [ $type != $readtype ]
                            then
                                echo "版本号不对应，请从新操作"
                                continue
                            fi
                            echo "请确认操作对 $area 区 $operate"
                            read
                            awk -F '"' '/'$area'/{print $12}' $conf |xargs -i sed -i '/'{}'/s/10[12][0-9][0-9][0-9][0-9][0-9][0-9]/'$version'/' $conf
                        ;;
                        esac
                    ;;
                    添加维护中)
                        case $area in
                        全部)
                            echo "请确认操作对 $area 区 $operate"
                            read
                            awk -F '"' '/<s/{print $2}' $conf |xargs -i sed -i 's/'{}'/&维护中/' $conf
                        ;;
                        *)
                            echo "请确认操作对 $area 区 $operate"
                            read
                            sed -i 's/'$area'/&维护中/' $conf
                        ;;
                        esac
                    ;;
                    删除维护中)
                        case $area in
                        全部)
                            echo "请确认操作对 $area 区 $operate"
                            read
                            sed -i 's/维护中//' $conf
                        ;;
                        *)
                            echo "请确认操作对 $area 区 $operate"
                            read
                            sed -i '/'$area'/s/维护中//' $conf
                        ;;
                        esac
                    ;;
                    返回菜单)
                        break
                    ;;
                    esac
                done
            ;;
            esac
            echo "回车重新选择区"
        done
    }
    keepalive剔除后端服务{
        #!/bin/bash
        #行数请自定义,默认8行
        if [ X$2 == X ];then
            echo "error: IP null"
            read
            exit
        fi
        case $1 in
        del)
            sed -i '/real_server.*'$2'.*8888/,+8 s/^/#/' /etc/keepalived/keepalived.conf
            /etc/init.d/keepalived reload
        ;;
        add)
            sed -i '/real_server.*'$2'.*8888/,+8 s/^#//' /etc/keepalived/keepalived.conf
            /etc/init.d/keepalived reload
        ;;
        *)
            echo "Parameter error"
        ;;
        esac
    }
    申诉中国反垃圾邮件联盟黑名单{
        #!/bin/bash
        IpList=`awk '$1!~"^#"&&$1!=""{print $1}' host.list`
        QueryAdd='http://www.anti-spam.org.cn/Rbl/Query/Result'
        ComplaintAdd='http://www.anti-spam.org.cn/Rbl/Getout/Submit'
        CONTENT='我们是一家正规的XXX。xxxxxxx。恳请将我们的发送服务器IP移出黑名单。谢谢！
        处理措施：
        1.XXXX。
        2.XXXX。'
        CORP='abc.com'
        WWW='www.abc.cm'
        NAME='def'
        MAIL='def@163.com.cn'
        TEL='010-50000000'
        LEVEL='0'
        for Ip in $IpList
        do
            Status=`curl -d "IP=$Ip" $QueryAdd |grep 'Getout/ShowForm?IP=' |grep -wc '申诉脱离'`
            if [ $Status -ge 1 ];then
                IpStatus="黑名单中"
                results=`curl -d "IP=${Ip}&CONTENT=${CONTENT}&CORP=${CORP}&WWW=${WWW}&NAME=${NAME}&MAIL=${MAIL}&TEL=${TEL}&LEVEL=${LEVEL}" $ComplaintAdd |grep -E '您的黑名单脱离申请已提交|该IP的脱离申请已被他人提交|申请由于近期内有被拒绝的记录'`
                echo $results
                if echo $results | grep '您的黑名单脱离申请已提交'  > /dev/null 2>&1
                then
                    complaint='申诉成功'
                elif echo $results | grep '该IP的脱离申请已被他人提交'  > /dev/null 2>&1
                then
                    complaint='申诉重复'
                elif echo $results | grep '申请由于近期内有被拒绝的记录'  > /dev/null 2>&1
                then
                    complaint='申诉拒绝'
                else
                    complaint='异常'
                fi
            else
                IpStatus='正常'
                complaint='无需申诉'
            fi
            echo "$Ip    $IpStatus    $complaint" >> $(date +%Y%m%d_%H%M%S).log
        done
}
    Web Server in Awk{
        #gawk -f file
        BEGIN {
          x        = 1                         # script exits if x < 1
          port     = 8080                      # port number
          host     = "/inet/tcp/" port "/0/0"  # host string
          url      = "http://localhost:" port  # server url
          status   = 200                       # 200 == OK
          reason   = "OK"                      # server response
          RS = ORS = "\r\n"                    # header line terminators
          doc      = Setup()                   # html document
          len      = length(doc) + length(ORS) # length of document
          while (x) {
             if ($1 == "GET") RunApp(substr($2, 2))
             if (! x) break
             print "HTTP/1.0", status, reason |& host
             print "Connection: Close"        |& host
             print "Pragma: no-cache"         |& host
             print "Content-length:", len     |& host
             print ORS doc                    |& host
             close(host)     # close client connection
             host |& getline # wait for new client request
          }
          # server terminated...
          doc = Bye()
          len = length(doc) + length(ORS)
          print "HTTP/1.0", status, reason |& host
          print "Connection: Close"        |& host
          print "Pragma: no-cache"         |& host
          print "Content-length:", len     |& host
          print ORS doc                    |& host
          close(host)
        }
        function Setup() {
          tmp = "<html>\
          <head><title>Simple gawk server</title></head>\
          <body>\
          <p><a href=" url "/xterm>xterm</a>\
          <p><a href=" url "/xcalc>xcalc</a>\
          <p><a href=" url "/xload>xload</a>\
          <p><a href=" url "/exit>terminate script</a>\
          </body>\
          </html>"
          return tmp
        }
        function Bye() {
          tmp = "<html>\
          <head><title>Simple gawk server</title></head>\
          <body><p>Script Terminated...</body>\
          </html>"
          return tmp
        }
        function RunApp(app) {
          if (app == "xterm")  {system("xterm&"); return}
          if (app == "xcalc" ) {system("xcalc&"); return}
          if (app == "xload" ) {system("xload&"); return}
          if (app == "exit")   {x = 0}
        }
    }
}
