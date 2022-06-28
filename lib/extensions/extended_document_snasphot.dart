import 'package:cloud_firestore/cloud_firestore.dart';

extension ExtendedDocumentSnapshot on DocumentSnapshot<Map<String, dynamic>> {
  Map<String, dynamic> toJSON() {
    return (data() ?? {})..['id'] = id;
  }
}
