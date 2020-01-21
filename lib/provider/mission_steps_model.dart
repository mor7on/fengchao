import 'package:fengchao/common/api/03_mission_list_fun.dart';
import 'package:fengchao/common/utils/sp_utils.dart';
import 'package:fengchao/models/article_model.dart';
import 'package:fengchao/models/custom_step.dart';
import 'package:flutter/material.dart';

class StepperModel with ChangeNotifier {
  CustomStep stepOne;
  CustomStep stepTwo;
  CustomStep stepThree;
  CustomStep stepFour;

  List<CustomStep> _steps;
  List<CustomStep> get missionSteps => _steps;

  Map<String, dynamic> _curStepParams;
  Map<String, dynamic> get curStepParams => _curStepParams;

  int _currentStep;
  int get currentStep => _currentStep;
  void setCurrentStep(index) {
    _currentStep = index;
    notifyListeners();
  }

  ArticleModel _missionInfo;
  ArticleModel get missionInfo => _missionInfo;

  Map<String, dynamic> _tradeInfo;
  Map<String, dynamic> get tradeInfo => _tradeInfo;

  Map<String, dynamic> _queryParams;
  Map<String, dynamic> get queryParams => _queryParams;

  int _taskUserId;
  int get taskUserId => _taskUserId;

  int _postUserId;
  int get postUserId => _postUserId;

  bool _hasRated = false;
  bool get hasRated => _hasRated;

  bool _hasPayOff = false;
  bool get hasPayOff => _hasPayOff;

  bool isShowSubmit() {
    int loginId = SpUtil.getInt('xxUserId');
    if (loginId == _taskUserId && _tradeInfo['state'].length == 0) {
      return true;
    }
    return false;
  }

  bool isShowPayment() {
    int loginId = SpUtil.getInt('xxUserId');
    if (loginId == _postUserId && _hasPayOff == false && currentStep == 2) {
      return true;
    }
    return false;
  }

  BuildContext _missionStepsContext;
  BuildContext get missionStepsContext => _missionStepsContext;

  // Loads the list of available products from the repo.
  Future init({Map params, BuildContext context}) async {
    _missionStepsContext = null;
    _queryParams = null;
    _postUserId = null;
    _missionInfo = null;
    _hasPayOff = false;
    print(params);
    _queryParams = params;
    _postUserId = params['pu_id'];
    _missionInfo = params['missionInfo'];
    _missionStepsContext = context;
    initMissionSteps();
  }

  void initCurrentMissionStepModel() {
    _steps = null;
    _currentStep = null;
    _tradeInfo = null;

    _taskUserId = null;

    _hasRated = false;

    stepOne = CustomStep(
      title: Text('成果提交'),
      content: [],
      state: StepState.indexed,
      isActive: false,
      subtitle: Text('任务完成后，请尽快提交成果'),
    );
    stepTwo = CustomStep(
      title: Text('成果审核'),
      content: [],
      state: StepState.indexed,
      isActive: false,
      subtitle: Text('成果提交后，可通过上方列表查看成果，\n并确认完成付款或退回成果'),
    );
    stepThree = CustomStep(
      title: Text('确认付款'),
      content: [],
      state: StepState.indexed,
      isActive: false,
      subtitle: Text('收到付款通知后，请尽快确认付款，\n或在3天后自动转入乙方账户'),
    );
    stepFour = CustomStep(
      title: Text('双方评价'),
      content: [],
      state: StepState.indexed,
      isActive: false,
      subtitle: Text('双方确认付款后，可进行评价'),
    );
    notifyListeners();
  }

  Future initMissionSteps() async {
    initCurrentMissionStepModel();
    Map<String, dynamic> result = await getMissionStateById(params: queryParams);
    if (null != result) {
      print('-------------------------');
      _tradeInfo = result['data'];
      _taskUserId = _tradeInfo['user_id'];
      _currentStep = _tradeInfo['type'] - 1;
      print(_currentStep);
      _steps = [stepOne, stepTwo, stepThree, stepFour];
      if (_currentStep > 0) {
        for (var i = 0; i < _currentStep; i++) {
          _steps[i].state = StepState.complete;
        }
      }
      if (_currentStep >= 3) {
        _steps[_currentStep - 1].isActive = true;
      } else {
        _steps[_currentStep].isActive = true;
      }

      List steps = _tradeInfo['state'];

      if (steps != null || steps.length > 0) {
        for (var i = 0; i < steps.length; i++) {
          if (steps[i]['type'] == 1) {
            Map<String, dynamic> params = steps[i];
            params.addAll({'pu_id': postUserId});
            _curStepParams = params;
            _steps[0].content.add(
                  StepWidget(
                    operation: steps[i]['operation'],
                    time: steps[i]['create_time'],
                    callBack: () {
                      Navigator.pushNamed(missionStepsContext, '/missionResult', arguments: params);
                    },
                  ),
                );
            setCurrentStep(1);
          } else if (steps[i]['type'] == 2) {
            Function method = () {
              Navigator.pushNamed(missionStepsContext, '/missionBackResult', arguments: steps[i]);
            };
            _curStepParams = steps[i];
            _steps[1].content.add(
                  StepWidget(
                    operation: steps[i]['operation'],
                    time: steps[i]['create_time'],
                    callBack: steps[i]['operation'] == '退回成果' ? method : null,
                  ),
                );
            if (steps[i]['operation'] == '退回成果') {
              setCurrentStep(0);
            } else {
              setCurrentStep(2);
            }
          } else if (steps[i]['type'] == 3 || steps[i]['type'] == 4) {
            Map<String, dynamic> params = {};
            params.addAll({'tradeInfo': _tradeInfo, 'missionInfo': missionInfo});
            _curStepParams = params;
            _steps[2].content.add(
                  StepWidget(
                    operation: steps[i]['operation'],
                    time: steps[i]['create_time'],
                    callBack: () {
                      Navigator.pushNamed(missionStepsContext, '/missionBill', arguments: params);
                    },
                  ),
                );
            if (steps[i]['operation'] == '甲方付款') {
              _hasPayOff = true;
              setCurrentStep(2);
            } else {
              setCurrentStep(3);
            }
          } else {
            Map<String, dynamic> params = steps[i];
            int loginId = SpUtil.getInt('xxUserId');
            if (params['user_id'] == loginId) {
              _hasRated = true;
            }
            params.addAll({'pu_id': _postUserId});
            _curStepParams = params;
            _steps[3].content.add(
                  StepWidget(
                    operation: steps[i]['operation'],
                    time: steps[i]['create_time'].substring(0, 4) + '-##-## ##:##:##',
                    callBack: null,
                  ),
                );
            setCurrentStep(3);
          }
        }
      }

      notifyListeners();
    }
  }
}

class StepWidget extends StatelessWidget {
  const StepWidget({Key key, this.operation, this.time, this.callBack}) : super(key: key);
  final String operation;
  final String time;
  final Function callBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          child: Text(
            operation,
            style: TextStyle(fontSize: 14.0),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Container(
            child: Text(
              time,
              style: TextStyle(fontSize: 14.0),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Container(
          width: 32.0,
          height: 32.0,
          child: IconButton(
            padding: EdgeInsets.all(2.0),
            icon: Icon(Icons.navigate_next),
            onPressed: callBack,
          ),
        ),
      ],
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return ListTile(
  //     dense: true,
  //     contentPadding: EdgeInsets.all(0.0),
  //     title: Text(
  //       content,
  //       maxLines: 1,
  //       overflow: TextOverflow.ellipsis,
  //     ),
  //     subtitle: Text(time),
  //     trailing: Icon(Icons.navigate_next),
  //     onTap: () {
  //       Navigator.pushNamed(context, '/missionResult', arguments: arguments);
  //     },
  //   );
  // }
}
