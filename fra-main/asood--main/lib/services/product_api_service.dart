// import 'dart:convert';
import 'package:http/http.dart' as http;

import '../shared/constants/links.dart';
import '../models/product_model.dart';
import 'api_client.dart';
import 'api_status.dart';

class ProductApiService {
  ApiClient apiClient = ApiClient(appBaseUrl: BaseUrls.baseUrl);

  //get products
  Future getProducts() async {
    var uri = 'product/user/list/';
    try {
      http.Response res = await apiClient.getData(uri);
      return ApiStatus(res);
    } catch (e) {
      return CustomApiStatus();
    }
  }

  //get product by id
  Future getProductById(productId) async {
    var uri = 'product/user/detail/$productId';
    try {
      http.Response res = await apiClient.getData(uri);
      return ApiStatus(res);
    } catch (e) {
      return CustomApiStatus();
    }
  }

// create product
  Future createProduct(ProductModel product) async {
    var uri = 'product/user/create/';
    try {
      http.Response res = await apiClient.postData(uri, product.toJson());
      return ApiStatus(res);
    } catch (e) {
      return CustomApiStatus();
    }
  }

  //get product comments
  Future getProductComments(productId) async {
    var uri = ' comment/user/product/$productId';
    try {
      http.Response res = await apiClient.getData(uri);
      return ApiStatus(res);
    } catch (e) {
      return CustomApiStatus();
    }
  }
}
