import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire3/models/task.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';

class FirestoreRepository {
  static Future<void> createTask({Task? task}) async {
    try {
      await FirebaseFirestore.instance
          .collection(GetStorage().read('email'))
          .doc(task!.id)
          .set(task.toMap());
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<List<Task>> getAllTasks() async {
    List<Task> tasksList = [];
    try {
      final data = await FirebaseFirestore.instance
          .collection(GetStorage().read('email'))
          .get();

      for (var task in data.docs) {
        tasksList.add(Task.fromMap(task.data()));
      }
      return tasksList;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<void> update({Task? task}) async {
    try {
      final data = await FirebaseFirestore.instance
          .collection(GetStorage().read('email'));
      data.doc(task!.id).update(task.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> delete({Task? task}) async {
    try {
      final data = await FirebaseFirestore.instance
          .collection(GetStorage().read('email'))
          .doc(task!.id);
      data.delete();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> deleteAll({List<Task>? taskList}) async {
    try {
      final data = await FirebaseFirestore.instance
          .collection(GetStorage().read('email'));
      for (var task in taskList!) {
        data.doc(task.id).delete();
      }
    } catch (e) {
      Exception(e.toString());
    }
  }
}
