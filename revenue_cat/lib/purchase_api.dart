import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi {
  static const apiKey = 'goog_kuvShwXuCwNPinpHkLZLEDMreDr';
  static const app_user_id = 'shah-12345';
  static LogInResult? results;

  Future init() async {
    late PurchasesConfiguration configuration;
    await Purchases.setDebugLogsEnabled(true);
    configuration = PurchasesConfiguration(apiKey)..appUserID = app_user_id;
    Purchases.configure(configuration);
    results = await Purchases.logIn(app_user_id);
    print('id informing');
    print(results!.customerInfo.originalAppUserId);
    Purchases.purchaseProduct('coins_100');
    print(results!.customerInfo.activeSubscriptions.length);
  }

  static Future<List<Offering>> fetchOffers() async {
    try {
      CustomerInfo info;
      info = await Purchases.getCustomerInfo();
      print('customer information');
      print(info);
      var offerings = await Purchases.getOfferings();
      final current = offerings.current;
      print('current offerings ${offerings.current}');
      print('offerings $offerings');

      return current == null ? [] : [current];
    } on PlatformException catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}

class Coins {
  static const id10 = '';
}
