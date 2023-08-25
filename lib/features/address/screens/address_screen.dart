import 'package:amazon_clone/constants/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../common/widgets/custom_textfield.dart';
import '../../../constants/global_variables.dart';
import '../../../providers/user_provider.dart';
import '../services/address_services.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address-screen';
  final String totalAmount;

  const AddressScreen({super.key, required this.totalAmount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final GlobalKey<FormState> _addressFormKey = GlobalKey<FormState>();
  final TextEditingController flatBuildingController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final _razorpay = Razorpay();
  final AddressServices _addressServices = AddressServices();

  String addressToBeUsed = '';

  void onApplePayResult(res) {}

  void onGooglePayResult(res) {}

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print('---------------------------success');
    _addressServices.placeOrder(context: context, address: addressToBeUsed, totalSum: double.parse(widget.totalAmount));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print('---------------------------failed');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    print('---------------------------external');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    flatBuildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_j9ttyLWlZWagAu',
      'amount': 100 * int.parse(widget.totalAmount),
      'name': 'Amazon',
      'description': 'Fine T-Shirt',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'}
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void payPressed(String addressFromProvider) {
    addressToBeUsed = '';

    bool isFrom = flatBuildingController.text.isNotEmpty ||
        areaController.text.isNotEmpty ||
        pincodeController.text.isNotEmpty ||
        cityController.text.isNotEmpty;

    if (isFrom) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            '${flatBuildingController.text}, ${areaController.text}, ${pincodeController.text}, ${cityController.text}';
      } else {
        throw Exception('Please fill all the fields');
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    } else {
      showSnackBar(context, Colors.red, 'Error');
    }
    print(addressToBeUsed);
  }

  void saveUserAddress() {
    _addressServices.saveUserAddress(
        address: addressToBeUsed, context: context);
  }

  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().getUser.address!;
    // var address = 'context.watch<UserProvider>().getUser.address!';
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: GlobalVariables.appBarGradient)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (address.isNotEmpty)
                Column(children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text(address, style: const TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'OR',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ]),
              Form(
                  key: _addressFormKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: flatBuildingController,
                        hintText: 'Flat, House no, Building name',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: areaController,
                        hintText: 'Area, Street',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: pincodeController,
                        hintText: 'Pincode',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: cityController,
                        hintText: 'Town/City',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  )),
              // Platform.isAndroid
              //     ? GooglePayButton(
              //         paymentConfiguration:
              //             PaymentConfiguration.fromJsonString(defaultGooglePay),
              //         onPaymentResult: onGooglePayResult,
              //         paymentItems: paymentItems)
              //     : ApplePayButton(
              //         paymentConfiguration:
              //             PaymentConfiguration.fromJsonString(defaultApplePay),
              //         onPaymentResult: onApplePayResult,
              //         paymentItems: paymentItems,
              // ),
              ElevatedButton(
                  onPressed: () {
                    payPressed(address);
                    saveUserAddress();
                    openCheckout();
                  },
                  child: const Text('Confirm & Pay'))
            ],
          ),
        ),
      ),
    );
  }
}
