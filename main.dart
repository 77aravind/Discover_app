import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; 
import 'package:discover_app/core/injection_container.dart' as di; 
import 'package:discover_app/features/discover/presentation/pages/main_wrapper_page.dart'; 

void main() async {
  // 1. ഫ്ലട്ടർ വിഡ്ജറ്റുകൾ ബൈൻഡ് ചെയ്യുന്നു എന്ന് ഉറപ്പുവരുത്തുന്നു
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. 📦 ലോക്കൽ ഡാറ്റാബേസ് ആയ Hive ഇവിടെ ഇനിഷ്യലൈസ് ചെയ്യുന്നു
  await Hive.initFlutter();
  
  // 3. 🚀 ആപ്പിലെ എല്ലാ ലെയറുകളെയും തമ്മിൽ കണക്ട് ചെയ്യുന്നു
  await di.init(); 
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netflix Discover App',
      debugShowCheckedModeBanner: false,
      
      // 🖤 നെറ്റ്ഫ്ലിക്സ് ലുക്ക് കിട്ടാൻ വേണ്ടി ആപ്പ് മുഴുവൻ ഡാർക്ക് തീം നൽകുന്നു
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      
      // 🏠 ആപ്പ് തുറക്കുമ്പോൾ ആദ്യം കാണിക്കേണ്ട മെയിൻ നാവിഗേഷൻ സ്ക്രീൻ
      home: const MainWrapperPage(), 
    );
  }
}