import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/features/admin/widgets/category_products_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import '../../../common/widgets/loader.dart';
import '../model/sales.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminServices adminServices = AdminServices();
  int? totalSales;
  List<Sales>? earnings;

  getEarnings() async {
    var earningData = await adminServices.getEarnings(context);
    setState(() {
      totalSales = earningData['totalEarnings'];
      earnings = earningData['sales'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEarnings();
  }

  @override
  Widget build(BuildContext context) {
    return earnings == null || totalSales == null
        ? const Loader()
        : Column(
            children: [
              Text(
                'Total Earnings: \₹$totalSales',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 250,
                child: CategoryProductsChart(seriesList: [
                  charts.Series(
                      id: 'Sales',
                      data: earnings!,
                      domainFn: (Sales sales, _) => sales.label,
                      measureFn: (Sales sales, _) => sales.earning)
                ]),
              )
            ],
          );
  }
}
