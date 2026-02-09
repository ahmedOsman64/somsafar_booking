import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Example method to get a collection
  CollectionReference getCollection(String collectionName) {
    return _firestore.collection(collectionName);
  }

  // Example method to add data
  Future<void> addData(String collection, Map<String, dynamic> data) async {
    await _firestore.collection(collection).add(data);
  }

  // Example method to get data
  Future<QuerySnapshot> getData(String collection) async {
    return await _firestore.collection(collection).get();
  }

  // Example method to update data
  Future<void> updateData(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    await _firestore.collection(collection).doc(docId).update(data);
  }

  // Example method to delete data
  Future<void> deleteData(String collection, String docId) async {
    await _firestore.collection(collection).doc(docId).delete();
  }

  // Initialize default data if not exists
  Future<void> initializeDatabase() async {
    // Check if 'users' collection has any documents
    final usersSnapshot = await _firestore.collection('users').limit(1).get();
    if (usersSnapshot.docs.isEmpty) {
      // Create a default user or initial data
      await _firestore.collection('users').add({
        'name': 'Default User',
        'email': 'default@example.com',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    // Similarly for other collections, e.g., 'trips'
    final tripsSnapshot = await _firestore.collection('trips').limit(1).get();
    if (tripsSnapshot.docs.isEmpty) {
      await _firestore.collection('trips').add({
        'title': 'Sample Trip',
        'description': 'A sample trip for SomSafar',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
