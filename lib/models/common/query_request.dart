class QueryRequest {
  final int? currentPage;
  final int? pageSize;   
  final String? sortBy;
  final String? direction;

  QueryRequest({
    this.currentPage,
    this.pageSize,
    this.sortBy,
    this.direction,
  });

  factory QueryRequest.fromJson(Map<String, dynamic> json) {
    return QueryRequest(currentPage: json['currentPage'], pageSize: json['pageSize'], sortBy: json['sortBy'], direction: json['direction']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {}; // defalut ko gửi req params j

    // chỉ gửi những j khác null
    if (currentPage != null) data['currentPage'] = currentPage;
    if (pageSize != null) data['pageSize'] = pageSize;
    if (sortBy != null) data['sortBy'] = sortBy;
    if (direction != null) data['direction'] = direction;

    return data;
  }
}