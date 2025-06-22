class InvoiceModel {
  String? id;
  String? title;
  String? invoicetext;
  dynamic richContent;

  InvoiceModel({this.id, this.title, this.invoicetext, this.richContent});

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'],
      title: json['title'],
      invoicetext: json['invoice_text'],
      richContent: json['rich_content'],
    );
  }

  Map<String, dynamic> toJson() => {
    // 'id': id,
    'title': title,
    'invoice_text': invoicetext,
    'rich_content': richContent,
  };
}
