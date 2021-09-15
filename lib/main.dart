import 'package:currency_converter_app/drop_down.dart';
import 'package:currency_converter_app/services/api_client.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiClient client = ApiClient();
  Color mainColor = Color(0xFF212936);
  Color secondColor = Color(0xFF2849E5);
  List<String> currencies;
  String from;
  String to;

  double rate;
  String result = "";

  @override
  void initState(){
    super.initState();
    (() async{
      List<String> list = await client.getCurrencies();
      setState((){
        currencies = list;
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200.0,
                child: Text(
                  "currency converter",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      onSubmitted: (value) async {
                        rate = await client.getRate(from,to);
                        setState(() {
                          result =
                          (rate * double.parse(value)).toStringAsFixed(3);
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "input value to convert",
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18.0,
                          color:secondColor
                        )
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customDropDown(currencies, from, (val) {
                          setState((){
                            from = val;
                          });
                        }),
                        FloatingActionButton(
                          onPressed: (){
                          String temp = from;
                          setState(() {
                            from = to;
                            to = temp;
                          });
                        },
                          child:Icon(Icons.swap_horiz),
                          elevation:0.0,
                          backgroundColor: secondColor,
                        ),
                        customDropDown(currencies, to, (val){
                          setState(() {
                            to = val;
                          });
                        }),
                      ],
                    ),
                     SizedBox(height: 15.0),
                     Container(
                       width: double.infinity,
                       padding: EdgeInsets.all(16.0),
                       decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(16.0),
                       ),
                       child: Column(
                         children: [
                           Text("result",
                         style: TextStyle(
                           color: Colors.black,
                           fontSize: 24.0,
                           fontWeight: FontWeight.bold,
                           )),
                           Text(result,
                           style: TextStyle(
                             color: secondColor,
                             fontSize: 36.0,
                             fontWeight: FontWeight.bold,
                           )),
                         ],
                       ),
                     ),
                  ],
                ),
              ))
            ],
          ),
        ),
    ),
    );
  }
}

