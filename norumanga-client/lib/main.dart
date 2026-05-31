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
import 'data/network/chapter_api_service.dart';
import 'data/network/bundle_api_service.dart';
import 'data/network/payment_api_service.dart';
import 'data/network/user_api_service.dart';
import 'data/network/role_api_service.dart';
import 'data/network/favorite_api_service.dart';
import 'data/network/reading_history_api_service.dart';
import 'providers/tag_provider.dart';
import 'providers/creator_provider.dart';
import 'providers/manga_provider.dart';
import 'providers/chapter_provider.dart';
import 'providers/search_provider.dart';
import 'providers/bundle_provider.dart';
import 'providers/payment_provider.dart';
import 'providers/user_provider.dart';
import 'providers/role_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/reading_history_provider.dart';

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
        ChangeNotifierProxyProvider<MangaApiService, SearchProvider>(
          create: (context) => SearchProvider(MangaApiService(ApiService())),
          update: (_, mangaApi, previous) => previous ?? SearchProvider(mangaApi),
        ),
        ProxyProvider<ApiService, ChapterApiService>(
          update: (_, api, __) => ChapterApiService(api),
        ),
        ChangeNotifierProxyProvider<ChapterApiService, ChapterProvider>(
          create: (context) => ChapterProvider(ChapterApiService(ApiService())),
          update: (_, chapterApi, previous) => previous ?? ChapterProvider(chapterApi),
        ),
        ProxyProvider<ApiService, BundleApiService>(
          update: (_, api, __) => BundleApiService(api),
        ),
        ChangeNotifierProxyProvider<BundleApiService, BundleProvider>(
          create: (context) => BundleProvider(BundleApiService(ApiService())),
          update: (_, bundleApi, previous) => previous ?? BundleProvider(bundleApi),
        ),
        ProxyProvider<ApiService, PaymentApiService>(
          update: (_, api, __) => PaymentApiService(api),
        ),
        ChangeNotifierProxyProvider<PaymentApiService, PaymentProvider>(
          create: (context) => PaymentProvider(PaymentApiService(ApiService())),
          update: (_, paymentApi, previous) => previous ?? PaymentProvider(paymentApi),
        ),
        ProxyProvider<ApiService, UserApiService>(
          update: (_, api, __) => UserApiService(api),
        ),
        ChangeNotifierProxyProvider<UserApiService, UserProvider>(
          create: (context) => UserProvider(UserApiService(ApiService())),
          update: (_, userApi, previous) => previous ?? UserProvider(userApi),
        ),
        ProxyProvider<ApiService, RoleApiService>(
          update: (_, api, __) => RoleApiService(api),
        ),
        ChangeNotifierProxyProvider<RoleApiService, RoleProvider>(
          create: (context) => RoleProvider(RoleApiService(ApiService())),
          update: (_, roleApi, previous) => previous ?? RoleProvider(roleApi),
        ),
        ProxyProvider<ApiService, FavoriteApiService>(
          update: (_, api, __) => FavoriteApiService(api),
        ),
        ChangeNotifierProxyProvider<FavoriteApiService, FavoriteProvider>(
          create: (context) => FavoriteProvider(FavoriteApiService(ApiService())),
          update: (_, favApi, previous) => previous ?? FavoriteProvider(favApi),
        ),
        ProxyProvider<ApiService, ReadingHistoryApiService>(
          update: (_, api, __) => ReadingHistoryApiService(api),
        ),
        ChangeNotifierProxyProvider<ReadingHistoryApiService, ReadingHistoryProvider>(
          create: (context) =>
              ReadingHistoryProvider(ReadingHistoryApiService(ApiService())),
          update: (_, histApi, previous) =>
              previous ?? ReadingHistoryProvider(histApi),
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
