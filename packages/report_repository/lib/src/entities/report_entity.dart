class ReportEntity {
  String reportId;
  String city;
  String kw;
  List<String>? images;
  List<String>? tools;
  DateTime reportDate;
  List<String>? ginsets;
  List<String>? bays;

  ReportEntity({
    required this.reportId,
    required this.city,
    required this.kw,
    required this.images,
    required this.tools,
    required this.reportDate,
    required this.ginsets,
    required this.bays,
  });

  Map<String, Object?> toDocument() {
    return {
      'reportId': reportId,
      'city': city,
      'kw': kw,
      'images': images,
      'tools': tools,
      'reportDate': reportDate,
      'ginsets': ginsets,
      'bays': bays,
    };
  }

  static ReportEntity fromDocument(Map<String, dynamic> document) {
    return ReportEntity(
      reportId: document['reportId'] as String,
      city: document['city'] as String,
      kw: document['kw'] as String,
      images: (document['images'] as List?)?.map((e) => e as String).toList(),
      tools: (document['tools'] as List?)?.map((e) => e as String).toList(),
      reportDate: document['reportDate'].toDate(),
      ginsets: (document['ginsets'] as List?)?.map((e) => e as String).toList(),
      bays: (document['bays'] as List?)?.map((e) => e as String).toList(),
    );
  }

  @override
  List<Object?> get props => [
        reportId,
        city,
        kw,
        images,
        tools,
        reportDate,
        ginsets,
        bays,
      ];

  @override
  String toString() {
    return ''''ReportEntity {
      reportId: $reportId
      city: $city
      kw: $kw
      images: $images
      tools: $tools
      reportDate: $reportDate
      ginsets: $ginsets
      bays: $bays
    }''';
  }
}
