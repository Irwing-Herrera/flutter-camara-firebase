bool isNumeric(String valor) {
  if (valor.isEmpty) return false;
  final numero = num.tryParse(valor);
  return (numero == null) ? false : true;
}