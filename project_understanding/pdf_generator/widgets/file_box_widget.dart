import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class FileBox extends StatelessWidget {
  String fileName;

  FileBox(this.fileName);

  @override
  Widget build(Context context) {
    return Container(
//        color: PdfColors.black,
        decoration: BoxDecoration(
            border: BoxBorder(
                color: PdfColors.blue,
                width: 3,
                left: true,
                bottom: true,
                top: true,
                right: true,
                style: BorderStyle.dashed)),
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Text(
          fileName,
        ));
  }
}
