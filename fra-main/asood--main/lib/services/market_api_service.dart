// import 'dart:convert';

import 'package:asood/models/market_location_model.dart';
import 'package:asood/models/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../shared/constants/links.dart';
import '../models/market_contact_model.dart';
import 'api_client.dart';
import 'api_status.dart';

class MarketApiService {
  ApiClient apiClient =
      ApiClient(appBaseUrl: '${BaseUrls.baseUrl}market/user/');

  //create market base
  Future createMarketBase(String type, String businessId, String name,
      String description, int subCategory, String slogan) async {
    var body = {
      "type": type,
      "business_id": businessId,
      "name": name,
      "description": description,
      "sub_category": subCategory,
      "slogan": slogan
    };
    var uri = 'create/';
    try {
      http.Response res = await apiClient.postData(uri, body);

      return ApiStatus(res);
    } catch (e) {
      return CustomApiStatus();
    }
  }

  //create contact information
  Future createMarketContact(MarketContactModel marketContact) async {
    var body = {
      "market": marketContact.market,
      "first_mobile_number": marketContact.firstMobileNumber,
      "second_mobile_number": marketContact.secondMobileNumber,
      "telephone": marketContact.telephone,
      "fax": marketContact.fax,
      "email": marketContact.email,
      "website_url": marketContact.websiteUrl,
      "instagram_id": marketContact.instagramId,
      "telegram_id": marketContact.telegramId
    };
    var uri = 'contact/create/';
    try {
      http.Response res = await apiClient.postData(uri, body);
      return ApiStatus(res);
    } catch (e) {
      return CustomApiStatus();
    }
  }

  //create market location
  Future createMarketLocation(MarketLocationModel marketLocation) async {
    var body = {
      "market": marketLocation.market,
      "city": marketLocation.city,
      "address": marketLocation.address,
      "zip_code": marketLocation.zipCode,
      "latitude": marketLocation.latitude,
      "longitude": marketLocation.longitude
    };
    var uri = 'location/create/';
    try {
      http.Response res = await apiClient.postData(uri, body);
      return ApiStatus(res);
    } catch (e) {
      return CustomApiStatus();
    }
  }

  //get market List
  Future getMarketList() async {
    var uri = 'list/';
    try {
      http.Response res = await apiClient.getData(uri);

      return ApiStatus(res);
    } catch (e) {
      return CustomApiStatus();
    }
  }

  //inactive market
  Future inactiveMarket(marketId) async {
    var uri = 'inactive/$marketId';
    try {
      http.Response res = await apiClient.getData(
        uri,
      );
      return ApiStatus(res);
    } catch (e) {
      return CustomApiStatus();
    }
  }

  //queue market
  Future queueMarket(marketId) async {
    var uri = 'queue/$marketId';
    try {
      http.Response res = await apiClient.getData(
        uri,
      );
      return ApiStatus(res);
    } catch (e) {
      return CustomApiStatus();
    }
  }

  //market logo upload
  Future uploadMarketLogo(
    XFile imagesFile,
    marketId,
  ) async {
    List<MultipartBody> images = [MultipartBody('logo_img', imagesFile)];
    var uri = 'logo/$marketId/';
    var body = <String, String>{};
    try {
      http.Response res = await apiClient.postMultipartData(uri, body, images);
      return ApiStatus(res);
    } catch (e) {
      return CustomApiStatus();
    }
  }

  //delete logo image
  Future deleteMarketLogo(marketId) async {
    var uri = 'logo/$marketId/';

    try {
      http.Response res = await apiClient.deleteData(uri);
      return ApiStatus(res);
    } catch (e) {
      return CustomApiStatus();
    }
  }

  //market background upload
  Future uploadMarketBackground(XFile imagesFile, marketId,) async {
    List<MultipartBody> images = [MultipartBody('background_img', imagesFile)];
    var uri = 'background/$marketId/';
    var body = <String, String>{};
    try {
      http.Response res = await apiClient.postMultipartData(uri, body, images);
      return ApiStatus(res);
    } catch (e) {
      return CustomApiStatus();
    }
  }

  //delete background image
  Future deleteMarketBackground(marketId) async {
    var uri = 'background/$marketId/';

    try {
      http.Response res = await apiClient.deleteData(uri);
      return ApiStatus(res);
    } catch (e) {
      return CustomApiStatus();
    }
  }

  //get market slider by id
  Future getMarketSlider(marketId) async {
    var uri = 'slider/$marketId';
    try {
      http.Response res = await apiClient.getData(
        uri,
      );
      return ApiStatus(res);
    } catch (e) {
      return CustomApiStatus();
    }
  }

  //create new slider by id
  Future createMarketSlider(marketId, XFile imagesFile) async {
    List<MultipartBody> images = [MultipartBody('slider_img', imagesFile)];
    var uri = 'slider/$marketId/';
    var body = <String, String>{};
    try {
      http.Response res = await apiClient.postMultipartData(uri, body, images);
      return ApiStatus(res);
    } catch (e) {
      return CustomApiStatus();
    }
  }

  //edit new slider by id
  Future editMarketSlider(sliderId, XFile imagesFile) async {
    List<MultipartBody> images = [MultipartBody('slider_img', imagesFile)];
    var uri = 'slider/$sliderId/';
    var body = <String, String>{};
    try {
      http.Response res = await apiClient.patchMultipartData(uri, body, images);
      return ApiStatus(res);
    } catch (e) {
      return CustomApiStatus();
    }
  }

  //modify slider by slider id
  Future modifyMarketSlider(body, sliderId) async {
    var uri = 'slider/$sliderId';
    try {
      http.Response res = await apiClient.patchData(uri, body);
      return ApiStatus(res);
    } catch (e) {
      return CustomApiStatus();
    }
  }

  //delete slider by id
  Future deleteMarketSlider(sliderId) async {
    var uri = 'slider/$sliderId/';
    try {
      http.Response res = await apiClient.deleteData(uri);
      return ApiStatus(res);
    } catch (e) {
      return CustomApiStatus();
    }
  }

  Future setMarketTheme(int marketId, ThemeModel themeModel) async {
    var body = {
      "color": themeModel.color,
      "background_color": themeModel.backgroundColor,
      "secondary_color": themeModel.secondaryColor,

      "font_color": themeModel.fontColor,
      "font": themeModel.font,
      "secondary_font_color": themeModel.secondaryFontColor
    };
    var uri = 'theme/$marketId/';
    try {
      http.Response res = await apiClient.postData(uri, body);
      return ApiStatus(res);
    } catch (e) {
      return CustomApiStatus();
    }
  }

  Future getMarketComments(marketId) async {
    var uri = 'comment/list/$marketId';
    try {
      http.Response res = await apiClient.getData(
        uri,
      );
      return ApiStatus(res);
    } catch (e) {
      return CustomApiStatus();
    }
  }

}
