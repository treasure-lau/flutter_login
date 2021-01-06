//  创建人：张争勇
//  最后修改人：    修改时间：
//  修改内容：

import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// 效果支持
///  * [Default], 默认加载.
///  * [Circle], 圆点加载.
///  * [ThreeBounce], 三点加载.
class RcLoading extends StatefulWidget {
  /// 加载文字
  final Widget title;

  /// 加载颜色
  final Color color;
  const RcLoading({Key key, this.title, this.color}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RcLoadingState();
}

/// 动画效果
enum RcLoadingType {
  Default,
  Circle,
  ThreeBounce,
}

class _RcLoadingState extends State<RcLoading> {
  Timer _timer;
  bool isLongTimer = false;
  @override
  void initState() {
    _timer = Timer(Duration(milliseconds: 500), () {
      setState(() {
        isLongTimer = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLongTimer
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildLoading(LoadingConfig.loadingType),
                if (widget.title != null) widget.title
              ],
            ),
          )
        : SizedBox();
  }

  Widget _buildLoading(RcLoadingType rcLoadingType) {
    switch (rcLoadingType) {
      case RcLoadingType.Circle:
        return SpinKitCircle(
          color: widget.color ?? LoadingConfig.loadingColor,
        );
        break;
      case RcLoadingType.ThreeBounce:
        return LayoutBuilder(builder: (context, BoxConstraints constraints) {
          final size = max(
              min(min(constraints.maxWidth, constraints.maxHeight) / 3, 20.0),
              5.0);
          return SpinKitThreeBounce(
            size: size,
            itemBuilder: (_, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size),
                  color: widget.color ?? LoadingConfig.loadingColor,
                ),
              );
            },
          );
        });
        break;
      case RcLoadingType.Default:
      default:
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              widget.color ?? LoadingConfig.loadingColor),
        );
        break;
    }
  }
}

// /// 空数据显示
// /// 修改默认图片只需替换assets/images/empty.svg
// class RcEmpty extends StatelessWidget {
//   /// 提示
//   final String title;

//   final Widget child;

//   const RcEmpty({Key key, this.title, this.child}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           child ??
//               Icon(
//                 RcIcons.article,
//                 size: 60,
//                 color: Theme.of(context).textTheme.bodyText1.color,
//               ),
//           SizedBox(
//             height: 30,
//           ),
//           RcText(
//             title ?? LoadingConfig.emptyText,
//             style: TextStyle(
//               color: LoadingConfig.textColor,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// /// 加载异常
// ///
// /// 修改默认图片只需替换assets/images/error.svg
// class RcError extends StatelessWidget {
//   /// 错误提示
//   final Widget title;

//   /// 显示图标
//   final Widget child;

//   /// 显示刷新按钮
//   final bool showRefresh;

//   /// 显示返回按钮
//   final bool showBack;

//   /// 刷新按钮事件
//   final Function refreshTap;

//   /// 返回事件
//   final Function backTap;

//   const RcError({
//     Key key,
//     this.refreshTap,
//     this.backTap,
//     this.title,
//     this.showRefresh = false,
//     this.showBack = false,
//     this.child,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           child ?? SvgPicture.asset("assets/images/error.svg"),
//           SizedBox(
//             height: 30,
//           ),
//           title ??
//               RcText(
//                 LoadingConfig.errorText,
//                 style: TextStyle(
//                   color: LoadingConfig.textColor,
//                 ),
//               ),
//           if (showRefresh || showBack)
//             SizedBox(
//               height: 30,
//             ),
//           if (showRefresh || showBack)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (showBack)
//                   OutlineButton(
//                     borderSide: Divider.createBorderSide(context,
//                         color: LoadingConfig.backColor),
//                     // borderSide: BorderSide(color: LoadingConfig.backColor),
//                     textColor: LoadingConfig.backColor,
//                     child: RcText(
//                       '返回',
//                       style: TextStyle(
//                           color: LoadingConfig.backColor, letterSpacing: 10),
//                     ),
//                     onPressed: backTap ??
//                         () {
//                           Navigator.of(context).pop();
//                         },
//                   ),
//                 if (showRefresh && showBack)
//                   SizedBox(
//                     width: 40,
//                   ),
//                 if (showRefresh)
//                   RaisedButton(
//                     child: RcText(
//                       '刷新',
//                       style: TextStyle(color: Colors.white, letterSpacing: 10),
//                     ),
//                     color: LoadingConfig.refreshColor,
//                     onPressed: refreshTap ?? () {},
//                   )
//               ],
//             )
//         ],
//       ),
//     );
//   }
// }

/// 加载全局设置
/// 在main.dart配置
/// ```dart
/// LoadingConfig.setConfig()
/// ```
class LoadingConfig {
  LoadingConfig._internal();

  //保存单例
  static LoadingConfig _singleton = LoadingConfig._internal();

  //工厂构造函数
  factory LoadingConfig() => _singleton;

  /// loading样式
  static RcLoadingType loadingType = RcLoadingType.ThreeBounce;

  /// 加载颜色
  static Color loadingColor = Color(0xFFA3AEB6);

  /// 字体颜色，错误和空信息的颜色
  static Color textColor = Color(0xFF606D74);

  /// 空信息配置
  static String emptyText = '暂无内容';

  /// 错误提示
  static String errorText = '网络错误，请稍后再试';

  /// 返回按钮的边框和文字颜色
  static Color backColor = Color(0xFF606D74);
  static Color refreshColor = Color(0xFF606D74);

  LoadingConfig.setConfig({
    RcLoadingType loadingType,
    Color loadingColor,
    Color textColor,
    String emptyText,
    String errorText,
    bool errorShowRefresh,
    bool errorShowBack,
  }) {
    LoadingConfig.loadingType = loadingType ?? LoadingConfig.loadingType;
    LoadingConfig.loadingColor = loadingColor ?? LoadingConfig.loadingColor;
    LoadingConfig.textColor = textColor ?? LoadingConfig.textColor;
    LoadingConfig.emptyText = emptyText ?? LoadingConfig.emptyText;
    LoadingConfig.errorText = errorText ?? LoadingConfig.errorText;
  }
}

// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// const double _kDefaultIndicatorRadius = 18.0;

/// An iOS-style activity indicator that spins clockwise.
///
/// See also:
///
///  * <https://developer.apple.com/ios/human-interface-guidelines/controls/progress-indicators/#activity-indicators>
// class RcCupertinoActivityIndicator extends StatefulWidget {
//   /// Creates an iOS-style activity indicator that spins clockwise.
//   const RcCupertinoActivityIndicator({
//     Key key,
//     this.animating = true,
//     this.radius = _kDefaultIndicatorRadius,
//   })  : assert(animating != null),
//         assert(radius != null),
//         assert(radius > 0),
//         super(key: key);

//   /// Whether the activity indicator is running its animation.
//   ///
//   /// Defaults to true.
//   final bool animating;

//   /// Radius of the spinner widget.
//   ///
//   /// Defaults to 10px. Must be positive and cannot be null.
//   final double radius;

//   @override
//   _RcCupertinoActivityIndicatorState createState() =>
//       _RcCupertinoActivityIndicatorState();
// }

// class _RcCupertinoActivityIndicatorState
//     extends State<RcCupertinoActivityIndicator>
//     with SingleTickerProviderStateMixin {
//   AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     );

//     if (widget.animating) _controller.repeat();
//   }

//   @override
//   void didUpdateWidget(RcCupertinoActivityIndicator oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.animating != oldWidget.animating) {
//       if (widget.animating)
//         _controller.repeat();
//       else
//         _controller.stop();
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: widget.radius * 2,
//       width: widget.radius * 2,
//       child: CustomPaint(
//         painter: _RcCupertinoActivityIndicatorPainter(
//           position: _controller,
//           activeColor: Colors.white,
//           radius: widget.radius,
//         ),
//       ),
//     );
//   }
// }

// const double _kTwoPI = math.pi * 2.0;
// const int _kTickCount = 12;

// // Alpha values extracted from the native component (for both dark and light mode).
// // The list has a length of 12.
// const List<int> _alphaValues = <int>[
//   147,
//   131,
//   114,
//   97,
//   81,
//   64,
//   255,
//   255,
//   255,
//   255,
//   255,
//   255
// ];

// class _RcCupertinoActivityIndicatorPainter extends CustomPainter {
//   _RcCupertinoActivityIndicatorPainter({
//     @required this.position,
//     @required this.activeColor,
//     double radius,
//   })  : tickFundamentalRRect = RRect.fromLTRBXY(
//           -radius,
//           radius / _kDefaultIndicatorRadius,
//           -radius / 2.0,
//           -radius / _kDefaultIndicatorRadius,
//           radius / _kDefaultIndicatorRadius,
//           radius / _kDefaultIndicatorRadius,
//         ),
//         super(repaint: position);

//   final Animation<double> position;
//   final RRect tickFundamentalRRect;
//   final Color activeColor;

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint();

//     canvas.save();
//     canvas.translate(size.width / 2.0, size.height / 2.0);

//     final int activeTick = (_kTickCount * position.value).floor();

//     for (int i = 0; i < _kTickCount; ++i) {
//       final int t = (i + activeTick) % _kTickCount;
//       paint.color = activeColor.withAlpha(_alphaValues[t]);
//       canvas.drawRRect(tickFundamentalRRect, paint);
//       canvas.rotate(-_kTwoPI / _kTickCount);
//     }

//     canvas.restore();
//   }

//   @override
//   bool shouldRepaint(_RcCupertinoActivityIndicatorPainter oldPainter) {
//     return oldPainter.position != position ||
//         oldPainter.activeColor != activeColor;
//   }
// }
