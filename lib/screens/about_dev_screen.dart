import 'package:flutter/material.dart';
import 'package:schedule_profs/shared/constants.dart';

class AboutDev extends StatefulWidget {
  const AboutDev({super.key});

  @override
  State<AboutDev> createState() => _AboutDevState();
}

class _AboutDevState extends State<AboutDev> {
  
  Map<String, String> faq = {
    "Project Managers" : "Gabriel Santoc\nMark Joshua Tarcelo",
    "UI/UX Designers" : "Clark Kent Amargo\nRaven Cuadro",
    "Front-end Developers" : "Mark Joshua Tarcelo\nKenrick Driz",
    "Back-end Developers" : "Gabriel Santoc\nErickson Molino",
    "Database Managers" : "Erickson Molino\nJoseph Begornia\nKenrick Driz",
    "API Integration Specialists" : "Dave Matthew Ramiro\nRaven Cuadro",
    "Testers/QAs" : "Jus Martinez\nDenzel Espino\nClark Kent Amargo",
    "Documentation Specialists" : "Joseph Begornia\nDave Matthew Ramiro\nJus Martinez\nDezen Espina",
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
        title: const Text("Developers"),
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