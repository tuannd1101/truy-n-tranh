import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'providers/auth_provider.dart';
import 'data/network/api_service.dart';
import 'data/network/tag_api_service.dart';
import 'data/network/creator_api_service.dart';
import 'data/network/manga_api_service.dart';
import 'providers/tag_provider.dart';
import 'providers/creator_provider.dart';
import 'providers/manga_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..checkAuthStatus()),
        Provider<ApiService>(create: (_) => ApiService()),
        ProxyProvider<ApiService, TagApiService>(
          update: (_, api, __) => TagApiService(api),
        ),
        ChangeNotifierProxyProvider<TagApiService, TagProvider>(
          create: (context) => TagProvider(TagApiService(ApiService())),
          update: (_, tagApi, previous) => previous ?? TagProvider(tagApi),
        ),
        ProxyProvider<ApiService, CreatorApiService>(
          update: (_, api, __) => CreatorApiService(api),
        ),
        ChangeNotifierProxyProvider<CreatorApiService, CreatorProvider>(
          create: (context) => CreatorProvider(CreatorApiService(ApiService())),
          update: (_, creatorApi, previous) => previous ?? CreatorProvider(creatorApi),
        ),
        ProxyProvider<ApiService, MangaApiService>(
          update: (_, api, __) => MangaApiService(api),
        ),
        ChangeNotifierProxyProvider<MangaApiService, MangaProvider>(
          create: (context) => MangaProvider(MangaApiService(ApiService())),
          update: (_, mangaApi, previous) => previous ?? MangaProvider(mangaApi),
        ),
      ],
      child: MaterialApp(
        title: 'MangaFlow',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        initialRoute: AppRouter.login,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
