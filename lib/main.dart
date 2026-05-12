import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grama Urja',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final DatabaseReference db = FirebaseDatabase.instance.ref();

  String selectedVillage = "Kavuru";

  final List<String> villages = [
    "Kavuru",
    "Tenali",
    "Guntur",
    "Vijayawada",
  ];

  bool power = false;

  String updatedAt = "Not Updated";

  List<double> powerUsage = [
    2,
    4,
    3,
    5,
    4,
    6,
    5,
  ];

  @override
  void initState() {
    super.initState();
    loadVillageData();
  }

  void loadVillageData() {

    db.child("villages/$selectedVillage").onValue.listen((event) {

      final data = event.snapshot.value as Map?;

      if (data != null) {

        setState(() {

          power = data['power'] ?? false;

          updatedAt = data['updatedAt'] ?? "No Time";
        });
      }
    });
  }

  Future<void> togglePower() async {

    await db.child("villages/$selectedVillage").update({

      "power": !power,

      "updatedAt": DateTime.now().toString(),

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        centerTitle: true,

        title: Text(

          "Grama Urja ⚡",

          style: GoogleFonts.poppins(

            color: Colors.white,

            fontSize: 30,

            fontWeight: FontWeight.bold,

            letterSpacing: 1,
          ),
        ),
      ),

      body: Container(

        width: double.infinity,

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            colors: [

              Color(0xFF0F172A),

              Color(0xFF1E293B),

              Color(0xFF111827),

            ],

            begin: Alignment.topLeft,

            end: Alignment.bottomRight,
          ),
        ),

        child: SingleChildScrollView(

          child: Padding(

            padding: const EdgeInsets.all(20),

            child: Column(

              children: [

                const SizedBox(height: 10),

                Text(

                  "Village Power Monitoring System",

                  style: GoogleFonts.poppins(

                    fontSize: 16,

                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 30),

                DropdownButton<String>(

                  isExpanded: true,

                  value: selectedVillage,

                  dropdownColor: const Color(0xFF1E293B),

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),

                  items: villages.map((village) {

                    return DropdownMenuItem(

                      value: village,

                      child: Row(

                        children: [

                          const Icon(
                            Icons.location_city,
                            color: Colors.white,
                          ),

                          const SizedBox(width: 10),

                          Text(
                            village,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );

                  }).toList(),

                  onChanged: (value) {

                    setState(() {
                      selectedVillage = value!;
                    });

                    loadVillageData();
                  },
                ),

                const SizedBox(height: 50),

                AnimatedContainer(

                  duration: const Duration(milliseconds: 600),

                  curve: Curves.easeInOut,

                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(30),

                    gradient: LinearGradient(

                      colors: power

                          ? [
                              Colors.green.shade400,
                              Colors.green.shade700,
                            ]

                          : [
                              Colors.red.shade400,
                              Colors.red.shade700,
                            ],
                    ),

                    boxShadow: [

                      BoxShadow(

                        color: power
                            ? Colors.green.withOpacity(0.5)
                            : Colors.red.withOpacity(0.5),

                        blurRadius: 25,

                        spreadRadius: 2,
                      ),
                    ],
                  ),

                  child: Padding(

                    padding: const EdgeInsets.all(35),

                    child: Column(

                      children: [

                        AnimatedRotation(

                          turns: power ? 1 : 0,

                          duration: const Duration(seconds: 1),

                          child: Icon(

                            power
                                ? Icons.flash_on
                                : Icons.power_off,

                            size: 120,

                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(

                          power
                              ? "POWER IS ON"
                              : "POWER IS OFF",

                          style: GoogleFonts.poppins(

                            fontSize: 30,

                            fontWeight: FontWeight.bold,

                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                ElevatedButton(

                  onPressed: togglePower,

                  style: ElevatedButton.styleFrom(

                    backgroundColor:
                        power
                            ? Colors.redAccent
                            : Colors.greenAccent,

                    foregroundColor: Colors.black,

                    elevation: 20,

                    shadowColor:
                        power
                            ? Colors.red
                            : Colors.green,

                    padding: const EdgeInsets.symmetric(

                      horizontal: 60,

                      vertical: 20,
                    ),

                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),

                  child: Text(

                    power
                        ? "Turn OFF"
                        : "Turn ON",

                    style: GoogleFonts.poppins(

                      fontSize: 20,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                Card(

                  color: const Color(0xFF1E293B),

                  elevation: 10,

                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(25),
                  ),

                  child: Padding(

                    padding: const EdgeInsets.all(25),

                    child: Column(

                      children: [

                        const Icon(

                          Icons.access_time,

                          size: 45,

                          color: Colors.cyan,
                        ),

                        const SizedBox(height: 15),

                        Text(

                          "Last Updated",

                          style: GoogleFonts.poppins(

                            color: Colors.white,

                            fontWeight: FontWeight.bold,

                            fontSize: 22,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(

                          updatedAt,

                          textAlign: TextAlign.center,

                          style: GoogleFonts.poppins(

                            color: Colors.white70,

                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                Card(

                  color: const Color(0xFF1E293B),

                  elevation: 10,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),

                  child: Padding(

                    padding: const EdgeInsets.all(20),

                    child: Column(

                      children: [

                        Text(

                          "Power Usage Analytics",

                          style: GoogleFonts.poppins(

                            color: Colors.white,

                            fontSize: 22,

                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 30),

                        SizedBox(

                          height: 250,

                          child: LineChart(

                            LineChartData(

                              gridData: FlGridData(
                                show: true,
                              ),

                              borderData: FlBorderData(
                                show: false,
                              ),

                              titlesData: FlTitlesData(

                                leftTitles: AxisTitles(
                                  sideTitles:
                                      SideTitles(showTitles: true),
                                ),

                                bottomTitles: AxisTitles(
                                  sideTitles:
                                      SideTitles(showTitles: true),
                                ),
                              ),

                              lineBarsData: [

                                LineChartBarData(

                                  spots: [

                                    FlSpot(0, powerUsage[0]),
                                    FlSpot(1, powerUsage[1]),
                                    FlSpot(2, powerUsage[2]),
                                    FlSpot(3, powerUsage[3]),
                                    FlSpot(4, powerUsage[4]),
                                    FlSpot(5, powerUsage[5]),
                                    FlSpot(6, powerUsage[6]),
                                  ],

                                  isCurved: true,

                                  dotData:
                                      FlDotData(show: true),

                                  belowBarData:
                                      BarAreaData(show: true),

                                  color: Colors.greenAccent,

                                  barWidth: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}