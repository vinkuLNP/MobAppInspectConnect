


class FetchBookingEntity {
  final String? page;
  final String? perPageLimit;
  final String? search;
  final String? sortBy;
  final String? sortOrder;
  final int? status;

  const FetchBookingEntity({
     this.page,
     this.perPageLimit,
     this.search,
     this.sortBy,
     this.sortOrder,
     this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      "page": page,
      "perPageLimit": perPageLimit,
      "search": search,
      "sortBy": sortBy, 
      "sortOrder": sortOrder,
      "status": status,
    };
  }
}