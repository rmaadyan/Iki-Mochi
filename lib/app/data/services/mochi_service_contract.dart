abstract class MochiServiceContract {
  Future<List<Map<String, dynamic>>> fetchPopular();
  Future<List<Map<String, dynamic>>> fetchSpecials();
}
