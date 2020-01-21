
class CONFIG {
  static const PAGE_SIZE = 10;
  static const DEBUG = true;

  /// //////////////////////////////////////常量////////////////////////////////////// ///
  static const BASE_URL = "http://www.4u2000.com/";
  static const USER_AVATAR = BASE_URL + 'h5/static/avatar01.png';
  static const APP_VER = 11421;
  static const APP_VER_NAME = "1.1.421(FY00A421RIP1)";
  static const WEBSOCKET_SERVER = "ws://www.4u2000.com/sesame/websocket";
  static const USER_INFO = "user-info";
  static const LANGUAGE_SELECT = "language-select";
  static const LANGUAGE_SELECT_NAME = "language-select-name";
  static const REFRESH_LANGUAGE = "refreshLanguageApp";
  static const THEME_COLOR = "theme-color";
  static const LOCALE = "locale";
  static const path = {
    'mutiImageUpload'           : 'sesame/api/user/multiupload',
    'kIDCardUpload'           : 'sesame/api/user/card',
    'uploadAvatar'           : 'sesame/api/user/avatar',
    'editUserInfo'           : 'sesame/api/user/information',
    'publishIDCard'           : 'sesame/api/usernofiler/savecard',
    'queryPublicKey'           : 'sesame/api/user/publickey',
    'getUserCertificate'           : 'sesame/api/user/whethercard',
    'getUserUnreadChat'           : 'sesame/api/user/unread',
    'getUserUnreadInbox'           : 'sesame/api/center/isnews',
    'getRecommendQuanzies'      : 'sesame/api/socialcategory/selectrecommend',
    'getRecommendCompanies'     : 'sesame/api/company/selectrecommend',
    'getRecommendMissions'      : 'sesame/api/portaltask/selectrecommend',
    'getRecommendKnowhows'      : 'sesame/api/knowhow/selectrecommend',
    'getCompanyList'            : 'sesame/api/company/select',
    'getCompanyById'            : 'sesame/api/company/single',
    'getCompanyComments'            : 'sesame/api/company/searchleave',
    'getArticleComments'            : 'sesame/api/socialpost/searchleave',
    'toCompanyReply'            : 'sesame/api/company/leave',
    'toArticleReply'            : 'sesame/api/socialpost/leave',
    'addCompany'            : 'sesame/api/company/add',
    'editCompany'            : 'sesame/api/company/update',
    'deleteCompany'            : 'sesame/api/company/delete',
    'getMissionList'            : 'sesame/api/portaltask/select',
    'addMission'              : 'sesame/api/portaltask/add',
    'editMission'              : 'sesame/api/portaltask/update',
    'deleteMission'              : 'sesame/api/portaltask/delete',
    'getMissionById'            : 'sesame/api/portaltask/single',
    'todoBMfunById'            : 'sesame/api/portaltask/enlist', // 任务报名
    'todoTBfunById'            : 'sesame/api/portaltask/tendering', // 任务投标
    'toCancleTenderById'            : 'sesame/api/portaltask/cancelenlist', // 取消报名
    'toAgreeUserWinMissionById'            : 'sesame/api/portaltask/agree', // 同意报名人
    'toRefuseUserWinMissionById'            : 'sesame/api/portaltask/disagree', // 拒绝报名人
    'getMissionStateById'            : 'sesame/api/portaltask/queryresult',
    'toPostResultById'            : 'sesame/api/portaltask/postresult',
    'toRefusResultById'            : 'sesame/api/portaltask/confirmresult?isgood=2',
    'toAgreeResultById'            : 'sesame/api/portaltask/confirmresult?isgood=1',
    'getTradeBill'            : 'sesame/api/portaltask/payment',
    'toConfirmPayment'            : 'sesame/api/portaltask/receivables',
    'getSkillList'              : 'sesame/api/knowhow/select',
    'addSkill'              : 'sesame/api/knowhow/add',
    'editSkill'              : 'sesame/api/knowhow/update',
    'deleteSkill'              : 'sesame/api/knowhow/delete',
    'getTeamList'               : 'sesame/api/user/allteam',
    'getSkillById'              : 'sesame/api/knowhow/single',
    'getSocialList'             : 'sesame/api/socialcategory/select',
    'getSocialPostById'             : 'sesame/api/socialpost/select',
    'getSocialById'             : 'sesame/api/socialcategory/single',
    'getArticleById'             : 'sesame/api/socialpost/single',
    'delArticleById'             : 'sesame/api/socialpost/delete',
    'addSocial'              : 'sesame/api/socialcategory/add',
    'addSocialPost'              : 'sesame/api/socialpost/add',
    'editSocial'              : 'sesame/api/socialcategory/update',
    'editSocialPost'              : 'sesame/api/socialpost/update',
    'deleteSocial'              : 'sesame/api/socialcategory/delete',
    'getMissionByState'         : 'sesame/api/portaltask/',
    'getUserSocialList'         : 'sesame/api/socialcategory/follow',
    'toCancleUserFollow'         : 'sesame/api/socialcategory/cancelf',
    'getUserInfo'               : 'sesame/api/user/single',
    'getUserInfoById'               : 'sesame/api/user/others',
    'getUserByNickName'               : 'sesame/api/user/queryname',
    'getUserBankCards'               : 'sesame/api/user/querybankcard',
    'toBindBankCards'               : 'sesame/api/usernofiler/bankcard',
    'toDeleteBankCard'               : 'sesame/api/user/deletebankcard',
    'getUserPassState'               : 'sesame/api/user/presencepay',
    'getMissionTenderUserList'  : 'sesame/api/portaltask/selectenlist',
    'getMySkillList'            : 'sesame/api/center/myknowhow',
    'getMyFavoriteCompany'      : 'sesame/api/company/favorate',
    'getMyFavoriteMission'      : 'sesame/api/portaltask/favorate',
    'getMyFavoriteSkill'        : 'sesame/api/knowhow/favorate',
    'getMyFavoriteArticle'      : 'sesame/api/socialpost/favorate',
    'getMyFriendsList'          : 'sesame/api/user/friend',
    'toApplyForFriend'          : 'sesame/api/user/apply',
    'toPassFriendApply'          : 'sesame/api/user/refuse',
    'getAskForNewFriend'          : 'sesame/api/user/query',
    'getMyShareList'            : 'sesame/api/socialpost/myshare',
    'getMyFriendsDynamic'            : 'sesame/api/user/dynamic',
    'getUserShareList'            : 'sesame/api/socialpost/personal',
    'getTeamByUserId'            : 'sesame/api/user/userteam',
    'getTeamInfoById'            : 'sesame/api/user/selectteam',
    'getApplyTeamUser'            : 'sesame/api/user/applyingteam',
    'toAddOrDelApplyTeamUser'            : 'sesame/api/user/choiceteam',
    'disbandUserTeam'            : 'sesame/api/user/dissolution',
    'dismissTeamUser'            : 'sesame/api/user/dismissmember',
    'quitUserTeam'              : 'sesame/api/user/quitteam',
    'creatTeam'                  : 'sesame/api/user/addteam',
    'toJoinTeam'                  : 'sesame/api/user/applyteam',
    'editTeam'                  : 'sesame/api/user/modifyteam',
    'getMyBalance'              : 'sesame/api/user/allcoin',
    'getMyIncome'              : 'sesame/api/user/income',
    'postFeedback'              : 'sesame/api/center/suggest',
    'getInboxInfo'              : 'sesame/api/center/sysmessage',
    'toSetInboxReaded'              : 'sesame/api/center/readly',
    'getChatBoxInfo'              : 'sesame/api/user/unread',
    'delInboxInfo'              : 'sesame/api/center/desysmessage',
    'getAppVersion'              : 'sesame/api/center/version',
    'getMyBillList'              : 'sesame/api/alipay/record',
    'doArticleThumb'              : 'sesame/api/socialpost/thumbsup',
    'doArticleFavorate'              : 'sesame/api/socialpost/favorites',
    'toPostUserRate'              : 'sesame/api/portaltask/rate',
    'getOrderInfo'              : 'sesame/api/alipay/rechargeews',
    'getMissionOrderInfo'              : 'sesame/api/alipay/ordernews',
    'toPayWithBill'              : 'sesame/api/alipay/deduction',
    'toPostWithdraw'              : 'sesame/api/usernofiler/withdraw',
    'toSetPassword'              : 'sesame/api/usernofiler/password',
    'toVerifyPassword'              : 'sesame/api/usernofiler/vnpassword',
    'toUpdatePassword'              : 'sesame/api/usernofiler/updatepassword',
    'toFavoriteCompany'              : 'sesame/api/company/favorites',
    'toFavoriteMission'              : 'sesame/api/portaltask/favorites',
    'toFavoriteSkill'              : 'sesame/api/knowhow/favorites',
    'toFavoriteTeam'              : 'sesame/api/user/teamfavorites',
    'toFavoriteSocial'              : 'sesame/api/socialcategory/favorites',
    'toDelFavoriteCompany'              : 'sesame/api/company/cancelf',
    'toDelFavoriteMission'              : 'sesame/api/portaltask/cancelf',
    'toDelFavoriteSkill'              : 'sesame/api/knowhow/cancelf',
    'toDelFavoriteArticle'              : 'sesame/api/socialpost/cancelf',
    // 'toDelFavoriteTeam'              : 'sesame/api/socialpost/cancelf',
  };


}
