import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:realestate/models/location.dart';
import 'package:realestate/screens/admin/admin_addCompound_screen.dart';
import 'package:realestate/screens/admin/admin_addLocation_area.dart';
import 'package:realestate/screens/admin/admin_addLocation_district.dart';
import 'package:realestate/screens/admin/admin_addLocation_governate.dart';
import 'package:realestate/screens/admin/addResale_screen.dart';
import 'package:realestate/screens/admin/admin_addSalesman_screen.dart';
import 'package:realestate/screens/shared/clients.dart';
import 'package:realestate/screens/shared/compound_info.dart';
import 'package:realestate/screens/shared/compounds_search.dart';
import 'package:realestate/screens/shared/listings.dart';
import 'package:realestate/screens/shared/map.dart';
import 'package:realestate/screens/shared/otherProfile.dart';
import 'package:realestate/screens/shared/property_info.dart';
import 'package:realestate/screens/shared/properties_search.dart';
import 'package:realestate/screens/admin/selectLocation_area.dart';
import 'package:realestate/screens/admin/selectLocation_district.dart';
import 'package:realestate/screens/admin/selectLocation_governate.dart';
import 'package:realestate/screens/shared/salesmen.dart';
import 'package:realestate/screens/shared/wrapper.dart';
import 'package:realestate/services/auth.dart';
import 'package:realestate/services/database.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<MyUser>.value(value: AuthService().user),
        StreamProvider<List<Location>>.value(
            value: DatabaseService().governates),
      ],
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'Roboto'),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          AdminAddSalesman.id: (context) => AdminAddSalesman(),
          AdminAddCompound.id: (context) => AdminAddCompound(),
          AddResale.id: (context) => AddResale(),
          AdminAddGovernate.id: (context) => AdminAddGovernate(),
          AdminAddDistrict.id: (context) => AdminAddDistrict(),
          AdminAddArea.id: (context) => AdminAddArea(),
          SelectArea.id: (context) => SelectArea(),
          SelectDistrict.id: (context) => SelectDistrict(),
          SelectGovernate.id: (context) => SelectGovernate(),
          PropertyInfo.id: (context) => PropertyInfo(),
          CompoundInfo.id: (context) => CompoundInfo(),
          PropertiesSearch.id: (context) => PropertiesSearch(),
          Listings.id: (context) => Listings(),
          Clients.id: (context) => Clients(),
          Salesmen.id: (context) => Salesmen(),
          OtherProfile.id: (context) => OtherProfile(),
          MapSelect.id: (context) => MapSelect(),
          CompoundsSearch.id: (context) => CompoundsSearch(),
        },
      ),
    );
  }
}
