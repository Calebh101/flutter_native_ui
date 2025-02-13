library flutter_native_ui;
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_ui/private.dart';
import 'package:flutter_native_ui/flutter_native_ui.dart';
import 'package:macos_ui/macos_ui.dart' as macos;
import 'package:yaru/yaru.dart' as yaru;

FlutterNativeUI? _currentInstance;

FlutterNativeUI _getCurrentInstance() {
  if (_currentInstance == null || !(_currentInstance!._initialized)) {
    throw Exception("An instance of FlutterNativeUI must be initialized before building an app.");
  }
  return _currentInstance!;
}

enum DesignType {
  /// Material Design 3 (Android)
  material,

  /// Cupertino Design (iOS/iPadOS)
  cupertino,

  /// macOS UI
  macos,

  /// Fluent UI (Windows)
  fluent,

  /// Yaru (Ubuntu)
  yaru,
}

/// Current (or set) platform
/// Note: this package mainly targets Ubuntu
enum Environment {
  /// Android
  android,

  /// iOS/iPadOS
  ios,

  /// macOS
  macos,

  /// Windows
  windows,

  /// Linux
  linux,

  /// Web/WASM
  web,

  /// Fuchsia
  fuchsia,
}

bool canWarn(bool? local) {
  if (local == true && _getCurrentInstance()._disableWarnings == false) {
    return true;
  } else {
    return false;
  }
}

/// Initializer for entire Native app
/// Note: making more than one instance of FlutterNativeUI is not recommended, as it causes property issues.
class FlutterNativeUI {
  /// Design for Android
  /// Default: Material Design
  final DesignType androidDesign;

  /// Design for iOS/iPadOS
  /// Default: Cupertino Design
  final DesignType iosDesign;

  /// Design for macOS
  /// Default: macOS UI
  final DesignType macosDesign;

  /// Design for Windows
  /// Default: Fluent UI
  final DesignType windowsDesign;

  /// Design for Linux (Primarily Ubuntu)
  /// Default: Yaru
  final DesignType linuxDesign;

  /// Design for web/WASM
  /// Default: Material Design
  final DesignType webDesign;

  /// Design for Fuchsia
  /// Default: Material Design
  final DesignType fuchsiaDesign;

  /// Used to overwrite the current platform to a set value.
  /// Note: if you want to do this for reasons other than debugging, just don't use this package.
  /// Default: based on current platform
  Environment? platform;

  /// Disable all component warnings for all unused but set components. This will basically make sure you know that a certain property you inputted that cannot be used in all different Design's version of the Widget.
  /// For example, the NativeApp widget contains multiple different App widgets, but we'll focus on MaterialApp and CupertinoApp. MaterialApp and CupertinoApp both have a lot of properties, but CupertinoApp lacks ThemeMode, scaffoldMessengerKey, and themeAnimationDuration. When the Cupertino version is called, it will tell you that it lacks those properties, to avoid confusion. NativeApp has a disableWarnings property specific to it, along with every other NativeWidget, but you can disable all warnings with this property.
  /// Default: based on debug mode
  bool disableWarnings;

  DesignType _designType = DesignType.material;
  bool _disableWarnings = false;
  bool _initialized = false;

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

  /// Initialize FlutterNativeUI. This is required to be ran in the main() function in main.dart.
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
        throw Exception(("Unknown platform: ${getPlatform()}"));
      }
    }

    _designType = _getDesignType(platform!);
    _disableWarnings = disableWarnings;

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

    _initialized = true;
    _currentInstance = this;
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
        warn("WindowHandler is not supported on platform ${getPlatform()}");
      }
    }
  }
}

/// Class to retrieve statuses on DesignTypes.
class Design {
  /// Checks if the current DesignType is Material Design.
  static bool isMaterial() {
    return _getCurrentInstance()._designType == DesignType.material;
  }

  /// Checks if the current DesignType is Cupertino Design.
  static bool isCupertino() {
    return _getCurrentInstance()._designType == DesignType.cupertino;
  }

  /// Checks if the current DesignType is macOS UI.
  static bool isMacOS() {
    return _getCurrentInstance()._designType == DesignType.macos;
  }

  /// Checks if the current DesignType is Fluent UI.
  static bool isFluent() {
    return _getCurrentInstance()._designType == DesignType.fluent;
  }

  /// Checks if the current DesignType is Yaru.
  static bool isYaru() {
    return _getCurrentInstance()._designType == DesignType.yaru;
  }

  /// Checks if the current DesignType is Material Design or Yaru.
  static bool isMaterialYaru() {
    return isMaterial() || isYaru();
  }

  /// Gets the current Design type.
  static DesignType get() {
    return _getCurrentInstance()._designType;
  }
}

/// Equivalent to MaterialApp, but this takes and sets up a new app Widget depending on the platform:
/// 
/// Material/Yaru: MaterialApp
/// Cupertino: CupertinoApp
/// macOS: MacosApp (from macos_ui)
/// Fluent UI: // TODO
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
  });

  MaterialApp _buildMaterialApp({required ThemeData theme, required ThemeData darkTheme, required ThemeData highContrastTheme, required ThemeData highContrastDarkTheme}) {
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
      themeAnimationStyle: themeAnimationStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = getBrightness(context) == Brightness.dark;
    bool highContrast = MediaQuery.of(context).highContrast;
    NativeHandler handler = NativeHandler(name: "NativeApp", enabled: !disableWarnings);

    if (Design.isMaterial()) {
      ThemeData themeS = theme?.build() as ThemeData? ?? ThemeData.fallback();
      ThemeData darkThemeS = darkTheme?.build() as ThemeData? ?? ThemeData.fallback();
      ThemeData highContrastThemeS = highContrastTheme?.build() as ThemeData? ?? ThemeData.fallback();
      ThemeData highContrastDarkThemeS = highContrastDarkTheme?.build() as ThemeData? ?? ThemeData.fallback();
      return _buildMaterialApp(theme: themeS, darkTheme: darkThemeS, highContrastTheme: highContrastThemeS, highContrastDarkTheme: highContrastDarkThemeS);
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
      );
    } else if (Design.isMacOS()) {
      handler.handle('scaffoldMessengerKey', scaffoldMessengerKey);
      handler.handle('onNavigationNotification', onNavigationNotification);
      handler.handle('highContrastTheme', highContrastTheme);
      handler.handle('highContrastDarkTheme', highContrastDarkTheme);
      handler.handle('themeAnimationDuration', themeAnimationDuration);
      handler.handle('themeAnimationCurve', themeAnimationCurve);
      handler.handle('debugShowMaterialGrid', debugShowMaterialGrid);
      handler.handle('themeAnimationStyle', themeAnimationStyle);

      return macos.MacosApp(
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
        theme: (highContrast ? highContrastTheme?.build() : theme?.build()) ?? macos.MacosThemeData.fallback(),
        darkTheme: (highContrast ? highContrastDarkTheme?.build() : darkTheme?.build()) ?? macos.MacosThemeData.fallback(),
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
        scrollBehavior: scrollBehavior ?? const macos.MacosScrollBehavior(),
      );
    } else if (Design.isYaru()) {
        return yaru.YaruTheme(
          key: key,
          builder: (context, yaruS, child) {
            ThemeData themeS = theme?.build() ?? yaruS.theme;
            ThemeData darkThemeS = darkTheme?.build() ?? yaruS.darkTheme;
            ThemeData highContrastThemeS = highContrastTheme?.build() ?? yaru.yaruHighContrastLight;
            ThemeData highContrastDarkThemeS = highContrastDarkTheme?.build() ?? yaruS.yaru.yaruHighContrastDark;
            return _buildMaterialApp(theme: themeS, darkTheme: darkThemeS, highContrastTheme: highContrastThemeS, highContrastDarkTheme: highContrastDarkThemeS);
          },
        );
    } else if (Design.isFluent()) {
      return fluent.FluentApp(
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
        theme: (highContrast ? highContrastTheme?.build() : theme?.build()) ?? ThemeData.fallback(),
        darkTheme: (highContrast ? highContrastDarkTheme?.build() : darkTheme?.build()) ?? ThemeData.fallback(),
        locale: locale,
        localizationsDelegates: localizationsDelegates,
        localeListResolutionCallback: localeListResolutionCallback,
        localeResolutionCallback: localeResolutionCallback,
        supportedLocales: supportedLocales,
        showPerformanceOverlay: showPerformanceOverlay,
        showSemanticsDebugger: showSemanticsDebugger,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        shortcuts: shortcuts,
        actions: actions,
        restorationScopeId: restorationScopeId,
        scrollBehavior: scrollBehavior ?? fluent.FluentScrollBehavior(),
      );
    } else {
      return handler.overflow();
    }
  }
}

extension on yaru.YaruThemeData {
  get yaru => null;
}

class NativeAppBar extends NativeStatefulWidget {
  const NativeAppBar({super.key, super.type = AppBar});

  @override
  State<NativeAppBar> createState() => _NativeAppBarState();
}

class _NativeAppBarState extends State<NativeAppBar> {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}

class NativeFloatingActionButton extends NativeStatelessWidget {
  const NativeFloatingActionButton({super.key, super.type = FloatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
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
}

class _NativeScaffoldState extends State<NativeScaffold> {
  @override
  Widget build(BuildContext context) {
    NativeHandler handler = NativeHandler(name: 'NativeScaffold');
    if (Design.isMaterialYaru()) {
      return Scaffold(
        key: widget.key,
        appBar: widget.appBar as PreferredSizeWidget?,
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
    } else if (Design.isFluent()) {
      return fluent.NavigationPaneTheme(
        data: fluent.NavigationPaneThemeData(),
        child: widget.body,
      );
    } else {
      return handler.overflow();
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
  final TextScaler? textScaler;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;
  final String? fontFamily;
  final bool selectable;

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
    this.selectable = false,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = (style ?? TextStyle()).copyWith(fontFamily: fontFamily ?? getFont());
    return Text(data, key: key, style: textStyle, strutStyle: strutStyle, textAlign: textAlign, textDirection: textDirection, locale: locale, softWrap: softWrap, overflow: overflow, textScaler: textScaler, maxLines: maxLines, semanticsLabel: semanticsLabel, textWidthBasis: textWidthBasis, textHeightBehavior: textHeightBehavior, selectionColor: selectionColor);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return "NativeText($data)";
  }
}
