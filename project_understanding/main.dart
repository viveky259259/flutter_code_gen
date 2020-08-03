import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/element/element.dart';

void main(List<String> args)async {
  print('understand the project');
  Directory directory = Directory('lib');
  print(directory.path);

//  AnalysisContextCollection collection =
//      AnalysisContextCollection(includedPaths: [directory.absolute.path]);
//  print(collection.toString());
  await printFiles(directory, 0);
}

Future<void> printFiles(Directory directory, int dash) async{
  directory.list().listen((event) async {
    FileStat stat = await event.stat();
    print('${'-' * dash} ${event.path}');
    if (stat.type == FileSystemEntityType.directory) await printFiles(event, dash+1);
  });
}

class UnderStandProject {
  String mainFolder = 'lib';
  Directory directory;

  UnderStandProject instance = UnderStandProject();

  UnderStandProject() {
    directory = Directory(mainFolder);
  }

  String getPath() {
    return directory.path;
  }

  dynamic getAnalysis() {
    AnalysisContextCollection collection =
        AnalysisContextCollection(includedPaths: [directory.absolute.path]);
    return collection;
  }

  void analyzeSingleFile(AnalysisSession session, String path) async {
    UnitElementResult result = await session.getUnitElement(path);
    CompilationUnitElement element = result.element;
    print(element);
  }
}
