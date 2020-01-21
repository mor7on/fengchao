import 'package:fengchao/models/category_model.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

List<Category> allKeywords = <Category>[
  Category(
    title: '家教',
    categoryId: 1,
    selected: false,
  ),
  Category(
    title: '跑腿',
    categoryId: 2,
    selected: false,
  ),
  Category(
    title: '代购',
    categoryId: 3,
    selected: false,
  ),
  Category(
    title: '维修',
    categoryId: 4,
    selected: false,
  ),
  Category(
    title: '设计',
    categoryId: 5,
    selected: false,
  ),
  Category(
    title: '制造',
    categoryId: 6,
    selected: false,
  ),
  Category(
    title: '互联网',
    categoryId: 7,
    selected: false,
  ),
  Category(
    title: '翻译',
    categoryId: 8,
    selected: false,
  ),
  Category(
    title: '程序',
    categoryId: 9,
    selected: false,
  ),
  Category(
    title: '房地产',
    categoryId: 10,
    selected: false,
  ),
  Category(
    title: '编程',
    categoryId: 11,
    selected: false,
  ),
  Category(
    title: '开发',
    categoryId: 12,
    selected: false,
  ),
  Category(
    title: '搬家',
    categoryId: 13,
    selected: false,
  ),
  Category(
    title: '货运',
    categoryId: 14,
    selected: false,
  ),
  Category(
    title: '游戏',
    categoryId: 15,
    selected: false,
  ),
  Category(
    title: '广告',
    categoryId: 16,
    selected: false,
  ),
  Category(
    title: '兼职',
    categoryId: 17,
    selected: false,
  ),
  Category(
    title: '印刷',
    categoryId: 18,
    selected: false,
  ),
  Category(
    title: '工艺礼品',
    categoryId: 19,
    selected: false,
  ),
  Category(
    title: '营销',
    categoryId: 20,
    selected: false,
  ),
  Category(
    title: '加工',
    categoryId: 21,
    selected: false,
  ),
  Category(
    title: '文案',
    categoryId: 22,
    selected: false,
  ),
  Category(
    title: '包装',
    categoryId: 23,
    selected: false,
  ),
  Category(
    title: 'IT',
    categoryId: 24,
    selected: false,
  ),
  Category(
    title: '造价',
    categoryId: 25,
    selected: false,
  ),
  Category(
    title: '财务',
    categoryId: 26,
    selected: false,
  ),
];


class PopupKeywords extends StatefulWidget {
  PopupKeywords({Key key, this.arguments}) : super(key: key);
  final arguments;

  _PopupKeywordsState createState() => _PopupKeywordsState();
}

class _PopupKeywordsState extends State<PopupKeywords> {
  List<Category> _targetSelect;
  List<Category> _allKeywords;

  @override
  void initState() {
    super.initState();
    initUserData();
  }

  void initUserData() {
    print(widget.arguments);
    _allKeywords = _allKeywords ?? allKeywords;

    for (var item in _allKeywords) {
      item.selected = false;
    }

    if (widget.arguments != null) {
      _targetSelect = [];
      for (var i = 0; i < widget.arguments['ids'].length; i++) {
        _allKeywords[widget.arguments['ids'][i]].selected = true;
        _targetSelect.add(_allKeywords[widget.arguments['ids'][i]]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: Text('选择关键词'),
        actions: <Widget>[
          Container(
            width: 60.0,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            child: Center(
              child: FlatButton(
                padding: EdgeInsets.all(2.0),
                color: Colors.blueGrey[400],
                textColor: Colors.white,
                child: Text('确定', style: TextStyle(fontSize: 14.0)),
                onPressed: () {
                  Navigator.of(context).pop(_buildResult());
                },
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        bottom: true,
        child: ListWidget(
          itemList: _allKeywords,
          onSelect: _onItemSelect,
        ),
      ),
    );
  }

  void _onItemSelect(bool val, int index) {
    _allKeywords[index].selected = val;
    setState(() {});
  }

  List<Category> _buildResult() {
    _targetSelect = [];
    for (var i = 0; i < _allKeywords.length; i++) {
      if (_allKeywords[i].selected == true) {
        _targetSelect.add(_allKeywords[i]);
      }
    }
    return _targetSelect;
  }
}

typedef ValuesChanged<T, int> = void Function(T value, int index);

class ListWidget extends StatelessWidget {
  final List<Category> itemList;
  final int selectedId;
  final ValuesChanged<bool, int> onSelect;

  ListWidget({this.itemList, this.onSelect, this.selectedId});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        Category item = itemList[index];
        return Container(
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: theme.dividerColor, width: 1.0))),
          child: CheckboxListTile(
            value: itemList[index].selected,
            title: Text(item.title),
            // item 标题
            dense: true,
            // item 直观感受是整体大小
            onChanged: (bool val) {
              onSelect(val,index);
            },
          ),
        );
      },
      itemCount: itemList.length,
    );
  }
}
