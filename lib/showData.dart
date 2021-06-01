import 'dart:collection';
import 'package:flutter/material.dart';

class ShowData extends StatefulWidget {
  @override
  final LinkedHashMap<String, dynamic> data;

  ShowData({Key key, this.data}) : super(key: key);
  _ShowDataState createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  List<String> bodyPart = [];
  List<dynamic> bodyPartValue = [];

  @override
  void initState() {
    widget.data.forEach((key, value) {
      if (key != 'measurementId') {
        bodyPart.add(key);
        bodyPartValue.add(value);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Data'),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.white, backgroundColor: Colors.blue),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Take Measurement Again')),
            Container(
              margin: EdgeInsets.only(top: 10),
              height: 500,
              width: 400,
              child: ListView.builder(
                  itemCount: bodyPart.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              bodyPart[index],
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              bodyPartValue[index],
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
