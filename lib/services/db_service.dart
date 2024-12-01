import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:schedule_profs/model/announcement_model.dart';
import 'package:schedule_profs/model/schedule_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {

  static Database? _db;

  static final DatabaseService instance = DatabaseService._constructor();
  // ANCHOR TABLE SCHEDULE
  final String _scheduleTableName    = "tbl_schedules";
  final String _scheduleIdColumnName = "schedule_id";
  final String _scheduleProfessorColumnName = "professor_name";
  final String _scheduleSubjectColumnName   = "subject";
  final String _scheduleSectionColumnName   = "section";
  final String _scheduleStartTimeColumnName = "start_time";
  final String _scheduleEndTimeColumnName   = "end_time";
  final String _scheduleDayOfWeekColumnName = "day_of_week";

  // ANCHOR TABLE SCHEDULE
  final String _announcementTableName    = "tbl_announcements";
  final String _announcementIdColumnName = "announcement_id";
  //scheduleID
  final String _createdAtColumnName      = "created_at";
  final String _titleColumnName   = "title";
  final String _contentColumnName = "content";

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _db = await getDatabase();
    return _db!; 
  }

  Future<Database> getDatabase() async{
    

    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "schedule_viewer.db");
    final database = await openDatabase(
       
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        // Create the schedules table
        await db.execute('''
          CREATE TABLE $_scheduleTableName (
            $_scheduleIdColumnName INT NOT NULL PRIMARY KEY,
            $_scheduleProfessorColumnName TEXT NOT NULL,
            $_scheduleSubjectColumnName TEXT NOT NULL,
            $_scheduleSectionColumnName TEXT NOT NULL,
            $_scheduleStartTimeColumnName TEXT NOT NULL,
            $_scheduleEndTimeColumnName TEXT NOT NULL,
            $_scheduleDayOfWeekColumnName TEXT NOT NULL
          )
        ''');

        print("Table $_scheduleTableName created.");

        // Create the announcements table
        await db.execute('''
          CREATE TABLE $_announcementTableName (
            $_announcementIdColumnName INT NOT NULL PRIMARY KEY,
            $_scheduleIdColumnName INT NOT NULL,
            $_createdAtColumnName TEXT NOT NULL,
            $_titleColumnName TEXT NOT NULL,
            $_contentColumnName TEXT NOT NULL,
            FOREIGN KEY ($_scheduleIdColumnName) REFERENCES $_scheduleTableName($_scheduleIdColumnName) ON DELETE CASCADE ON UPDATE CASCADE
          )
        ''');

        print("Table $_announcementTableName created.");
      }

    );

    return database;
  }

  Future<void> insertSchedules(List<SchedModel> schedules) async {
    final db = await database;
    for (var schedule in schedules) {
      await db.insert(
        _scheduleTableName,
        {
          _scheduleIdColumnName: schedule.schedId,
          _scheduleProfessorColumnName: schedule.profName,
          _scheduleSectionColumnName : schedule.section,
          _scheduleSubjectColumnName: schedule.subject,
          _scheduleStartTimeColumnName: convertTo24HourFormat(schedule.startTime),
          _scheduleEndTimeColumnName: convertTo24HourFormat(schedule.endTime),
          _scheduleDayOfWeekColumnName: schedule.dayOfWeek,
        },
        conflictAlgorithm: ConflictAlgorithm.replace, 
      );
    }
    print("ALL SCHEDULES are added to SQLite.");
  }

  Future<void> insertAnnouncements(List<AnnouncementModel> announcements) async {
    final db = await database;
    for (var announcement in announcements) {
      await db.insert(
        _announcementTableName,
        {
          _announcementIdColumnName: announcement.id,
          _scheduleIdColumnName : announcement.sched_id,
          _createdAtColumnName : convertToTimestamp(announcement.createdAt),
          _titleColumnName  : announcement.title,
          _contentColumnName: announcement.content

        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    print("ALL ANNOUNCEMENTS are added to SQLite.");
  }


  Future<List<SchedModel>> fetchSchedulesFromLocalStorage() async { 
    try { 
      List<SchedModel> schedules = [];
      final db = await database; 
      final data = await db.query(_scheduleTableName); 

      for(var s in data ) {
        var schedule = SchedModel( 
          schedId: s["schedule_id"] as int,  
          profName: s["professor_name"] as String, 
          subject: s["subject"] as String, 
          section: s["section"] as String,
          rawStartTime: s["start_time"] as String, 
          rawEndTime: s["end_time"] as String, 
          dayOfWeek: s["day_of_week"] as String ,
        );
        schedules.add(schedule);
      }
      return schedules; 
    } catch (e) { 

      print("Error fetching schedules: $e"); 
      return []; 
    } 
  }

  Future<List<AnnouncementModel>> fetchAnnouncementsByScheduleId( int scheduleId) async {
    try {
     
      List<AnnouncementModel> announcements = [];
      final db = await database;
      final data = await db.query(
        _announcementTableName,
        where: '$_scheduleIdColumnName = ?',
        whereArgs: [scheduleId],
        orderBy: _createdAtColumnName,

      );
      
      for (var a in data) {

        var announcement = AnnouncementModel(
          id: a['announcement_id'] as int,
          sched_id: a['schedule_id'] as int,
          createdAt: a['created_at'] as String,
          title: a['title'] as String,
          content: a['content'] as String,
        );
        announcements.add(announcement);
      }
      return announcements;
    } catch (e) {
      print('Error fetching announcements from local storage: $e');
      return [];
    }
  }

  // function for home screen widget
  Future<List<SchedModel>>  fetchSchedulesByDayOfWeek(String dayOfWeek) async {
    try {
      final db = await database;
      
      final result = await db.query(
        _scheduleTableName,
        where: 'day_of_week = ?', 
        whereArgs: [dayOfWeek]
      );

      List<SchedModel> schedules = [];
      for (var s in result) {

        var schedule = SchedModel(
          schedId: s['schedule_id'] as int ,
          profName: s['professor_name'] as String,
          subject: s['subject'] as String,
          section: s['section'] as String,
          rawStartTime: s['start_time'] as String ,
          rawEndTime: s['end_time'] as String,
          dayOfWeek: s['day_of_week'] as String,
        );
        schedules.add(schedule);
        
      }
      return schedules;

    } catch (e) {
      print("Error fetching schedules by day of week: $e");
      return [];
    }
  }

  // Function to convert 12-hour format into 24-hour format before storing it in the database
  static String convertTo24HourFormat(String time12Hour) {
    try {
      
      final inputFormat = DateFormat('h:mm a');
      final outputFormat = DateFormat('HH:mm');

      final dateTime = inputFormat.parse(time12Hour);
      return outputFormat.format(dateTime);

    } catch (e) {
      print('Error converting to 24-hour format: $e');
      return time12Hour;
    }
  }

  // Function to convert formatted-timestamp into raw timestamp format before storing it in the database
  String convertToTimestamp(String dateTime12Hour) {
    try {
      final inputFormat = DateFormat('MMMM d, yyyy h:mm a');

      final dateTime = inputFormat.parse(dateTime12Hour);

      return DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime);
    } catch (e) {
      print('Error converting to timestamp: $e');
      return dateTime12Hour;
    }
  }

  // for debugging
  Future<void> fetchAndPrintAllSchedules() async {
    final db = await database; 
    final result = await db.query(_scheduleTableName); 

    if (result.isEmpty) {
      print("No data found.");
    } else {
      print("Fetched data from tbl_schedules:");
      for (var row in result) {
        print(row); 
      }
    }
  }

  // for debugging
  Future<void> fetchAndPrintAllAnnouncements() async {
    final db = await database; 
    final result = await db.query(_announcementTableName); 

    if (result.isEmpty) {
      print("No data found.");
    } else {
      print("Fetched data from tbl_schedules:");
      for (var row in result) {
        print(row); 
      }
    }
  }

  // for debugging
  Future<void> fetchAndPrintAllAnnouncementsBasedOnSchedule(String scheduleId) async{
   
    try {
      final db = await database;
      final result = await db.query(
        _announcementTableName, 
        where: '$_scheduleIdColumnName = ?',
        whereArgs: [scheduleId] 
      );

      if(result.isEmpty) {
        print("No announcements found for schedule ID: $scheduleId.");
      } else {
        print("Announcements for schedule ID: $scheduleId:");
        for (var row in result) {
          print(row);
        }
      }

    } catch (e) {
      print("Error fetching announcements: $e");
    }

  }

  Future<void> clearTable(String tableName) async {
    final db = await database;
    try {
      await db.delete(tableName);
      print("Table $tableName cleared successfully.");
    } catch (e) {
      print("Error clearing table $tableName: $e");
    }
  }

  // Future<void> dropTable(String tableName) async {
  //   final db = await database;
  //   try {
  //     await db.execute('DROP TABLE IF EXISTS $tableName');
  //     print("Table '$tableName' dropped successfully.");
  //   } catch (e) {
  //     print("Error dropping table '$tableName': $e");
  //   }
  // }

}