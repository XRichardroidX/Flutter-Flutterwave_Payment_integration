import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:flutterwave_standard/models/subaccount.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zuhra Hashimi Project',
      debugShowCheckedModeBanner: false,
      home: MyHomePage('Zuhra Hashimi to Flutterwave'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(this.title);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formKey = GlobalKey<FormState>();
  final NameController = TextEditingController();
  final amountController = TextEditingController();
  final currencyController = TextEditingController();
  final publicKeyController = TextEditingController();
  final encryptionKeyController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();

  String selectedCurrency = "";

  bool isTestMode = true;
  final pbk = "FLWPUBK_TEST";

  @override
  Widget build(BuildContext context) {
    this.currencyController.text = this.selectedCurrency;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Form(
          key: this.formKey,
          child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: this.NameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(hintText: "Full Name"),
                  validator: (value) =>
                  value!.isNotEmpty ? null : "Full Name is required",
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: this.amountController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(hintText: "Amount"),
                  validator: (value) =>
                  value!.isNotEmpty ? null : "Amount is required",
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: this.currencyController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black),
                  readOnly: true,
                  onTap: this._openBottomSheet,
                  decoration: InputDecoration(
                    hintText: "Currency",
                  ),
                  validator: (value) =>
                  value!.isNotEmpty ? null : "Currency is required",
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: this.emailController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Email",
                  ),
                  validator: (value) =>
                  value!.isNotEmpty ? null : "Email is required",
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: this.phoneNumberController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                  ),
                  validator: (value) =>
                  value!.isNotEmpty ? null : "Phone Number is required",
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Use Debug"),
                    Switch(
                      onChanged: (value) => {
                        setState(() {
                          isTestMode = value;
                        })
                      },
                      value: this.isTestMode,
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: ElevatedButton(
                  onPressed: this._onPressed,
                  child: Text(
                    "Make Payment",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _onPressed() {
    if (this.formKey.currentState!.validate()) {
      this._handlePaymentInitialization();
    }
  }

  _handlePaymentInitialization() async {
    final style = FlutterwaveStyle(
      appBarText: "",
      buttonColor: Color(0xff000000),
      buttonTextStyle: TextStyle(
        color: Colors.deepOrangeAccent,
        fontSize: 16,
      ),
      appBarColor: Color(0xff3b40a3),
      dialogCancelTextStyle: TextStyle(
        color: Colors.brown,
        fontSize: 18,
      ),
      dialogContinueTextStyle: TextStyle(
        color: Colors.purpleAccent,
        fontSize: 18,
      ),
      mainBackgroundColor: Colors.indigo,
      mainTextStyle: TextStyle(
          color: Colors.indigo,
          fontSize: 19,
          letterSpacing: 2
      ),
      dialogBackgroundColor: Colors.greenAccent,
      appBarIcon: Icon(Icons.message, color: Colors.purple),
      buttonText: "Pay $selectedCurrency${amountController.text}",
      appBarTitleTextStyle: TextStyle(
        color: Colors.purpleAccent,
        fontSize: 18,
      ),
    );

    final Customer customer = Customer(
        name: NameController.text,
        phoneNumber: this.phoneNumberController.text,
        email: this.emailController.text,
    );

    // final subAccounts = [
    //   SubAccount(id: "RS_1A3278129B808CB588B53A14608169AD", transactionChargeType: "flat", transactionPercentage: 25),
    //   SubAccount(id: "RS_C7C265B8E4B16C2D472475D7F9F4426A", transactionChargeType: "flat", transactionPercentage: 50)
    // ];

    final Flutterwave flutterwave = Flutterwave(
        context: context,
        style: style,
        customization: Customization(title: "Zuhra Hashimi Payment"),
        publicKey: "FLWPUBK-061df4e42737c8f7b788b38f40fd1940-X",
        currency: this.selectedCurrency,
        redirectUrl: "https://google.com",
        txRef: Uuid().v1(),
        amount: this.amountController.text.toString().trim(),
        customer: customer,
        // subAccounts: subAccounts,
        paymentOptions: "card, payattitude, barter",
        isTestMode: isTestMode,
    );
    final ChargeResponse response = await flutterwave.charge();
    if (response != null) {
      this.showLoading(response.status!);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.toJson()}")));
      print("${response.toJson()}");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No Response!")));
      this.showLoading("No Response!");
    }
  }

  void _openBottomSheet() {
    showModalBottomSheet(
        context: this.context,
        builder: (context) {
          return this._getCurrency();
        });
  }

  Widget _getCurrency() {
    final currencies = ["NGN", "RWF", "UGX", "KES", "ZAR", "USD", "GHS", "TZS"];
    return Container(
      height: 250,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Colors.white,
      child: ListView(
        children: currencies
            .map((currency) => ListTile(
          onTap: () => {this._handleCurrencyTap(currency)},
          title: Column(
            children: [
              Text(
                currency,
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 4),
              Divider(height: 1)
            ],
          ),
        ))
            .toList(),
      ),
    );
  }

  _handleCurrencyTap(String currency) {
    this.setState(() {
      this.selectedCurrency = currency;
      this.currencyController.text = currency;
    });
    Navigator.pop(this.context);
  }

  Future<void> showLoading(String message) {
    return showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 50,
            child: Text(message),
          ),
        );
      },
    );
  }
}