import 'package:report_repository/src/entities/entities.dart';

class Report {
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

  Report({
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

  static final empty = Report(
    reportId: '',
    category: '',
    city: '',
    kw: '',
    images: [],
    tools: [],
    toolsQuantity: [],
    reportDate: DateTime.now(),
    ginsets: [],
    bays: [],
  );

  Report copyWith({
    String? reportId,
    String? category,
    String? city,
    String? kw,
    List<String>? images,
    List<String>? tools,
    List<int>? toolsQuantity,
    DateTime? reportDate,
    List<String>? ginsets,
    List<String>? bays,
  }) {
    return Report(
      reportId: reportId ?? this.reportId,
      category: category ?? this.category,
      city: city ?? this.city,
      kw: kw ?? this.kw,
      images: images ?? this.images,
      tools: tools ?? this.tools,
      toolsQuantity: toolsQuantity ?? this.toolsQuantity,
      reportDate: reportDate ?? this.reportDate,
      ginsets: ginsets ?? this.ginsets,
      bays: bays ?? this.bays,
    );
  }

  /// Convenience getter to determine whether the current report is empty.
  bool get isEmpty => this == Report.empty;

  /// Convenience getter to determine whether the current report is not empty.
  bool get isNotEmpty => this != Report.empty;

  ReportEntity toEntity() {
    return ReportEntity(
      reportId: reportId,
      category: category,
      city: city,
      kw: kw,
      images: images,
      tools: tools,
      toolsQuantity: toolsQuantity,
      reportDate: reportDate,
      ginsets: ginsets,
      bays: bays,
    );
  }

  static Report fromEntity(ReportEntity entity) {
    return Report(
      reportId: entity.reportId,
      category: entity.category,
      city: entity.city,
      kw: entity.kw,
      images: entity.images,
      tools: entity.tools,
      toolsQuantity: entity.toolsQuantity,
      reportDate: entity.reportDate,
      ginsets: entity.ginsets,
      bays: entity.bays,
    );
  }

  @override
  String toString() {
    return '''Report {
      reportId: $reportId,
      category: $category,
      city: $city,
      kw: $kw,
      images: $images,
      tools: $tools,
      toolsQuantity: $toolsQuantity,
      reportDate: $reportDate,
      ginsets: $ginsets,
      bays: $bays,
    }''';
  }
}