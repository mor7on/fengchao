import 'package:fengchao/models/category_model.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

List<Category> allKeywords = <Category>[
  Category(
    title: '社会',
    categoryId: 1,
    selected: false,
  ),
  Category(
    title: '军事',
    categoryId: 2,
    selected: false,
  ),
  Category(
    title: '文学',
    categoryId: 3,
    selected: false,
  ),
  Category(
    title: '情感',
    categoryId: 4,
    selected: false,
  ),
  Category(
    title: '游戏',
    categoryId: 5,
    selected: false,
  ),
  Category(
    title: '娱乐',
    categoryId: 6,
    selected: false,
  ),
  Category(
    title: '体育',
    categoryId: 7,
    selected: false,
  ),
  Category(
    title: '互联网',
    categoryId: 8,
    selected: false,
  ),
  Category(
    title: '生活',
    categoryId: 9,
    selected: false,
  ),
  Category(
    title: '财经',
    categoryId: 10,
    selected: false,
  ),
  Category(
    title: '教育',
    categoryId: 11,
    selected: false,
  ),
  Category(
    title: '汽车',
    categoryId: 12,
    selected: false,
  ),
  Category(
    title: '健康',
    categoryId: 13,
    selected: false,
  ),
  Category(
    title: '传媒',
    categoryId: 14,
    selected: false,
  ),
  Category(
    title: '房产',
    categoryId: 15,
    selected: false,
  ),
  Category(
    title: '数码',
    categoryId: 16,
    selected: false,
  ),
  Category(
    title: '职场',
    categoryId: 17,
    selected: false,
  ),
  Category(
    title: '学术',
    categoryId: 18,
    selected: false,
  ),
  Category(
    title: '艺术',
    categoryId: 19,
    selected: false,
  ),
  Category(
    title: '科技',
    categoryId: 20,
    selected: false,
  ),
  Category(
    title: '综合',
    categoryId: 21,
    selected: false,
  ),
  Category(
    title: '地区',
    categoryId: 22,
    selected: false,
  ),
  Category(
    title: '电影',
    categoryId: 23,
    selected: false,
  ),
  Category(
    title: '电视',
    categoryId: 24,
    selected: false,
  ),
  Category(
    title: '动漫',
    categoryId: 25,
    selected: false,
  ),
  Category(
    title: '制造',
    categoryId: 26,
    selected: false,
  ),
];


class PopupCategory extends StatefulWidget {
  PopupCategory({Key key, this.arguments}) : super(key: key);
  final arguments;

  _PopupCategoryState createState() => _PopupCategoryState();
}

class _PopupCategoryState extends State<PopupCategory> {
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
