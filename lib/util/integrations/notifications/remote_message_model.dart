import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remote_message_model.g.dart';

// Example
// {
//   senderId: null,
//   category: null,
//   collapseKey: fluttertemplate.app.qa,
//   contentAvailable: false,
//   data: { branchLink: https://fluttertemplate.test-app.link/KaffIz0gPCb },
//   from: 460558452848,
//   messageId: 0:1692792850659276%656b3184656b3184,
//   messageType: null,
//   mutableContent: false,
//   notification:
//     {
//       title: Push title,
//       titleLocArgs: [],
//       titleLocKey: null,
//       body: This is the body message,
//       bodyLocArgs: [],
//       bodyLocKey: null,
//       android:
//         {
//           channelId: null,
//           clickAction: null,
//           color: null,
//           count: null,
//           imageUrl: null,
//           link: null,
//           priority: 0,
//           smallIcon: null,
//           sound: null,
//           ticker: null,
//           tag: campaign_collapse_key_3647082664288689520,
//           visibility: 0,
//         },
//       apple: null,
//       web: null,
//     },
//   sentTime: 1692792834584,
//   threadId: null,
//   ttl: 2419200,
// }
@JsonSerializable()
class RemoteMessageModel {
  final String? messageId;
  final RemoteMessageNotificationModel? notification;
  final RemoteMessageDataModel? data;

  const RemoteMessageModel({
    this.messageId,
    this.notification,
    this.data,
  });

  factory RemoteMessageModel.fromFcm(RemoteMessage message) {
    return RemoteMessageModel(
      messageId: message.messageId,
      notification: message.notification != null
          ? RemoteMessageNotificationModel(
              title: message.notification?.title,
              body: message.notification?.body,
            )
          : null,
      data: RemoteMessageDataModel.fromJson(message.data),
    );
  }

  factory RemoteMessageModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteMessageModelFromJson(json);

  @override
  String toString() {
    return 'RemoteMessageModel{messageId: $messageId, notification: $notification, data: $data}';
  }
}

@JsonSerializable()
class RemoteMessageNotificationModel {
  final String? title;
  final String? body;

  const RemoteMessageNotificationModel({
    this.title,
    this.body,
  });

  factory RemoteMessageNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteMessageNotificationModelFromJson(json);

  @override
  String toString() {
    return 'RemoteMessageNotificationModel{title: $title, body: $body}';
  }
}

@JsonSerializable()
class RemoteMessageDataModel {
  final String? branchLink;

  const RemoteMessageDataModel({
    this.branchLink,
  });

  factory RemoteMessageDataModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteMessageDataModelFromJson(json);

  @override
  String toString() {
    return 'RemoteMessageDataModel{branchLink: $branchLink}';
  }
}
