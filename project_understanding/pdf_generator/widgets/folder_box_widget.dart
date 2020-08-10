import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class FolderBox extends StatelessWidget {
  String folderName;
  List<Widget> widgets;

  FolderBox(this.folderName, this.widgets);

  @override
  Widget build(Context context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 20, width: 5, color: PdfColors.black),
          Container(
              decoration: BoxDecoration(
                  border: BoxBorder(
                      color: PdfColors.blue,
                      width: 3,
                      left: true,
                      bottom: true,
                      top: true,
                      right: true,
                      style: BorderStyle.dotted)),
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Text(folderName))
        ]);
  }

  @override
  String toString() {
    return '$folderName , ${widgets.length}';
  }
}
