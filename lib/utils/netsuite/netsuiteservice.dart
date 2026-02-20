import 'package:powergroupess/services/pref.dart';
import 'package:powergroupess/utils/netsuite/credentials.dart';
import 'package:powergroupess/utils/netsuite/handlers/oauth_handler.dart';
import 'package:powergroupess/utils/netsuite/handlers/request_handler.dart';
import 'package:powergroupess/utils/netsuite/netsuite_client.dart';

class NetSuiteApiService {
  static const int timeOutDuration = 50;

  static Map<String, String> oauthCredentials = {
    // 'consumer_key':
    //     '402d234320a0f5fbde98708f654bcdf936f170030855880239660de112371c54',
    // 'consumer_secret':
    //     '90ff63756870856b86d9f3577e40e21a054688bc9fdd707752e315a33ee80501',
    // 'token': '948112673494910d61e759290d3b6ebe7cfeb620a464f1bc56ccffb421ca124b',
    // 'token_secret':
    //     '50eed256285ead2cff2de6bacf74cc1d09e4a4a164875ac52dc038f117e2129e',

    'consumer_key': Prefs.getnetsuiteConsumerKey('netsuiteConsumerKey')!,
    'consumer_secret':
        Prefs.getnetsuiteConsumerSecret('netsuiteConsumerSecret')!,
    'token': Prefs.getnetsuiteToken('netsuiteToken')!,
    'token_secret': Prefs.getnetsuiteTokenSecret('netsuiteTokenSecret')!,
  };
  static Credentials credentials =
      Credentials(NetSuiteApiService.oauthCredentials);
  static RequestHandler handler =
      OAuthHandler(credentials: NetSuiteApiService.credentials);
  static NetsuiteClient client = NetsuiteClient(handler: handler);
}
