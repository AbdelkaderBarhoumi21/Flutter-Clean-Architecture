import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter_clean_architecture/core/network/network_info.dart';
import 'package:flutter_clean_architecture/core/utils/input_converter.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasources/local/number_trivia_local_datasource.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasources/remote/number_trivia_remote_datasource.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/repositories/number_trivia_repositories_impl.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/repositories/number_trivia_repositories.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/usescases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/usescases/get_random_number_trivia.dart';
import 'package:flutter_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

///It means: if a class holds resources and needs close()/dispose() (like a Bloc with streams), you shouldn’t register it as a singleton
///A singleton lives for the whole app lifetime, so it may never get disposed, causing memory leaks or stale state.
/// Use registerFactory so each screen gets a fresh Bloc and you can dispose it when the screen is removed.
/// You are registering the interface type and returning the implementation.
///registerLazySingleton<NumberTriviaRepositories>(...) tells GetIt: “when someone asks for NumberTriviaRepositories, give them this instance.”
/// The instance you build is NumberTriviaRepositoriesImpl(...).
///So you do use the interface in DI, but the concrete class is what actually gets created.
///If you registered the impl type instead (registerLazySingleton<NumberTriviaRepositoriesImpl>), you’d have to request the impl everywhere, which defeats the abstraction.
///
/// =======> T Function() factoryFunc: required. Function that creates the instance. It runs only on the first sl<T>().<==========
/// String? instanceName: optional. Lets you register multiple instances of the same type and fetch by name.
/// FutureOr<dynamic> Function(T)? dispose: optional. Cleanup callback when the instance is removed/reset.
/// void Function(T)? onCreated: optional. Called right after the instance is created (good for logging or setup).
/// bool useWeakReference: optional. If true, the instance can be garbage‑collected when no one holds it; next sl<T>() will create it again.
final serverLocator = GetIt.instance;
Future<void> init() async {
  //!Features - Number Trivia
  //Bloc
  serverLocator.registerFactory(
    () => NumberTriviaBloc(
      concrete: serverLocator(),
      random: serverLocator(),
      inputConverter: serverLocator(),
    ),
  );
  //Use cases
  serverLocator.registerLazySingleton(
    () => GetConcreteNumberTrivia(serverLocator()),
  );
  serverLocator.registerLazySingleton(
    () => GetRandomNumberTrivia(serverLocator()),
  );

  //Repository
  serverLocator.registerLazySingleton<NumberTriviaRepositories>(
    () => NumberTriviaRepositoriesImpl(
      remoteDataSource: serverLocator(),
      localDataSource: serverLocator(),
      networkInfo: serverLocator(),
    ),
  );

  //Data sources
  serverLocator.registerLazySingleton<NumberTriviaLocalDatasource>(
    () => NumberTriviaLocalDatasourceImpl(sharedPreferences: serverLocator()),
  );
  serverLocator.registerLazySingleton<NumberTriviaRemoteDatasource>(
    () => NumberTriviaRemoteDatasourceImpl(client: serverLocator()),
  );

  //!Core
  serverLocator.registerLazySingleton(() => InputConverter());
  serverLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(serverLocator()),
  );

  //!External
  final sharedPreferences = await SharedPreferences.getInstance();
  serverLocator.registerLazySingleton(() => sharedPreferences);
  serverLocator.registerLazySingleton(() => http.Client());
  serverLocator.registerLazySingleton(() => DataConnectionChecker());
}
