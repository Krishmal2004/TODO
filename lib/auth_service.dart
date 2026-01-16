import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign In
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      return null;
    }
  }

  // Sign Up
  Future<User?> signUp(String fullName, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      return null;
    }
  }

  // Get ALL tasks (for the main list)
  Stream<QuerySnapshot> getTasks() {
    return _firestore
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Filter tasks specifically for TODAY (for the blue card)
  Stream<QuerySnapshot> getTodayTasks() {
    DateTime now = DateTime.now();
    DateTime startOfToday = DateTime(now.year, now.month, now.day);
    DateTime endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return _firestore
        .collection('tasks')
        .where('dueDate', isGreaterThanOrEqualTo: startOfToday)
        .where('dueDate', isLessThanOrEqualTo: endOfToday)
        .snapshots();
  }

  // Add Task with Due Date
  Future<void> addTask(String title, {required DateTime dueDate, String? subtitle}) async {
    await _firestore.collection('tasks').add({
      'title': title,
      'subtitle': subtitle ?? "",
      'dueDate': Timestamp.fromDate(dueDate), // Stores as Firebase Timestamp
      'isDone': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Delete Task
  Future<void> deleteTask(String docId) async {
    await _firestore.collection('tasks').doc(docId).delete();
  }
}