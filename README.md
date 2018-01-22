# koa2-coffee 一个基于coffee + mongoose + koa2 的服务端项目简单框架、demo

## 安装、使用
- 系统环境要求 node v7.6.0 或者更高版本
- 下载源代码
```
$ git clone https://github.com/jixl/koa2-coffee.git
```
- 目录结构
```
koa2-coffee
  |--app 框架程序目录
      |--lib 公用自定义类库
          |--index.coffee
          |--mongo-base.coffee
          |--mongoose.coffee
      |--middleware 中间件
          |--index.coffee
      |--model 模型定义
          |--index.coffee
      |--myutil 常用函数、常量
          |--index.coffee
      |--service 服务
          |--base.coffee
          |--index.coffee
          |--user.coffee
      |--router.coffee 路由
  |--docs 文档目录
  |--test 测试目录
  |--app.coffee 主程序 coffee app.coffee 启动
  |--app.js 主程序 node app.js 启动
  |--nodemon.json
  |--README.md
```

- 安装依赖包、并启动服务
```
$ npm install
$ npm start
```

## 框架开发流程
- 创建 koa2 + coffee 项目
- 增加 mongoose 数据库支持