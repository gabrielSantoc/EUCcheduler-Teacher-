import 'package:flutter/material.dart';
import 'package:schedule_profs/shared/constants.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  
  Map<String, String> faq = {
    "What is the purpose of this app ?" : "This app allows students to view their class schedules conveniently in one place, providing a clear and organized display of their class schedules.",
    "Can I access the app offline ?"  : "Unfortunately, the application is currently available only offline. However, we are planning to make it an open-source project so that junior Computer Science students can contribute to its development and more amazing features.",
    "Is this app available on both Android and iOS ?"  : "Unfortunately, the app is currently only available on Android. But don’t you worry, once we have access to a Mac, we’ll build an iOS version too. (We’re a bit broke 😞😞😞).",
    "Is my personal information safe in the app ? " : "Yes, the app follows strict university data protection policies and complies with privacy regulations to keep your information secure.",
    // "Is there a way to report technical issues or bugs in the app ?"  : "Yes, you can PM Erickson Molino on epbi.com and he will fix the bugs and error like ASAP ROCKY! 🥰🥰🥰",
    // "Can I receive notifications for important updates?"   : "Yes, you can allow notifications in your phone settings to stay updated on university anouncements and calendar events.",
    "What should I do if I forget my password ?"  : "Press the forgot password on the login page to reset your password, follow the instruction and wait for the token to be send to your email.",
  }; 

  late int faqLength;
  List<bool> expandedState = [];

  bool collapsed = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    faqLength = faq.length;
    expandedState = List<bool>.filled(faqLength, false);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("FAQ"),
        backgroundColor: MAROON,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            // color: Colors.whiter,
            borderRadius: BorderRadius.circular(12),
          ),
          child:  ListView.builder(
            itemCount: faqLength,
            itemBuilder: (context, index) {
              String question = faq.keys.elementAt(index);
              String answer = faq.values.elementAt(index);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(

                    onExpansionChanged: (isExpanded) {
                      setState(() {
                        expandedState[index] = isExpanded;
                      });
                    },

                    title: Text(question, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: !expandedState[index] ? const Icon(Icons.add) : const Icon(Icons.remove),
                    expandedAlignment: Alignment.centerLeft,
                    collapsedIconColor: MAROON,
                    iconColor: MAROON,
                    childrenPadding:  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide.none
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide.none
                    ),
                    
                    children: [
                      Text(answer),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      )
    ); 
  }
}