// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
// home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mtxo_lab/config/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'dependency_injection.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Added async
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // MapboxOptions.setAccessToken(Constants.MapBoxToken);
  // await AppVersionUtil.init();
  // await setupDependencies(); // Added await since setupDependencies is async
  // final userService = getIt<UserService>();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider(context)),
        // ChangeNotifierProvider<FeatureProvider>(
        //   create: (_) => getIt<FeatureProvider>(),
        // ),
        // ChangeNotifierProvider<AuthProvider>(
        //   create: (_) => getIt<AuthProvider>(),
        // ),
        // ChangeNotifierProvider<LoginProvider>(
        //   create: (_) => getIt<LoginProvider>(),
        // ),
        // ChangeNotifierProvider(
        //   create: (_) => getIt<BottomBarProvider>(),
        // ),
        // ChangeNotifierProvider(
        //   create: (_) => getIt<ButtonStateProvider>(),
        // ),
        // ChangeNotifierProvider(
        //   create: (_) => getIt<LanguageProvider>(),
        // ),
        // ChangeNotifierProvider(create: (context) => ThemeProvider(context)),
        // ChangeNotifierProvider(
        //     create: (context) => ProfileScreenController(userService)),
        // ChangeNotifierProvider(
        //   create: (_) => getIt<ChatProvider>(),
        // ),
        // ChangeNotifierProvider(
        //   create: (_) => getIt<SideBarProvider>(),
        // ),
        // ChangeNotifierProvider(
        //   create: (_) => getIt<ProfileProvider>(),
        // ),
        // ChangeNotifierProvider(
        //   create: (_) => getIt<ChatHistoryProvider>(),
        // ),
        // ChangeNotifierProvider(
        //   create: (_) => getIt<AgentProvider>(),
        // ),
        // ChangeNotifierProvider(
        //   create: (_) => getIt<VoiceSearchProvider>(),
        // ),
        // ChangeNotifierProvider(
        //   create: (_) => getIt<PersonalizeProvider>(),
        // ),
        // ChangeNotifierProvider(create: (_) => getIt<ChangePasswordProvider>()),
        // ChangeNotifierProvider(create: (_) => getIt<TextToSpeechProvider>()),
        // ChangeNotifierProvider(create: (_) => getIt<AreaProvider>()),
        // ChangeNotifierProvider(create: (_) => getIt<ResearchStyleProvider>()),
        // ChangeNotifierProvider(create: (_) => getIt<SpeaktoSpeakProvider>()),
        // ChangeNotifierProvider(create: (_) => getIt<TTSProvider>()),
        // ChangeNotifierProvider(create: (_) => getIt<ManageLanagugeProvider>()),
        //  ChangeNotifierProvider(create: (_) => getIt<TutorialState>()),
      ],
      child: const MyApp(),
    ),
  );
}
