import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/pantry_item.dart';
import '../models/pantry_item_dto.dart';

abstract class PantryRepository {
  Future<Either<Failure, List<PantryItem>>> getPantryItems();
  Future<Either<Failure, void>> addPantryItem(PantryItem item);
  Future<Either<Failure, void>> deletePantryItem(String id);
}

@LazySingleton(as: PantryRepository)
class PantryRepositoryImpl implements PantryRepository {
  final Database database;

  PantryRepositoryImpl(this.database);

  @override
  Future<Either<Failure, List<PantryItem>>> getPantryItems() async {
    try {
      final List<Map<String, dynamic>> maps = await database.query('pantry_items', orderBy: 'expiry_date ASC');
      return Right(maps.map((map) => PantryItemDTO.fromMap(map)).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addPantryItem(PantryItem item) async {
    try {
      final dto = PantryItemDTO(
        id: item.id,
        name: item.name,
        expiryDate: item.expiryDate,
        quantity: item.quantity,
        unit: item.unit,
        category: item.category,
      );
      await database.insert(
        'pantry_items',
        dto.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePantryItem(String id) async {
    try {
      await database.delete(
        'pantry_items',
        where: 'id = ?',
        whereArgs: [id],
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
