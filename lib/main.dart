import 'package:fireblogs/data/auth.dart';
import 'package:fireblogs/data/blogs.dart';
import 'package:fireblogs/data/userProfile.dart';
import 'package:fireblogs/screens/add_blog_screen.dart';
import 'package:fireblogs/screens/auth_screen.dart';
import 'package:fireblogs/screens/home.dart';
import 'package:fireblogs/screens/splash_screen.dart';
import 'package:fireblogs/screens/user_blogs_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Blogs>(
          create: (BuildContext context) => Blogs(),
          update: (_, auth, blogs) =>
              blogs..update(auth.token, auth.userId, auth.username),
        ),
        ChangeNotifierProxyProvider<Auth, UserProfile>(
          create: (BuildContext context) => UserProfile(),
          update: (_, auth, userProfile) =>
              userProfile..update(auth.token, auth.userId, auth.username),
        )
      ],
      child: Consumer<Auth>(
        builder: (BuildContext context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FireBlogs',
          home: auth.isAuth
              ? Home()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    return snapshot.connectionState == ConnectionState.waiting
                        ? SplashScreen()
                        : AuthScreen();
                  },
                ),
          routes: {
            AddBlogScreen.routeName: (ctx) => AddBlogScreen(),
            UserBlogsScreen.routeName: (ctx) => UserBlogsScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
          },
        ),
      ),
    );
  }
}
