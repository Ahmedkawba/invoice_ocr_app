import 'package:flutter/material.dart';
import 'package:invoice_ocr_app/core/models/invoice_model.dart';

import '../../../../../core/app/routes.dart';

class CustomInvoicesItem extends StatelessWidget {
  const CustomInvoicesItem({super.key, required this.invoice});

  final InvoiceModel invoice;

  @override
  Widget build(BuildContext context) {
    final createdAt = DateTime.parse(invoice.createdAt ?? '');
    final formattedDate =
        "${createdAt.day}-${createdAt.month}-${createdAt.year}";
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.referenceInvoice,
          arguments: {
            'deltaJson': invoice.richContent,
            'isReadOnly': true,
            'title': invoice.title,
          },
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  invoice.title ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  formattedDate ?? '',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                ),
              ],
            ),
            SizedBox(width: 15),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.inventory_outlined,
                size: 30,
                color: Color(0xFF00B2CA),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
