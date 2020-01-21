import 'package:fengchao/models/custom_entity.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

final List<CustomEntity> postList = [
  CustomEntity(value: 1, label: "保密", selected: true),
  CustomEntity(value: 2, label: "IT|通信|互联网", selected: false),
  CustomEntity(value: 3, label: "机械机电|自动化", selected: false),
  CustomEntity(value: 4, label: "专业服务", selected: false),
  CustomEntity(value: 5, label: "冶金冶炼|五金|采掘", selected: false),
  CustomEntity(value: 6, label: "化工行业", selected: false),
  CustomEntity(value: 7, label: "纺织服装|皮革鞋帽", selected: false),
  CustomEntity(value: 8, label: "电子电器|仪器仪表", selected: false),
  CustomEntity(value: 9, label: "快消品|办公用品", selected: false),
  CustomEntity(value: 10, label: "房产|建筑|城建|环保", selected: false),
  CustomEntity(value: 11, label: "金融行业", selected: false),
  CustomEntity(value: 12, label: "制药|医疗", selected: false),
  CustomEntity(value: 13, label: "生活服务|娱乐休闲", selected: false),
  CustomEntity(value: 14, label: "交通工具|运输物流", selected: false),
  CustomEntity(value: 15, label: "批发|零售|贸易", selected: false),
  CustomEntity(value: 16, label: "广告|媒体", selected: false),
  CustomEntity(value: 17, label: "教育|科研|培训", selected: false),
  CustomEntity(value: 18, label: "造纸|印刷", selected: false),
  CustomEntity(value: 19, label: "包装|工艺礼品|奢侈品", selected: false),
  CustomEntity(value: 20, label: "营销|销售人员", selected: false),
  CustomEntity(value: 21, label: "能源|资源", selected: false),
  CustomEntity(value: 22, label: "农|林|牧|渔", selected: false),
  CustomEntity(value: 23, label: "政府|非赢利机构|其他", selected: false),
  CustomEntity(value: 24, label: "其他", selected: false)
];

class PopupIndustry extends StatefulWidget {
  PopupIndustry({Key key, this.arguments}) : super(key: key);
  final arguments;

  _PopupIndustryState createState() => _PopupIndustryState();
}

class _PopupIndustryState extends State<PopupIndustry> {
  CustomEntity _targetSelect;
  List<CustomEntity> _industryList;

  @override
  void initState() {
    super.initState();
    initUserData();
  }

  void initUserData() {
    _industryList = _industryList ?? postList;

    for (var item in _industryList) {
      item.selected = false;
    }

    if (widget.arguments['id'] == 0) {
      _industryList[0].selected = true;
    } else {
      _industryList[widget.arguments['id'] - 1].selected = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: Text('选择所属行业'),
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
          itemList: postList,
          onSelect: _onItemSelect,
        ),
      ),
    );
  }

  void _onItemSelect(int index) {
    for (var item in _industryList) {
      item.selected = false;
    }
    _industryList[index].selected = true;
    _targetSelect = _industryList[index];
    setState(() {});
  }

  CustomEntity _buildResult() {
    return _targetSelect;
  }
}

class ListWidget extends StatelessWidget {
  final List<CustomEntity> itemList;
  final int selectedId;
  final ValueChanged<int> onSelect;

  ListWidget({this.itemList, this.onSelect, this.selectedId});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        CustomEntity item = itemList[index];
        return Container(
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: theme.dividerColor, width: 1.0))),
          child: CheckboxListTile(
            value: itemList[index].selected,
            title: Text(item.label),
            // item 标题
            dense: true,
            // item 直观感受是整体大小
            onChanged: (bool val) {
              onSelect(index);
            },
          ),
        );
      },
      itemCount: itemList.length,
    );
  }
}
