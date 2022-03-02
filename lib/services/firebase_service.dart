import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:suggest_filmov/components/check_error.dart';
import 'package:suggest_filmov/const.dart';
import 'package:suggest_filmov/models/current_user.dart';
import 'package:suggest_filmov/provider/provider_data.dart';
import 'package:suggest_filmov/screens/auth/auth.dart';

import '../screens/bottombar.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseStorage _storage = FirebaseStorage.instance;

class FirestoreService {
  static Future<void> getUser(ProviderData data) async {
    try {
      await _db
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value) {
        data.currUser = CurrUser.fromJson(value.id, value.data()!);
        data.getUrl();
      });
    } catch (e) {
      //  print(e.toString());
      throw Exception("the person not found");
    }
  }

  static Future<void> addUser(CurrUser user) async {
    await _db.collection("users").doc(user.id).set(user.toMap(user));
  }
}

class AuthService {
  static Future<void> register(BuildContext context, String email,
      String password, ProviderData data, CurrUser currUser) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        currUser.id = value.user!.uid;
        FirestoreService.addUser(currUser).then(
          (value) {
            data.loaded = true;
            goToRemove(context, BottomBarPage());
          },
        );
      });
    } catch (e) {
      //print(e.toString());
      CheckError.checkErrors(e, context);
    }
  }

  static Future<void> login(BuildContext context, String email, String password,
      ProviderData data) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        FirestoreService.getUser(data).then((value) {
          data.loaded = true;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomBarPage(),
            ),
          );
        });
      });
    } catch (e) {
      // print(e.toString());
      CheckError.checkErrors(e, context);
    }
  }

  static bool isLogin() {
    return _auth.currentUser != null;
  }

  static Future<void> signOut(BuildContext context) async {
    await _auth.signOut().then((value) {
      goToRemove(context, AuthScreen());
    });
  }
}

class FirestorageService {
  static Future<String> uploadMedia(File file) async {
    var uploadTask = _storage
        .ref()
        .child(
            "${DateTime.now().millisecondsSinceEpoch}.${file.path.split('.').last}")
        .putFile(file);

    uploadTask.snapshotEvents.listen((event) {});

    var storageRef = await uploadTask;

    return await storageRef.ref.getDownloadURL();
  }

  static Future selectFile() async {
    //var result = await
  }
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static UploadTask? uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putData(data);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static Future<void> uploadImage(File uploadFile) async {
    Reference referencePath = _storage
        .ref()
        .child("profileImages")
        .child(_auth.currentUser!.uid)
        .child("profileImage.png");

    UploadTask uploadTask = referencePath.putFile(uploadFile);
  }

  static Future<String> loadImage() async {
    Reference ref = _storage
        .ref()
        .child("profileImages")
        .child(_auth.currentUser!.uid)
        .child("profileImage.png");
    return await ref.getDownloadURL();
  }
}
