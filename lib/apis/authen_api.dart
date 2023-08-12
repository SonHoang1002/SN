import 'dart:convert';

import 'package:social_network_app_mobile/apis/api_root.dart';

class AuthenApi {
  fetchDataToken(data) async {
    var response = await Api().postRequestBase('/oauth/token', data);
    return response;
  }

  loginByGoogle(token) async {
    return await Api().postRequestBaseNoTokenDefault(
        '/api/v1/authorization', null, {"access_token": token});
  }

  registrationAccount(data) async {
    return await Api().postRequestBase('/api/v1/registrations', data);
  }

  validateEmail(params) async {
    //params: {"email": ''}
    return await Api().getRequestBase('/api/v1/validate_email', params);
  }

  forgotPassword(data) async {
    return await Api().postRequestBase('/api/v1/forgot_password', data);
  }

  reconfirmationEmail(data) async {
    return await Api().postRequestBase('/api/v1/reconfirmation', data);
  }
}
