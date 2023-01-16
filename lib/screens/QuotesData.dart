import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../navDrawer.dart';

class QuotesData extends StatefulWidget {
  const QuotesData({Key key}) : super(key: key);

  @override
  State<QuotesData> createState() => _QuotesDataState();
}

class _QuotesDataState extends State<QuotesData> {
  List<Map<String, dynamic>> _quotes = [];
  var _random = new Random();

  void _shuffleQuotes() {
    _quotes.shuffle(_random);
  }

  Future<void> _fetchData() async {
    var response = await http.get(Uri.parse("https://api.quotable.io/quotes?limit=100"));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      _quotes = List<Map<String, dynamic>>.from(json["results"]);
      _shuffleQuotes();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {

    int colorIndex = 0;
    Color _two = Color(0xffA3DEE9);
    Color _four = Color(0xffDCECFF);
    Color _five = Color(0xffC5ABFF);
    Color _three = Color(0xffFAD764);
    Color _one = Color(0xffFFE9ED);
    List mixColors = [_one, _two, _three, _four, _five];

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Philosophy"),
        backgroundColor: Colors.blue,
      ),
      body: _quotes.length > 0
          ? Scrollbar(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _quotes.length,
                itemBuilder: (context, index) {
                  List tags = _quotes[index]['tags'];

                  if(colorIndex < 4){
                    colorIndex +=1;
                  }else{
                    colorIndex = 0;
                  }

                  return Card(
                    margin: EdgeInsets.all(10),
                    color: mixColors[colorIndex],
                    elevation: 8.0,
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(_quotes[index]['author'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20)),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              '"${_quotes[index]['content']}"',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            (tags.isNotEmpty) ?
                            Text("#${tags[0]}", style: TextStyle(color: Color(0xff71838E), fontWeight: FontWeight.w600)):
                            Text("#philosophy", style: TextStyle(color: Color(0xff71838E), fontWeight: FontWeight.w600))

                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
