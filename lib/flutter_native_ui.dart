library flutter_native_ui;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_native_ui/_private/_logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_ui/_private/_api.dart';
import 'package:flutter_native_ui/_private/_base.dart';
import 'package:flutter_native_ui/_private/_handler.dart';
import 'package:flutter_native_ui/themes.dart';
import 'package:macos_ui/macos_ui.dart';

enum DesignType {material, cupertino, macos, fluent, yaru}
enum Environment {android, ios, macos, windows, linux, web, fuchsia}
DesignType _designType = DesignType.material;

class FlutterNativeUI {
  final DesignType androidDesign;
  final DesignType iosDesign;
  final DesignType macosDesign;
  final DesignType windowsDesign;
  final DesignType linuxDesign;
  final DesignType webDesign;
  final DesignType fuchsiaDesign;

  Environment? platform;
  bool disableWarnings;

  FlutterNativeUI({
    this.platform,
    this.disableWarnings = kDebugMode,
    this.androidDesign = DesignType.material,
    this.iosDesign = DesignType.cupertino,
    this.macosDesign = DesignType.macos,
    this.windowsDesign = DesignType.fluent,
    this.linuxDesign = DesignType.yaru,
    this.webDesign = DesignType.material,
    this.fuchsiaDesign = DesignType.material,
  });

  Future<void> init() async {
    if (platform == null) {
      if (kIsWeb || kIsWasm) {
        platform = Environment.web;
      } else if (Platform.isIOS) {
        platform = Environment.ios;
      } else if (Platform.isAndroid) {
        platform = Environment.android;
      } else if (Platform.isWindows) {
        platform = Environment.windows;
      } else if (Platform.isLinux) {
        platform = Environment.linux;
      } else if (Platform.isMacOS) {
        platform = Environment.macos;
      } else if (Platform.isFuchsia) {
        platform = Environment.fuchsia;
      } else {
        throw Exception(("Unknown platform: ${Platform.operatingSystem}"));
      }
    }

    _designType = _getDesignType(platform!);

    if (getPlatform() == "macos" && _designType == DesignType.macos) {
      if (disableWarnings == false) {
        warn("Attempting to run the \"$_designType\" design type on platform ${getPlatform()} is not officially supported and can cause issues.");
      }
    }

    bool supportWeb = false;
    if (getPlatform() == "fuchsia" || ((getPlatform() == "web:native" || getPlatform() == "web:wasm") && supportWeb == false)) {
      if (disableWarnings == false) {
        warn("Platform ${getPlatform()} is not officially supported.");
      }
    }
  }

  DesignType _getDesignType(Environment platform) {
    switch (platform) {
      case Environment.web: return webDesign;
      case Environment.android: return androidDesign;
      case Environment.ios: return iosDesign;
      case Environment.macos: return macosDesign;
      case Environment.windows: return windowsDesign;
      case Environment.linux: return linuxDesign;
      case Environment.fuchsia: return fuchsiaDesign;
    }
  }
}

class WindowHandler {
  final bool hideWarnings;
  WindowHandler({
    this.hideWarnings = false,
  });

  void init(Environment platform) {
    if (platform == Environment.linux || platform == Environment.windows) {
      // linux/windows
    } else if (platform == Environment.macos) {
      // MacosWindow
    } else {
      if (!hideWarnings) {
        warn("WindowHandler is not supported on platform ${Platform.operatingSystem}");
      }
    }
  }
}

class Design {
  static bool isMaterial() {
    return _designType == DesignType.material;
  }

  static bool isCupertino() {
    return _designType == DesignType.cupertino;
  }

  static bool isMacOS() {
    return _designType == DesignType.macos;
  }

  static bool isFluent() {
    return _designType == DesignType.fluent;
  }

  static bool isYaru() {
    return _designType == DesignType.yaru;
  }
}

String getFont() {
  if (Design.isMaterial()) {
    return 'Roboto';
  } else if (Design.isCupertino() || Design.isMacOS()) {
    return 'SFPro';
  } else if (Design.isFluent()) {
    return 'SegoeUI';
  } else if (Design.isYaru()) {
    return 'Ubuntu';
  } else {
    throw Exception('Unknown platform: ${Platform.operatingSystem}');
  }
}

void main() {
  throw Exception("The base package is not supposed to be run as a program.");
}

class NativeIcon extends NativeStatelessWidget {
  final bool disableWarnings;
  final NativeIconData icon;
  final double? size;
  final double? fill;
  final double? weight;
  final double? grade;
  final double? opticalSize;
  final Color? color;
  final List<Shadow>? shadows;
  final String? semanticLabel;
  final TextDirection? textDirection;
  final bool? applyTextScaling;
  final BlendMode? blendMode;

  const NativeIcon(
    this.icon, {
    super.key,
    super.type = Icon,
    this.disableWarnings = kDebugMode,
    this.size,
    this.fill,
    this.weight,
    this.grade,
    this.opticalSize,
    this.color,
    this.shadows,
    this.semanticLabel,
    this.textDirection,
    this.applyTextScaling,
    this.blendMode,
  });

  @override
  Widget build(BuildContext context) {
    VariableHandler handler = VariableHandler(name: 'NativeIcon', enabled: !disableWarnings);
    if (Design.isMacOS()) {
      handler.handle('fill', fill);
      handler.handle('weight', weight);
      handler.handle('grade', grade);
      handler.handle('opticalSize', opticalSize);
      handler.handle('shadows', shadows);
      handler.handle('applyTextScaling', applyTextScaling);
      handler.handle('blendMode', blendMode);
      return MacosIcon(icon.build(), key: key, size: size, color: color, semanticLabel: semanticLabel, textDirection: textDirection);
    }
    return Icon(icon.build(), 
      size: size,
      color: color,
      shadows: shadows,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
      applyTextScaling: applyTextScaling,
      blendMode: blendMode,
    );
  }

  @override
  Widget transform(BuildContext context, Widget input) {
    throw Exception("Type ${super.type} cannot be transformed (from type ${input.runtimeType})");
  }
}

/// For generating IconData to be used with NativeIcon. This is recommended to only be used with NativeIcon, and if used with anything else (this only applies to macOS), then it will not look correct.
///
/// macosIcon is not strictly required due to the fact that the macos_ui library uses a specialized Widget that relies on the regular Material Icons library to generate a macOS icon. Because of this, you can omit the macosIcon argument, as it will just use the icon parameter.
class NativeIconData {
  final IconData? icon;
  final IconData? cupertinoIcon;
  final IconData? macosIcon;
  final IconData? fluentIcon;
  final IconData? yaruIcon;
  final bool disableWarnings;
  final IconData fallback;

  const NativeIconData({
    this.disableWarnings = kDebugMode,
    this.icon,
    this.cupertinoIcon,
    this.fluentIcon,
    this.yaruIcon,

    /// macosIcon is not strictly required due to the fact that the macos_ui library uses a specialized Widget that relies on the regular Material Icons library to generate a macOS icon. Because of this, you can omit the macosIcon argument, as it will just use the icon parameter.
    this.macosIcon,

    /// If you see a random warning symbol in your code, then that means that you didn't supply an icon for the platform the app is currently running on. That's why it's recommended to fill out It is recommended to fill out icon, cupertinoIcon, fluentIcon, and yaruIcon. (see macosIcon docs for details of why macosIcon isn't required)
    this.fallback = Icons.warning_amber,
  });

  IconData build() {
    if ([icon, cupertinoIcon, macosIcon, fluentIcon, yaruIcon].every((element) => element == null)) {
      throw Exception("At least one icon should be specified for NativeIconData. It is recommended to fill out icon, cupertinoIcon, fluentIcon, and yaruIcon.");
    }
    if ([icon, cupertinoIcon, macosIcon, fluentIcon, yaruIcon].any((element) => element == null) && disableWarnings == false) {
      warn("It is recommended to fill out icon, cupertinoIcon, fluentIcon, and yaruIcon into NativeIconData.");
    }
    if (Design.isMaterial()) {
      return icon ?? fallback;
    }
    if (Design.isCupertino()) {
      return cupertinoIcon ?? fallback;
    }
    if (Design.isMacOS()) {
      return macosIcon ?? (icon ?? fallback);
    }
    if (Design.isFluent()) {
      return fluentIcon ?? fallback;
    }
    if (Design.isYaru()) {
      return yaruIcon ?? fallback;
    }
    throw Exception("Unrecognized platform: ${Platform.operatingSystem}");
  }
}

class NativeApp extends NativeStatelessWidget {
  final GlobalKey<NavigatorState>? navigatorKey;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final Widget? home;
  final Map<String, Widget Function(BuildContext)> routes;
  final String? initialRoute;
  final Route<dynamic>? Function(RouteSettings)? onGenerateRoute;
  final List<Route<dynamic>> Function(String)? onGenerateInitialRoutes;
  final Route<dynamic>? Function(RouteSettings)? onUnknownRoute;
  final bool Function(NavigationNotification)? onNavigationNotification;
  final List<NavigatorObserver> navigatorObservers;
  final Widget Function(BuildContext, Widget?)? builder;
  final String? title;
  final String Function(BuildContext)? onGenerateTitle;
  final Color? color;
  final NativeThemeData? theme;
  final NativeThemeData? darkTheme;
  final NativeThemeData? highContrastTheme;
  final NativeThemeData? highContrastDarkTheme;
  final ThemeMode? themeMode;
  final Duration themeAnimationDuration;
  final Curve themeAnimationCurve;
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Locale? Function(List<Locale>?, Iterable<Locale>)? localeListResolutionCallback;
  final Locale? Function(Locale?, Iterable<Locale>)? localeResolutionCallback;
  final Iterable<Locale> supportedLocales;
  final bool debugShowMaterialGrid;
  final bool showPerformanceOverlay;
  final bool checkerboardRasterCacheImages;
  final bool checkerboardOffscreenLayers;
  final bool showSemanticsDebugger;
  final bool debugShowCheckedModeBanner;
  final Map<ShortcutActivator, Intent>? shortcuts;
  final Map<Type, Action<Intent>>? actions;
  final String? restorationScopeId;
  final ScrollBehavior? scrollBehavior;
  final bool useInheritedMediaQuery;
  final AnimationStyle? themeAnimationStyle;
  final bool disableWarnings;

  const NativeApp({
    super.key,
    super.type = MaterialApp,
    this.disableWarnings = false,
    this.navigatorKey,
    this.scaffoldMessengerKey,
    this.home,
    this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.onNavigationNotification,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.darkTheme,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.themeMode = ThemeMode.system,
    this.themeAnimationDuration = kThemeAnimationDuration,
    this.themeAnimationCurve = Curves.linear,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
    this.themeAnimationStyle,

    @Deprecated(
      'Remove this parameter as it is now ignored. '
      'CupertinoApp never introduces its own MediaQuery; the View widget takes care of that. '
      'This feature was deprecated after v3.7.0-29.0.pre.'
    )
    this.useInheritedMediaQuery = false,
  });

  @override
  Widget transform(BuildContext context, Widget input) {
    return NativeApp(
      key: input.key,
      themeMode: themeMode,
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: home,
      routes: routes,
      initialRoute: initialRoute,
      onGenerateRoute: onGenerateRoute,
      onGenerateInitialRoutes: onGenerateInitialRoutes,
      onUnknownRoute: onUnknownRoute,
      onNavigationNotification: onNavigationNotification,
      navigatorObservers: navigatorObservers,
      builder: builder,
      title: title,
      onGenerateTitle: onGenerateTitle,
      color: color,
      theme: theme,
      darkTheme: darkTheme,
      highContrastTheme: highContrastTheme,
      highContrastDarkTheme: highContrastDarkTheme,
      themeAnimationDuration: themeAnimationDuration,
      themeAnimationCurve: themeAnimationCurve,
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      localeListResolutionCallback: localeListResolutionCallback,
      localeResolutionCallback: localeResolutionCallback,
      supportedLocales: supportedLocales,
      debugShowMaterialGrid: debugShowMaterialGrid,
      showPerformanceOverlay: showPerformanceOverlay,
      checkerboardRasterCacheImages: checkerboardRasterCacheImages,
      checkerboardOffscreenLayers: checkerboardOffscreenLayers,
      showSemanticsDebugger: showSemanticsDebugger,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      shortcuts: shortcuts,
      actions: actions,
      restorationScopeId: restorationScopeId,
      scrollBehavior: scrollBehavior,
      useInheritedMediaQuery: useInheritedMediaQuery,
      themeAnimationStyle: themeAnimationStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = themeMode == ThemeMode.dark;
    bool highContrast = MediaQuery.of(context).highContrast;
    VariableHandler handler = VariableHandler(name: "NativeApp", enabled: !disableWarnings);

    if (themeMode == ThemeMode.system) {
      darkMode = getBrightness(context) == Brightness.dark;
    }

    if (Design.isMaterial()) {
      return MaterialApp(
        key: key,
        themeMode: themeMode,
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: scaffoldMessengerKey,
        home: home,
        routes: routes,
        initialRoute: initialRoute,
        onGenerateRoute: onGenerateRoute,
        onGenerateInitialRoutes: onGenerateInitialRoutes,
        onUnknownRoute: onUnknownRoute,
        onNavigationNotification: onNavigationNotification,
        navigatorObservers: navigatorObservers,
        builder: builder,
        title: title,
        onGenerateTitle: onGenerateTitle,
        color: color,
        theme: (theme?.build() as ThemeData?) ?? ThemeData.fallback(),
        darkTheme: (darkTheme?.build() as ThemeData?) ?? ThemeData.fallback(),
        highContrastTheme: (highContrastTheme?.build() as ThemeData?) ?? ThemeData.fallback(),
        highContrastDarkTheme: (highContrastDarkTheme?.build() as ThemeData?) ?? ThemeData.fallback(),
        themeAnimationDuration: themeAnimationDuration,
        themeAnimationCurve: themeAnimationCurve,
        locale: locale,
        localizationsDelegates: localizationsDelegates,
        localeListResolutionCallback: localeListResolutionCallback,
        localeResolutionCallback: localeResolutionCallback,
        supportedLocales: supportedLocales,
        debugShowMaterialGrid: debugShowMaterialGrid,
        showPerformanceOverlay: showPerformanceOverlay,
        checkerboardRasterCacheImages: checkerboardRasterCacheImages,
        checkerboardOffscreenLayers: checkerboardOffscreenLayers,
        showSemanticsDebugger: showSemanticsDebugger,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        shortcuts: shortcuts,
        actions: actions,
        restorationScopeId: restorationScopeId,
        scrollBehavior: scrollBehavior,
        useInheritedMediaQuery: useInheritedMediaQuery,
        themeAnimationStyle: themeAnimationStyle,
      );
    } else if (Design.isCupertino()) {
      handler.handle('themeMode', themeMode);
      handler.handle('scaffoldMessengerKey', scaffoldMessengerKey);
      handler.handle('themeAnimationDuration', themeAnimationDuration);

      return CupertinoApp(
        key: key,
        navigatorKey: navigatorKey,
        home: home,
        routes: routes,
        initialRoute: initialRoute,
        onGenerateRoute: onGenerateRoute,
        onGenerateInitialRoutes: onGenerateInitialRoutes,
        onUnknownRoute: onUnknownRoute,
        onNavigationNotification: onNavigationNotification,
        navigatorObservers: navigatorObservers,
        builder: builder,
        title: title,
        onGenerateTitle: onGenerateTitle,
        color: color,
        theme: (darkMode ? (highContrast ? highContrastDarkTheme : darkTheme) : (highContrast ? highContrastTheme : theme))?.build(),
        locale: locale,
        localizationsDelegates: localizationsDelegates,
        localeListResolutionCallback: localeListResolutionCallback,
        localeResolutionCallback: localeResolutionCallback,
        supportedLocales: supportedLocales,
        showPerformanceOverlay: showPerformanceOverlay,
        checkerboardRasterCacheImages: checkerboardRasterCacheImages,
        checkerboardOffscreenLayers: checkerboardOffscreenLayers,
        showSemanticsDebugger: showSemanticsDebugger,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        shortcuts: shortcuts,
        actions: actions,
        restorationScopeId: restorationScopeId,
        scrollBehavior: scrollBehavior,
        useInheritedMediaQuery: useInheritedMediaQuery,
      );
    } else if (Design.isMacOS()) {
      handler.handle('scaffoldMessengerKey', scaffoldMessengerKey);
      handler.handle('onNavigationNotification', onNavigationNotification);
      handler.handle('highContrastTheme', highContrastTheme);
      handler.handle('highContrastDarkTheme', highContrastDarkTheme);
      handler.handle('themeAnimationDuration', themeAnimationDuration);
      handler.handle('themeAnimationCurve', themeAnimationCurve);
      handler.handle('debugShowMaterialGrid', debugShowMaterialGrid);
      handler.handle('useInheritedMediaQuery', useInheritedMediaQuery);
      handler.handle('themeAnimationStyle', themeAnimationStyle);

      return MacosApp(
        key: key,
        themeMode: themeMode,
        navigatorKey: navigatorKey,
        home: home,
        routes: routes,
        initialRoute: initialRoute,
        onGenerateRoute: onGenerateRoute,
        onGenerateInitialRoutes: onGenerateInitialRoutes,
        onUnknownRoute: onUnknownRoute,
        navigatorObservers: navigatorObservers,
        builder: builder,
        title: title ?? '',
        onGenerateTitle: onGenerateTitle,
        color: color,
        theme: (highContrast ? highContrastTheme?.build() : theme?.build()) ?? MacosThemeData.fallback(),
        darkTheme: (highContrast ? highContrastDarkTheme?.build() : darkTheme?.build()) ?? MacosThemeData.fallback(),
        locale: locale,
        localizationsDelegates: localizationsDelegates,
        localeListResolutionCallback: localeListResolutionCallback,
        localeResolutionCallback: localeResolutionCallback,
        supportedLocales: supportedLocales,
        showPerformanceOverlay: showPerformanceOverlay,
        checkerboardRasterCacheImages: checkerboardRasterCacheImages,
        checkerboardOffscreenLayers: checkerboardOffscreenLayers,
        showSemanticsDebugger: showSemanticsDebugger,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        shortcuts: shortcuts?.map((key, value) => MapEntry(key is SingleActivator ? LogicalKeySet(key.trigger) : null, value)).cast<LogicalKeySet, Intent>(),
        actions: actions,
        restorationScopeId: restorationScopeId,
        scrollBehavior: scrollBehavior ?? const MacosScrollBehavior(),
      );
    } else {
      throw Exception("Invalid design type");
    }
  }
}

class NativeAppBar extends AppBar {
  NativeAppBar({
    super.key,
  });
}

class NativeFloatingActionButton extends AppBar {
  NativeFloatingActionButton({
    super.key,
  });
}

class NativeScaffold extends NativeStatefulWidget {
  final NativeAppBar? appBar;
  final Widget body;
  final NativeFloatingActionButton? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final AlignmentDirectional persistentFooterAlignment;
  final Widget? drawer;
  final void Function(bool)? onDrawerChanged;
  final Widget? endDrawer;
  final void Function(bool)? onEndDrawerChanged;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final Color? drawerScrimColor;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;
  final String? restorationId;

  const NativeScaffold({
    super.key,
    super.type = Scaffold,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.persistentFooterAlignment = AlignmentDirectional.centerEnd,
    this.drawer,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.restorationId,
  });

  @override
  _NativeScaffoldState createState() => _NativeScaffoldState();

  @override
  Widget transform(BuildContext context, Widget input) {
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      persistentFooterButtons: persistentFooterButtons,
      drawer: drawer,
      onDrawerChanged: onDrawerChanged,
      endDrawer: endDrawer,
      onEndDrawerChanged: onEndDrawerChanged,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      primary: primary,
      drawerDragStartBehavior: drawerDragStartBehavior,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      drawerScrimColor: drawerScrimColor,
      drawerEdgeDragWidth: drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
      restorationId: restorationId,
    );
  }
}

class _NativeScaffoldState extends State<NativeScaffold> {
  @override
  Widget build(BuildContext context) {
    VariableHandler handler = VariableHandler(name: 'NativeScaffold');
    if (Design.isMaterial()) {
      return Scaffold(
        key: widget.key,
        appBar: widget.appBar,
        body: widget.body,
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
        persistentFooterButtons: widget.persistentFooterButtons,
        drawer: widget.drawer,
        onDrawerChanged: widget.onDrawerChanged,
        endDrawer: widget.endDrawer,
        onEndDrawerChanged: widget.onEndDrawerChanged,
        bottomNavigationBar: widget.bottomNavigationBar,
        bottomSheet: widget.bottomSheet,
        backgroundColor: widget.backgroundColor,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        primary: widget.primary,
        drawerDragStartBehavior: widget.drawerDragStartBehavior,
        extendBody: widget.extendBody,
        extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
        drawerScrimColor: widget.drawerScrimColor,
        drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
        drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
        restorationId: widget.restorationId,
      );
    } else if (Design.isCupertino()) {
      handler.handle('appBar', widget.appBar);
      handler.handle('floatingActionButton', widget.floatingActionButton);
      handler.handle('floatingActionButtonLocation', widget.floatingActionButtonLocation);
      handler.handle('floatingActionButtonAnimator', widget.floatingActionButtonAnimator);
      handler.handle('persistentFooterButtons', widget.persistentFooterButtons);
      handler.handle('drawer', widget.drawer);
      handler.handle('onDrawerChanged', widget.onDrawerChanged);
      handler.handle('endDrawer', widget.endDrawer);
      handler.handle('onEndDrawerChanged', widget.onEndDrawerChanged);
      handler.handle('bottomSheet', widget.bottomSheet);
      handler.handle('primary', widget.primary);
      handler.handle('drawerDragStartBehavior', widget.drawerDragStartBehavior);
      handler.handle('extendBody', widget.extendBody);
      handler.handle('extendBodyBehindAppBar', widget.extendBodyBehindAppBar);
      handler.handle('drawerScrimColor', widget.drawerScrimColor);
      handler.handle('drawerEdgeDragWidth', widget.drawerEdgeDragWidth);
      handler.handle('drawerEnableOpenDragGesture', widget.drawerEnableOpenDragGesture);
      handler.handle('endDrawerEnableOpenDragGesture', widget.endDrawerEnableOpenDragGesture);
      handler.handle('restorationId', widget.restorationId);

      return CupertinoPageScaffold(
        key: widget.key,
        navigationBar: widget.bottomNavigationBar as ObstructingPreferredSizeWidget?,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset ?? true,
        backgroundColor: widget.backgroundColor,
        child: widget.body,
      );
    } else {
      throw UnimplementedError();
    }
  }
}

class NativeText extends NativeStatelessWidget {
  final String data;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final TextScaler? textScaler;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;
  final String? fontFamily;

  const NativeText(this.data, {
    super.key,
    super.type = Text,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.fontFamily,

    @Deprecated(
      'Use textScaler instead. '
      'Use of textScaleFactor was deprecated in preparation for the upcoming nonlinear text scaling support. '
      'This feature was deprecated after v3.12.0-2.0.pre.',
    )
    this.textScaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = style ?? TextStyle();
    return Text(data, key: key, style: textStyle.copyWith(fontFamily: fontFamily ?? getFont()), strutStyle: strutStyle, textAlign: textAlign, textDirection: textDirection, locale: locale, softWrap: softWrap, overflow: overflow, textScaleFactor: textScaleFactor, textScaler: textScaler, maxLines: maxLines, semanticsLabel: semanticsLabel, textWidthBasis: textWidthBasis, textHeightBehavior: textHeightBehavior, selectionColor: selectionColor);
  }

  @override
  Widget transform(BuildContext context, Widget input) {
    throw Exception("Type ${super.type} cannot be transformed (from type ${input.runtimeType})");
  }
}