class InvoiceModel {
  String? id;
  String? title;
  String? invoicetext;
  dynamic richContent;
  String? createdAt;

  InvoiceModel({this.id, this.title, this.invoicetext, this.richContent, this.createdAt});

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'].toString(),
      title: json['title'],
      invoicetext: json['invoice_text'],
      richContent: json['rich_content'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() => {
    // 'id': id,
    'title': title,
    'invoice_text': invoicetext,
    'rich_content': richContent,
  };
}
