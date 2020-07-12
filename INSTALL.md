## SKAPP安装

### 准备工作

1.安装flutter，关于flutter的安装，可以参考：https://flutterchina.club/get-started/install/
2.推荐使用vscode编辑器，在vscode中安装flutter，dart插件

### 克隆项目

```
git clone https://github.com/Mockingbird1234/skapp.git
```

### 运行项目

1.使用vscode打开，安装好flutter插件后编辑器会自动安装依赖包，也可以运行```flutter pub get```安装依赖。
2.运行```flutter doctor```查看环境是否正常。
3.按下F5或者运行```flutter run```即可运行项目

注意：在运行项目前查看文件<code>/android/app/build.gradle</code>是否有以下代码：
```
ndk {
            //设置支持的SO库架构
            abiFilters 'armeabi-v7a' // , 'arm64-v8a', 'x86', 'x86_64'
        }
```
如果有以上代码，需要在开发环境时加上注释，否则可能会出现运行失败的情况。

推荐在真机环境中运行，测试发现影片播放界面在模拟器中会出现闪退。


### 关于打包

1.打包首先需要进行签名，可以参考：https://blog.csdn.net/weixin_43434223/article/details/88047861

2.将文件<code>/android/app/build.gradle</code>以下代码的注释打开：

```
ndk {
            //设置支持的SO库架构
            abiFilters 'armeabi-v7a' // , 'arm64-v8a', 'x86', 'x86_64'
        }
```

3. 运行```flutter build apk --release --no-shrink```命令即可打包apk文件。


> 如果安装有问题欢迎issue