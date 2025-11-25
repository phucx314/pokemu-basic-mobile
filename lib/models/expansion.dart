import 'package:pokemu_basic_mobile/models/common/query_request.dart';

class ExpansionOptions {
  final int id;
  final String expansionName;
  final String expansionCode;
  final String expansionImage;

  ExpansionOptions({required this.id, required this.expansionName, required this.expansionCode, required this.expansionImage});

  factory ExpansionOptions.fromJson(Map<String, dynamic> json) {
    return ExpansionOptions(id: json['id'], expansionName: json['expansionName'], expansionCode: json['expansionCode'], expansionImage: json['expansionImage']);
  }
}

class ExpansionOptionsQueryParams extends QueryRequest {
  final String? searchKey;

  ExpansionOptionsQueryParams({
    this.searchKey,
    super.currentPage,
    super.pageSize,
    super.sortBy,
    super.direction,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson(); // lấy map từ class cha query request

    if (searchKey != null && searchKey!.isNotEmpty) {
      data['searchKey'] = searchKey;
    }

    return data;
  }

  // helper copyWith (tiện cho phân trang)
  ExpansionOptionsQueryParams copyWith({
    String? searchKey,
    int? currentPage,
    int? pageSize,
    String? sortBy,
    String? direction,
  }) {
    return ExpansionOptionsQueryParams(
      searchKey: searchKey ?? this.searchKey,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      sortBy: sortBy ?? this.sortBy,
      direction: direction ?? this.direction,
    );
  }
}
