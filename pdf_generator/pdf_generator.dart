import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class Product {
  const Product(
    this.sku,
    this.productName,
    this.price,
    this.quantity,
  );

  final String sku;
  final String productName;
  final double price;
  final int quantity;

  double get total => price * quantity;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return sku;
      case 1:
        return productName;
      case 2:
        return price != -1 ? price.toString() : '';
      case 3:
        return quantity != -1 ? quantity.toString() : '';
      case 4:
        return price.toString();
    }
    return '';
  }
}

void main() {
  final doc = pw.Document();
  const tableHeaders = ['ITEM NAME', 'QUANTITY', 'PRICE', 'PRICE SUB TOTAL'];

  final products = <Product>[
    Product('Tank Bag', '1', 3500, 3500),
    Product('Gloves', '2', 1250, 1250),
    Product('Misc charges', '', -1, 20)
  ];
  final finalCharge = <Product>[
    Product('', '2', -1, 4770),
  ];

  doc.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Column(children: [
        pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(height: 64, width: 64, color: PdfColors.black),
                    pw.SizedBox(height: 24),
                    pw.Text('Customer',
                        style: pw.TextStyle(
                            color: PdfColors.grey500,
                            fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 8),
                    pw.Text('Rucha',
                        style: pw.TextStyle(color: PdfColors.black)),
                    pw.SizedBox(height: 8),
                    pw.Text('5, Swapnil CHS',
                        style: pw.TextStyle(color: PdfColors.black)),
                    pw.SizedBox(height: 8),
                    pw.Text('+919819892429',
                        style: pw.TextStyle(color: PdfColors.black)),
                  ]),
              pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('ORDER #',
                        style: pw.TextStyle(
                            color: PdfColors.grey500,
                            fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 8),
                    pw.Text('8824262',
                        style: pw.TextStyle(color: PdfColors.black)),
                    pw.SizedBox(height: 24),
                    pw.Text('DATE',
                        style: pw.TextStyle(color: PdfColors.grey500)),
                    pw.SizedBox(height: 8),
                    pw.Text('July 31, 2020 23:02',
                        style: pw.TextStyle(color: PdfColors.black)),
                    pw.SizedBox(height: 24),
                    pw.Text('BUSINESS',
                        style: pw.TextStyle(
                            color: PdfColors.grey500,
                            fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 8),
                    pw.Text('Garrage',
                        style: pw.TextStyle(
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 8),
                    pw.Text('+919819892429',
                        style: pw.TextStyle(color: PdfColors.black)),
                  ])
            ]),
        pw.SizedBox(height: 24),
        pw.Table.fromTextArray(
          headerDecoration: pw.BoxDecoration(
            borderRadius: 2,
          ),
          headerHeight: 25,
          cellHeight: 40,
          headerAlignment: pw.Alignment.centerLeft,
          cellAlignment: pw.Alignment.centerLeft,
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerLeft,
            3: pw.Alignment.centerRight
          },


          headerStyle: pw.TextStyle(
            color: PdfColors.cyan,
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
          ),
          cellStyle: const pw.TextStyle(
            color: PdfColors.black,
            fontSize: 10,
          ),
          headers: List<String>.generate(
            tableHeaders.length,
            (col) => tableHeaders[col],
          ),
          data: List<List<String>>.generate(
            products.length,
            (row) => List<String>.generate(
              tableHeaders.length,
              (col) => products[row].getIndex(col),
            ),
          ),
          border: pw.TableBorder(
              right: false,
              top: false,
              left: false,
              bottom: false,
              color: PdfColors.cyan,
              verticalInside: false,
              width: 3),
        ),
        pw.Container(width: double.infinity, height: 3, color: PdfColors.cyan),
        pw.Table.fromTextArray(
            cellHeight: 40,
            cellAlignment: pw.Alignment.centerLeft,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerRight,
              2: pw.Alignment.centerRight,
              3: pw.Alignment.centerRight
            },
            cellStyle: const pw.TextStyle(
              color: PdfColors.black,
              fontSize: 10,
            ),
            border: pw.TableBorder(
                right: false,
                top: false,
                left: false,
                bottom: false,
                verticalInside: false,
                horizontalInside: false,
                width: 3),
            columnWidths: {
              0: FlexColumnWidth(1.3),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(4),
            },
            data: List<List<String>>.generate(
              finalCharge.length,
              (row) => List<String>.generate(
                tableHeaders.length,
                (col) => finalCharge[row].getIndex(col),
              ),
            ))
      ]),
    ),
  );

  final file = File('sync_invoice.pdf');
  file.writeAsBytesSync(doc.save());
}
