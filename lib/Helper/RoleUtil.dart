class RoleUtil{

static bool HasRole(role){
  for(i in localStorage.roles){
    if(localStorage.roles[i] == role) {
      return true;
    }
  }
  return false;
}
}