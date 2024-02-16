import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageServices extends GetxController {
  final storage = GetStorage();

  saveClientCredentials({
    required String id,
    required String contactno,
    required String email,
    required String name,
    required String type,
    required String provider,
    required String profilePicture,
  }) {
    storage.write("id", id);
    storage.write("contactno", contactno);
    storage.write("name", name);
    storage.write("email", email);
    storage.write("type", type);
    storage.write("provider", provider);
    storage.write("profilePicture", profilePicture);
  }

  removeStorageCredentials() {
    storage.remove("id");
    storage.remove("contactno");
    storage.remove("email");
    storage.remove("type");
    storage.remove("provider");
    storage.remove("name");
    storage.remove("profilePicture");
  }
}
