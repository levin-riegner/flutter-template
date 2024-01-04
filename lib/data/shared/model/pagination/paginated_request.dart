import 'package:equatable/equatable.dart';

class PaginatedRequest extends Equatable {
  static const int initialPage = 1;
  static const int defaultPerPage = 10;

  final int page;
  final int perPage;

  const PaginatedRequest({
    this.page = initialPage,
    this.perPage = defaultPerPage,
  });

  @override
  List<Object?> get props => [
        page,
        perPage,
      ];
}
