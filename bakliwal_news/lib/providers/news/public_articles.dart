// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously, avoid_print
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'package:bakliwal_news/models/public_article_model.dart';

class PublicArticles with ChangeNotifier {
  String apiPath = 'articles';
  int pageNo = 1;
  int perPage = 10;
  String articleTag = '';
  List<PublicArticle> _newsArticles = [];
  List<PublicArticle> fetchedArticles = [];
  List<ArticleTags> _fetchedArticleTags = [];

  bool _gettingMoreArticles = false;
  bool _moreArticlesAvailable = true;
  bool loadingComments = false;
  bool universelLoading = false;

  List<PublicArticle> get newsArticles {
    return [..._newsArticles];
  }

  List<ArticleTags> get fetchedArticleTags {
    return [..._fetchedArticleTags];
  }

  bool get gettingMoreArticles {
    return _gettingMoreArticles;
  }

  bool get moreArticlesAvailable {
    return _moreArticlesAvailable;
  }

  bool get loadingCommentsGetter {
    return loadingComments;
  }

  bool get universalLoadingGetter {
    return universelLoading;
  }

  void switchUniversalLoading(bool value) {
    universelLoading = value;
    notifyListeners();
  }

  void switchApiPath(String value) {
    apiPath = value;
  }

  void switchApiTag(String value) {
    articleTag = value;
  }

  void setFetchLogicToDefault() {
    _gettingMoreArticles = false;
    _moreArticlesAvailable = true;
    pageNo = 1;
  }

  Future<void> fetchAndSetInitArticles() async {
    _newsArticles = [];
    final response = await apiResponse(
      "https://dev.to/api/$apiPath",
      pageNo,
      perPage,
      articleTag,
    );
    final List decodedJson = jsonDecode(response.body);
    for (var element in decodedJson) {
      _newsArticles.add(PublicArticle.fromJson(element));
    }
    notifyListeners();
  }

  Future<void> fetchAndSetMoreArticles() async {
    if (_moreArticlesAvailable == false) {
      return;
    }

    if (_gettingMoreArticles == true) {
      return;
    }

    _gettingMoreArticles = true;
    notifyListeners();

    List<PublicArticle> moreNewsArticles = [];
    pageNo++;
    final response = await apiResponse(
      "https://dev.to/api/$apiPath",
      pageNo,
      perPage,
      articleTag,
    );
    final List decodedJson = jsonDecode(response.body);
    for (var element in decodedJson) {
      moreNewsArticles.add(PublicArticle.fromJson(element));
    }

    _newsArticles.addAll(moreNewsArticles);

    if (moreNewsArticles.isEmpty) {
      _moreArticlesAvailable = false;
      notifyListeners();
    }
    _gettingMoreArticles = false;
    notifyListeners();
  }

  Future<http.Response> apiResponse(
      String apiEndpoint, int page, int perPage, String tag) async {
    var header = {
      'Content-type': 'application/json',
      'api-key': '<YOUR_API_KEY_HERE>'
    };
    print(Uri.parse(
        '$apiEndpoint?page=$page&per_page=$perPage${apiPath != 'articles/latest' ? '&tag=$tag' : ''}'));
    final response = await http.get(
      Uri.parse(
          '$apiEndpoint?page=$page&per_page=$perPage${apiPath != 'articles/latest' ? '&tag=$tag' : ''}'),
      headers: header,
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      print("Error");
      throw Exception('Failed to load post');
    }
  }

  Future<PublicArticleCanonicalModel?> fetchCanonicalArticle(
      String articleId) async {
    PublicArticleCanonicalModel? fetchedCanonicalArticle;

    var header = {
      'content-type': 'application/json',
      'api-key': 'rn25QUt4WuCGdrSf3GmmxmLV'
    };
    final response = await http.get(
      Uri.parse('https://dev.to/api/articles/$articleId'),
      headers: header,
    );

    List<PublicComments> fetchedPublicComments =
        await fetchCanonicalArticleComments(articleId);

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      fetchedCanonicalArticle = PublicArticleCanonicalModel.fromJson(
          decodedJson, fetchedPublicComments);

      return fetchedCanonicalArticle;
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<List<PublicComments>> fetchCanonicalArticleComments(
      String articleId) async {
    List<PublicComments> fetchedComments = [];

    var header = {
      'content-type': 'application/json',
      'api-key': 'rn25QUt4WuCGdrSf3GmmxmLV'
    };
    final response = await http.get(
      Uri.parse('https://dev.to/api/comments?a_id=$articleId'),
      headers: header,
    );

    if (response.statusCode == 200) {
      final List decodedJson = jsonDecode(response.body);
      for (var element in decodedJson) {
        fetchedComments.add(PublicComments.fromJson(element));
      }
      return fetchedComments;
    } else if (response.statusCode == 404) {
      return fetchedComments;
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> fetchAndSetArticleTags() async {
    List<ArticleTags> fetchedTags = [];

    var header = {
      'content-type': 'application/json',
      'api-key': 'rn25QUt4WuCGdrSf3GmmxmLV'
    };
    final response = await http.get(
      Uri.parse('https://dev.to/api/tags?per_page=1000'),
      headers: header,
    );

    if (response.statusCode == 200) {
      final List decodedJson = jsonDecode(response.body);
      for (var element in decodedJson) {
        fetchedTags.add(ArticleTags.fromJson(element));
      }
      _fetchedArticleTags = fetchedTags;
    } else {
      throw Exception('Failed to load comments');
    }
  }
}
