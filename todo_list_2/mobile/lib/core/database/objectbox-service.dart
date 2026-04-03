import 'package:path_provider/path_provider.dart';
import '../../objectbox.g.dart';

/// Singleton service managing the ObjectBox Store.
/// Call [initialize] once at app startup before accessing [store].
class ObjectBoxService {
  ObjectBoxService._();

  static late Store _store;

  /// The open ObjectBox Store instance.
  static Store get store => _store;

  /// Opens the ObjectBox Store in the app documents directory.
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    _store = await openStore(directory: '${dir.path}/objectbox');
  }

  /// Closes the store. Call during app teardown if needed.
  static void close() => _store.close();
}
