import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp_abrechner/bloc/formular/formular_bloc.dart';
import 'package:flutter_gp_abrechner/drag.dart';
import 'package:flutter_gp_abrechner/fade_page.dart';
import 'package:flutter_gp_abrechner/form.dart';
import 'package:flutter_gp_abrechner/models/document.dart';
import 'package:flutter_gp_abrechner/user_input.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_core/core.dart';

// import 'package:web/web.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return BlocProvider(
          create: (context) => FormularBloc(),
          child: const MyHomePage(),
        );
      },
    ),
    GoRoute(
        path: '/form/:params',
        pageBuilder: (context, state) {
          final doc = Document.fromURL(state.pathParameters['params']!);
          return FadePage(
            child: BlocProvider(
              create: (context) => FormularBloc()
                ..add(
                  FormularPreedited(
                    document: doc,
                  ),
                ),
              child: const MyHomePage(),
            ),
          );
        }),
  ],
);

// enum Type
enum ActionType { action, recherche, seminar, other, notSelected }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Fahrtkostenabrechner",
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData.dark().copyWith(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  Future<void> downloadBytes(Uint8List bytes, String fileName) async {
    await FileSaver.instance.saveFile(
      name: fileName,
      bytes: bytes,
      mimeType: MimeType.pdf,
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return const Scaffold(
      body: Center(
        child: UserInputFormular(),
      ),
      backgroundColor: Color.fromRGBO(42, 39, 55, 1),
    );
  }
}
