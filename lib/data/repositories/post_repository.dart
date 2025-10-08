import 'package:untitled1/data/models/post_model.dart';
import 'package:untitled1/data/services/api_service.dart';
import 'package:untitled1/domain/entities/post_entity.dart';

abstract class PostRepository {
  Future<List<PostEntity>> getPosts();
}

class PostRepositoryImpl implements PostRepository {
  final ApiService apiService;

  PostRepositoryImpl({required this.apiService});

  @override
  Future<List<PostEntity>> getPosts() async {
    apiService.baseUrl = "https://jsonplaceholder.typicode.com";
    final List<dynamic> list = await apiService.getJsonList('/posts');
    return list.map((e) => PostModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}


