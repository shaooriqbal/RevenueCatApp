import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PaywallWidget extends StatefulWidget {
  const PaywallWidget(
      {Key? key,
      required this.title,
      required this.description,
      required this.packages,
      required this.onClickedPackage})
      : super(key: key);
  final String title;
  final String description;
  final List<Package> packages;
  final ValueChanged<Package> onClickedPackage;

  @override
  State<PaywallWidget> createState() => _PaywallWidgetState();
}

class _PaywallWidgetState extends State<PaywallWidget> {
  @override
  Widget build(BuildContext context) => Container(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.title,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.description,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.normal),
              ),
              buildPackages()
            ],
          ),
        ),
      );

  Widget buildPackages() => ListView.builder(
      itemCount: widget.packages.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final package = widget.packages[index];
        return buildPackage(context, package);
      });

  Widget buildPackage(BuildContext context, Package package) {
    final product = package.storeProduct;
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        title: Text(
          product.title,
          style: const TextStyle(fontSize: 18),
        ),
        subtitle: Text(
          product.description,
          style: const TextStyle(fontSize: 16),
        ),
        trailing: Text(
          product.priceString,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onTap: () => widget.onClickedPackage(package),
      ),
    );
  }
}
