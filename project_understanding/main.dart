import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'dart:math' as math;

import 'package:pdf/widgets.dart';

import 'pdf_generator/generator.dart';
import 'pdf_generator/widgets/file_box_widget.dart';
import 'pdf_generator/widgets/folder_box_widget.dart';

void main(List<String> args) async {
  print('understand the project');
  Directory directory = Directory('F:\\Flutter\\sync-2\\lib');
  print(directory.path);
  print('Project Structure');
//  await printFiles(directory, 0);

  print('Classes Information');
  UnderStandProject underStandProject = UnderStandProject(directory);
  AnalysisContextCollection projectAnalysis = underStandProject.getAnalysis();
//  underStandProject.analyzeAllFiles(projectAnalysis);
  List<Widget> widgets =
      await printFiles(directory, 0, projectAnalysis, underStandProject);
  print(widgets);
  PDFGenerator(widgets).generate();
}

Future<List<Widget>> printFiles(
    Directory directory,
    int dash,
    AnalysisContextCollection projectAnalysis,
    UnderStandProject underStandProject) async {
  List<Widget> widgets = [];
  List<FileSystemEntity> entities = directory.listSync();

  for (FileSystemEntity entity in entities) {
    FileStat stat = await entity.stat();

    print(
        '${(stat.type == FileSystemEntityType.directory) ? '|' : '|'}${'-' * dash * 2} ${entity.path.split("\\").last}');

    if (stat.type == FileSystemEntityType.directory) {
      widgets.add(FolderBox(
          entity.path.split("\\").last,
          await printFiles(
              entity, dash + 1, projectAnalysis, underStandProject)));
    } else {
      widgets.add(FileBox(entity.path.split("\\").last));
    }
  }
  return widgets;
}

class UnderStandProject {
  String mainFolder = 'lib';
  Directory directory;

  UnderStandProject(this.directory);

  String getPath() {
    return directory.path;
  }

  AnalysisContextCollection getAnalysis() {
    AnalysisContextCollection collection =
        AnalysisContextCollection(includedPaths: [directory.absolute.path]);
    return collection;
  }

  void analyzeAllFiles(AnalysisContextCollection collection) async {
    for (AnalysisContext context in collection.contexts) {
      for (String path in context.contextRoot.analyzedFiles()) {
        await analyzeSingleFile(context, path);
      }
    }
  }

  Future<void> analyzeSingleFile(AnalysisContext context, String path) async {
    AnalysisSession session = context.currentSession;

    UnitElementResult result = await session.getUnitElement(path);
    CompilationUnitElement element = result.element;
    printMembers(element);
  }

  void printMembers(CompilationUnitElement unitElement) {
    for (ClassElement classElement in unitElement.types) {
//      classElement.visitChildren(ParameterCounter());
      int field = 0;
      int constructors = 0;
      int property = 0;
      int method = 0;
//      print('class: ${classElement.name}');
      for (ConstructorElement constructorElement in classElement.constructors) {
        if (!constructorElement.isSynthetic) {
//          if (constructorElement.name == null) {
//            print('constructor without name  ${constructorElement.name}');
//          } else {
//            print(
//                'constructor with name:  ${classElement.name}.${constructorElement.name}');
//          }

//          print(
//              '   constructor  ${classElement.name}${constructorElement.name.trim().isNotEmpty ? '.' : ''}${constructorElement.name}()');
          constructors++;
        }
      }
      for (FieldElement fieldElement in classElement.fields) {
        if (!fieldElement.isSynthetic) {
//          print('   field:  ${fieldElement.name}');
          field++;
        }
      }
      for (PropertyAccessorElement accessorElement in classElement.accessors) {
        if (!accessorElement.isSynthetic) {
//          print('   property:  ${accessorElement.name}');
          property++;
        }
      }
      for (MethodElement methodElement in classElement.methods) {
        if (!methodElement.isSynthetic) {
//          print('   method:  ${methodElement.name}');
          method++;
        }
      }
      print(
          ' ${classElement.name} [ Fields: $field, Constructors: $constructors, Methods: $method Property:$property]');
    }
  }

  void analyzeSingleFile1(AnalysisSession session, String path) async {
    UnitElementResult result = await session.getUnitElement(path);
    CompilationUnitElement element = result.element;
    print(element);
  }
}

class ParameterCounter extends GeneralizingElementVisitor<void> {
  int maxParameterCount = 0;

  @override
  void visitExecutableElement(ExecutableElement element) {
    maxParameterCount = math.max(maxParameterCount, element.parameters.length);
    print(' max count:  $maxParameterCount');
    print('current: ${element.name} ${element.parameters}');
    super.visitExecutableElement(element);
  }
}
