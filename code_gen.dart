import 'dart:io';
import 'package:dart_style/dart_style.dart';


var formatter = new DartFormatter();


void main() {
  print("""Select a choice!
  
  1. crete bloc
  2. generate classes
  3. init project
  
  """);
  String selectedOption = stdin.readLineSync();

  if (selectedOption.compareTo('1') == 0)
    createBloc();
  else if (selectedOption.compareTo('2') == 0)
    generateClasses();
  else if (selectedOption.compareTo('3') == 0) initProject();
}

/// give list from space seperated string
List<String> getListFromSSVString(String string) {
  List<String> strings = string.split(" ")
    ..forEach((element) {
      element.trim();
    });
  print(strings);
  return strings;
}

void createBloc() async {
  print('Enter name of bloc');
//  String blocName = stdin.readLineSync();
   String blocName = "Chat";
  print('Enter states for bloc seperated by a space');
//  String states = stdin.readLineSync();
   String states = 'A B C D';
  List<String> stateList = getListFromSSVString(states);
  print('Enter events for bloc seperated by a space');

//  String events = stdin.readLineSync();
   String events = 'E F G H';
  List<String> eventList = getListFromSSVString(events);
  Directory mainBLocDirectory = Directory('blocs');
  if (!await mainBLocDirectory.exists()) mainBLocDirectory.createSync();

  Directory blocDirectory = Directory('blocs/' + blocName.toLowerCase());
  if (!await blocDirectory.exists()) blocDirectory.createSync();

  File blocFile =
      File(blocDirectory.path + '/${blocName.toLowerCase()}_bloc.dart')
        ..createSync();
  File stateFile =
      File(blocDirectory.path + '/${blocName.toLowerCase()}_state.dart')
        ..createSync();
  File eventFile =
      File(blocDirectory.path + '/${blocName.toLowerCase()}_event.dart')
        ..createSync();

  await updateFile("""
abstract class ${capitalizeFirstLetter(blocName)}State {}

class ${capitalizeFirstLetter(blocName)}Loading extends ${capitalizeFirstLetter(blocName)}State {}
  
  
  """, stateFile);

  await updateFile("""
abstract class ${capitalizeFirstLetter(blocName)}Event {}

class ${capitalizeFirstLetter(blocName)}Init extends ${capitalizeFirstLetter(blocName)}Event {}
  
  """, eventFile);

  await updateFromList(
      stateList, stateFile, '${capitalizeFirstLetter(blocName)}State');
  await updateFromList(
      eventList, eventFile, '${capitalizeFirstLetter(blocName)}Event');
  await createBlocFromList(eventList, blocName, blocFile, stateFile, eventFile);
  print('BLoc: --------------------------------------------------');
  print(await blocFile.readAsString());
  print('Event: --------------------------------------------------');
  print(await eventFile.readAsString());
  print('State: --------------------------------------------------');
  print(await stateFile.readAsString());
}

Future<void> createBlocFromList(List<String> events, String blocName, File file,
    File stateFile, File eventFile) async {
  await updateFile("""
import 'package:flutter_bloc/flutter_bloc.dart';
import \'${stateFile.path.split("/").last}\';
import  \'${eventFile.path.split("/").last}\';

class ${capitalizeFirstLetter(blocName)}Bloc extends Bloc<${capitalizeFirstLetter(blocName)}Event, ${capitalizeFirstLetter(blocName)}State> {
  ${capitalizeFirstLetter(blocName)}Bloc() : super(${capitalizeFirstLetter(blocName)}Loading());

  @override
  Stream<${capitalizeFirstLetter(blocName)}State> mapEventToState(${capitalizeFirstLetter(blocName)}Event event) async* {

  """, file, doFormat: false);

  for (int i = 0; i < events.length; i++) {
    if (events[i].trim().isNotEmpty) await updateFile("""

 if (event is ${events[i]}) {}

""", file, doFormat: false);
  }

  await updateFile("""
  }
  }
  
  
  """, file);
}

Future<void> updateFromList(
    List<String> list, File file, String parentClass) async {
  for (int i = 0; i < list.length; i++) {
    if (list[i].trim().isNotEmpty) await updateFile("""
class ${list[i]} extends $parentClass {}
""", file);
  }
}

String capitalizeFirstLetter(String text) {
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}

Future<void> updateFile(String newContent, File fileToUpdate,
    {bool doFormat = true}) async {
  String oldContent = await fileToUpdate.readAsString();

  String contentToWrite = """
  $oldContent

  $newContent
  """;
  if (doFormat) contentToWrite = formatter.format(contentToWrite);
  fileToUpdate.writeAsString(contentToWrite, flush: true, mode: FileMode.write);
}

void generateClasses() async {
  print('Enter parent classes to extend');
  String parentClassName = stdin.readLineSync();

  if (parentClassName.isNotEmpty)
    print('Enter classes that will extend $parentClassName separated by space');
  else
    print('Enter classes to print separated by space');

  String childClassString = stdin.readLineSync();

  List<String> childClasses = getListFromSSVString(childClassString);

  for (String each in childClasses) {
    if (parentClassName.isNotEmpty)
      print('class $each extends $parentClassName');
    else
      print('class $each');
  }
}

void initProject() {
  /// 1. create files blocs,extension,models,providers,screens,services,utilities,component[atoms,molecules,organisms]
  /// 2. update pubspec.yaml file with required data
  /// 3. update android/gradle files to add firebase
  /// 4. update manifest files
  ///
  ///  Start with step 1

  List<String> folders = [
    'blocs',
    'component',
    'component/atoms',
    'component/molecules',
    'component/organisms',
    'extensions',
    'providers',
    'screens',
    'services',
    'utilities'
  ];

  /// First check for lib folder
  Directory libDirectory = Directory('lib');
  if (!libDirectory.existsSync()) {
    libDirectory.createSync();
  }
  for (String each in folders) {
    StringBuffer buffer = StringBuffer();
    buffer.write(libDirectory.path);
    buffer.write('/');
    buffer.write(each);
    Directory directory = Directory(buffer.toString());
    if (!directory.existsSync()) directory.createSync();
  }
}
