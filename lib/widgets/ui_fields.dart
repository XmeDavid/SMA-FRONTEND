import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:sma_frontend/models/Contract.dart';

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
                  style: const TextStyle(
                      fontSize: 20
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
  const TextArea({Key? key, required this.labelText ,required this.hintText, required this.controller, required this.size, this.isEnabled = true}) : super(key: key);

  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final double size;
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
            height: 120,
            child: Center(
              child:TextFormField(
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
          ),
        ],
      ),
    );
  }
}


class DropDown extends StatelessWidget {
  const DropDown({Key? key, required this.label, required this.callback, required this.getData}) : super(key: key);

  final String label;

  final Function(String s) callback;
  final Function() getData;

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
              height: 50,
              child: DropdownSearch<String>(
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
              ),
            ),
          ]
      ),
    );
  }
}
