import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

enum DesignType {material, cupertino, macos, fluent, yaru}
enum Environment {android, ios, macos, windows, linux, web, fuchsia}
DesignType _designType = DesignType.material;

class FlutterNativeUI {
  Environment? platform;
  FlutterNativeUI({
    this.platform,
  });

  void init() {
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

    if (platform == Environment.web || platform == Environment.android || platform == Environment.fuchsia) {
      _designType = DesignType.material;
    } else if (platform == Environment.ios) {
      _designType = DesignType.cupertino;
    } else if (platform == Environment.macos) {
      _designType = DesignType.macos;
    } else if (platform == Environment.windows) {
      _designType = DesignType.fluent;
    } else if (platform == Environment.linux) {
      _designType = DesignType.yaru;
    } else {
      throw Exception("Invalid platform: $platform");
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

class NativeApp extends StatelessWidget {
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

  const NativeApp({
    super.key,
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
    this.useInheritedMediaQuery = false,
    this.themeAnimationStyle,
  });

  @override
  Widget build(BuildContext context) {
    bool darkMode = themeMode == ThemeMode.dark;
    if (themeMode == ThemeMode.system) {
      darkMode = _getBrightness(context) == Brightness.dark;
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
        theme: darkMode ? (darkTheme?.build()) : theme?.build(),
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
    } else {
      throw Exception("Invalid design type");
    }
  }
}

Brightness _getBrightness(BuildContext context) {
  return MediaQuery.platformBrightnessOf(context);
}

class NativeThemeData {
  final BuildContext context;
  final Iterable<Adaptation<Object>>? adaptations;
  final bool? applyElevationOverlayColor;
  final NoDefaultCupertinoThemeData? cupertinoOverrideTheme;
  final Iterable<ThemeExtension>? extensions;
  final InputDecorationTheme? inputDecorationTheme;
  final MaterialTapTargetSize? materialTapTargetSize;
  final PageTransitionsTheme? pageTransitionsTheme;
  final TargetPlatform? platform;
  final ScrollbarThemeData? scrollbarTheme;
  final InteractiveInkFeatureFactory? splashFactory;
  final bool? useMaterial3;
  final VisualDensity? visualDensity;
  final ColorScheme? colorScheme;
  Brightness? brightness;
  final Color? colorSchemeSeed;
  final Color? canvasColor;
  final Color? cardColor;
  final Color? dialogBackgroundColor;
  final Color? disabledColor;
  final Color? dividerColor;
  final Color? focusColor;
  final Color? highlightColor;
  final Color? hintColor;
  final Color? hoverColor;
  final Color? indicatorColor;
  final Color? primaryColor;
  final Color? primaryColorDark;
  final Color? primaryColorLight;
  final MaterialColor? primarySwatch;
  final Color? secondaryHeaderColor;
  final Color? shadowColor;
  final Color? splashColor;
  final Color? unselectedWidgetColor;
  final String? fontFamily;
  final List<String>? fontFamilyFallback;
  final String? package;
  final IconThemeData? iconTheme;
  final IconThemeData? primaryIconTheme;
  final TextTheme? primaryTextTheme;
  final TextTheme? textTheme;
  final Typography? typography;
  final ActionIconThemeData? actionIconTheme;
  final AppBarTheme? appBarTheme;
  final BadgeThemeData? badgeTheme;
  final MaterialBannerThemeData? bannerTheme;
  final BottomAppBarTheme? bottomAppBarTheme;
  final BottomNavigationBarThemeData? bottomNavigationBarTheme;
  final BottomSheetThemeData? bottomSheetTheme;
  final ButtonThemeData? buttonTheme;
  final Object? cardTheme;
  final CheckboxThemeData? checkboxTheme;
  final ChipThemeData? chipTheme;
  final DataTableThemeData? dataTableTheme;
  final DatePickerThemeData? datePickerTheme;
  final Object? dialogTheme;
  final DividerThemeData? dividerTheme;
  final DrawerThemeData? drawerTheme;
  final DropdownMenuThemeData? dropdownMenuTheme;
  final ElevatedButtonThemeData? elevatedButtonTheme;
  final ExpansionTileThemeData? expansionTileTheme;
  final FilledButtonThemeData? filledButtonTheme;
  final FloatingActionButtonThemeData? floatingActionButtonTheme;
  final IconButtonThemeData? iconButtonTheme;
  final ListTileThemeData? listTileTheme;
  final MenuBarThemeData? menuBarTheme;
  final MenuButtonThemeData? menuButtonTheme;
  final MenuThemeData? menuTheme;
  final NavigationBarThemeData? navigationBarTheme;
  final NavigationDrawerThemeData? navigationDrawerTheme;
  final NavigationRailThemeData? navigationRailTheme;
  final OutlinedButtonThemeData? outlinedButtonTheme;
  final PopupMenuThemeData? popupMenuTheme;
  final ProgressIndicatorThemeData? progressIndicatorTheme;
  final RadioThemeData? radioTheme;
  final SearchBarThemeData? searchBarTheme;
  final SearchViewThemeData? searchViewTheme;
  final SegmentedButtonThemeData? segmentedButtonTheme;
  final SliderThemeData? sliderTheme;
  final SnackBarThemeData? snackBarTheme;
  final SwitchThemeData? switchTheme;
  final Object? tabBarTheme;
  final TextButtonThemeData? textButtonTheme;
  final TextSelectionThemeData? textSelectionTheme;
  final TimePickerThemeData? timePickerTheme;
  final ToggleButtonsThemeData? toggleButtonsTheme;
  final TooltipThemeData? tooltipTheme;
  @Deprecated('Use OverflowBar instead. This feature was deprecated after v3.21.0-10.0.pre.')
  final ButtonBarThemeData? buttonBarTheme;
  final bool? applyThemeToAll;

  NativeThemeData({
    required this.context,
    this.adaptations,
    this.applyElevationOverlayColor,
    this.cupertinoOverrideTheme,
    this.extensions,
    this.inputDecorationTheme,
    this.materialTapTargetSize,
    this.pageTransitionsTheme,
    this.platform,
    this.scrollbarTheme,
    this.splashFactory,
    this.useMaterial3,
    this.visualDensity,
    this.colorScheme,
    this.brightness,
    this.colorSchemeSeed,
    this.canvasColor,
    this.cardColor,
    this.dialogBackgroundColor,
    this.disabledColor,
    this.dividerColor,
    this.focusColor,
    this.highlightColor,
    this.hintColor,
    this.hoverColor,
    this.indicatorColor,
    this.primaryColor,
    this.primaryColorDark,
    this.primaryColorLight,
    this.primarySwatch,
    this.secondaryHeaderColor,
    this.shadowColor,
    this.splashColor,
    this.unselectedWidgetColor,
    this.fontFamily,
    this.fontFamilyFallback,
    this.package,
    this.iconTheme,
    this.primaryIconTheme,
    this.primaryTextTheme,
    this.textTheme,
    this.typography,
    this.actionIconTheme,
    this.appBarTheme,
    this.badgeTheme,
    this.bannerTheme,
    this.bottomAppBarTheme,
    this.bottomNavigationBarTheme,
    this.bottomSheetTheme,
    this.buttonTheme,
    this.cardTheme,
    this.checkboxTheme,
    this.chipTheme,
    this.dataTableTheme,
    this.datePickerTheme,
    this.dialogTheme,
    this.dividerTheme,
    this.drawerTheme,
    this.dropdownMenuTheme,
    this.elevatedButtonTheme,
    this.expansionTileTheme,
    this.filledButtonTheme,
    this.floatingActionButtonTheme,
    this.iconButtonTheme,
    this.listTileTheme,
    this.menuBarTheme,
    this.menuButtonTheme,
    this.menuTheme,
    this.navigationBarTheme,
    this.navigationDrawerTheme,
    this.navigationRailTheme,
    this.outlinedButtonTheme,
    this.popupMenuTheme,
    this.progressIndicatorTheme,
    this.radioTheme,
    this.searchBarTheme,
    this.searchViewTheme,
    this.segmentedButtonTheme,
    this.sliderTheme,
    this.snackBarTheme,
    this.switchTheme,
    this.tabBarTheme,
    this.textButtonTheme,
    this.textSelectionTheme,
    this.timePickerTheme,
    this.toggleButtonsTheme,
    this.tooltipTheme,
    this.buttonBarTheme,
    this.applyThemeToAll,
  });

  dynamic build() {
    brightness ??= _getBrightness(context);
    if (Design.isMaterial()) {
      return ThemeData(
        adaptations: adaptations,
        applyElevationOverlayColor: applyElevationOverlayColor,
        extensions: extensions,
        inputDecorationTheme: inputDecorationTheme,
        materialTapTargetSize: materialTapTargetSize,
        pageTransitionsTheme: pageTransitionsTheme,
        scrollbarTheme: scrollbarTheme,
        splashFactory: splashFactory,
        useMaterial3: useMaterial3,
        visualDensity: visualDensity,
        colorScheme: colorScheme,
        brightness: brightness,
        colorSchemeSeed: colorSchemeSeed,
        canvasColor: canvasColor,
        cardColor: cardColor,
        dialogBackgroundColor: dialogBackgroundColor,
        disabledColor: disabledColor,
        dividerColor: dividerColor,
        focusColor: focusColor,
        highlightColor: highlightColor,
        hintColor: hintColor,
        hoverColor: hoverColor,
        indicatorColor: indicatorColor,
        primaryColor: primaryColor,
        primaryColorDark: primaryColorDark,
        primaryColorLight: primaryColorLight,
        primarySwatch: primarySwatch,
        secondaryHeaderColor: secondaryHeaderColor,
        shadowColor: shadowColor,
        splashColor: splashColor,
        unselectedWidgetColor: unselectedWidgetColor,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        package: package,
        iconTheme: iconTheme,
        primaryIconTheme: primaryIconTheme,
        primaryTextTheme: primaryTextTheme,
        textTheme: textTheme,
        typography: typography,
        actionIconTheme: actionIconTheme,
        appBarTheme: appBarTheme,
        badgeTheme: badgeTheme,
        bannerTheme: bannerTheme,
        bottomAppBarTheme: bottomAppBarTheme,
        bottomNavigationBarTheme: bottomNavigationBarTheme,
        bottomSheetTheme: bottomSheetTheme,
        buttonTheme: buttonTheme,
        cardTheme: cardTheme,
        checkboxTheme: checkboxTheme,
        chipTheme: chipTheme,
        dataTableTheme: dataTableTheme,
        datePickerTheme: datePickerTheme,
        dialogTheme: dialogTheme,
        dividerTheme: dividerTheme,
        drawerTheme: drawerTheme,
        dropdownMenuTheme: dropdownMenuTheme,
        elevatedButtonTheme: elevatedButtonTheme,
        expansionTileTheme: expansionTileTheme,
        filledButtonTheme: filledButtonTheme,
        floatingActionButtonTheme: floatingActionButtonTheme,
        iconButtonTheme: iconButtonTheme,
        listTileTheme: listTileTheme,
        menuBarTheme: menuBarTheme,
        menuButtonTheme: menuButtonTheme,
        menuTheme: menuTheme,
        navigationBarTheme: navigationBarTheme,
        navigationDrawerTheme: navigationDrawerTheme,
        navigationRailTheme: navigationRailTheme,
        outlinedButtonTheme: outlinedButtonTheme,
        popupMenuTheme: popupMenuTheme,
        progressIndicatorTheme: progressIndicatorTheme,
        radioTheme: radioTheme,
        searchBarTheme: searchBarTheme,
        searchViewTheme: searchViewTheme,
        segmentedButtonTheme: segmentedButtonTheme,
        sliderTheme: sliderTheme,
        snackBarTheme: snackBarTheme,
        switchTheme: switchTheme,
        tabBarTheme: tabBarTheme,
        textButtonTheme: textButtonTheme,
        textSelectionTheme: textSelectionTheme,
        timePickerTheme: timePickerTheme,
        toggleButtonsTheme: toggleButtonsTheme,
        tooltipTheme: tooltipTheme,
        buttonBarTheme: buttonBarTheme,
      );
    } else if (Design.isCupertino()) {
      return CupertinoThemeData(
        brightness: brightness,
        primaryColor: primaryColor,
        primaryContrastingColor: primaryColorDark ?? primaryColor!,
        //textTheme: primaryTextTheme ?? textTheme,
        applyThemeToAll: applyThemeToAll,
      );
    }
  }

  @override
  String toString() {
    return "NativeThemeData(platform: $platform)";
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

class NativeScaffold extends StatefulWidget {
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
    Key? key,
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
  }) : super(key: key);

  @override
  _NativeScaffoldState createState() => _NativeScaffoldState();
}

class _NativeScaffoldState extends State<NativeScaffold> {
  @override
  Widget build(BuildContext context) {
    if (Design.isMaterial()) {
      return Scaffold(
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

class NativeText extends StatelessWidget {
  final String data;
  final Key? key;
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

  NativeText(this.data, {
    this.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = style ?? TextStyle();
    return Text(data, key: key, style: textStyle.copyWith(fontFamily: fontFamily ?? getFont()), strutStyle: strutStyle, textAlign: textAlign, textDirection: textDirection, locale: locale, softWrap: softWrap, overflow: overflow, textScaleFactor: textScaleFactor, textScaler: textScaler, maxLines: maxLines, semanticsLabel: semanticsLabel, textWidthBasis: textWidthBasis, textHeightBehavior: textHeightBehavior, selectionColor: selectionColor);
  }
}

String getFont() {
  if (Design.isMaterial()) {
    return 'Roboto.bold';
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