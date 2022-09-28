import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:revenue_cat/PaywallWidget.dart';
import 'package:revenue_cat/purchase_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PurchaseApi purchaseApi = PurchaseApi();
  await purchaseApi.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'In App Purchases'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void loadOffers(dynamic package) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 500.0,
            color: Colors.blueGrey,
            child: PaywallWidget(
                title: 'Courses Subscriptions',
                description: 'subscribe to get benefits from udemy courses',
                packages: packages,
                onClickedPackage: (package) async {
                  await PurchaseApi.purchasePackage(package);
                  if (mounted) {
                    Navigator.pop(context);
                  }
                }),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    fetchOffers();
  }

  List<Package> packages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Click to get Offers',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Purchases.addCustomerInfoUpdateListener((customerInfo) {
            print('Listener added');
          });
          List list = [];
          print('active sub informing');
          print(PurchaseApi.results!.customerInfo);
          print(PurchaseApi.results!.customerInfo.activeSubscriptions.length);
          print(packages.length);
          if (PurchaseApi.results!.customerInfo.allPurchasedProductIdentifiers
                  .length ==
              packages.length) {
            list.addAll(PurchaseApi.results!.customerInfo.activeSubscriptions);

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Already subscribed'),
              shape: RoundedRectangleBorder(),
            ));
          } else {
            loadOffers(packages);
          }
        },
        tooltip: 'Load',
        child: const Icon(Icons.cloud_download),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future fetchOffers() async {
    final offerings = await PurchaseApi.fetchOffers();
    if (offerings.isEmpty) {
      print('No Plans Found');
    } else {
      final offer = offerings.first;
      packages = offerings
          .map((e) => offer.availablePackages)
          .expand((element) => element)
          .toList();
      print(offer);
      print('packages length ${packages.length}');
    }
    setState(() {});
  }
}
