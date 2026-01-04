import 'package:get/get.dart';
import 'package:mochi/app/data/models/mochi_model.dart';

class FavoriteController extends GetxController {
  // simpan ID saja (ringan & aman)
  final RxSet<String> _favoriteIds = <String>{}.obs;

  bool isFavorite(String id) {
    return _favoriteIds.contains(id);
  }

  void toggleFavorite(MochiModel mochi) {
    if (_favoriteIds.contains(mochi.id)) {
      _favoriteIds.remove(mochi.id);
    } else {
      _favoriteIds.add(mochi.id);
    }
  }

  List<MochiModel> filterFavorites(List<MochiModel> all) {
    return all.where((m) => _favoriteIds.contains(m.id)).toList();
  }
}
