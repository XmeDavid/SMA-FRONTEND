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
  final status = TextEditingController();
  final purchaseDate = TextEditingController();
  final purchasePrice = TextEditingController();
  final warrantyMonths = TextEditingController();

  bool isEditMode = false;

  bool assetLoaded = false;
  late Asset asset;

  void loadAsset() async{
    var _asset = await Asset.get(int.parse(Get.parameters['id'] ?? ''));
    if(_asset == null) return null;
    setState(() {
      asset = _asset;
      model.text = asset.model;
      brand.text = asset.brand;
      serialNumber.text = asset.serialNumber;
      purchaseDate.text = asset.purchaseDate;
      purchasePrice.text = asset.purchasePrice.toString();
      warrantyMonths.text = asset.warrantyMonths.toString();
      status.text = asset.assetStatusId.toString();
      assetLoaded = true;
    });
  }

  void saveChanges() async{

  }

  @override
  void initState(){
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
                              TextLine(
                                isEnabled: isEditMode,
                                labelText: "Status Id",
                                hintText: "Status Id //TODO WAITING FOR BACKEND",
                                controller: status,
                                size: MediaQuery.of(context).size.width * (Responsive.isDesktop(context) ? 0.666 : 0.9) - 144,
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