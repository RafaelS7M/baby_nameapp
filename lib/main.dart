import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MyApp());
final = [
  {"name": "Rafael", "votes": 15},
  {"name": "Marcos", "votes": 14},
  {"name": "Carlos", "votes": 11},
  {"name": "Wanbasten", "votes": 10},
  {"name": "Bruno", "votes": 1},
];
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'baby_name',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState(){
    return _MyHomePageState();

  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text('votos para nomes de bebês')),
      body: _buildBody(context),
    );
  }
  Widget _buildBody(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('baby').snapshots(),
      builder: (context, snapshot){
        if (!snapshot.hasData) return LinearProgressIndicator();

    return _buildList(context, snapshot.data.documents);
     },
   );
  }
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot){
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }
  Widget _buildListItem(BuildContext context, DocumentSnapshot data){
    final record = Record.fromSnapshot(data);
    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey)
        ),
        child: ListTile(
          title: Text(record.name),
          trailing: Text(record.votes.toString()),
          onTap: () => record.reference.updateData({'votes': FieldValue.increment(1)}),
        ),
      ),
    );
  }
}
  class Record {
    final String name;
    final int votes;
    final DocumentReference reference;

    Record.fromMap(Map<String, dynamic> map, {this.reference})
          : assert(map['name'] != null),
            assert(map['votes'] != null),
            name = map['name'],
            votes = map['votes'];
    Record.fromSnapshot(DocumentSnapshot snapshot)
          : this.fromMap(snapshot.data, reference: snapshot.reference);

    @override 
    String toString() => "Record<$name:$votes>";
    
  }
