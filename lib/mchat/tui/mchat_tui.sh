# 使用Screen

# 左边文件读取记录，实现读取的信息流
# 右边是命令行，实现输入的控制流
# 这样组合来完成应用的交互形态

# https://www.gnu.org/software/screen/manual/screen.html#Split

# screenrc 里面写的就是 文档里面的命令
# split 是默认上下  split -v 是左右
# focus 是永远关注在下一个（cycle来工作的） 对应按键  C-a Tab

# -c 读取配置
screen -c './screenrc'

