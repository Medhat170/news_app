import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_flutter/shared/bloc_observer.dart';
import 'package:udemy_flutter/shared/cubit/cubit.dart';
import 'package:udemy_flutter/shared/cubit/states.dart';
import 'package:udemy_flutter/shared/network/local/cache_helper.dart';
import 'package:udemy_flutter/shared/network/remote/dio_helper.dart';
import 'package:udemy_flutter/shared/styles/themes.dart';
import 'layout/news__app/cubit/cubit.dart';
import 'layout/news__app/news_layout.dart';


void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  BlocOverrides.runZoned(
        () async {
      // Use cubits...
          DioHelper.init();
          await CacheHelper.init();

          bool? isDark = CacheHelper.getBoolean(key: 'isDark');

          runApp(MyApp(isDark));
    },
    blocObserver: MyBlocObserver(),
  );

}


class MyApp extends StatelessWidget
{

  final bool? isDark;

  MyApp(this.isDark);

  @override
  Widget build(BuildContext context)
  {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) =>
        NewsCubit()..getBusiness()..getSports()..getScience(),
        ),
        BlocProvider(create: (BuildContext context) =>
        AppCubit()..changeAppMode(
          fromShared: isDark,
        ),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state){},
        builder: (context, state){
          return MaterialApp(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: const NewsLayout(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

}

