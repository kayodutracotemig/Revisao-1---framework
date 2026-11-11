import '../models/material_evento.dart';
import '../services/database_service.dart';

// Somente esta classe consulta ou altera os registros da tabela materiais.
class MaterialRepository {
  final DatabaseService service;
  MaterialRepository(this.service);

  // A leitura já está pronta: o app abre mostrando os quatro materiais iniciais.
  Future<List<MaterialEvento>> listar() async {
    final db = await service.database;
    final linhas = await db.query('materiais', orderBy: 'nome COLLATE NOCASE');
    return linhas.map((linha) => MaterialEvento.fromMap(linha)).toList();
  }

  Future<bool> existeNome(String nome, {int? ignorarId}) async {
    // Usa a mesma normalização do modelo e pode ignorar o próprio registro em edição.
    final db = await service.database;
    final nomeNormalizado = nome.trim().toLowerCase();
    final linhas = await db.query(
      'materiais',
      columns: ['id'],
      where: ignorarId == null
          ? 'nome_normalizado = ?'
          : 'nome_normalizado = ? AND id != ?',
      whereArgs: ignorarId == null ? [nomeNormalizado] : [nomeNormalizado, ignorarId],
      limit: 1,
    );
    return linhas.isNotEmpty;
  }

  Future<void> inserir(MaterialEvento material) async {
    // Persiste os campos pelo mapa do modelo; o banco gera o ID automaticamente.
    final db = await service.database;
    await db.insert('materiais', material.toMap());
  }

  Future<void> atualizar(MaterialEvento material) async {
    // Requer um ID para garantir que somente o material selecionado seja alterado.
    final id = material.id;
    if (id == null) throw ArgumentError('O material precisa ter um ID para ser atualizado.');
    final db = await service.database;
    final dados = material.toMap()..remove('id');
    await db.update('materiais', dados, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> excluir(int id) async {
    // Filtra pelo ID recebido para preservar todos os outros materiais.
    final db = await service.database;
    await db.delete('materiais', where: 'id = ?', whereArgs: [id]);
  }
}
