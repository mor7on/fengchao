import 'package:fengchao/common/utils/sp_utils.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/provider/app_state_model.dart';
import 'package:fengchao/provider/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeDataComponent extends StatelessWidget {
  const ThemeDataComponent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('切换主题'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: AppTheme.values.length,
        itemBuilder: (BuildContext context, int index) {
          final itemAppTheme = AppTheme.values[index];
          return Card(
            color: appThemeData[itemAppTheme].primaryColor,
            child: ListTile(
              title: Text(appThemeTitle[itemAppTheme], style: appThemeData[itemAppTheme].textTheme.body1),
              onTap: () async {
                Provider.of<AppStateModel>(context).refreshTheme(appThemeData[itemAppTheme]);
                SpUtil.putInt('xxTheme', index);
              },
            ),
          );
        },
      ),
    );
  }
}
