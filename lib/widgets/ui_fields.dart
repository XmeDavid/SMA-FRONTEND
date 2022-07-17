import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:sma_frontend/models/Contract.dart';
import 'package:sma_frontend/models/paginated_model/PaginatedModel.dart';
import 'package:sma_frontend/responsive.dart';

import '../consts.dart';


class TextLine extends StatelessWidget {
  const TextLine({Key? key, required this.labelText ,required this.hintText, required this.controller, required this.size, this.isEnabled = true}) : super(key: key);

  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final double size;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: Center(
                  child:Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        labelText,
                        style: const TextStyle(
                            fontSize: 20
                        ),
                      )
                  )
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                ),
                color: thirdColor3,
              ),
              height: 40,
              width: size,
              child: Center(
                child:TextFormField(
                  enabled: isEnabled,
                  controller: controller,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 10,bottom: 8),
                      hintText: hintText,
                      border: InputBorder.none
                  ),
                  style: TextStyle(
                      fontSize: 20,
                    color: isEnabled ? Colors.white : Colors.white70,
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}

class TextArea extends StatelessWidget {
  const TextArea({Key? key, required this.labelText ,required this.hintText, required this.controller, required this.height, this.isEnabled = true}) : super(key: key);

  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final double height;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding/2),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10)
              ),
              color: thirdColor5,
            ),
            height: 40,
            child: Center(
                child:Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      labelText,
                      style: const TextStyle(
                          fontSize: 20
                      ),
                    )
                )
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)
              ),
              color: thirdColor3,
            ),
            height: height,
            child: TextFormField(
                enabled: isEnabled,
                keyboardType: TextInputType.multiline,
                minLines: 6,
                maxLines: 20,
                controller: controller,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10),
                    hintText: hintText,
                    border: InputBorder.none
                ),
                style: const TextStyle(
                    fontSize: 16
                ),
              ),

          ),
        ],
      ),
    );
  }
}


class DropDown extends StatelessWidget {
  const DropDown({Key? key, required this.label, required this.callback, required this.getData, this.selected= "", this.enabled = true}) : super(key: key);

  final String label;

  final Function(String s) callback;
  final Function() getData;

  final String selected;
  final bool enabled;

  bool whatDropdownMode(BuildContext context){
    return (MediaQuery.of(context).size.width > 800);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding/2),
      child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                //borderRadius: whatDropdownMode(context)? const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)) : const BorderRadius.all(Radius.circular(10)),
                color: thirdColor5,
              ),
              height: Responsive.isMobile(context) ? 60 : 50,
              child: DropdownSearch<String>(
                enabled: enabled,
                onFind: (String? filter) => getData(),
                mode:whatDropdownMode(context) ? Mode.MENU : Mode.BOTTOM_SHEET,
                showSelectedItems: true,
                popupBackgroundColor: thirdColor3,
                dropdownSearchDecoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  border: InputBorder.none,
                  labelText: label,
                ),
                //popupItemDisabled: (String s) => s.startsWith('I'),
                showSearchBox: true,
                onChanged: (s){
                  callback(s ?? "");
                },
                selectedItem: selected == "" ? null : selected,
              ),
            ),
          ]
      ),
    );
  }
}


class AddressField extends StatelessWidget {
  const AddressField({Key? key, required this.zipCodeController, required this.getCountrys, this.enabled = true ,required this.width, required this.height, required this.cityController, required this.stateController,required this.streetController, required this.doorController, required this.floorController, required this.roomController, required this.countryController}) : super(key: key);

  final bool enabled;
  final double width;
  final double height;
  final dynamic getCountrys;
  final TextEditingController countryController;
  final TextEditingController streetController;
  final TextEditingController doorController;
  final TextEditingController floorController;
  final TextEditingController roomController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController zipCodeController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding/2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Color.fromRGBO(secondColor7.red, secondColor7.green, secondColor7.blue, 0.3),
        ),
        width: width,//
        height: height,
        child: ListView(
          padding: const EdgeInsets.all(defaultPadding/2),
          children: [
            Row(
              children: const [
                Text("Address",
                  style: TextStyle(
                      fontSize: 16
                  ),
                ),
                Spacer()
              ],
            ),
            Responsive.isDesktop(context) ?  Row(children: [
                TextLine(labelText: "Street", hintText: "Street name", controller: streetController, size: width * 0.6 - 149,isEnabled: enabled,),
                TextLine(labelText: "Zip Code", hintText: "Zip Code", controller: zipCodeController, size: width * 0.4 - 114, isEnabled: enabled,),
              ],
            ) : Column(
              children: [
                TextLine(labelText: "Street", hintText: "Street name", controller: streetController, size: width -149,isEnabled: enabled,),
                TextLine(labelText: "Zip Code", hintText: "Zip Code", controller: zipCodeController, size: width-179, isEnabled: enabled,),
              ],
            ),
            Responsive.isDesktop(context) ? Row(children: [
                TextLine(labelText: "Door", hintText: "Door number", controller: doorController, size: width * 0.33 - 138, isEnabled: enabled,),
                TextLine(labelText: "Floor", hintText: "Floor", controller: floorController, size: width * 0.29 - 75 , isEnabled: enabled,),
                TextLine(labelText: "Room", hintText: "Room", controller: roomController, size: width * 0.38 -84, isEnabled: enabled,)
              ],
            ): Column(
              children: [
                TextLine(labelText: "Door", hintText: "Door number", controller: doorController, size: width -138, isEnabled: enabled,),
                TextLine(labelText: "Floor", hintText: "Floor", controller: floorController, size: width -139, isEnabled: enabled,),
                TextLine(labelText: "Room", hintText: "Room", controller: roomController, size: width -148, isEnabled: enabled,)
              ],
            ),
            DropDown(
              label: "Country",
              callback: (s) =>{countryController.text = s},
              getData: getCountrys,
              selected: countryController.text,
              enabled: enabled,
            ),
            Responsive.isDesktop(context) ? Row(children: [
                TextLine(labelText: "City", hintText: "City", controller: cityController, size: width * 0.5 - 143, isEnabled: enabled,),
                TextLine(labelText: "State", hintText: "State", controller: stateController, size: width * 0.5 - 96, isEnabled: enabled,),
              ],
            ) : Column(
              children: [
                TextLine(labelText: "City", hintText: "City", controller: cityController, size: width -143, isEnabled: enabled,),
                TextLine(labelText: "State", hintText: "State", controller: stateController, size: width -160, isEnabled: enabled,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmationDialog extends StatefulWidget {

  final String title;
  final String message;
  final Function callback;

  const ConfirmationDialog({Key? key, required this.title, required this.message, required this.callback}) : super(key: key);

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        child: Container(
          height: 128,
          child: Column(
            children: [
              Text(widget.message),
              const Spacer(),
              Row(
                children: [
                  Padding(padding: const EdgeInsets.all(defaultPadding/2),
                    child: OutlinedButton (
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(padding: const EdgeInsets.all(defaultPadding/2),
                    child: ElevatedButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          widget.callback();
                        },
                        child: const Text('Yes')
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


class PaginatedNavigation extends StatelessWidget {
  final PaginatedModel paginatedModel;
  final Function callback;
  const PaginatedNavigation({Key? key, required this.paginatedModel, required this.callback,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (paginatedModel.meta.current_page > 1)Padding(
          padding: const EdgeInsets.all(smallPadding),
          child: SizedBox(
            width: 40,
            child: OutlinedButton(
              onPressed: () {
                callback(1);
              },
              child: const Text('1',style: TextStyle(color: Colors.white),)
            ),
          ),
        ),
        if(paginatedModel.meta.current_page > 3) const Text(' . . . '),
        if (paginatedModel.meta.current_page > 2)Padding(
          padding: const EdgeInsets.all(smallPadding),
          child: SizedBox(
            width: 40,
            child: OutlinedButton(
                onPressed: () {
                  callback(paginatedModel.meta.current_page -1);
                },
                child: Text('${paginatedModel.meta.current_page -1}',
                  style: const TextStyle(color: Colors.white),
                )
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(smallPadding),
          child: SizedBox(
            width: 40,
            child: OutlinedButton(
              onPressed: null,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.blueAccent.withOpacity(0.3))
              ),
              child: Text(paginatedModel.meta.current_page.toString(),
                style: const TextStyle(
                  color: Colors.white
                ),
              )
            ),
          ),
        ),
        if (paginatedModel.meta.current_page < paginatedModel.meta.last_page-1)Padding(
          padding: const EdgeInsets.all(smallPadding),
          child: SizedBox(
            width: 40,
            child: OutlinedButton(
              onPressed: () {
                callback(paginatedModel.meta.current_page + 1);
              },
              child: Text('${paginatedModel.meta.current_page +1}',
                style: const TextStyle(
                  color: Colors.white
                ),
              )
            ),
          ),
        ),
        if(paginatedModel.meta.current_page < paginatedModel.meta.last_page - 2) const Text(' . . . '),
        if (paginatedModel.meta.current_page < paginatedModel.meta.last_page)Padding(
          padding: const EdgeInsets.all(smallPadding),
          child: SizedBox(
            width: 40,
            child: OutlinedButton(
              onPressed: () {
              callback(paginatedModel
                  .meta.last_page);
              },
              child: Text('${paginatedModel.meta.last_page}',
                style: const TextStyle(
                  color: Colors.white
                ),
              )
            ),
          ),
        ),
      ]
    );
  }
}
