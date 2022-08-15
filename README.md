# Mchat

IRC like chat client.

![preview](./assets/preview.png)

## Installation


install it yourself as:

    $ gem install mchat

## Usage

```ruby
# enter mchat
mchat

# /h for help
/h
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).



----

# Features

### repl

* [x] repl主流程
* [x] 命令模块化
* [x] help 命令
* [x] channel 命令
* [x] join 命令
* [x] name 命令
* [x] message 命令
* [x] leave 命令
* [x] quit 命令
* [x] clear 命令
* [x] default mode
* [x] boss mode
* [x] 存储 Pstore 实现取代文件
### timeline

* [x] timeline 独立
* [x] 支持简单命令
* [x] hook_quit

### union

* [x] 联合打开screen window
* [x] 联合关闭


### TODO features

* [ ] 密码登录用户，超级管理员
* [ ] 密码登录channel
* [x] 创建频道
* [x] 配置化
~~* [ ] temp~~
* [ ] 日志
~~* [ ] 优化代码，现在太分散~~
~~* [ ] 是否要实现一个 tail 包装命令~~
* [x] 打包下载
* [ ] README update HOWTO
* [x] 指令插件化
* [ ] set 命令
* [ ] 打字机效果(需要单独的渲染，不可以文件输出)
* [ ] eval 增加连续组合命令
* [ ] 可以封装在docker里
* [ ] 合理化初始化参数
* [ ] config 三个 path 和dir 部分处理
* [x] cli 关闭通知timeline关闭
* [ ] 加密消息
