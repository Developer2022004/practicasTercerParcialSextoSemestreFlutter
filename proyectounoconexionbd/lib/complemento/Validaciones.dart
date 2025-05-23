class Validaciones {
  //Las siguientes validaciones actuan conforme a la estructura ascii
  //No obstante es fundamental llamarlas dentro del metodo de validacion de
  //los FormState

  String? validarLetrasNumeros(String cadena) {
    //Para iterar por cada uno de los caracteres de la cadena, se debe emplear la clase de nombre Runes
    //Con el atributo runes de String
    //NOTA Runes crea una coleccion, razon por la cual es fundamental implementar variables de tipo final
    final caracteres = cadena.runes;
    for (final caracter_ascii in caracteres) {
      if (!((caracter_ascii > 96 && caracter_ascii < 123) ||
          (caracter_ascii > 47 && caracter_ascii < 58))) {
        return "Solo se admiten letras minusculas y numeros";
      }
    }
    return null;
  }

  String? validarLetrasEspacio(String cadena) {
    final regex = RegExp(r'^[a-zA-Z]+\s?[a-z-A-Z]+$');
    if (!regex.hasMatch(cadena)) {
      return "Solo se admiten letras minusculas, mayusculas y espacios";
    }
    return null;
  }

  String? validarNumerosDecimal(String cadena) {
    final regex = RegExp(r'^([0-9]+)((\.){0,1}([0-9]){0,2})?$');
    if (!regex.hasMatch(cadena)) {
      return "Solo se admiten numeros decimales con dos decimales";
    }
    return null;
  }

  String? validarNumerosEnteros(String cadena) {
    final regex = RegExp(r'^[0-9]+$');
    if (!regex.hasMatch(cadena)) {
      return "Solo se admiten numeros enteros";
    }
    return null;
  }

  /*
    Otra version

    String? validarLetrasNumeros(String cadena) {
    for (final rune in cadena.runes) {
      final char = String.fromCharCode(rune);
      if (!(char.contains(RegExp(r'[a-z0-9]')))) {
        return "Solo se admiten letras minusculas y numeros";
     }
    }
    return null;

    Otra version

    String? validarLetrasNumeros(String cadena) {
    final regex = RegExp(r'^[a-z0-9]+$');
    if (!regex.hasMatch(cadena)) {
      return "Solo se admiten letras minusculas y numeros";
    }
    return null;
  */
}
