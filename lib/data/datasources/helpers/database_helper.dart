import 'dart:io';

import 'package:hive_ce/hive.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../models/cart_model.dart';
import '../../models/favorite_model.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Box<CartModel>? _cartBox;
  static Box<FavoriteModel>? _favoriteBox;

  DatabaseHelper._();

  static DatabaseHelper get instance {
    _instance ??= DatabaseHelper._();
    return _instance!;
  }

  static Box<CartModel> get cartBox {
    if (_cartBox == null) {
      throw Exception('Database not initialized. Call init() first.');
    }
    return _cartBox!;
  }

  static Box<FavoriteModel> get favoriteBox {
    if (_favoriteBox == null) {
      throw Exception('Database not initialized. Call init() first.');
    }
    return _favoriteBox!;
  }

  static Future<void> init() async {
    if (_cartBox != null && _favoriteBox != null) return;

    print('Starting Hive initialization...');

    try {
      // Try to get the application documents directory
      final docsDir = await getApplicationDocumentsDirectory();
      final hiveDir = Directory(path.join(docsDir.path, 'hive'));

      print('Checking directory permissions...');
      final canWrite = await _checkDirectoryPermissions(hiveDir);
      if (!canWrite) {
        throw Exception('Cannot write to documents directory');
      }

      // Initialize Hive
      Hive.init(hiveDir.path);

      // Register adapters;
      Hive.registerAdapter(CartModelAdapter());
      Hive.registerAdapter(FavoriteModelAdapter());

      if (!await hiveDir.exists()) {
        print('Creating Hive directory...');
        await hiveDir.create(recursive: true);
      }

      // Open boxes
      _cartBox = await Hive.openBox<CartModel>('cart');
      _favoriteBox = await Hive.openBox<FavoriteModel>('favorites');

      print('Hive initialized successfully');
    } catch (e) {
      print('Error initializing Hive with documents directory: $e');

      // Fallback for macOS - try application support directory
      try {
        final appSupportDir = await getApplicationSupportDirectory();
        final hiveDir = Directory(path.join(appSupportDir.path, 'hive'));

        print('Hive fallback directory path: ${hiveDir.path}');

        if (!await hiveDir.exists()) {
          print('Creating Hive directory...');
          await hiveDir.create(recursive: true);
        }

        print('Checking directory permissions...');
        final canWrite = await _checkDirectoryPermissions(hiveDir);
        if (!canWrite) {
          throw Exception('Cannot write to application support directory');
        }

        // Open boxes
        _cartBox = await Hive.openBox<CartModel>('cart');
        _favoriteBox = await Hive.openBox<FavoriteModel>('favorites');

        print('Hive initialized successfully at fallback location');
      } catch (fallbackError) {
        print('Fallback Hive initialization failed: $fallbackError');

        // Last resort - try temporary directory
        try {
          // final tempDir = Directory.current;
          final hiveDir = Directory(path.join("./", 'hive'));

          print('Hive temp directory path: ${hiveDir.path}');

          // if (!await hiveDir.exists()) {
          //   print('Creating Hive directory...');
          //   await hiveDir.create(recursive: true);
          // }
          //
          // print('Checking directory permissions...');
          // final canWrite = await _checkDirectoryPermissions(hiveDir);
          // if (!canWrite) {
          //   throw Exception('Cannot write to temporary directory');
          // }

          // Open boxes
          _cartBox = await Hive.openBox<CartModel>('cart');
          _favoriteBox = await Hive.openBox<FavoriteModel>('favorites');

          print('Hive initialized successfully at temp location');
        } catch (tempError) {
          print('Temp Hive initialization failed: $tempError');
          rethrow;
        }
      }
    }
  }

  static Future<bool> _checkDirectoryPermissions(Directory dir) async {
    try {
      final testFile = File(path.join(dir.path, 'test_write.tmp'));
      await testFile.writeAsString('test');
      await testFile.delete();
      return true;
    } catch (e) {
      print('Permission check failed: $e');
      return false;
    }
  }

  static void close() {
    print('Closing Hive boxes...');
    _cartBox?.close();
    _favoriteBox?.close();
    _cartBox = null;
    _favoriteBox = null;
  }
}
