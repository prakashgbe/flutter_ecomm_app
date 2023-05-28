import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../components/helpvideo1.dart';
import '../components/helpvideo2.dart';
import '../components/helpvideo3.dart';
import '../utils/common.dart';
import '../utils/custom_theme.dart';
import '/components/custom_button.dart';
import '/utils/application_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
              child:  Text(
            'help'.tr,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25.0),
          )),
          const SizedBox(
            height: 10,
          ),
          Container(
              child: Text(
                'clickvideothumbnail'.tr,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0),
              )),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 390,
            child: HelpSection(),
          ),
          const Divider(
            height: 30,
            color: CustomTheme.grey,
            thickness: 2,
          ),
          Container(
              child: Text(
            'tellushelp'.tr,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25.0),
          )),
          const SizedBox(
            height: 800,
            width: 350,
            child: FormSection(),
          ),
          const Divider(
            height: 30,
            color: CustomTheme.grey,
            thickness: 2,
          ),
          Container(
              child: Text(
            'graphqlinteg'.tr,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25.0),
          )),
          const SizedBox(
            height: 200,
            child: GraphQLPage(),
          ),
        ],
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(12.910578, 80.222428),
    zoom: 15,
  );
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GoogleMap(
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          initialCameraPosition: _initialCameraPosition),
    );
  }
}

class GraphQLPage extends StatefulWidget {
  const GraphQLPage({super.key});

  @override
  State<GraphQLPage> createState() => _GraphQLPageState();
}

class _GraphQLPageState extends State<GraphQLPage> {
  List<dynamic> characters = [];
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const CircularProgressIndicator()
          : characters.isEmpty
              ? Center(
                  child: ElevatedButton(
                    child:  Text('fetchdata'.tr),
                    style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(190, 222, 7, 7), // Background color
                                  ),
                    onPressed: () {
                      fetchData();
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: characters.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: Image(
                              image: NetworkImage(
                                characters[index]['image'],
                              ),
                            ),
                            title: Text(
                              characters[index]['name'],
                            ),
                          ),
                        );
                      }),
                ),
    );
  }

  void fetchData() async {
    setState(() {
      _loading = true;
    });
    HttpLink link = HttpLink("https://rickandmortyapi.com/graphql");
    GraphQLClient qlClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(
        store: HiveStore(),
      ),
    );
    QueryResult queryResult = await qlClient.query(
      QueryOptions(
        document: gql(
          """query {
  characters() {
    results {
      name
      image 
    }
  }
  
}""",
        ),
      ),
    );

    setState(() {
      characters = queryResult.data!['characters']['results'];
      _loading = false;
    });
  }
}

class HelpSection extends StatefulWidget{
  @override
  State<HelpSection> createState() => _HelpSectionState();
}

class _HelpSectionState extends State<HelpSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('stocklookupvideo'.tr),
        SizedBox(height: 100, width: 350, child: const HelpVideoComponent1()),
        const SizedBox(height: 10,),
        Text('browseprodcutsvideo'.tr),
        SizedBox(height: 100, width: 350,child: const HelpVideoComponent2()),
        const SizedBox(height: 10,),
        Text('regtnvideo'.tr),
        SizedBox(height: 100, width: 350, child: const HelpVideoComponent3()),
        const SizedBox(height: 10,),
      ],
    );
  }
}

class FormSection extends StatefulWidget {
  const FormSection({super.key});

  @override
  State<FormSection> createState() => _FormSectionState();
}

class _FormSectionState extends State<FormSection> {
  final _formKey = GlobalKey<FormState>();
  bool submit = false;
  String type = "concern";

  // Initial Selected Value
  String dropdownvalue = 'selectone'.tr;

  // List of items in our dropdown menu
  var items = [
    'selectone'.tr,
    'accountinquiry'.tr,
    'solidsurfacewarranty'.tr,
    'comment'.tr,
    'dealerdist'.tr,
    'mediapress'.tr,
    'purchsales'.tr,
    'specifier'.tr,
    'techdiff'.tr,
    'techprodinfo'.tr,
    'adhesives'.tr,
    'decedges'.tr,
    'decmetals'.tr,
    'flooring'.tr,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: showForm());
  }

  onSubmit() {
    setState(() {
      submit = true;
      CommonUtil.showAlert(context, 'weheardu'.tr,
          'thxforcontact'.tr);
    });
  }

  Widget showConfirmation() {
    return  Center(
        child: Text(
      'thxforcontact'.tr,
      style: TextStyle(
          color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20.0),
    ));
  }

  Widget showForm() {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'errorname'.tr;
                  return null;
                },
                decoration:  InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'entername'.tr,
                  labelText: 'name'.tr,
                ),
              ),
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'errorphone'.tr;
                  return null;
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.phone),
                  hintText: 'enterphone'.tr,
                  labelText: 'phone'.tr,
                ),
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'erroremail'.tr;
                  String pattern = r'\w+@\w+\.\w+';
                  if (!RegExp(pattern).hasMatch(value))
                    return 'invalidemail'.tr;
                  return null;
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.email),
                  hintText: 'enteremail'.tr,
                  labelText: 'email'.tr,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'selecttype'.tr,
                style: TextStyle(fontSize: 15.0),
              ),
              RadioListTile(
                title:  Text('queryconcern'.tr),
                activeColor: Color.fromARGB(190, 222, 7, 7),
                value: "concern",
                groupValue: type,
                onChanged: (value) {
                  setState(() {
                    type = value.toString();
                  });
                },
              ),
              RadioListTile(
                title: Text('feedback'.tr),
                activeColor: Color.fromARGB(190, 222, 7, 7),
                value: "feedback",
                groupValue: type,
                onChanged: (value) {
                  setState(() {
                    type = value.toString();
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'subject'.tr,
                style: TextStyle(fontSize: 15.0),
              ),
              DropdownButton(
                // Initial Value
                value: dropdownvalue,

                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),

                // Array list of items
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                },
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) return 'errormsg'.tr;
                  return null;
                },
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                decoration:  InputDecoration(
                  icon: Icon(Icons.message),
                  hintText: 'entermsg'.tr,
                  labelText: 'yourmsg'.tr,
                ),
              ),
              Container(
                  padding:
                      const EdgeInsets.only(right: 50.0, left: 50.0, top: 40.0),
                  child: CustomButton(
                    text: 'submit'.tr,
                    onPress: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        print("form submitted.");
                        onSubmit();
                      }

                    },
                  )),
            ],
          ),
        ),
      ],
    );
  }



}
