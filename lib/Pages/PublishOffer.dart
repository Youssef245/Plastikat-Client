import 'dart:ui';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:plastikat_client/Pages/HomePage.dart';
import 'package:plastikat_client/Pages/ProfilePage.dart';
import 'package:plastikat_client/entities/item.dart';
import 'package:plastikat_client/services/item_service.dart';
import 'package:plastikat_client/services/offer_service.dart';
import '../Widgets/PlastikatButton.dart';
import '../Widgets/PlastikatBar.dart';
import '../Widgets/PlastikatButton.dart';
import '../Widgets/PlastikatDrawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plastikat_client/globals.dart' as globals;

import '../entities/offer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart' show AppLocalizations;

class PublishOffer extends StatelessWidget {


  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home:MyPublishOffer()
    );
  }
}

class MyPublishOffer extends StatefulWidget {
  @override
  _MyPublishOfferState createState() => _MyPublishOfferState();
}

class _MyPublishOfferState extends State<MyPublishOffer> {
  Color plastikatGreen = Color.fromRGBO(10, 110, 15, 100);
  List<Item> Items = [];
  List<Item> results = [];
  List<ItemOffer> finalResults = [];
  List<String> names = [];
  bool isLoaded=false;
  //var Items = ["Small Bottle","Big Bottle","Jar","Ketchup Bottle","Mustard Bottle","Jerrycan","Cups","Forks and Spoons","Can"];
  //List<int> listDynamic = [];
  int size =0;
  List<String> values=[];
  List <int> numbers=[];
  int totalPoints=0;

  _MyPublishOfferState();

  @override
  void initState() {
    super.initState();
    getItems();
  }

  void addItem(String chosen,int index){
    String type = chosen.split(" ").last;
    List<String> nameList = chosen.split(" ");
    nameList.removeLast();
    String name = nameList.join(" ");
    Item newItem = Items.singleWhere((e) => e.type==type && e.name == name);
    print(newItem.toString());
    results[index]=newItem;
  }

  void calculatePoints()
  {
    int localPoints = 0;
    for(int i=0;i<results.length;i++)
    {
      localPoints+=numbers[i]*results[i].points;
    }
    totalPoints = localPoints;
  }

  void itemsToOffers (){
   for(int j=0;j<results.length;j++)
   {
     finalResults.add(ItemOffer(results[j].id, results[j].name, results[j].type, results[j].points, numbers[j]));
   }
  }

  getItems() async {
    final ItemService service =  ItemService();
    Items = await service.getItems();
    for (Item it in Items)
    {
        names.add(it.name+" "+it.type);
    }
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          drawer: PlastikatDrawer(),
          appBar: PlastikatBar(),
          body: isLoaded? Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.add , color: plastikatGreen),
                      onPressed: () { setState(() {
                        values.add(names[0]);
                        size++;
                        numbers.add(1);
                        results.add(Items[0]);
                        calculatePoints();
                      }); },
                    ),
                    IconButton(
                      icon: Icon(Icons.remove , color: plastikatGreen),
                      onPressed: () { setState(() {
                        size!=0 ? size-- : null ;
                        values.isEmpty? null : values.removeLast();
                        numbers.isEmpty? null : numbers.removeLast();
                        results.isEmpty? null : results.removeLast();
                        calculatePoints();
                      }); },
                    )
                  ],
                ),
                Container(
                  decoration: BoxDecoration( border: Border.all(width: 0.5, color:Colors.black), color: Colors.white ),
                  height: 350,
                  width: 340,
                  child:  SingleChildScrollView(
                    child: Card(
                      elevation: 0.0,
                      child: Column(
                        children: [
                         for(int i = 0;i<size;i++)
                           Row(
                             children: [
                               Container(
                                 width: 130,
                                 child: DropdownButton<String>(
                                   items: names
                                       .map<DropdownMenuItem<String>>((String value) {
                                     return DropdownMenuItem<String>(
                                       value: value,
                                       child: Text(value),
                                     );
                                   }).toList(),
                                   value: values[i],
                                   onChanged: (String? newValue) {
                                     addItem(newValue!,i);
                                     setState(() {
                                       values[i] = newValue!;
                                       calculatePoints();
                                       print(values);
                                     });
                                   },
                                   elevation: 16,
                                   isExpanded: true,
                                   style: const TextStyle(fontFamily:'Poppins',color: Colors.black),
                                   underline: Container(height: 2, color: plastikatGreen,),
                                 ),
                               ),
                               SizedBox(width: 70,),
                               IconButton(onPressed: () { setState(() {numbers[i]++;
                               calculatePoints();}); }
                                 ,icon: Icon(Icons.add),color: plastikatGreen,),
                               TextWidget(numbers[i].toString(), Colors.black),
                               IconButton(onPressed: () { setState(() {numbers[i]==1 ? null : numbers[i]-- ;
                               calculatePoints();}); }
                                 ,icon: Icon(Icons.remove),color: Colors.red,),
                             ],
                           )
                        ],
                    ),
                  ),),),
                const SizedBox(height: 30,),
                Text("${AppLocalizations.of(context)!.points} : ${totalPoints.toString()}",
                style: const TextStyle(
                  fontFamily: 'comfortaa',
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),),
                const SizedBox(height: 50,),
                PlastikatButton(AppLocalizations.of(context)!.publish_Offer, () async {
                  itemsToOffers();
                  if(finalResults.isNotEmpty)
                  {
                    String? accessToken = await globals.secureStorage.read(key: "access_token");
                    String? id = await globals.user.read(key: "id");
                    final OfferService service =  OfferService(accessToken!);
                    final response = await service.initiateOffer({
                      'client' : id,
                      'points' : totalPoints,
                      'items': finalResults.map((x) => {
                        '_id' : x.id,
                        'quantity' : x.quantity}).toList()
                    });
                    if(response==201)
                    {
                      ArtSweetAlert.show(
                          context: context,
                          artDialogArgs: ArtDialogArgs(
                              type: ArtSweetAlertType.success,
                              text:AppLocalizations.of(context)!.offer_success
                          )
                      );
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HomePage()));
                    }

                  }
                }),

              ],
            ): const CircularProgressIndicator());
  }

  Widget TextWidget(String name,Color c) {
    return Text(name,
        style: TextStyle(
            color: c,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            //decoration: TextDecoration.underline
        ));
  }


}


