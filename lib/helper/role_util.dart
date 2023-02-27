class RoleUtil {
  static var data;

  RoleUtil(readData) {
    data = readData;
  }

  static dynamic getData() {
    return data;
  }

  static void deleteDataFromBox() {
    data = null;
  }

  static bool hasRole(role) {
    for (var i = 0; i < data["roles"].length; i++) {
      if (data["roles"][i] == role) {
        return true;
      }
    }
    return false;
  }
}
