import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sma_frontend/models/Address.dart';
import 'package:sma_frontend/models/Contract.dart';
import 'package:sma_frontend/models/Country.dart';
import 'package:sma_frontend/models/EntityType.dart';
import 'package:sma_frontend/models/TicketCategory.dart';


import '../../api_interactions/api_functions.dart';
import '../../models/AssetStatus.dart';
import '../../models/Entity.dart';
import '../../models/Asset.dart';
import '../../responsive.dart';
import '../../consts.dart';
import '../../widgets/datePicker.dart';
import '../../widgets/ui_fields.dart';
import '../side_menu.dart';

class NewAssetScreen extends StatefulWidget {
  const NewAssetScreen({Key? key}) : super(key: key);

  @override
  State<NewAssetScreen> createState() => _NewAssetState();


}

class _NewAssetState  extends State<NewAssetScreen> {

  final _formKey = GlobalKey<FormState>();

  final brand = TextEditingController();
  final model = TextEditingController();
  final serialNumber = TextEditingController();
  final purchaseDate = TextEditingController();
  final purchasePrice = TextEditingController();
  final warrantyMonths = TextEditingController();

  int _selectedStatus = 1;
  bool loaded = false;
  late List<AssetStatus> status;

  DateTime? selectedPurchaseDate;

  void showDatePanel() async {
    var tempDate = await getDateFromPicker(context: context, initialDate: selectedPurchaseDate ?? DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime(2050));
    if(tempDate != null){
      setState(() {
        selectedPurchaseDate = tempDate;
        purchaseDate.text = "${selectedPurchaseDate?.year.toString().padLeft(4,"0") ?? ""}-${selectedPurchaseDate?.month.toString().padLeft(2,"0") ?? ""}-${selectedPurchaseDate?.day.toString().padLeft(2,"0") ?? ""}";
      });
    }
  }


  void create() async{
    await Asset.create(serialNumber.text,brand.text,model.text,purchaseDate.text,double.parse(purchasePrice.text),int.parse(warrantyMonths.text));
  }

  void loadStatus() async {
    var _status = await AssetStatus.getAll();
    setState((){
      status = _status;
      loaded = true;
    });
  }

  @override
  void initState(){
    GetStorage().read('token') ?? Get.toNamed('/login');
    super.initState();
    loadStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !Responsive.isDesktop(context) ? AppBar(title: Text ("Create Asset"), backgroundColor: bgColor) : null,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              const Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 6,
              child: Center(child:Column(
                  children:[
                    if(Responsive.isDesktop(context)) SizedBox(
                        width: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9),
                        child: Row(
                          children:  const [
                            Text("Create Asset",
                              style: TextStyle(
                                  fontSize: 48
                              ),
                            ),
                            Spacer()
                          ],
                        )
                    ),
                    Container(
                      padding: const EdgeInsets.all(defaultPadding),
                      decoration: const BoxDecoration(
                          color: secondColor3,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      height: Responsive.isDesktop(context) ? MediaQuery.of(context).size.height * 0.8 : MediaQuery.of(context).size.height * 0.75,
                      width: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextLine(
                                isEnabled: true,
                                labelText: "SN",
                                hintText: "Serial Number",
                                controller: serialNumber,
                                size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 84,
                              ),
                              TextLine(
                                isEnabled: true,
                                labelText: "Brand",
                                hintText: "Brand",
                                controller: brand,
                                size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 118,
                              ),
                              TextLine(
                                isEnabled: true,
                                labelText: "Model",
                                hintText: "Model",
                                controller: model,
                                size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 119,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(defaultPadding/2),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)
                                        ),
                                        color: thirdColor5,
                                      ),
                                      height: 40,
                                      child: const Center(
                                          child:Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Text(
                                                "Purchase Date",
                                                style: TextStyle(fontSize: 20),
                                              )
                                          )
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: thirdColor3,
                                      ),
                                      height: 40,
                                      width: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 261,
                                      child: Center(
                                        child:TextFormField(
                                          enabled: false,
                                          controller: purchaseDate,
                                          decoration: const InputDecoration(
                                              contentPadding:  EdgeInsets.only(left: 10,bottom: 8),
                                              hintText: "yyyy-mm-dd",
                                              border: InputBorder.none
                                          ),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10)
                                          ),
                                          color: thirdColor5,
                                        ),
                                        height: 40,
                                        child: TextButton(onPressed: showDatePanel, child: const Icon(Icons.calendar_month_outlined,color: Colors.white,))
                                    ),
                                  ],
                                ),
                              ),
                              Responsive.isDesktop(context) ? Row(
                                children: [
                                  TextLine(
                                    isEnabled: true,
                                    labelText: "Price",
                                    hintText: "Purchase Price",
                                    controller: purchasePrice,
                                    size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) * 0.5 - 107,
                                  ),
                                  TextLine(
                                    isEnabled: true,
                                    labelText: "Warranty",
                                    hintText: "Warranty Months",
                                    controller: warrantyMonths,
                                    size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) * 0.5 - 120,
                                  ),
                                ],
                              ) : Column(
                                children: [
                                  TextLine(
                                    isEnabled: true,
                                    labelText: "Price",
                                    hintText: "Purchase Price",
                                    controller: purchasePrice,
                                    size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 107,
                                  ),
                                  TextLine(
                                    isEnabled: true,
                                    labelText: "Warranty",
                                    hintText: "Warranty Months",
                                    controller: warrantyMonths,
                                    size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 152,
                                  ),
                                ],
                              ),
                              DropDown(
                                  label: 'Status',
                                  enabled: true,
                                  selected: loaded ? status.where((element) => element.id == _selectedStatus).first.name : "Unknown",
                                  callback: (s){
                                    setState((){
                                      _selectedStatus = status.where((element) => element.name == s).first.id;
                                    });
                                  },
                                  getData: () async {
                                    return status.map((e) => e.name).toList();
                                  }
                              ),

                              Row(children: [
                                Padding(padding: const EdgeInsets.all(defaultPadding/2),
                                    child: OutlinedButton (
                                      onPressed: (){
                                        Get.toNamed('/assets');
                                      },
                                      child: const Text("Go Back",style: TextStyle(color: Colors.white),),
                                    ),
                                ),
                                const Spacer(),
                                Padding(padding: const EdgeInsets.all(defaultPadding/2),
                                  child: ElevatedButton(
                                    onPressed: (){
                                      setState(() {
                                        create();
                                      });
                                    },
                                    child: const Text("Create"),
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green),),
                                  ),
                                ),
                              ],)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}