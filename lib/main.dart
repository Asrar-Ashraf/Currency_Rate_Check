import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_currency_change_api/apiservice.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Currency Converter App'),
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
  final Apiservice apiservice = Apiservice();
  TextEditingController multiplycurrency = TextEditingController();
  String currentCurrency = "USD";
  String lastUpdate = "";
  String documentation = "";
  String termsOfUse = "";
  String baseCode = "";
  String willUpdate = "";
  double dollerprice = 0.0;

  String hour = "";
  String minute = "";
  String second = "";

  Map<String, dynamic> conversionRates = {};

  late Timer clockTimer;

  @override
  void initState() {
    super.initState();
    fetchCurrencyData();
    clockTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => updateTime(),
    );
  }

  @override
  void dispose() {
    clockTimer.cancel();
    super.dispose();
  }

  void updateTime() {
    final now = DateTime.now();
    setState(() {
      hour = now.hour.toString().padLeft(2, '0');
      minute = now.minute.toString().padLeft(2, '0');
      second = now.second.toString().padLeft(2, '0');
    });
  }

  Future<void> fetchCurrencyData() async {
    try {
      final data = await apiservice.fetchdata("USD");
      if (data["result"] == "success") {
        setState(() {
          lastUpdate = data["time_last_update_utc"].toString();
          documentation = data["documentation"];
          termsOfUse = data["terms_of_use"];
          baseCode = data["base_code"];
          willUpdate = data["time_next_update_utc"].toString();
          conversionRates = Map<String, dynamic>.from(data["conversion_rates"]);
        });
      } else {
        print("API Error: ${data["error-type"]}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    final currencyList = conversionRates.keys.toList();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                infoBox(
                  "Time: $hour:$minute:$second",
                  height * 0.08,
                  width * 0.4,
                ),
                infoBox("Base Code: $baseCode", height * 0.08, width * 0.4),
              ],
            ),
            const SizedBox(height: 20),
            currencyList.isEmpty
                ? const CircularProgressIndicator()
                : DropdownButton<String>(
                    value: currentCurrency,
                    items: currencyList
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        currentCurrency = value!;
                        dollerprice = (conversionRates[currentCurrency] as num)
                            .toDouble();
                      });
                    },
                  ),
            const SizedBox(height: 20),
            infoBox(
              "Documentation:  $documentation",
              height * 0.08,
              width * 0.8,
            ),
            const SizedBox(height: 20),
            infoBox("Terms of Use:  $termsOfUse", height * 0.08, width * 0.8),
            const SizedBox(height: 20),
            infoBox("Last Update:  $lastUpdate", height * 0.08, width * 0.8),
            const SizedBox(height: 20),
            infoBox(
              "Incomming Price Update:  $willUpdate",
              height * 0.08,
              width * 0.8,
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: width * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  infoBox("rate: $dollerprice", height * 0.08, width * 0.15),
                  SizedBox(width: width * 0.05),
                  Container(
                    height: height * 0.04,
                    width: width * 0.1,
                    color: Colors.white,
                    child: Text(
                      "*",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(
                    width: width * 0.15,

                    child: TextField(
                      controller: multiplycurrency,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Colors.deepOrange,
                            width: 2,
                          ),
                        ),
                        labelText: 'Enter Amount',
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.05),
                  Container(
                    height: height * 0.04,
                    width: width * 0.1,
                    color: Colors.white,
                    child: Text(
                      "=",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  infoBox(
                    (dollerprice *
                            (double.tryParse(multiplycurrency.text) ?? 0.0))
                        .toString(),
                    height * 0.08,
                    width * 0.15,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoBox(String text, double boxHeight, double boxWidth) {
    return Container(
      height: boxHeight,
      width: boxWidth,
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 218, 211, 211),
        border: Border.all(color: Colors.purple, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: SelectableText(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
