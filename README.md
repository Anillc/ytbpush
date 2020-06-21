# ytbpush  

将YouTube视频/直播推向阿里的直播服务的qq机器人www  

使用方法：  
`npm install`
先将src/index.coffee里的server改为你的酷q http插件的websocket地址  
然后将src/push.coffee里的mKey、pushUrl、pullUrl改成你阿里云上的key、推流域名、播放域名  
把ffmpegPath替换成你的ffmpeg二进制文件的位置  
然后  
```bash
npm run build
node lib/index.js
```  

> 请保证PATH里有python（youtube-dl需要）  

指令有三条：  
1. |转播 <url>  -  字面意思，返回播放地址以及一个id  
2. |关闭转播 <id>  -  关闭转播，id为上一条指令返回的id（注，这里会返回一个异常是正常现象，因为fluent-ffmpeg是直接对ffmpeg进程发的SIGKILL信号）  
3. |列表  -  列出正在推的流  

"|"是指令前缀，可以在src/index.coffee里改

就酱XD