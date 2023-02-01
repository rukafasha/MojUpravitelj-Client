
class RoleUtil{
static var data;

  RoleUtil(readData){data = readData;}

static dynamic GetData(){
  return data;
}

static bool HasRole(role){
  var i;
  for(i in data["roles"]){
    if(data["roles"][i] == role) {
      return true;
    }
  }
  return false;
}
}