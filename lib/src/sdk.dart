import 'rest_client.dart';

class MP {
  final String _client_id;
  final String _client_secret;

  String _access_token;
  MLRestClient _restClient;

  MP(this._client_id, this._client_secret) {
    _restClient = MLRestClient();
  }

  /// Get access token
  /// return Future<String>
  Future<String> getAccessToken() async {
    if (this._access_token != null && !this._access_token.isEmpty) {
      return this._access_token;
    }

    Map<String, String> data_app_client = {
      'client_id': this._client_id,
      'client_secret': this._client_secret,
      'grant_type': 'client_credentials',
    };

    var access_data = await this._restClient.post('/oauth/token',
        data: data_app_client, contentType: _restClient.MIME_FORM);

    if (access_data['status'] == 200) {
      this._access_token = access_data['response']['access_token'];
      return this._access_token;
    }
    return null;
  }

  /// Get information for specific payment
  /// return Future<Map<String, dynamic>>
  Future<Map<String, dynamic>> getPayment(String id) async {
    final String access_token = await this.getAccessToken();
    return await this
        ._restClient
        .get('/v1/payments/${id}', {'access_token': access_token});
  }
}
