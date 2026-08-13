import 'package:color_picker/data/corrector/model/correction.dart';
import 'package:color_picker/data/corrector/service/local/corrector_service.dart';

/// Thin data-layer facade around the on-device [CorrectorService].
///
/// Kept as a separate Repository (per project convention) so the rest of the
/// feature depends on this interface rather than the service directly.
class CorrectorRepository {
  final CorrectorService _service;

  CorrectorRepository(this._service);

  Future<Correction> correct(String content) => _service.correct(content);
}
