import 'dart:io';

import 'package:pdf/widgets.dart';

import 'widgets/file_box_widget.dart';
import 'widgets/folder_box_widget.dart';

class PDFGenerator {
  List<Widget> widgets;

  PDFGenerator(this.widgets);

  Future<File> generate() async {
    final doc = Document();
    for (int i = 0; i < widgets.length; i++) {
      Widget widget = widgets[i];
      if (widget is FileBox)
        doc.addPage(MultiPage(build: (context) => [widget]));
      else
        doc.addPage(MultiPage(
            build: (Context context) {
              return[ widget, getFolderWidget(widget)];
            },
            orientation: PageOrientation.natural));
    }

    final file = File('structure.pdf');
    await file.writeAsBytes(doc.save());
    return file;
  }

  Widget getFolderWidget(FolderBox folderBox) {
    return Padding(
        padding: EdgeInsets.all(0),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: List<Widget>.generate(folderBox.widgets.length, (index) {
              Widget widget = folderBox.widgets[index];
              if (widget is FolderBox) {
                return getFolderWidget(widget);
              } else
                return getFileWidget(widget);
            })));
  }

  Widget getFileWidget(FileBox widget) => widget;
}
