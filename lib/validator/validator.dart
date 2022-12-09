class Validator {
  static String? emailValidate(String? value) {
    if (value!.isEmpty) {
      return "Email tidak boleh kosong";
    }
    if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(value)) {
      return "Masukan email dengan benar";
    }
    return null;
  }

  static String? passwordValidate(String? value) {
    if (value!.isEmpty) {
      return "Password tidak boleh kosong";
    }
    if (value.length < 6) {
      return "Password kurang dari 8";
    }
    return null;
  }

  static String? formKsosng(String? value) {
    if (value!.isEmpty) {
      return "Form ini tidak boleh kosong";
    }
  }
}
