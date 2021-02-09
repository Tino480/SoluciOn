import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class Refrescos extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text('Refrescos'),
//         centerTitle: true,
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('Refrescos').snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData)
//             return new Center(child: CircularProgressIndicator());
//           return orderBuilder(documents: snapshot.data.docs);
//         },
//       ),
//     );
//   }
// }
