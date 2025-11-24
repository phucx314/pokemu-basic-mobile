class QueryRequest {
  final int currentPage;
  final int pageSize;   
  final String sortBy;
  final String direction;

  QueryRequest({
    required this.currentPage,
    required this.pageSize,
    required this.sortBy,
    required this.direction,
  });

  factory QueryRequest.fromJson(Map<String, dynamic> json) {
    return QueryRequest(currentPage: json['currentPage'], pageSize: json['pageSize'], sortBy: json['sortBy'], direction: json['direction']);
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'pageSize': pageSize,
      'sortBy': sortBy,
      'direction': direction,
    };
  }
}