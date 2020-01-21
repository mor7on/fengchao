import 'dart:async';

import 'package:fengchao/common/api/01_index_component_fun.dart';
import 'package:fengchao/models/chat_message.dart';
import 'package:fengchao/models/inbox.dart';
import 'package:flutter/foundation.dart';

class HomeRedDot with ChangeNotifier {
  Timer timer;
  bool _showChatDot = false;
  bool get showChatDot => _showChatDot;

  bool _showInboxDot = false;
  bool get showInboxDot => _showInboxDot;

  handleTimeout(Timer timer) async {
    List<Inbox> inbox = await getUserUnreadInbox();
    List<ChatMessage> chatBox = await getUserUnreadChat();

    print(timer.tick);

    if (null != chatBox) {
      if (chatBox.length > 0) {
        print(_showChatDot);

        if (!_showChatDot) {
          _showChatDot = true;
          notifyListeners();
        }
      } else {
        if (_showChatDot) {
          _showChatDot = false;
          notifyListeners();
        }
      }
    }

    if (null != inbox) {
      if (inbox.length > 0) {
        print(_showInboxDot);

        if (!_showInboxDot) {
          _showInboxDot = true;
          notifyListeners();
        }
      } else {
        if (_showInboxDot) {
          _showInboxDot = false;
          notifyListeners();
        }
      }
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(milliseconds: 10000), handleTimeout);
  }

  void changeChatDot() {
    _showChatDot = !_showChatDot;
    notifyListeners();
  }

  void changeInboxDot() {
    _showChatDot = !_showChatDot;
    notifyListeners();
  }

  void stopTimer() {
    timer?.cancel();
  }
}
