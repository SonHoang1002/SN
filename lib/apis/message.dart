// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:market_place/constant/config.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:market_place/screens/Auth/storage.dart';

class ApiMessage {
  Future<Map<String, dynamic>?> getConversationsApi(
      int limit, int lastUpdated) async {
    try {
      var url = "method.call/subscriptions%3Aget";

      var body = jsonEncode({
        "message": jsonEncode({
          "msg": 'method',
          "id": '14',
          "method": 'subscriptions/get',
          "params": [
            {"\$date": null},
            limit,
            {"\$date": lastUpdated}
          ]
        })
      });

      var dataUserId = await SecureStorage().getKeyStorage("userId");
      var dataToken = await SecureStorage().getKeyStorage("token");

      if (dataUserId != "noData" && dataUserId != "noData") {
        var response =
            await http.post(Uri.parse('${urlRocketChat}/api/v1/${url}'),
                headers: {
                  'X-Auth-Token': "${dataToken}",
                  'X-User-Id': "${dataUserId}",
                  'Content-Type': 'application/json'
                },
                body: body);

        if (response.statusCode == 200) {
          const utf8Decoder = Utf8Decoder(allowMalformed: true);
          return json.decode(utf8Decoder.convert(response.bodyBytes));
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<Map<String, dynamic>?> getPageConversationsApi(
      int count, int offset, String idPage) async {
    try {
      var url = "rooms.getDiscussions";

      var dataUserId = await SecureStorage().getKeyStorage("userId");
      var dataToken = await SecureStorage().getKeyStorage("token");

      if (dataUserId != "noData" && dataUserId != "noData") {
        var response = await http.get(
          Uri.parse(
              '${urlRocketChat}/api/v1/${url}?count=${count}&roomId=${idPage}&offset=${offset}&sort={"lastMessage._updatedAt": -1}'),
          headers: {
            'X-Auth-Token': "${dataToken}",
            'X-User-Id': "${dataUserId}",
            'Content-Type': 'application/json'
          },
        );

        if (response.statusCode == 200) {
          const utf8Decoder = Utf8Decoder(allowMalformed: true);
          return json.decode(utf8Decoder.convert(response.bodyBytes));
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<Map<String, dynamic>?> getListUserActive(ids) async {
    try {
      var url = "users.presence";

      final params = {"ids": ids};

      var dataUserId = await SecureStorage().getKeyStorage("userId");
      var dataToken = await SecureStorage().getKeyStorage("token");

      if (dataUserId != "noData" && dataUserId != "noData") {
        Uri uri = Uri.parse('${urlRocketChat}/api/v1/${url}');
        final finalUri = uri.replace(queryParameters: params);
        var response = await http.get(finalUri, headers: {
          'X-Auth-Token': "${dataToken}",
          'X-User-Id': "${dataUserId}",
          'Content-Type': 'application/json'
        });
        if (response.statusCode == 200) {
          const utf8Decoder = Utf8Decoder(allowMalformed: true);
          return json.decode(utf8Decoder.convert(response.bodyBytes));
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<Map<String, dynamic>?> getListDetailConversation(
      roomId, perPage, lastMoment) async {
    var body = json.encode({
      "message":
          "{\"msg\":\"method\",\"id\":\"45\",\"method\":\"loadHistory\",\"params\":[\"${roomId}\",{\"\$date\":${lastMoment}},${perPage}, null]}"
    });

    var dataUserId = await SecureStorage().getKeyStorage("userId");
    var dataToken = await SecureStorage().getKeyStorage("token");

    try {
      var response = await http.post(
          Uri.parse('${urlRocketChat}/api/v1/method.call/getMessages'),
          headers: {
            'X-Auth-Token': "${dataToken}",
            'X-User-Id': "${dataUserId}",
            'Content-Type': 'application/json'
          },
          body: body);

      if (response.statusCode == 200) {
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        return json.decode(utf8Decoder.convert(response.bodyBytes));
      }
    } catch (e) {
      print(e.toString());
    }

    return null;
  }

  Future<Map<String, dynamic>?> sendMessageApi(String message, roomId) async {
    var dataUserId = await SecureStorage().getKeyStorage("userId");
    var dataToken = await SecureStorage().getKeyStorage("token");

    try {
      var data = jsonEncode({
        "message": {
          "rid": roomId ?? '38jF2HkKkLGEE4cJageEc922XhMPgFHqEg',
          "msg": message
        }
      });

      var response =
          await http.post(Uri.parse('${urlRocketChat}/api/v1/chat.sendMessage'),
              headers: {
                'X-Auth-Token': "${dataToken}",
                'X-User-Id': "${dataUserId}",
                'Content-Type': 'application/json'
              },
              body: data);

      if (response.statusCode == 200) {
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        return json.decode(utf8Decoder.convert(response.bodyBytes));
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<Map<String, dynamic>?> seenMessageApi(String messageId) async {
    var dataUserId = await SecureStorage().getKeyStorage("userId");
    var dataToken = await SecureStorage().getKeyStorage("token");

    try {
      var data = jsonEncode({
        "message": jsonEncode({
          "msg": 'method',
          "id": '65',
          "method": 'readMessages',
          "params": [messageId]
        })
      });
      var response = await http.post(
          Uri.parse('${urlRocketChat}/api/v1/method.call/readMessages'),
          headers: {
            'X-Auth-Token': "${dataToken}",
            'X-User-Id': "${dataUserId}",
            'Content-Type': 'application/json'
          },
          body: data);

      if (response.statusCode == 200) {
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        return json.decode(utf8Decoder.convert(response.bodyBytes));
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<Map<String, dynamic>?> getRoomRolesApi(String username) async {
    var dataUserId = await SecureStorage().getKeyStorage("userId");
    var dataToken = await SecureStorage().getKeyStorage("token");

    try {
      var data = json.encode({
        "message":
            "{\"msg\":\"method\",\"id\":\"83\",\"method\":\"createDirectMessage\",\"params\":[\"$username\"]}"
      });
      var response = await http.post(
          Uri.parse('${urlRocketChat}/api/v1/method.call/getRoomRoles'),
          headers: {
            'X-Auth-Token': "${dataToken}",
            'X-User-Id': "${dataUserId}",
            'Content-Type': 'application/json'
          },
          body: data);
      if (response.statusCode == 200) {
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        return json.decode(utf8Decoder.convert(response.bodyBytes));
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<Map<String, dynamic>?> getDetailConversationApi(String roomId) async {
    var dataUserId = await SecureStorage().getKeyStorage("userId");
    var dataToken = await SecureStorage().getKeyStorage("token");

    try {
      var response = await http.get(
          Uri.parse(
              '${urlRocketChat}/api/v1/subscriptions.getOne?roomId=${roomId}'),
          headers: {
            'X-Auth-Token': "${dataToken}",
            'X-User-Id': "${dataUserId}",
            'Content-Type': 'application/json'
          });

      if (response.statusCode == 200) {
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        return json.decode(utf8Decoder.convert(response.bodyBytes)) as dynamic;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<Map<String, dynamic>?> seenMessage(String messageId) async {
    var dataUserId = await SecureStorage().getKeyStorage("userId");
    var dataToken = await SecureStorage().getKeyStorage("token");

    try {
      var data = jsonEncode({
        "message": jsonEncode({
          "msg": 'method',
          "id": '65',
          "method": 'readMessages',
          "params": [messageId]
        })
      });
      var response = await http.post(
          Uri.parse(
              '${urlRocketChat}/api/v1/method.call/readMessages?roomId=${messageId}'),
          headers: {
            'X-Auth-Token': "${dataToken}",
            'X-User-Id': "${dataUserId}",
            'Content-Type': 'application/json'
          },
          body: data);
      if (response.statusCode == 200) {
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        return json.decode(utf8Decoder.convert(response.bodyBytes));
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<Map<String, dynamic>?> deleteMessage(String messageId) async {
    var dataUserId = await SecureStorage().getKeyStorage("userId");
    var dataToken = await SecureStorage().getKeyStorage("token");

    try {
      var data = jsonEncode({
        "message": jsonEncode({
          "msg": 'method',
          "id": '56',
          "method": 'deleteMessage',
          "params": [
            {"_id": messageId}
          ]
        })
      });
      var response = await http.post(
          Uri.parse('${urlRocketChat}/api/v1/method.call/deleteMessage'),
          headers: {
            'X-Auth-Token': "${dataToken}",
            'X-User-Id': "${dataUserId}",
            'Content-Type': 'application/json'
          },
          body: data);
      if (response.statusCode == 200) {
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        return json.decode(utf8Decoder.convert(response.bodyBytes));
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<Map<String, dynamic>?> updateMessage(
      String messageId, String roomId, String message) async {
    var dataUserId = await SecureStorage().getKeyStorage("userId");
    var dataToken = await SecureStorage().getKeyStorage("token");

    try {
      var data = jsonEncode({
        "message": jsonEncode({
          "msg": 'method',
          "id": '25',
          "method": 'updateMessage',
          "params": [
            {"_id": messageId, "rid": roomId, "msg": message}
          ]
        })
      });
      var response = await http.post(
          Uri.parse('${urlRocketChat}/api/v1/method.call/deleteMessage'),
          headers: {
            'X-Auth-Token': "${dataToken}",
            'X-User-Id': "${dataUserId}",
            'Content-Type': 'application/json'
          },
          body: data);
      if (response.statusCode == 200) {
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        return json.decode(utf8Decoder.convert(response.bodyBytes));
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<Map<String, dynamic>?> setReactionMessage(
      String react, String messageId) async {
    var dataUserId = await SecureStorage().getKeyStorage("userId");
    var dataToken = await SecureStorage().getKeyStorage("token");

    try {
      var data = jsonEncode({
        "message": jsonEncode({
          "msg": 'method',
          "id": '20',
          "method": 'setReaction',
          "params": [react, messageId]
        })
      });
      var response = await http.post(
          Uri.parse('${urlRocketChat}/api/v1/method.call/setReaction'),
          headers: {
            'X-Auth-Token': "${dataToken}",
            'X-User-Id': "${dataUserId}",
            'Content-Type': 'application/json'
          },
          body: data);
      if (response.statusCode == 200) {
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        return json.decode(utf8Decoder.convert(response.bodyBytes));
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<Map<dynamic, dynamic>?> seenMessageMediaApi(
      fileUpload, String roomId, String fileName) async {
    var dataUserId = await SecureStorage().getKeyStorage("userId");
    var dataToken = await SecureStorage().getKeyStorage("token");

    try {
      var request = http.MultipartRequest(
          "POST", Uri.parse('${urlRocketChat}/api/v1/rooms.upload/$roomId'));
      request.fields['description'] = '${roomId}file';

      var stream = http.ByteStream(fileUpload!.openRead());
      stream.cast();

      var length = await fileUpload!.length();

      var file = http.MultipartFile('file', stream, length,
          filename: fileName, contentType: MediaType('image', 'jpeg'));

      request.files.add(file);
      request.headers['X-Auth-Token'] = "${dataToken}";
      request.headers['X-User-Id'] = "${dataUserId}";
      request.send().then((response) {
        if (response.statusCode == 200) {
        } else {}
      });
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<Map<String, dynamic>?> createGroupApi(body) async {
    var dataUserId = await SecureStorage().getKeyStorage("userId");
    var dataToken = await SecureStorage().getKeyStorage("token");

    try {
      var response =
          await http.post(Uri.parse('${urlRocketChat}/api/v1/groups.create'),
              headers: {
                'X-Auth-Token': "${dataToken}",
                'X-User-Id': "${dataUserId}",
                'Content-Type': 'application/json'
              },
              body: jsonEncode(body));

      if (response.statusCode == 200) {
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        return json.decode(utf8Decoder.convert(response.bodyBytes));
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<Map<String, dynamic>?> mediaFileLinkRoom(params) async {
    var dataUserId = await SecureStorage().getKeyStorage("userId");
    var dataToken = await SecureStorage().getKeyStorage("token");
    try {
      var response = await http.get(
          Uri.parse(
              '${urlRocketChat}/api/v1/im.files?roomId=${params['roomId']}&offset=${params['offset']}&count=25&sort=%7B%22uploadedAt%22:-1%7D&query=%7B%22name%22:%7B%22\$regex%22:%22%22,%22\$options%22:%22i%22%7D,%22typeGroup%22:%22${params['type']}%22%7D'),
          headers: {
            'X-Auth-Token': "${dataToken}",
            'X-User-Id': "${dataUserId}",
            'Content-Type': 'application/json'
          });

      if (response.statusCode == 200) {
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        return json.decode(utf8Decoder.convert(response.bodyBytes));
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<http.Response?> blockChatUser(type, rid, blocked) async {
    var dataUserId = await SecureStorage().getKeyStorage("userId");
    var dataToken = await SecureStorage().getKeyStorage("token");

    var response =
        await http.post(Uri.parse('$urlRocketChat/api/v1/method.call/$type'),
            headers: {
              'X-Auth-Token': "$dataToken",
              'X-User-Id': "$dataUserId",
              'Content-Type': 'application/json'
            },
            body: jsonEncode({
              "message": jsonEncode({
                "msg": 'method',
                "id": '65',
                "method": '$type',
                "params": [
                  {"rid": "${rid}", "blocked": "${blocked}"}
                ]
              })
            }));
    return response;
  }

  Future<http.Response?> editNameGroupChat(rid, roomAvatar, roomName) async {
    var dataUserId = await SecureStorage().getKeyStorage("userId");
    var dataToken = await SecureStorage().getKeyStorage("token");

    var response = await http.post(
        Uri.parse('$urlRocketChat/api/v1/rooms.saveRoomSettings'),
        headers: {
          'X-Auth-Token': "$dataToken",
          'X-User-Id': "$dataUserId",
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "rid": '$rid',
          // "roomAvatar": '$roomAvatar',
          "roomName": '$roomName'
        }));
    return response;
  }

  Future<Map<String, dynamic>?> getMembersRoom(params) async {
    var dataUserId = await SecureStorage().getKeyStorage("userId");
    var dataToken = await SecureStorage().getKeyStorage("token");
    try {
      var response = await http.get(
          Uri.parse(
              '${urlRocketChat}/api/v1/groups.members?count=${params?['offset']}&roomId=${params?['roomId']}&count=${params?['count']}'),
          headers: {
            'X-Auth-Token': "${dataToken}",
            'X-User-Id': "${dataUserId}",
            'Content-Type': 'application/json'
          });

      if (response.statusCode == 200) {
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        return json.decode(utf8Decoder.convert(response.bodyBytes));
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<http.Response?> getRoomRoles(params) async {
    var dataUserId = await SecureStorage().getKeyStorage("userId");
    var dataToken = await SecureStorage().getKeyStorage("token");
    try {
      var response = await http.post(
          Uri.parse('$urlRocketChat/api/v1/method.call/getRoomRoles'),
          headers: {
            'X-Auth-Token': "$dataToken",
            'X-User-Id': "$dataUserId",
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            'message': jsonEncode({
              'msg': "method",
              'id': "14",
              'method': "getRoomRoles",
              'params': ['$params']
            })
          }));
      return response;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<http.Response?> addRemoveMemberAdminGroup(params, type) async {
    var dataUserId = await SecureStorage().getKeyStorage("userId");
    var dataToken = await SecureStorage().getKeyStorage("token");
    try {
      var response = await http.post(
          Uri.parse(
              '$urlRocketChat/api/v1/groups.$type'), //addOwner && removeOwner
          headers: {
            'X-Auth-Token': "$dataToken",
            'X-User-Id': "$dataUserId",
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            'roomId': '${params['roomId']}',
            'userId': '${params['userId']}'
          })); // roomId && userId
      return response;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<http.Response?> kickMemberGroupChat(params) async {
    var dataUserId = await SecureStorage().getKeyStorage("userId");
    var dataToken = await SecureStorage().getKeyStorage("token");
    try {
      var response = await http.post(
          Uri.parse(
              '$urlRocketChat/api/v1/groups.kick'), //addOwner && removeOwner
          headers: {
            'X-Auth-Token': "$dataToken",
            'X-User-Id': "$dataUserId",
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            'roomId': '${params['roomId']}',
            'userId': '${params['userId']}'
          })); // roomId && userId
      return response;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<http.Response?> addMemberGroupChat(rid, users) async {
    var dataUserId = await SecureStorage().getKeyStorage("userId");
    var dataToken = await SecureStorage().getKeyStorage("token");
    try {
      var response = await http.post(
          Uri.parse('$urlRocketChat/api/v1/method.call/addUsersToRoom'),
          headers: {
            'X-Auth-Token': "$dataToken",
            'X-User-Id': "$dataUserId",
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            'message': jsonEncode({
              'msg': "method",
              'id': "66",
              'method': "addUsersToRoom",
              'params': [
                {'rid': rid, 'users': users}
              ]
            })
          }));
      return response;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<http.Response?> clearHistoryRoomChat(rid) async {
    var dataUserId = await SecureStorage().getKeyStorage("userId");
    var dataToken = await SecureStorage().getKeyStorage("token");
    try {
      var response =
          await http.post(Uri.parse('$urlRocketChat/api/v1/rooms.cleanHistory'),
              headers: {
                'X-Auth-Token': "$dataToken",
                'X-User-Id': "$dataUserId",
                'Content-Type': 'application/json'
              },
              body: jsonEncode({
                "roomId": rid,
                "latest": "9999-12-31T23:59:59.000Z",
                "oldest": "0001-01-01T00:00:00.000Z",
                "inclusive": false,
                "limit": 2000,
                "excludePinned": false,
                "filesOnly": false,
                "ignoreDiscussion": false,
                "ignoreThreads": false,
                "users": []
              }));
      return response;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Map<String, dynamic>?> searchMessageRoomChatApi(
      rid, uid, keyword) async {
    var dataUserId = await SecureStorage().getKeyStorage("userId");
    var dataToken = await SecureStorage().getKeyStorage("token");
    try {
      var response = await http.post(
          Uri.parse(
              '$urlRocketChat/api/v1/method.call/rocketchatSearch.search'),
          headers: {
            'X-Auth-Token': "$dataToken",
            'X-User-Id': "$dataUserId",
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            'message': jsonEncode({
              'msg': "method",
              'id': "17",
              'method': "rocketchatSearch.search",
              'params': [
                keyword,
                {'rid': rid, 'uid': uid},
                {'searchAll': false}
              ]
            })
          }));
      if (response.statusCode == 200) {
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        return json.decode(utf8Decoder.convert(response.bodyBytes));
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<http.Response?> leaveRoomChat(rid) async {
    var dataUserId = await SecureStorage().getKeyStorage("userId");
    var dataToken = await SecureStorage().getKeyStorage("token");
    try {
      var response = await http.post(
          Uri.parse('$urlRocketChat/api/v1/method.call/leaveRoom'),
          headers: {
            'X-Auth-Token': "$dataToken",
            'X-User-Id': "$dataUserId",
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            'message': jsonEncode({
              'msg': "method",
              'id': "37",
              'method': "leaveRoom",
              'params': [rid]
            })
          }));
      return response;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<http.Response?> unreadMessages(rid) async {
    var dataUserId = await SecureStorage().getKeyStorage("userId");
    var dataToken = await SecureStorage().getKeyStorage("token");
    try {
      var response = await http.post(
          Uri.parse('$urlRocketChat/api/v1/method.call/unreadMessages'),
          headers: {
            'X-Auth-Token': "$dataToken",
            'X-User-Id': "$dataUserId",
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            'message': jsonEncode({
              'msg': "method",
              'id': "20",
              'method': "unreadMessages",
              'params': [null, rid]
            })
          }));
      return response;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<http.Response?> saveNotifications(rid, disableNotification) async {
    var dataUserId = await SecureStorage().getKeyStorage("userId");
    var dataToken = await SecureStorage().getKeyStorage("token");
    try {
      var response = await http.post(
          Uri.parse('$urlRocketChat/api/v1/rooms.saveNotification'),
          headers: {
            'X-Auth-Token': "$dataToken",
            'X-User-Id': "$dataUserId",
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            'roomId': rid,
            'notifications': {
              'disableNotifications': disableNotification == false ? '1' : '0'
            }
          }));
      return response;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
