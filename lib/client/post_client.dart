import 'package:demo_dio_imagepicker/model/model.dart';
import 'package:dio/dio.dart';

class PostClient {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: 5000,
      receiveTimeout: 3000,
    ),
  );

  Future<List<Post>> getPost() async {
    Response strRes = await dio.get('/posts');

    if (strRes.statusCode == 200) {
      List<dynamic> result = strRes.data;
      List<Post> resultJson = result.map((json) {
        return Post.fromJson(json);
      }).toList();
      return resultJson;
    } else {
      throw Exception('Failed to lead jobs from API');
    }
  }

  Future<Post?> getPostFetch({required String id}) async {
    Post? post;

    Response strRes = await dio.get('/posts/$id');
    post = Post.fromJson(strRes.data);

    if (strRes.statusCode == 200) {
      return post;
    } else {
      throw Exception('Failed to lead jobs from API');
    }
  }

  Future<PostInfo?> updatePost(
      {required PostInfo postInfo, required String id}) async {
    PostInfo? updatedPost;

    try {
      Response strRes = await dio.put(
        '/posts/$id',
        data: postInfo.toJson(),
      );
      // print('Post updated: ${strRes.data}');
      updatedPost = PostInfo.fromJson(strRes.data);
    } catch (e) {
      Exception('Failed to lead jobs from API');
    }
    return updatedPost;
  }

  Future<void> deletePost({required String id}) async {
    try {
      await dio.delete('/posts/$id');
      // print('Post deleted!');
    } catch (e) {
      Exception('Failed to lead jobs from API');
    }
  }
}
