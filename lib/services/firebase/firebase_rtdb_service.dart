import 'package:firebase_database/firebase_database.dart';

class FirebaseRTDBService {
  final FirebaseDatabase _database;

  FirebaseRTDBService({FirebaseDatabase? database})
      : _database = database ?? FirebaseDatabase.instance;

  /// Obtain reference to a specific path
  DatabaseReference ref(String path) {
    return _database.ref(path);
  }

  /// Write data in a path
  Future<void> set(String path, Map<String, dynamic> data) async {
    await _database.ref(path).set(data);
  }

  /// Update specific fields in a path
  Future<void> update(String path, Map<String, dynamic> data) async {
    await _database.ref(path).update(data);
  }

  /// Delete a path
  Future<void> remove(String path) async {
    await _database.ref(path).remove();
  }

  /// Register a server-side removal to run automatically when the client's
  /// connection drops (crash, force-kill, network loss)
  Future<void> removeOnDisconnect(String path) async {
    await _database.ref(path).onDisconnect().remove();
  }

  /// Cancel a previously registered onDisconnect operation for a path.
  Future<void> cancelOnDisconnect(String path) async {
    await _database.ref(path).onDisconnect().cancel();
  }

  /// Listen changes in a path
  Stream<DatabaseEvent> watch(String path) {
    return _database.ref(path).onValue;
  }

  /// Obtain data ONCE from a path
  Future<DataSnapshot> getOnce(String path) async {
    final snapshot = await _database.ref(path).get();
    return snapshot;
  }

  /// Verify if a path exists
  Future<bool> exists(String path) async {
    final snapshot = await _database.ref(path).get();
    return snapshot.exists;
  }
}