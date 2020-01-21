import 'package:flutter/material.dart';

class WithdrawPasswordWidget extends StatelessWidget {
  final List<int> passwords;
  final String title;
  final double coin;
  final Color borderColor;
  const WithdrawPasswordWidget({
    Key key,
    this.passwords,
    this.title,
    this.borderColor = Colors.grey,
    this.coin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              title,
              style: TextStyle(fontSize: 14.0),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            child: Text(
              '账户提现',
              style: TextStyle(fontSize: 14.0),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 3.0),
                child: Text(
                  '¥',
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
              Text(
                coin.toStringAsFixed(2),
                style: TextStyle(fontSize: 24.0),
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '服务费',
                style: TextStyle(fontSize: 12.0),
              ),
              Text(
                '(${(coin * 0.02).toStringAsFixed(2)})',
                style: TextStyle(fontSize: 12.0),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '费率',
                style: TextStyle(fontSize: 12.0),
              ),
              Text(
                '2%(最低¥0.10)',
                style: TextStyle(fontSize: 12.0),
              ),
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          Stack(
            children: <Widget>[
              Container(
                height: 50.0,
                decoration: BoxDecoration(
                  border: Border.fromBorderSide(BorderSide(width: 0.5, color: borderColor)),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          border: Border.fromBorderSide(BorderSide(width: 0.5, color: borderColor)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          border: Border.fromBorderSide(BorderSide(width: 0.5, color: borderColor)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          border: Border.fromBorderSide(BorderSide(width: 0.5, color: borderColor)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          border: Border.fromBorderSide(BorderSide(width: 0.5, color: borderColor)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          border: Border.fromBorderSide(BorderSide(width: 0.5, color: borderColor)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          border: Border.fromBorderSide(BorderSide(width: 0.5, color: borderColor)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: _biuldBlackDot(),
              )
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _biuldBlackDot() {
    List<Widget> children;
    children = passwords.map((f) {
      return Expanded(
        child: Container(
          height: 50.0,
          alignment: Alignment.center,
          child: Container(
            width: 10.0,
            height: 10.0,
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
      );
    }).toList();
    if (passwords.length < 6) {
      for (var i = 0; i < 6 - passwords.length; i++) {
        children.add(
          Expanded(
            child: Container(
              height: 50.0,
              alignment: Alignment.center,
              child: Container(
                width: 10.0,
                height: 10.0,
                decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(10.0)),
              ),
            ),
          ),
        );
      }
    }
    print(children.length);
    return children;
  }
}
