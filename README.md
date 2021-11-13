# servant

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# 编译模型
* 一次性代码生成
  通过在项目根目录运行 `flutter pub run build_runner build` 或者 `flutter pub run build_runner build --delete-conflicting-outputs`，你可以在任何需要的时候为你的模型生成 JSON 序列化数据代码。这会触发一次构建，遍历源文件，选择相关的文件，然后为它们生成必须的序列化数据代
* 持续生成代码
  监听器 让我们的源代码生成过程更加方便。它会监听我们项目中的文件变化，并且会在需要的时候自动构建必要的文件。你可以在项目根目录运行 `flutter pub run build_runner watch` 启动监听。

启动监听并让它留在后台运行是安全的。

* 项目初始化
```
flutter create .
```
# 不安全的库
```
flutter run --no-sound-null-safety
```


