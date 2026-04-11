// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:predictive_pantry_planner/core/database/database_helper.dart'
    as _i581;
import 'package:predictive_pantry_planner/features/pantry/data/datasources/tflite_vision_datasource.dart'
    as _i970;
import 'package:predictive_pantry_planner/features/pantry/data/repositories/pantry_repository_impl.dart'
    as _i339;
import 'package:predictive_pantry_planner/features/pantry/presentation/bloc/camera_bloc.dart'
    as _i990;
import 'package:predictive_pantry_planner/features/recipes/domain/usecases/generate_recipe_usecase.dart'
    as _i1018;
import 'package:sqflite/sqflite.dart' as _i779;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final databaseModule = _$DatabaseModule();
    await gh.factoryAsync<_i779.Database>(
      () => databaseModule.database,
      preResolve: true,
    );
    gh.lazySingleton<_i339.PantryRepository>(
      () => _i339.PantryRepositoryImpl(gh<_i779.Database>()),
    );
    gh.lazySingleton<_i1018.GenerateRecipeUseCase>(
      () => _i1018.GenerateRecipeUseCase(gh<_i1018.RecipeService>()),
    );
    gh.lazySingleton<_i970.VisionDataSource>(
      () => _i970.TFLiteVisionDataSource(),
    );
    gh.factory<_i990.CameraBloc>(
      () => _i990.CameraBloc(visionDataSource: gh<_i970.VisionDataSource>()),
    );
    return this;
  }
}

class _$DatabaseModule extends _i581.DatabaseModule {}
