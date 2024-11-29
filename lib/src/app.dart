import 'package:fit_and_healthy/src/features/routing/app_router.dart';
import 'package:fit_and_healthy/src/features/settings/settings_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// The Widget that configures your application.
class MyApp extends ConsumerWidget {
  const MyApp({
    super.key,
    //required this.settingsController,
  });

  //final SettingsController settingsController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsFuture = ref.watch(settingsControllerProvider.future);
    final appRouter = ref.watch(appRouterProvider);
    return FutureBuilder(
        future: settingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // TODO: Change this if we actually notice a delay in loading the settings
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return CupertinoApp.router(
            // Providing a restorationScopeId allows the Navigator built by the
            // MaterialApp to restore the navigation stack when a user leaves and
            // returns to the app after it has been killed while running in the
            // background.
            restorationScopeId: 'app',

            // Provide the generated AppLocalizations to the MaterialApp. This
            // allows descendant Widgets to display the correct translations
            // depending on the user's locale.
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
            ],

            // Use AppLocalizations to configure the correct application title
            // depending on the user's locale.
            //
            // The appTitle is defined in .arb files found in the localization
            // directory.
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,

            // Define a light and dark color theme. Then, read the user's
            // preferred ThemeMode (light, dark, or system default) from the
            // SettingsController to display the correct theme.
            theme: CupertinoThemeData(
              brightness: snapshot.data!.themeMode == ThemeMode.dark
                  ? Brightness.dark
                  : snapshot.data!.themeMode == ThemeMode.light
                      ? Brightness.light
                      : MediaQuery.platformBrightnessOf(context),
              primaryColor: Colors.blue,
            ),
            // darkTheme: ThemeData.dark(),
            // themeMode: snapshot.data!.themeMode,

            routerConfig: appRouter,

            builder: (context, child) {
              return ScaffoldMessenger(
                key: scaffoldMessengerKey,
                child: child!,
              );
            },
          );
        });
  }
}
