// import 'package:dio/dio.dart';
// import 'package:get_it/get_it.dart';
// import 'package:http/http.dart' as http;
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:pucho/core/api/ai_api_client.dart';
// import 'package:pucho/features/Personalization_research/providers/research_area_providers.dart';
// import 'package:pucho/features/Personalization_research/providers/research_style_providers.dart';
// import 'package:pucho/features/Personalization_research/repositories/area_repository_repositories.dart';
// import 'package:pucho/features/Personalization_research/repositories/style_repository_repositories.dart';
// import 'package:pucho/features/Personalize/provider/personalize_provider.dart';
// import 'package:pucho/features/agents/data/repository/agent_repository.dart';
// import 'package:pucho/features/agents/provider/agent_provider.dart';
// import 'package:pucho/features/bottombar/data/repository/bottombar_repository.dart';
// import 'package:pucho/features/bottombar/providers/bottombar_provider.dart';
// import 'package:pucho/features/chat/data/repository/chat_repository.dart';
// import 'package:pucho/features/chat/providers/app_tutorial.dart';
// import 'package:pucho/features/chat/providers/chat_provider.dart';
// import 'package:pucho/features/chat/providers/speak_to_speak_provider.dart';
// import 'package:pucho/features/chat_history/data/repository/chat_history_repository.dart';
// import 'package:pucho/features/chat_history/provider/chat_history_provider.dart';
// import 'package:pucho/features/login/data/repository/login_repository.dart';
// import 'package:pucho/features/login/data/service/auth_service.dart';
// import 'package:pucho/features/login/data/service/user_service.dart';
// import 'package:pucho/features/login/providers/auth_provider.dart';
// import 'package:pucho/features/login/providers/login_provider.dart';
// import 'package:pucho/features/profile/data/repository/profile_repository.dart';
// import 'package:pucho/features/profile/provider/myprofile_provider.dart';
// import 'package:pucho/features/security/provider/security_provider.dart';
// import 'package:pucho/features/security/repository/password_repository.dart';
// import 'package:pucho/features/settings/provider/manage_lanaguge_provider.dart';
// import 'package:pucho/features/settings/data/repository/manage_language_repository.dart';
// import 'package:pucho/features/side_bar/provider/side_bar_provider.dart';
// import 'package:pucho/features/voice_search/provider/voice_search_provider.dart';
// import 'package:pucho/shared/languagemanagement/language_provider.dart';
// import 'package:pucho/shared/services/newtexttospeechservice.dart';
// import 'package:pucho/shared/services/texttospeechservice.dart';
// import 'package:pucho/shared/sharedprovider/button_state_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'core/api/api_client.dart';
// import 'core/utils/network_info.dart';
// import 'features/example_feature/data/repositories/feature_repository.dart';
// import 'features/example_feature/providers/feature_provider.dart';

// final GetIt getIt = GetIt.instance;

// Future<void> setupDependencies() async {
//   // Core
//   getIt.registerLazySingleton(() => http.Client());
//   getIt.registerLazySingleton(() => Dio());
//   getIt.registerLazySingleton(() => InternetConnectionChecker());
//   getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));
//   getIt.registerLazySingleton(() => ApiClient(getIt(), getIt()));
//   getIt.registerLazySingleton(() => AIApiClient(getIt()));

//   //sharedpref
//   final sharedPreferences = await SharedPreferences.getInstance();
//   getIt.registerSingleton<SharedPreferences>(sharedPreferences);

//   //services
//   getIt.registerSingleton<AuthService>(AuthService(getIt<SharedPreferences>()));
//   getIt.registerSingleton<UserService>(
//       UserService(getIt<Dio>(), getIt<NetworkInfo>()));

//   // Repositories
//   getIt.registerLazySingleton(() => FeatureRepository(getIt()));
//   getIt.registerLazySingleton(() => LoginRepository());
//   getIt.registerLazySingleton(() => BottomBarRepository(getIt(), getIt()));
//   getIt.registerLazySingleton(() => ChatRepository(getIt(), getIt()));
//   getIt.registerLazySingleton(() => ProfileRepository(getIt()));
//   getIt.registerLazySingleton(() => ChatHistoryRepository(getIt()));
//   getIt.registerLazySingleton(() => AgentRepository(getIt(), getIt(), getIt()));
//   getIt.registerLazySingleton(() => PasswordRepository(getIt()));
//   getIt.registerLazySingleton(() => AreaRepository(getIt()));
//   getIt.registerLazySingleton(() => ResearchStyleRepository(getIt()));
//   getIt.registerLazySingleton(() => ManageLanguageRepository(getIt()));

//   // Providers - IMPORTANT: Register AuthProvider BEFORE LoginProvider
//   getIt.registerFactory<AuthProvider>(
//       () => AuthProvider(getIt<AuthService>(), getIt<UserService>()));

//   //LoginProvider since AuthProvider is already registered
//   getIt.registerFactory<LoginProvider>(
//       () => LoginProvider(getIt<AuthProvider>()));

//   getIt.registerFactory(() => ButtonStateProvider());
//   getIt.registerFactory(() => FeatureProvider(getIt()));
//   getIt.registerFactory(() => BottomBarProvider(getIt()));
//   getIt.registerFactory(() => LanguageProvider());
//   getIt.registerFactory(() => ChatProvider(getIt(), getIt(), getIt()));
//   getIt.registerFactory(() => ProfileProvider(getIt(), getIt()));
//   getIt.registerFactory(() => SideBarProvider());
//   getIt.registerFactory(() => ChatHistoryProvider(getIt()));

//   getIt.registerFactory<AgentProvider>(
//       () => AgentProvider(getIt<AgentRepository>(), getIt<UserService>()));
//   getIt.registerFactory(() => VoiceSearchProvider());
//   getIt.registerFactory(() => PersonalizeProvider(getIt(), getIt()));
//   getIt.registerFactory(() => ChangePasswordProvider(getIt()));
//   getIt.registerFactory(() => TextToSpeechProvider());
//   getIt.registerFactory(() => AreaProvider(getIt(), getIt(), getIt()));
//   getIt.registerFactory(() => ResearchStyleProvider(getIt(), getIt()));
//   getIt.registerFactory(() => SpeaktoSpeakProvider(getIt()));
//   getIt.registerFactory(() => TTSProvider());
//   getIt.registerFactory(
//       () => ManageLanagugeProvider(getIt(), getIt(), getIt()));
//   getIt.registerFactory(() => TutorialState());
//   // You can add more dependencies here as your app grows
// }
