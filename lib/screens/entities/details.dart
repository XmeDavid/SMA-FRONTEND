import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../consts.dart';
import '../../responsive.dart';
import '../../widgets/ui_fields.dart';
import '../side_menu.dart';

class EntityDetails extends StatelessWidget {
  const EntityDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(Get.parameters['id']);
    return Scaffold(
      appBar: !Responsive.isDesktop(context)
          ? AppBar(title: const Text("Dashboard"), backgroundColor: bgColor)
          : null,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              const Expanded(
                flex: 1,
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!Responsive.isMobile(context))
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width *
                            (Responsive.isDesktop(context) ? 0.666 : 0.9),
                        child: Text(
                          Get.parameters['id'] ?? '',
                          style: TextStyle(fontSize: 48),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
