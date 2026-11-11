class Validadores {
  static String? textoObrigatorio(String? valor) {
    // Remove espaços externos antes de validar para rejeitar texto vazio ou só com espaços.
    if (valor == null || valor.trim().isEmpty) {
      return 'Preencha este campo.';
    }
    return null;
  }

  static String? quantidade(String? valor) {
    // tryParse aceita apenas a representação inteira e a comparação recusa negativos.
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe uma quantidade inteira maior ou igual a zero.';
    }
    final numero = int.tryParse(valor.trim());
    if (numero == null || numero < 0) {
      return 'Informe um número inteiro maior ou igual a zero.';
    }
    return null;
  }
}
