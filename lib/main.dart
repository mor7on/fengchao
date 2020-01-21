import 'dart:async';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:fengchao/common/utils/common_utils.dart';
import 'package:fengchao/common/utils/sp_utils.dart';
import 'package:fengchao/models/home_red_dot.dart';
import 'package:fengchao/pages/01index/app_update.dart';
import 'package:fengchao/pages/01index/home_component.dart';
import 'package:fengchao/pages/01index/qrcode_scan.dart';
import 'package:fengchao/pages/01index/splash_component.dart';
import 'package:fengchao/pages/01index/temp_chat.dart';
import 'package:fengchao/pages/01index/user_chatbox.dart';
import 'package:fengchao/pages/01index/user_inbox.dart';
import 'package:fengchao/pages/01index/user_instructions.dart';
import 'package:fengchao/pages/01index/user_login.dart';
import 'package:fengchao/pages/02company/comments.dart';
import 'package:fengchao/pages/02company/company_detail.dart';
import 'package:fengchao/pages/02company/company_edit.dart';
import 'package:fengchao/pages/02company/company_list.dart';
import 'package:fengchao/pages/02company/company_publish.dart';
import 'package:fengchao/pages/02company/popup_industry.dart';
import 'package:fengchao/pages/03mission/mission_bill.dart';
import 'package:fengchao/pages/03mission/mission_center.dart';
import 'package:fengchao/pages/03mission/mission_detail.dart';
import 'package:fengchao/pages/03mission/mission_edit.dart';
import 'package:fengchao/pages/03mission/mission_list.dart';
import 'package:fengchao/pages/03mission/mission_operations.dart';
import 'package:fengchao/pages/03mission/mission_payment.dart';
import 'package:fengchao/pages/03mission/mission_publish.dart';
import 'package:fengchao/pages/03mission/mission_rate.dart';
import 'package:fengchao/pages/03mission/mission_result.dart';
import 'package:fengchao/pages/03mission/mission_result_back.dart';
import 'package:fengchao/pages/03mission/mission_result_toback.dart';
import 'package:fengchao/pages/03mission/post_result.dart';
import 'package:fengchao/pages/04skill/popup_keywords.dart';
import 'package:fengchao/pages/04skill/skill_detail.dart';
import 'package:fengchao/pages/04skill/skill_edit.dart';
import 'package:fengchao/pages/04skill/skill_list.dart';
import 'package:fengchao/pages/04skill/skill_publish.dart';
import 'package:fengchao/pages/04skill/team_detail.dart';
import 'package:fengchao/pages/05social/comments.dart';
import 'package:fengchao/pages/05social/popup_category.dart';
import 'package:fengchao/pages/05social/social_detail.dart';
import 'package:fengchao/pages/05social/social_edit.dart';
import 'package:fengchao/pages/05social/social_list.dart';
import 'package:fengchao/pages/05social/social_post_detail.dart';
import 'package:fengchao/pages/05social/social_post_edit.dart';
import 'package:fengchao/pages/05social/social_post_publish.dart';
import 'package:fengchao/pages/05social/social_publish.dart';
import 'package:fengchao/pages/06profile/friends_dynamic.dart';
import 'package:fengchao/pages/06profile/my_certificate.dart';
import 'package:fengchao/pages/06profile/my_favorite/home.dart';
import 'package:fengchao/pages/06profile/my_friends.dart';
import 'package:fengchao/pages/06profile/my_friends_add.dart';
import 'package:fengchao/pages/06profile/my_new_friends.dart';
import 'package:fengchao/pages/06profile/my_option.dart';
import 'package:fengchao/pages/06profile/my_option/about_us.dart';
import 'package:fengchao/pages/06profile/my_option/feed_back.dart';
import 'package:fengchao/pages/06profile/my_option/theme_data.dart';
import 'package:fengchao/pages/06profile/my_profile/my_avatar.dart';
import 'package:fengchao/pages/06profile/my_profile/my_email.dart';
import 'package:fengchao/pages/06profile/my_profile/my_intro.dart';
import 'package:fengchao/pages/06profile/my_profile/my_nickname.dart';
import 'package:fengchao/pages/06profile/my_profile/my_profile.dart';
import 'package:fengchao/pages/06profile/my_profile/my_profile_more.dart';
import 'package:fengchao/pages/06profile/my_profile/my_qrcode.dart';
import 'package:fengchao/pages/06profile/my_profile/my_signature.dart';
import 'package:fengchao/pages/06profile/my_profile/my_skill.dart';
import 'package:fengchao/pages/06profile/my_share.dart';
import 'package:fengchao/pages/06profile/my_skill_list.dart';
import 'package:fengchao/pages/06profile/my_team/apply_team.dart';
import 'package:fengchao/pages/06profile/my_team/creat_team.dart';
import 'package:fengchao/pages/06profile/my_team/edit_team.dart';
import 'package:fengchao/pages/06profile/my_team/my_team.dart';
import 'package:fengchao/pages/06profile/my_team/my_team_qr.dart';
import 'package:fengchao/pages/06profile/my_wallet.dart';
import 'package:fengchao/pages/06profile/my_wallet/bind_bankcard.dart';
import 'package:fengchao/pages/06profile/my_wallet/edit_password.dart';
import 'package:fengchao/pages/06profile/my_wallet/my_balance.dart';
import 'package:fengchao/pages/06profile/my_wallet/my_bill.dart';
import 'package:fengchao/pages/06profile/my_wallet/my_recharge.dart';
import 'package:fengchao/pages/06profile/my_wallet/my_withdraw.dart';
import 'package:fengchao/pages/06profile/my_wallet/my_withdraw_finish.dart';
import 'package:fengchao/pages/06profile/my_wallet/query_bankcard.dart';
import 'package:fengchao/pages/06profile/my_wallet/set_password.dart';
import 'package:fengchao/pages/06profile/user_dynamic.dart';
import 'package:fengchao/pages/06profile/user_info.dart';
import 'package:fengchao/pages/widgets/expect_service.dart';
import 'package:fengchao/provider/app_state_model.dart';
import 'package:fengchao/provider/login_user_model.dart';
import 'package:fengchao/provider/mission_steps_model.dart';
import 'package:fengchao/provider/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

import 'common/utils/common_localizations_delegate.dart';

Future main() async {
  // 判断是否登录
  await SpUtil.getInstance();
  // bool isLogin = CommonUtils.dateToCompare(SpUtil.getString('xxLoginTime'));
  await fluwx.registerWxApi(appId: "wx85d4b2567a9ee2aa");
  var result = await fluwx.isWeChatInstalled();
  print("is installed $result");

  // 读取个人设置信息
  int themeIndex = SpUtil.getInt('xxTheme') ?? 0;
  String localeFile = SpUtil.getString('xxLocale') ?? 'zh_CN';
  Locale xxLocale = Locale(localeFile.split('_')[0], localeFile.split('_')[1]);
  ThemeData xxTheme = appThemeData[AppTheme.values[themeIndex]];

  final FlutterI18nDelegate _flutterI18nDelegate =
      FlutterI18nDelegate(useCountryCode: true, fallbackFile: localeFile, path: 'assets/i18n', forcedLocale: xxLocale);
  await _flutterI18nDelegate.load(null);

  // /// 创建全局Store
  // final store = Store<GlobalState>(getReduce, initialState: GlobalState(theme: xxTheme));

  // runApp(new MyApp(store: store, flutterI18nDelegate: _flutterI18nDelegate, isLogin: isLogin));
  runApp(new MyApp(
    flutterI18nDelegate: _flutterI18nDelegate,
    // isLogin: isLogin,
    kTheme: xxTheme,
    kLocale: xxLocale,
  ));

  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  final FlutterI18nDelegate flutterI18nDelegate;
  // final Store<GlobalState> store;
  // final bool isLogin;
  final ThemeData kTheme;
  final Locale kLocale;

  final _routes = {
    '/': (context) => HomeComponent(),
    '/login': (context) => UserLoginComponent(),
    '/appUpdate': (context) => AppUpdateComponent(),
    '/companyList': (context) => CompanyListComponent(),
    '/companyDetail': (context, {arguments}) => CompanyDetailComponent(arguments: arguments),
    '/companyComments': (context, {arguments}) => CompanyComments(arguments: arguments),
    '/articleComments': (context, {arguments}) => ArticleComments(arguments: arguments),
    '/companyEdit': (context, {arguments}) => CompanyEditComponent(arguments: arguments),
    '/popIndustry': (context, {arguments}) => PopupIndustry(arguments: arguments),
    '/companyPublish': (context) => CompanyPublishComponent(),
    '/missionList': (context) => MissionListComponent(),
    '/missionDetail': (context, {arguments}) => MissionDetailComponent(arguments: arguments),
    '/missionOperations': (context, {arguments}) => MissionOperationsComponent(arguments: arguments),
    '/missionResult': (context, {arguments}) => MissionResultComponent(arguments: arguments),
    '/missionBackResult': (context, {arguments}) => MissionResultBackComponent(arguments: arguments),
    '/missionResultToBack': (context, {arguments}) => MissionResultToBackComponent(arguments: arguments),
    '/missionCenter': (context) => MissionCenterComponent(),
    '/missionPublish': (context) => MissionPublishComponent(),
    '/missionEdit': (context, {arguments}) => MissionEditComponent(arguments: arguments),
    '/missionBill': (context, {arguments}) => MissionBillComponent(arguments: arguments),
    '/missionPayment': (context, {arguments}) => MissionPaymentComponent(arguments: arguments),
    '/missionRate': (context, {arguments}) => MissionRateComponent(arguments: arguments),
    '/postResult': (context, {arguments}) => PostResultComponent(arguments: arguments),
    '/skillList': (context) => SkillListComponent(),
    '/skillPublish': (context) => SkillPublishComponent(),
    '/popKeywords': (context, {arguments}) => PopupKeywords(arguments: arguments),
    '/skillDetail': (context, {arguments}) => SkillDetailComponent(arguments: arguments),
    '/skillEdit': (context, {arguments}) => SkillEditComponent(arguments: arguments),
    '/teamDetail': (context, {arguments}) => TeamDetailComponent(arguments: arguments),
    '/socialList': (context) => SocialListComponent(),
    '/socialPublish': (context) => SocialPublishComponent(),
    '/socialPostPublish': (context, {arguments}) => SocialPostPublishComponent(arguments: arguments),
    '/socialEdit': (context, {arguments}) => SocialEditComponent(arguments: arguments),
    '/socialPostEdit': (context, {arguments}) => SocialPostEditComponent(arguments: arguments),
    '/socialDetail': (context, {arguments}) => SocialDetailComponent(arguments: arguments),
    '/articleDetail': (context, {arguments}) => ArticleDetailComponent(arguments: arguments),
    '/popCategory': (context, {arguments}) => PopupCategory(arguments: arguments),
    '/myCertificate': (context) => MyCertificateComponent(),
    '/mySkillList': (context) => MySkillListComponent(),
    '/myFavoriteList': (context) => MyFavoriteListComponent(),
    '/myFriendsList': (context) => MyFriendsComponent(),
    '/myShareList': (context) => MyShareComponent(),
    '/myTeamInfo': (context, {arguments}) => MyTeamComponent(arguments: arguments),
    '/teamApplyUser': (context, {arguments}) => ApplyTeamComponent(arguments: arguments),
    '/myTeamQR': (context) => MyTeamQRComponent(),
    '/creatTeam': (context) => CreatTeamComponent(),
    '/editTeam': (context) => EditTeamComponent(),
    '/myWalletInfo': (context) => MyWalletComponent(),
    '/myOption': (context) => MyOptionComponent(),
    '/myProfile': (context) => MyProfileComponent(),
    '/myAvatar': (context, {arguments}) => MyAvatarComponent(arguments: arguments),
    '/myNickname': (context, {arguments}) => MyNickNameComponent(arguments: arguments),
    '/mySkillTags': (context, {arguments}) => MySkillTagsComponent(arguments: arguments),
    '/mySignature': (context, {arguments}) => MySignatureComponent(arguments: arguments),
    '/myIntro': (context, {arguments}) => MyIntroComponent(arguments: arguments),
    '/myQrcode': (context, {arguments}) => MyQrcodeComponent(arguments: arguments),
    '/myProfileMore': (context, {arguments}) => MyProfileMoreComponent(arguments: arguments),
    '/myEmail': (context, {arguments}) => MyEmailComponent(arguments: arguments),
    '/myBalance': (context) => MyBalanceComponent(),
    '/myRechage': (context) => MyRechargeComponent(),
    '/myWithdraw': (context) => MyWithdrawComponent(),
    '/myWithdrawFinish': (context, {arguments}) => MyWithdrawFinish(arguments: arguments),
    '/myBill': (context) => MyBillComponent(),
    '/setPassword': (context) => SetPasswordComponent(),
    '/editPassword': (context) => EditPasswordComponent(),
    '/queryBankCard': (context) => QueryBankCardComponent(),
    '/bindBankCard': (context) => BindBankCardComponent(),
    '/myFriendsAdd': (context) => MyFriendsAddComponent(),
    '/myNewFriends': (context) => MyNewFriendsComponent(),
    '/friendsDynamic': (context, {arguments}) => FriendsDynamicComponent(arguments: arguments),
    '/userInfo': (context, {arguments}) => UserInfoComponent(arguments: arguments),
    '/userShareList': (context, {arguments}) => UserDynamicComponent(arguments: arguments),
    '/aboutUs': (context) => AboutUsComponent(),
    '/feedBack': (context) => FeedBackComponent(),
    '/themeData': (context) => ThemeDataComponent(),
    '/qrScan': (context) => QrCodeScanComponent(),
    '/chat': (context, {arguments}) => ChatComponent(arguments: arguments),
    '/inboxInfo': (context) => UserInboxComponent(),
    '/chatBoxInfo': (context) => UserChatBoxComponent(),
    '/expectService': (context) => ExpectServiceComponent(),
    '/userInstro': (context) => UserInstructionsComponent(),
  };

  MyApp({this.flutterI18nDelegate, this.kTheme, this.kLocale});

  @override
  Widget build(BuildContext context) {
    print('App重建--------------------');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => AppStateModel(theme: kTheme, locale: kLocale)),
        ChangeNotifierProvider(builder: (_) => HomeRedDot()),
        ChangeNotifierProvider(builder: (_) => LoginUserModel()),
        ChangeNotifierProvider(builder: (_) => StepperModel()),
      ],
      child: Consumer<AppStateModel>(
        builder: (context, appModel, _) {
          return BotToastInit(
            child: MaterialApp(
              title: '蜂巢',
              debugShowCheckedModeBanner: false,
              theme: appModel.theme,
              locale: appModel.locale,
              supportedLocales: appModel.supportedLocales,
              localizationsDelegates: [
                flutterI18nDelegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                CommonLocalizationsDelegate()
              ],
              home: SplashComponent(),
              // routes: _routes,
              navigatorObservers: [BotToastNavigatorObserver()],
              onGenerateRoute: (settings) {
                final String name = settings.name;
                final Function pageBuilder = _routes[name];
                print(settings);
                if (settings.arguments != null) {
                  // 如果透传了参数
                  return CustomRoute(page: pageBuilder(context, arguments: settings.arguments));
                } else {
                  // 没有透传参数
                  return CustomRoute(page: pageBuilder(context));
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class CustomRoute extends PageRouteBuilder {
  final Widget page;
  CustomRoute({this.page})
      : super(
          // 设置过度时间
          transitionDuration: Duration(milliseconds: 600),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) => // 左右滑动动画效果
              //     SlideTransition(
              //   position: Tween<Offset>(
              //           // 设置滑动的 X , Y 轴
              //           begin: Offset(1.0, 0.0),
              //           end: Offset(0.0, 0.0))
              //       .animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
              //   child: child,
              // ),
              // 渐变效果
              FadeTransition(
            // 从0开始到1
            opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              // 传入设置的动画
              parent: animation,
              // 设置效果，快进漫出   这里有很多内置的效果
              curve: Curves.fastOutSlowIn,
            )),
            child: child,
          ),
          // 缩放动画效果
          //     ScaleTransition(
          //   alignment: Alignment.bottomRight,
          //   scale: Tween(begin: 0.0, end: 1.0).animate(
          //     CurvedAnimation(
          //       parent: animation,
          //       curve: Curves.fastOutSlowIn,
          //     ),
          //   ),
          //   child: child,
          // ),
        );
}
