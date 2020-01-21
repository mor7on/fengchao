import 'package:fengchao/common/utils/sp_utils.dart';
import 'package:fengchao/pages/widgets/custom_appbar.dart';
import 'package:fengchao/pages/widgets/custom_stepper.dart';
import 'package:fengchao/pages/widgets/loading_widget.dart';
import 'package:fengchao/provider/mission_steps_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MissionOperationsComponent extends StatefulWidget {
  MissionOperationsComponent({Key key, this.arguments}) : super(key: key);
  final Map arguments;

  _MissionOperationsComponentState createState() => _MissionOperationsComponentState();
}

class _MissionOperationsComponentState extends State<MissionOperationsComponent> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        print('初始化Provider');
        Provider.of<StepperModel>(context, listen: false).init(params: widget.arguments, context: context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("任务执行..."),
      ),
      bottomNavigationBar: Consumer<StepperModel>(
        builder: (context, model, _) {
          return model.missionSteps == null
              ? Container(
                  width: double.infinity,
                  height: 50.0,
                  color: Color(0xFF121234),
                )
              : _biudBottomBar(context, model);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<StepperModel>(builder: (context, model, child) {
          return model.missionSteps == null
              ? loadWidget
              : CustomStepper(
                  currentStep: model.currentStep,
                  steps: model.missionSteps,
                  type: StepperType.vertical,
                  onStepTapped: (step) {
                    print("onStepTapped : " + step.toString());
                    model.setCurrentStep(step);
                  },
                );
        }),
      ),
    );
  }

  Widget _biudBottomBar(BuildContext context, StepperModel model) {
    int loginId = SpUtil.getInt('xxUserId');
    int curStep = model.currentStep + 1;
    bool isPostUser = loginId == model.postUserId;
    Widget inerChild;
    if (isPostUser) {
      if (curStep == 1) {
        inerChild = new _BottomBarItem(
          title: Text(
            '待乙方提交成果',
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        );
      }
      if (curStep == 2) {
        inerChild = new _BottomBarItem(
          title: Text(
            '待确认成果',
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
          onPressed: () {
            Map<String, dynamic> params = new Map();
            params.addAll(model.curStepParams);
            params.addAll({'isShow': true});
            Navigator.pushNamed(context, '/missionResult', arguments: params);
          },
          child: Icon(
            Icons.navigate_next,
            color: Colors.white,
          ),
        );
      }
      if (curStep == 3) {
        inerChild = new _BottomBarItem(
          title: Text(
            model.hasPayOff ? '待乙方确认收款' : '待付款',
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
          onPressed: () {
            Map<String, dynamic> params = new Map();
            params.addAll({'tradeInfo': model.tradeInfo, 'missionInfo': model.missionInfo});
            Navigator.pushNamed(context, '/missionBill', arguments: params);
          },
          child: Icon(
            Icons.navigate_next,
            color: Colors.white,
          ),
        );
      }
      if (curStep == 4) {
        inerChild = new _BottomBarItem(
          title: Text(
            model.hasRated ? '已评价' : '待评价',
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
          onPressed: model.hasRated
              ? null
              : () {
                  Navigator.pushNamed(context, '/missionRate',
                      arguments: {'user_id': model.tradeInfo['user_id'], 'trade_id': model.tradeInfo['id']});
                },
          child: model.hasRated
              ? null
              : Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                ),
        );
      }
    } else {
      if (curStep == 1) {
        inerChild = new _BottomBarItem(
          title: Text(
            '待提交成果',
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/postResult', arguments: {'id': model.tradeInfo['id']});
          },
          child: Icon(
            Icons.navigate_next,
            color: Colors.white,
          ),
        );
      }
      if (curStep == 2) {
        inerChild = new _BottomBarItem(
          title: Text(
            '待甲方确认成果',
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
        );
      }
      if (curStep == 3) {
        inerChild = new _BottomBarItem(
          title: Text(
            model.hasPayOff ? '待确认收款' : '待甲方付款',
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
          onPressed: () {
            Map<String, dynamic> params = new Map();
            params.addAll({'tradeInfo': model.tradeInfo, 'missionInfo': model.missionInfo});
            Navigator.pushNamed(context, '/missionBill', arguments: params);
          },
          child: Icon(
            Icons.navigate_next,
            color: Colors.white,
          ),
        );
      }
      if (curStep == 4) {
        inerChild = new _BottomBarItem(
          title: Text(
            model.hasRated ? '已评价' : '待评价',
            style: TextStyle(fontSize: 16.0, color: Colors.white),
          ),
          onPressed: model.hasRated
              ? null
              : () {
                  Navigator.pushNamed(context, '/missionRate',
                      arguments: {'user_id': model.postUserId, 'trade_id': model.tradeInfo['id']});
                },
          child: model.hasRated
              ? null
              : Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                ),
        );
      }
    }

    Widget bottomBar = Container(
      width: double.infinity,
      height: 60.0,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Container(
              width: double.infinity,
              height: 50.0,
              color: Color(0xFF121234),
              child: inerChild,
            ),
          ),
          Positioned(
            left: 16.0,
            top: 0.0,
            child: CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: Text(
                '$curStep',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );

    return bottomBar;
  }
}

class _BottomBarItem extends StatelessWidget {
  final Widget title;
  final VoidCallback onPressed;
  final Widget child;
  const _BottomBarItem({
    Key key,
    this.title,
    this.onPressed,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 70.0,
        ),
        Expanded(
          child: Container(
            child: title,
          ),
        ),
        Material(
          color: Colors.blueGrey,
          child: InkWell(
            child: Container(
              width: 70.0,
              height: 50.0,
              child: child,
            ),
            onTap: onPressed,
          ),
        )
      ],
    );
  }
}
