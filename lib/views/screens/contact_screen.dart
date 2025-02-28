import 'package:flutter/material.dart';
import 'package:muzn/app_localization.dart';
import 'package:muzn/views/widgets/custom_button.dart';
import 'package:muzn/views/widgets/custom_text_field.dart';
import 'package:muzn/views/widgets/screen_header.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();

    return Scaffold(
        appBar: AppBar(
          title: Text('contact'.trans(context)),
          centerTitle: true,
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
            child: Column(children: [
              ScreenHeader(),
              Expanded(
                child: SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 5),
                      const Icon(
                        Icons.contact_mail,
                        size: 80,
                      ),
                      const SizedBox(height: 10),

                      Text(
                        'contact_welcome'.trans(context),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),

                      Column(
                        children: [
                          GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Icon(Icons.phone),
                                  const SizedBox(width: 5),
                                  Text(
                                    '+966 1234567898',
                                  ),
                                ],
                              )),
                          const SizedBox(height: 10),
                          GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Icon(Icons.email),
                                  const SizedBox(width: 5),
                                  Text(
                                    'support@example.com',
                                  ),
                                ],
                              )),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Contact Form
                      CustomTextField(
                        labelText: 'type_message'.trans(context),
                        hintText: 'type_message'.trans(context),
                        line: 10,
                      ),

                      const SizedBox(height: 20),
                      CustomButton(
                          text: 'send_message'.trans(context),
                          icon: Icons.send,
                          onPressed: () {}),
                    ],
                  ),
                ),
              ),
            ])));
  }
}
