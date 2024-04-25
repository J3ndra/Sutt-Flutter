class ReportEntity {
  String reportId;
  String category;
  String city;
  String kw;
  List<String>? images;
  List<String>? tools;
  List<int>? toolsQuantity;
  DateTime reportDate;
  List<String>? ginsets;
  List<String>? bays;

  ReportEntity({
    required this.reportId,
    required this.category,
    required this.city,
    required this.kw,
    required this.images,
    required this.tools,
    required this.toolsQuantity,
    required this.reportDate,
    required this.ginsets,
    required this.bays,
  });

  Map<String, Object?> toDocument() {
    return {
      'reportId': reportId,
      'category': category,
      'city': city,
      'kw': kw,
      'images': images,
      'tools': tools,
      'toolsQuantity': toolsQuantity,
      'reportDate': reportDate,
      'ginsets': ginsets,
      'bays': bays,
    };
  }

  static ReportEntity fromDocument(Map<String, dynamic> document) {
    return ReportEntity(
      reportId: document['reportId'] as String,
      category: document['category'] as String,
      city: document['city'] as String,
      kw: document['kw'] as String,
      images: (document['images'] as List?)?.map((e) => e as String).toList(),
      tools: (document['tools'] as List?)?.map((e) => e as String).toList(),
      toolsQuantity: (document['toolsQuantity'] as List?)?.map((e) => e as int).toList(),
      reportDate: document['reportDate'].toDate(),
      ginsets: (document['ginsets'] as List?)?.map((e) => e as String).toList(),
      bays: (document['bays'] as List?)?.map((e) => e as String).toList(),
    );
  }

  List<Object?> get props => [
        reportId,
        category,
        city,
        kw,
        images,
        tools,
        toolsQuantity,
        reportDate,
        ginsets,
        bays,
      ];

  @override
  String toString() {
    return ''''ReportEntity {
      reportId: $reportId
      category: $category
      city: $city
      kw: $kw
      images: $images
      tools: $tools
      toolsQuantity: $toolsQuantity
      reportDate: $reportDate
      ginsets: $ginsets
      bays: $bays
    }''';
  }
}
