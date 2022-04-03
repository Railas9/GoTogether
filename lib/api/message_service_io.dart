import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:go_together/models/conversation.dart';
import 'package:go_together/models/messages.dart';
import 'package:go_together/helper/api.dart';

class MessageServiceApi {
  final api = Api();

  Future<List<Message>> getAll({Map<String, dynamic> map = const {}}) async {
    final response = await api.client
        .get(Uri.parse(api.host + 'messages'),
        headers: api.mainHeader
    );
    if (response.statusCode == 200) {
      return compute(api.parseMessages, response.body);
    } else {
      throw ApiErr(codeStatus: response.statusCode, message: "failed to load messages");
    }
  }

  Future<List<Message>> getById(int id) async {
    final response = await api.client
        .get(Uri.parse(api.host + 'messages/$id'),
        headers: api.mainHeader
    );
    if (response.statusCode == 200) {
      return compute(api.parseMessages, response.body);
    } else {
      throw ApiErr(codeStatus: response.statusCode, message: "can't load message");
    }
  }

  Future<List<Conversation>> getConversationById(int id) async {
    final response = await api.client
        .get(Uri.parse(api.host + 'conversations/$id'),
        headers: api.mainHeader
    );
    if (response.statusCode == 200) {
      return compute(api.parseConversation, response.body);
    } else {
      throw ApiErr(codeStatus: response.statusCode, message: "failed to load conversations data");
    }
  }

  // we add a copy of one encrypted message for each user in conversation
  Future<Message> add(int id, List<Message> message) async {
    List<Map<String, dynamic>> t = [];
    message.forEach((element) {
      t.add(element.toMap());
    });
    String body = jsonEncode(t);
    final response = await api.client
        .post(Uri.parse(api.host + 'messages/$id'),
      headers: api.mainHeader,
      body: body,
    );
    if (response.statusCode == 201) {
      return Message.fromJson(jsonDecode(response.body)["success"]["last_insert"]);
    } else {
      throw ApiErr(codeStatus: response.statusCode, message: "can't add message in this conversation");
    }
  }
}