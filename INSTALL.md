## SKAPP 安装

### 准备工作

1.安装 flutter，关于 flutter 的安装，可以参考：https://flutterchina.club/get-started/install/

2.推荐使用 vscode 编辑器，在 vscode 中安装 flutter，dart 插件

flutter doctor 信息

```
Doctor summary (to see all details, run flutter doctor -v):
[√] Flutter (Channel stable, 1.22.5, on Microsoft Windows [Version 10.0.19042.685], locale zh-CN)

[√] Android toolchain - develop for Android devices (Android SDK version 29.0.3)
[√] Android Studio (version 3.6)
[√] VS Code (version 1.52.0)
[√] Connected device (1 available)

• No issues found!
```

### 克隆项目

```
git clone https://github.com/Mockingbird1234/skapp.git
```

### 运行项目

1.使用 vscode 打开，安装好 flutter 插件后编辑器会自动安装依赖包，也可以运行`flutter pub get`安装依赖。

2.运行`flutter doctor`查看环境是否正常。

3.按下 F5 或者运行`flutter run`即可运行项目

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

3. 运行`flutter build apk --release --no-shrink --obfuscate --split-debug-info=./symbols`命令即可打包 apk 文件。

> 如果安装有问题欢迎 issue
