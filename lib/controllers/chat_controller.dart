import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:get/get.dart';
import 'home_controller.dart';

class ChatController extends GetxController {
  @override
  void onInit() {
    getChatId();
    super.onInit();
  }

  // create chats collection to save data from arguments[0],[1]
  // communicate between user and vendor
  var chats = firestore.collection(chatsCollection);
  var friendName = Get.arguments[0];
  var friendId = Get.arguments[1];
  // senderName is from HomeController.username
  var senderName = Get.find<HomeController>().username;
  // currentId is  current userId
  var currentId = currentUser!.uid;
  //create a text controller for messages
  var msgController = TextEditingController();
  //create chatDocId to carry the send text
  dynamic chatDocId;
  //create loading icon boolean
  var isLoading = false.obs;
  //create getChatId to read users
  // chat between friendId and currentId
  getChatId() async {
    isLoading(true);
    await chats
        .where('users', isEqualTo: {friendId: null, currentId: null})
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
          //if the doc is not empty read
          // all chat data from docs
          if (snapshot.docs.isNotEmpty) {
            chatDocId = snapshot.docs.single.id;
          } else {
            // else if chat is send
            // it will send with these parameter
            chats.add({
              'created_on': null,
              'last_msg': '',
              'users': {friendId: null, currentId: null},
              'toId': '',
              'fromId': '',
              'friend_name': friendName,
              'sender_name': senderName
            }).then((value) {
              {
                //the save the message as chatDocId
                chatDocId = value.id;
              }
            });
          }
        });
    //switch the active loading icon to false
    isLoading(false);
  }

  //create the sendMessage where parameter
  // are these currentId and friendId
  sendMsg(String msg) async {
    if (msg.trim().isNotEmpty) {
      chats.doc(chatDocId).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
        'toId': friendId,
        'fromId': currentId,
      });
      // store message send inside messagesCollection
      // adding msg currentId and timestamp
      chats.doc(chatDocId).collection(messagesCollection).doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': currentId,
      });
    }
  }
}
