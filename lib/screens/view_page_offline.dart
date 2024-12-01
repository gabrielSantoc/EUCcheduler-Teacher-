import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:schedule_profs/model/announcement_model.dart';
import 'package:schedule_profs/screens/add_announcement.dart';
import 'package:schedule_profs/screens/edit_announcement.dart';
import 'package:schedule_profs/screens/edit_subject.dart';
import 'package:schedule_profs/screens/teacher_screen.dart';
import 'package:schedule_profs/services/db_service.dart';
import 'package:schedule_profs/shared/alert.dart';
import 'package:schedule_profs/shared/button.dart';
import 'package:schedule_profs/shared/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ViewPageOffline extends StatefulWidget {
  final int schedId;
  final String? profName;
  final String subjectName;
  final String section;
  final String startTime;
  final String endTime;
  final String day;

  const ViewPageOffline({
    required this.schedId,
    this.profName,
    required this.subjectName,
    required this.section,
    required this.startTime,
    required this.endTime,
    required this.day,
    super.key,
  });

  @override
  ViewPageOfflineState createState() => ViewPageOfflineState();
}

class ViewPageOfflineState extends State<ViewPageOffline> {

  late StreamSubscription _internetConnectionStreamSubscription;
  bool isConnectedTointernet = false;

  @override
  void initState() {
    super.initState();

     // Check initial connectivity first
    InternetConnection().hasInternetAccess.then((hasInternet) {
      setState(() {
        isConnectedTointernet = hasInternet;
        print("INITIAL STATE $isConnectedTointernet");
      });
    });

    _internetConnectionStreamSubscription = InternetConnection().onStatusChange.listen((event) {
      print("EVENT ::: $event");
      
      switch(event) {
        case InternetStatus.connected: 
          setState(() {
            isConnectedTointernet = true;
            print("INTERNET CONNECTION ::: $isConnectedTointernet");
          });
          break;
        case InternetStatus.disconnected:
          setState(() {
            isConnectedTointernet = false;
            print("INTERNET CONNECTION ::: $isConnectedTointernet");
          });
          break;
        default:
          isConnectedTointernet = false;
          break;
      }
      
    });

  }

  @override
  void dispose() {
    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }

  // ANCHOR - DELETE SCHEDULE FUNCTION
  void deleteSubject(int scheduleId) async {
    try{

      await Supabase.instance.client
      .from('tbl_schedule')
      .delete()
      .eq('schedule_id', scheduleId);
      print("deleted successfully");
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context)=> const TeacherScreen())
      );
      Alert.of(context).showSuccess("Schedule deleted successfully🥰🥰🥰");
    } catch(e) {
      Alert.of(context).showError("$e 😢😢😢");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MAROON,
      appBar: AppBar(
        backgroundColor: MAROON,
        iconTheme: const IconThemeData(color: WHITE),

        actions: [
          
          // IconButton(
          //   onPressed: () {

          //     if(isConnectedTointernet == false) {
          //       return Alert.of(context).showError("Internet connection is required to delete schedule 😊");
          //     }
          //     showConfirmDialog(
          //       context,
          //       'Delete Subject',
          //       'Are you sure you want to delete this Subject?',
          //       (){
          //         deleteSubject(widget.schedId);
          //       }
          //     );

          //   } ,
          //   icon: const Icon(Icons.delete, color: WHITE,),
          // ),
        ],
      ),
      

      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
          
      //     if(isConnectedTointernet == false) {
      //       return Alert.of(context).showError("Internet connection is required to add an announcement 😊");
      //     }

      //     Navigator.push(
      //       context, 
      //       MaterialPageRoute(builder: (context)=> AddAnnouncementScreen(schedId: widget.schedId))
      //     );
      //   },
      //   backgroundColor: MAROON,
      //   label: const Row(
      //     children: [

      //       Icon(Icons.add, color: WHITE),
            
      //       SizedBox(width: 5),

      //       Text(
      //         "Add Announcement",
      //         style: TextStyle(
      //           color: WHITE,
      //           fontSize: 12,
      //         ),
      //       )

      //     ],
      //   ),
      // ),
      
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Text(
            widget.subjectName,
            style: const TextStyle(
              fontSize: 32, 
              fontWeight: FontWeight.bold, 
              color: WHITE
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.all(23),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: 8),

                    Text(
                      'Time',
                      style: TextStyle(fontWeight: FontWeight.bold, color: WHITE),
                    ),

                    SizedBox(height: 8),

                    Text(
                      'Section',
                      style: TextStyle(fontWeight: FontWeight.bold, color: WHITE),
                    ),

                  ],
                ),
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [

                    const SizedBox(height: 8),

                    Text(
                      "${widget.startTime}-${widget.endTime}",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: WHITE),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      widget.section,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: WHITE),
                    ),

                  ],
                ),
              ],
            ),
          ),

          // MyButton2( // ANCHOR - PAGE ROUTE FOR EDIT SUBJECT SCREEN
          //   onTap: (){
          //     if(isConnectedTointernet == false) {
          //       return Alert.of(context).showError("Internet connection is required to edit subject 😊");
          //     }

          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context)=> EditSubjectScreen( 
          //         schedId: widget.schedId,
          //         section: widget.section,
          //         subjectName: widget.subjectName,
          //         day: widget.day,
          //         startTime: widget.startTime,
          //         endTime: widget.endTime
          //       ))
          //     );
          //   }, 
          //   buttonName: "Edit Subject"
          // ),

          const SizedBox(height: 10),

          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25)
                ),
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              child: Column(
                children: [
                  
                  const SizedBox(height: 10),

                  const Text(
                    'ANNOUNCEMENTS',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: AnnouncementCard(
                        schedId: widget.schedId,
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnnouncementCard extends StatefulWidget {
  final int schedId;

  const AnnouncementCard({
    required this.schedId,
    super.key
  });

  @override
  State<AnnouncementCard> createState() => _AnnouncementCardState();
}

class _AnnouncementCardState extends State<AnnouncementCard> {
  final SupabaseClient supabase = Supabase.instance.client;
  late Future<List<AnnouncementModel>> announcementFuture;

  final DatabaseService _databaseService = DatabaseService.instance;
  StreamSubscription? _internetConnectionStreamSubscription;
  bool isConnectedTointernet = false;

  @override
  void initState() {
    super.initState();
    announcementFuture = fetchAnnouncement();

    _internetConnectionStreamSubscription = InternetConnection().onStatusChange.listen((event) {
      print("EVENT ::: $event");
      switch(event) {
        case InternetStatus.connected:
          setState(() {
            isConnectedTointernet = false;
          });
          break;
        case InternetStatus.disconnected:
          setState(() {
            isConnectedTointernet = false;
          });
          break;
        default:
          setState(() {
            isConnectedTointernet = false;
          });
          break;
      }
    });

  }


  Future<List<AnnouncementModel>> fetchAnnouncement() async {
    try {
      final response = await Supabase.instance.client
      .from('tbl_announcement')
      .select()
      .eq('schedule_id', widget.schedId)
      .order('id',ascending: false);

      return AnnouncementModel.jsonToList(response);

    } catch (e) {
      print('Error fetching announcements: $e');
      print("SCHED ID :::: ${widget.schedId}");
      return await _databaseService.fetchAnnouncementsByScheduleId(widget.schedId);
    }
  }

  
  // ANCHOR - DELETE ANNOUNCEMENT FUNCTION
  void deleteAnnouncement(int announcmentId) async {
    try{
      await Supabase.instance.client
      .from('tbl_announcement')
      .delete()
      .eq('id', announcmentId);
      print("Announcment was deleted successfully");
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context)=> const TeacherScreen())
      );
      Alert.of(context).showSuccess("Announcment was deleted successfully🥰🥰🥰");
    } catch(e) {
      Alert.of(context).showError("$e 😢😢😢");
    }
  }

  // TODO - EDIT ANNOUNCMENT
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AnnouncementModel>>(
      future: announcementFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: MAROON,
                  size: 50
                )
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Looking for announcements...",
                style: TextStyle(color: GRAY, fontSize: 15),
              )
            ],
          );
        } else if (snapshot.hasError) {

          return Center(child: Text('Error: ${snapshot.error}'));

        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {

          return const Center(child: Text('No announcements available.'));

        } else {

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final announcement = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: LIGHTGRAY,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            announcement.title,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),

                          // PopupMenuButton( // ANCHOR - POP-UP MENU
                          //   color: WHITE,
                          //   padding: EdgeInsets.zero,
                          //   itemBuilder: (context) => [
                              
                          //     PopupMenuItem( // ANCHOR - EDIT ANNOUNCEMENT
                          //       onTap: (){

                          //         print("ANNOUNCEMENT ID ::::: ${announcement.id}");
                          //         Navigator.push(
                          //           context, 
                          //           MaterialPageRoute(builder: (context)=>  EditAnnouncement(
                          //             announcementId: announcement.id,
                          //             title: announcement.title,
                          //             content: announcement.content,
                          //           ))
                          //         );
                          //       },  
                          //       child: const ListTile(
                          //         leading: Icon(Icons.edit_document ),
                          //         title: Text('Edit'),
                          //       ),
                          //     ),
                          
                          //     PopupMenuItem( // ANCHOR - DELETE ANNOUNCEMENT
                              
                          //       onTap: () {
                          //         showConfirmDialog(
                          //           context,
                          //           'Delete Announcement',
                          //           'Are you sure you want to delete this Announcment?',
                          //           (){
                          //             deleteAnnouncement(announcement.id);
                          //           }
                          //         );

                          //       },
                          //       child: const ListTile(
                          //         leading: Icon(Icons.delete),
                          //         title: Text('Delete'),
                          //       ),
                          //     ),  
                          //   ],
                          //   child: Container(
                          //     height: 36,
                          //     width: 48,
                          //     alignment: Alignment.centerRight,
                          //     child: const Icon(
                          //       Icons.more_vert,
                          //     ),
                          //   ),
                          // )
                        ] ,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        announcement.content,
                        style: const TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Created at: ${announcement.createdAt}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}