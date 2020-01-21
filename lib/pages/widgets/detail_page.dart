
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class DetailPage extends StatelessWidget {
  final List<AssetEntity> list;
  const DetailPage({Key key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: PageView.builder(
        itemBuilder: _pageViewItemBuilder,
        itemCount: list.length,
      ),
    );
  }

  Widget _pageViewItemBuilder(BuildContext context, int index) {
    return FutureBuilder(
      future: list[index].file,
      // initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Widget w;
        if (snapshot.hasError) {
          w = Center(
            child: Text("load error"),
          );
        }
        if (snapshot.hasData) {
          w = GestureDetector(            
            onTap: () => Navigator.of(context).pop(),
            child: Stack(
              children: <Widget>[
                SizedBox.expand(
                  child: Image.file(snapshot.data, fit: BoxFit.contain),
                ),
                Positioned(
                  bottom: 8.0,
                  left: 8.0,
                  child: Text('hahaha', style: TextStyle(fontSize: 16.0)),
                )
              ],
            ),
          );
        } else {
          w = Center(
            child: loadWidget,
          );
        }

        return w;
      },
    );
  }
}
