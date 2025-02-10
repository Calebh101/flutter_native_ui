library;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_ui/flutter_native_ui.dart';
import 'package:flutter_native_ui/private.dart';

/// Allows you to create theme data based on the platform:
/// 
/// Android/
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
    brightness ??= getBrightness(context);
    if (Design.isMaterialYaru()) {
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
}