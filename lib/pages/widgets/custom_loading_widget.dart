import 'package:flutter/material.dart';

// class CustomLoadingWidget extends StatelessWidget {
//   const CustomLoadingWidget({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: 400.0,
//       child: Center(
//           child: SizedBox(
//         height: 200.0,
//         width: 300.0,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Container(
//                 width: 50.0,
//                 height: 50.0,
//                 child: SpinKitFadingCube(
//                   color: Theme.of(context).primaryColorDark,
//                   size: 25.0,
//                 ),
//               ),
//               Container(
//                 child: Text(FlutterI18n.translate(context, 'loading'),
//                     style: TextStyle(fontSize: 12.0, color: Color(0xFF999999))),
//               )
//             ],
//           ),
//         ),
//       )),
//     );
//   }
// }

class CustomEmptyWidget extends StatelessWidget {
  const CustomEmptyWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300.0,
      alignment: Alignment.center,
      child: Center(
          child: Column(
        children: <Widget>[
          Expanded(flex: 1, child: SizedBox()),
          Icon(Icons.cloud_off, size: 128.0, color: Colors.black12),
          Text('暂无数据',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black12)),
          Expanded(flex: 1, child: SizedBox()),
        ],
      )),
    );
  }
}
