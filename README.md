一款简单的开心乐小游戏，利用flutter制作的APP。<br>
<div style="display:flex; justify-content: space-evenly;">
<img src="https://github.com/tec8297729/hh_game/blob/master/demo/hhgame_demo.gif?raw=true" width="33%">
</div>

<div style="display:flex; justify-content: space-evenly;">
<img src="https://github.com/tec8297729/hh_game/blob/master/demo/1.png?raw=true" width="33%">
<img src="https://github.com/tec8297729/hh_game/blob/master/demo/2.png?raw=true" width="33%">
<img src="https://github.com/tec8297729/hh_game/blob/master/demo/3.png?raw=true" width="33%">
</div>

<br><br>

国内分发下载APK体验: <br>
密码:111111 <br>
<div style="display:flex;">
<img src="https://github.com/tec8297729/hh_game/blob/master/demo/QRCode_258.png?raw=true" width="300px" height="300px">
</div>

<br>

## 关键技术点总结文章

<div><a href="//www.jonhuu.com/sample-post/1744.html" target="_blank">情绪表情实现总结</a></div>

<div><a href="//www.jonhuu.com/sample-post/1706.html" target="_blank">双面旋转卡牌实现总结</a>
</div>

## 迁移flutter3

内部脚手架更新到最新版本（<https://github.com/tec8297729/flutter_flexible>）

* 为什么更新成最新sdk兼容版本？
主要是因为适应未来flutter版本是否能跑起来，并且可以随时去尝试新特殊组件或API之类融合到项目中，如果想体验完整功能可以把本地的flutter切换到2.x版本

* 启动项目使用命令启动，vscode内置启动有点问题
使用npm run dev或是flutter原生启动命令，因为还有flare_flutter第三方包没有过空安全检测，内置启动会启动不了

* 带变色的表情头，暂时关闭
由于flutter新版本后，ColorTween没有需要的类型参数，强制转换也无法显示，稍后等有空时间在修复
