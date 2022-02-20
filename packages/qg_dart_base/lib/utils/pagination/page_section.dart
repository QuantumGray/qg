class PageSection<T> {
  final List<T> content;
  final bool last;
  final int? totalElements;

  const PageSection({
    required this.content,
    required this.last,
    this.totalElements,
  });

  factory PageSection.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) mapper,
  ) =>
      PageSection(
        content: List<Map<String, dynamic>>.from(json['content'] as List)
            .map(mapper)
            .toList(),
        last: json['last'] as bool? ?? true,
        totalElements: json['totalElements'] as int,
      );

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) mapper) =>
      <String, dynamic>{
        'content':
            List.generate(content.length, (index) => mapper(content[index])),
        'last': last,
        'totalElements': totalElements,
      };

  PageSection<T> copyWith({
    List<T>? content,
    bool? last,
    int? totalElements,
  }) =>
      PageSection<T>(
        content: content ?? this.content,
        last: last ?? this.last,
        totalElements: totalElements ?? this.totalElements,
      );

  @override
  int get hashCode => content.hashCode ^ last.hashCode ^ totalElements.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(other, this) ||
      other is PageSection &&
          other.totalElements == totalElements &&
          other.last == last &&
          other.content == content;
}
