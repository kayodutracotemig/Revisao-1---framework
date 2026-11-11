import 'package:flutter_test/flutter_test.dart';

import '../lib/models/material_evento.dart';
import '../lib/utils/validadores.dart';

void main() {
  // Confere que os campos textuais exigem conteúdo além de espaços.
  group('Validadores.textoObrigatorio', () {
    test('recusa valores nulos, vazios e formados por espaços', () {
      expect(Validadores.textoObrigatorio(null), isNotNull);
      expect(Validadores.textoObrigatorio(''), isNotNull);
      expect(Validadores.textoObrigatorio('   '), isNotNull);
    });

    test('aceita texto preenchido', () {
      expect(Validadores.textoObrigatorio(' Microfone '), isNull);
    });
  });

  // Exercita inteiros válidos e entradas inválidas sem convertê-las para zero.
  group('Validadores.quantidade', () {
    test('aceita zero e inteiros positivos', () {
      expect(Validadores.quantidade('0'), isNull);
      expect(Validadores.quantidade('12'), isNull);
    });

    test('recusa campos vazios, letras, negativos e decimais', () {
      for (final valor in [null, '', '   ', 'abc', '-1', '1.5']) {
        expect(Validadores.quantidade(valor), isNotNull, reason: 'Valor: $valor');
      }
    });
  });

  // Garante as três classificações e o caso-limite de estoque/mínimo zerados.
  group('MaterialEvento.situacao', () {
    String situacao(int quantidade, int minimo) => MaterialEvento(
      nome: 'Material de teste',
      categoria: 'Teste',
      quantidade: quantidade,
      minimo: minimo,
    ).situacao;

    test('zero é sempre sem estoque, inclusive com mínimo zero', () {
      expect(situacao(0, 0), 'Sem estoque');
      expect(situacao(0, 3), 'Sem estoque');
    });

    test('distingue abaixo do mínimo e mínimo atendido', () {
      expect(situacao(2, 3), 'Estoque baixo');
      expect(situacao(3, 3), 'Estoque adequado');
      expect(situacao(4, 3), 'Estoque adequado');
    });
  });
}
