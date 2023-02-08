import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Helper/GlobalUrl.dart';
import '../Models/Comment.dart';

class CommentService{
  static var data;

  CommentService(readData){
    data = readData;
  }


  Future<List<Comment>> getAllComments() async {

    var url = Uri.parse('${GlobalUrl.url}comment');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((comment) => Comment.fromMap(comment)).toList();
    } else {
      throw Exception('Unexpected error occured');
    }
  }

  Future<Comment> getCountryById(int id) async{
    var url = Uri.parse('${GlobalUrl.url}comment/$id');
    final response = await http.get(url);

    if(response.statusCode == 200){
      return Comment.fromMap(json.decode(response.body));
    }else{
      throw Exception("Unexpected error ocured");
    }
  }

  Future<Comment> addCountry(Comment comment) async{
     final response = await http.post(
      Uri.parse('${GlobalUrl.url}comment/add'),
      headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
      body: jsonEncode(<String,dynamic>{
        "content": comment.content,
        "personId": comment.personId,
        "reportId": comment.reportId
      }),
    );

    if (response.statusCode == 200) {
    return Comment.fromMap(json.decode(response.body));
  } else {
    throw Exception('Unexpected error occured');
  }
  }

  
  Future<Comment> editCountry(Comment comment) async{
     final response = await http.put(
      Uri.parse('${GlobalUrl.url}comment/edit/${comment.commentId}'),
      headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
      body: jsonEncode(<String,dynamic>{
        "content": comment.content,
        "personId": comment.personId,
        "reportId": comment.reportId
      }),
    );

    if (response.statusCode == 200) {
    return Comment.fromMap(json.decode(response.body));
  } else {
    throw Exception('Unexpected error occured');
  }
  }
}