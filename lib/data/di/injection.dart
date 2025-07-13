import 'package:get_it/get_it.dart';
import '../datasources/helpers/database_helper.dart';
import '../datasources/local_data_source.dart';
import '../datasources/assets_data_source.dart';
import '../repositories/app_repository_impl.dart';
import '../../domain/repositories/app_repository.dart';
import '../../domain/usecases/cart_use_case.dart';
import '../../domain/usecases/favorites_use_case.dart';
import '../../domain/usecases/product_use_case.dart';

final GetIt getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // Initialize Hive database
  await DatabaseHelper.init();

  // Data sources
  getIt.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());
  getIt.registerLazySingleton<AssetsDataSource>(() => AssetsDataSourceImpl());

  // Repositories
  getIt.registerLazySingleton<AppRepository>(
    () =>
        AppRepositoryImpl(getIt<LocalDataSource>(), getIt<AssetsDataSource>()),
  );

  // Use cases
  getIt.registerLazySingleton<FavoritesUseCase>(
    () => FavoritesUseCase(getIt<AppRepository>()),
  );
  getIt.registerLazySingleton<CartUseCase>(
    () => CartUseCase(getIt<AppRepository>()),
  );
  getIt.registerLazySingleton<ProductUseCase>(
    () => ProductUseCase(getIt<AppRepository>()),
  );
}

void disposeDependencies() {
  DatabaseHelper.close();
  getIt.reset();
}
