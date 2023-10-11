import 'package:equatable/equatable.dart';

class PaginationModel extends Equatable {
  final int? total;
  final int? count;
  final int? perPage; // Defaults to 10
  final int? currentPage; // Starts from 1
  final int? totalPages;

  const PaginationModel({
    this.total,
    this.count,
    this.perPage,
    this.currentPage,
    this.totalPages,
  });

  bool get isLast =>
      currentPage == null || totalPages == null || currentPage == totalPages;

  @override
  List<Object?> get props => [
        total,
        count,
        perPage,
        currentPage,
        totalPages,
      ];
}

class MetadataModel extends Equatable {
  final PaginationModel? pagination;

  const MetadataModel({
    required this.pagination,
  });

  @override
  List<Object?> get props => [
        pagination,
      ];
}
