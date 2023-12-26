import 'package:app/core/constraints/config.dart';
import 'package:app/core/errors/exceptions.dart';
import 'package:app/domain/models/article.dart';
import 'package:app/domain/models/source.dart';
import 'package:dio/dio.dart';

abstract class NewsApi {
  Future<List<Article>> loadFeedFromTopHeadline({
    int page = 1,
    int pageSize = 10,
    String country = "in",
    String? q,
  });
  Future<List<Article>> loadFeedFromEverything({
    int page = 1,
    int pageSize = 10,
    String? q,
    List<String>? sources,
    String? sortBy,
  });
  Future<List<Source>> fetchSources();
}

class NewsApiImp implements NewsApi {
  final dio = Dio(BaseOptions(headers: {"X-Api-Key": AppConfig.apiKey}));
  @override
  Future<List<Article>> loadFeedFromTopHeadline({
    int page = 1,
    int pageSize = 5,
    String country = "in",
    String? q,
  }) async {
    try {
      // Build the base URL
      String baseUrl = "https://newsapi.org/v2/top-headlines";

      // Use a list to build query parameters
      List<String> queryParams = [];

      // Add parameters to the list
      if (q != null) {
        queryParams.add("q=$q");
      }

      if (page > 1) {
        queryParams.add("page=$page");
      }

      if (country.isNotEmpty) {
        queryParams.add("country=$country");
      }
      queryParams.add("pageSize=$pageSize");

      // Join the query parameters with "&" and append them to the base URL
      if (queryParams.isNotEmpty) {
        baseUrl += "?${queryParams.join("&")}";
      }

      // Check for errors in the API response
      print("printing baseUrl$baseUrl");
      final result = await dio.get(baseUrl);

      if (result.statusCode == 200) {
        final List<dynamic> articlesData = result.data['articles'];

        // Map the list of dynamic articles to a list of Article objects
        final List<Article> articles = articlesData
            .map((articleData) => Article.fromMap(articleData))
            .toList();

        return articles;
      } else {
        // If there's an error, throw a GeneralException
        throw GeneralException(
            "Failed to load feed", result.statusCode.toString());
      }
    } catch (e) {
      // If an unexpected error occurs, throw a GeneralException
      throw GeneralException("An unexpected error occurred", e.toString());
    }
  }

  @override
  Future<List<Article>> loadFeedFromEverything({
    int page = 1,
    int pageSize = 10,
    String? q,
    List<String>? sources,
    String? sortBy,
  }) async {
    try {
      // Build the base URL
      String baseUrl = "https://newsapi.org/v2/everything";

      // Use a list to build query parameters
      List<String> queryParams = [];

      // Add parameters to the list
      if (q != null && q.isNotEmpty) {
        queryParams.add("q=$q");
      } else {
        queryParams.add("q=description");
      }
      if (sources != null && sources.isNotEmpty) {
        String sourcesString = sources.take(20).join(",");
        queryParams.add("sources=$sourcesString");
      }

      if (page > 1) {
        queryParams.add("page=$page");
      }

      if (sortBy != null) {
        queryParams.add("sortBy=$sortBy");
      }

      // Join the query parameters with "&" and append them to the base URL
      if (queryParams.isNotEmpty) {
        baseUrl += "?${queryParams.join("&")}";
      }

      if (queryParams.isEmpty) {
        throw const GeneralException("Please Type Something To search", "500");
      }
      queryParams.add("pageSize=$pageSize");

      print("printing baseUrl$baseUrl");

      // Check for errors in the API response
      final result = await dio.get(baseUrl);

      if (result.statusCode == 200) {
        // Parse the response and return the articles

        final List<dynamic> articlesData = result.data['articles'];

        // Map the list of dynamic articles to a list of Article objects
        final List<Article> articles = articlesData
            .map((articleData) => Article.fromMap(articleData))
            .toList();

        return articles;
      } else {
        // If there's an error, throw a GeneralException
        throw GeneralException(
            "Failed to load feed", result.statusCode.toString());
      }
    } catch (e) {
      // If an unexpected error occurs, throw a GeneralException
      throw const GeneralException("An unexpected error occurred", "500");
    }
  }

  @override
  Future<List<Source>> fetchSources() async {
    try {
      String baseUrl = "https://newsapi.org/v2/top-headlines/sources";

      final result = await dio.get(baseUrl);

      if (result.statusCode == 200) {
        final List<dynamic> sourcesData = result.data["sources"];

        final List<Source> sources =
            sourcesData.map((e) => Source.fromMap(e)).toList();

        return sources;
      } else {
        throw GeneralException(
            "Failed to load sources", result.statusCode.toString());
      }
    } catch (e) {
      // If an unexpected error occurs, throw a GeneralException
      throw const GeneralException("An unexpected error occurred", "500");
    }
  }
}
