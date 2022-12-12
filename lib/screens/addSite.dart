import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class addSite extends StatefulWidget {
  const addSite(BuildContext context, {Key? key}) : super(key: key);

  @override
  State<addSite> createState() => _addSiteState();
}

class _addSiteState extends State<addSite> {
  final _formKey = GlobalKey<FormState>();
  String urlName = '';
  String url = '';
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.drive_file_rename_outline),
                    hintText: 'Google',
                    labelText: 'Name *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    urlName = value;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.link),
                    hintText: 'https://www.google.com/',
                    labelText: 'URL *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    url = value;
                  },
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonBar(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true)
                              .pop('Cancel');
                        },
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        child: Text("Add"),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            print("urlName: $urlName, url $url");
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
