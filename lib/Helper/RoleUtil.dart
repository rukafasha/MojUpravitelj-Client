class RoleUtil {
  static var data;

  RoleUtil(readData) {
    data = readData;
  }

  static dynamic GetData() {
    return data;
  }

  static void DeleteDataFromBox() {
    data = null;
  }

  static bool HasRole(role) {
    for (var i = 0; i < data["roles"].length; i++) {
      if (data["roles"][i] == role) {
        return true;
      }
    }
    return false;
  }
}
