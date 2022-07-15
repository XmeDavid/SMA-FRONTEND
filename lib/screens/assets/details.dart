import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sma_frontend/models/Address.dart';
import 'package:sma_frontend/models/AssetStatus.dart';
import 'package:sma_frontend/models/Contract.dart';
import 'package:sma_frontend/models/Country.dart';
import 'package:sma_frontend/models/EntityType.dart';
import 'package:sma_frontend/models/TicketCategory.dart';


import '../../api_interactions/api_functions.dart';
import '../../models/Entity.dart';
import '../../models/Asset.dart';
import '../../responsive.dart';
import '../../consts.dart';
import '../../widgets/ui_fields.dart';
import '../side_menu.dart';

class AssetDetailsScreen extends StatefulWidget {
  const AssetDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AssetDetailsScreen> createState() => _AssetDetailsState();


}

class _AssetDetailsState  extends State<AssetDetailsScreen> {



  final _formKey = GlobalKey<FormState>();

  final brand = TextEditingController();
  final model = TextEditingController();
  final serialNumber = TextEditingController();
  final purchaseDate = TextEditingController();
  final purchasePrice = TextEditingController();
  final warrantyMonths = TextEditingController();

  int _selectedStatus = -1;

  bool isEditMode = false;

  bool assetLoaded = false;
  late Asset asset;

  List<AssetStatus> status = [];

  void loadAsset() async{
    var _status = await AssetStatus.getAll();
    var _asset = await Asset.get(int.parse(Get.parameters['id'] ?? ''));
    if(_asset == null) return null;
    setState(() {
      status = _status;
      asset = _asset;
      model.text = asset.model;
      brand.text = asset.brand;
      serialNumber.text = asset.serialNumber;
      purchaseDate.text = asset.purchaseDate;
      purchasePrice.text = asset.purchasePrice.toString();
      warrantyMonths.text = asset.warrantyMonths.toString();
      _selectedStatus = asset.assetStatusId;
      assetLoaded = true;
    });
  }

  void saveChanges() async{
    Asset.update(asset.id,serialNumber.text,brand.text,model.text,purchaseDate.text,purchasePrice.text,int.parse(warrantyMonths.text),_selectedStatus);
  }

  void delete() async{
    Asset.remove(asset.id);
    Get.toNamed('/assets');
  }

  @override
  void initState(){
    GetStorage().read('token') ?? Get.toNamed('/login');
    super.initState();
    loadAsset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !Responsive.isDesktop(context) ? AppBar(title: Text (assetLoaded ? asset.toString() : "Unknown Entity"), backgroundColor: bgColor) : null,
      drawer: const SideMenu(),
      body: SafeArea(
        child: assetLoaded ? Row(
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
                          children:  [
                            Text(asset.toString(),
                              style: const TextStyle(
                                  fontSize: 28
                              ),
                            ),
                            const Spacer()
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
                                isEnabled: isEditMode,
                                labelText: "SN",
                                hintText: "Serial Number",
                                controller: serialNumber,
                                size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 84,
                              ),
                              TextLine(
                                isEnabled: isEditMode,
                                labelText: "Brand",
                                hintText: "Brand",
                                controller: brand,
                                size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 118,
                              ),
                              TextLine(
                                isEnabled: isEditMode,
                                labelText: "Model",
                                hintText: "Model",
                                controller: model,
                                size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 119,
                              ),
                              TextLine(
                                isEnabled: isEditMode,
                                labelText: "Date",
                                hintText: "Purchase Date",
                                controller: purchaseDate,
                                size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 106,
                              ),
                              Responsive.isDesktop(context) ? Row(
                                children: [
                                  TextLine(
                                    isEnabled: isEditMode,
                                    labelText: "Price",
                                    hintText: "Purchase Price",
                                    controller: purchasePrice,
                                    size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) * 0.5 - 107,
                                  ),
                                  TextLine(
                                    isEnabled: isEditMode,
                                    labelText: "Warranty",
                                    hintText: "Warranty Months",
                                    controller: warrantyMonths,
                                    size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) * 0.5 - 120,
                                  ),
                                ],
                              ) : Column(
                                children: [
                                  TextLine(
                                    isEnabled: isEditMode,
                                    labelText: "Price",
                                    hintText: "Purchase Price",
                                    controller: purchasePrice,
                                    size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 107,
                                  ),
                                  TextLine(
                                    isEnabled: isEditMode,
                                    labelText: "Warranty",
                                    hintText: "Warranty Months",
                                    controller: warrantyMonths,
                                    size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 152,
                                  ),
                                ],
                              ),
                              DropDown(
                                label: 'Status',
                                enabled: isEditMode,
                                selected: assetLoaded ? status.where((element) => element.id == _selectedStatus).first.name : "Unknown",
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
                                        Get.toNamed('/entities');
                                      },
                                      child: const Text("Go Back",style: TextStyle(color: Colors.white),),
                                    ),
                                ),
                                const Spacer(),
                                Padding(padding: const EdgeInsets.all(defaultPadding/2),
                                  child: OutlinedButton (
                                    onPressed: (){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext dialogContext) {
                                          return ConfirmationDialog(title: 'Confirm Delete', message: 'You are about to delete Asset #${asset.id} - ${asset.serialNumber}\nAre you sure you want to continue?', callback: delete);
                                        },
                                      );
                                    },
                                    child: const Text("Delete",style: TextStyle(color: Colors.white),),
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red),),
                                  ),
                                ),
                                Padding(padding: const EdgeInsets.all(defaultPadding/2),
                                  child: ElevatedButton(
                                    onPressed: (){
                                      setState(() {
                                        isEditMode = !isEditMode;
                                      });
                                    },
                                    child: ((){
                                      if(isEditMode){
                                        return const Text("Cancel");
                                      }
                                      return const Text("Edit");
                                    })(),
                                    style: isEditMode ? ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(thirdColor5),) : ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(firstColor),),
                                  ),
                                ),

                                if(isEditMode)Padding(padding: const EdgeInsets.all(defaultPadding/2),
                                  child: ElevatedButton(
                                    onPressed: (){
                                      setState(() {
                                        isEditMode = false;
                                      });
                                      saveChanges();
                                    },
                                    child: const Text("Save"),
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
        )  : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}