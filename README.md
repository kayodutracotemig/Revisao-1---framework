# Central de Materiais — Revisão 1

Projeto Flutter com SQLite para cadastrar e administrar materiais de eventos.

## O que foi corrigido

0. **Dependências do projeto:** o ZIP incluía `.dart_tool/package_config.json` com caminhos absolutos de um computador macOS, inválidos no Windows. Além disso, `pubspec.yaml` fixava `path` em `1.9.0`, mas o `flutter_test` da versão de Flutter instalada exige `path ^1.9.1`. Atualizei a restrição e rodei `flutter pub get` com sucesso, recriando a configuração local para Windows.
1. **Campos obrigatórios:** `Validadores.textoObrigatorio`, em `lib/utils/validadores.dart`, agora rejeita `null`, texto vazio e texto que contém apenas espaços. A mensagem orienta o usuário a preencher o campo. O `trim()` também evita salvar espaços externos.
2. **Quantidades:** `Validadores.quantidade`, no mesmo arquivo, rejeita campo vazio, letras, números negativos e decimais. `int.tryParse` aceita somente inteiros; valores inválidos recebem uma mensagem explicativa em vez de serem convertidos para zero.
3. **Situação do estoque:** o getter `situacao`, em `lib/models/material_evento.dart`, testa quantidade zero primeiro. Depois distingue estoque abaixo do mínimo e estoque adequado. Assim, quantidade zero e mínimo zero resulta em “Sem estoque”.
4. **Nome repetido:** `MaterialRepository.existeNome`, em `lib/repositories/material_repository.dart`, consulta `nome_normalizado`, que é calculado removendo espaços externos e convertendo para minúsculas. Na edição, a consulta ignora o ID do próprio material; um nome já usado por outro registro continua bloqueado.
5. **Cadastro:** `MaterialRepository.inserir` grava `material.toMap()` na tabela SQLite.
6. **Edição:** `MaterialRepository.atualizar` exige o ID do material e usa `where: 'id = ?'`, atualizando apenas aquele registro.
7. **Exclusão:** `MaterialRepository.excluir` filtra pelo ID recebido, preservando os demais registros. A confirmação e o cancelamento continuam sob responsabilidade da interface já existente.
8. **Atualização da lista:** após inserir ou atualizar, `MaterialViewModel.salvar` recarrega os dados do SQLite e notifica a interface. Por isso, o novo material aparece na lista e a edição persiste após recarregar.

## Por que validar em `Validadores`

A validação de formato e conteúdo fica em `lib/utils/validadores.dart`, nos métodos `textoObrigatorio` e `quantidade`. É adequado porque são regras reutilizáveis e independentes da tela e do banco. A página pode exibir as mensagens e o ViewModel também executa essas regras antes de salvar, inclusive se a operação for chamada fora da interface.

## Resultados conferidos

| Cenário | Resultado esperado / conferido no código |
|---|---|
| Nome formado só por espaços | Recusado com mensagem de campo obrigatório |
| Quantidade negativa | Recusada |
| Quantidade decimal | Recusada por não ser inteiro |
| Nome repetido com maiúsculas/espaços | Considerado duplicado após normalização |
| Edição mantendo o próprio nome | Permitida, pois o ID atual é ignorado |
| Edição para nome de outro material | Recusada pelo ViewModel após consulta de duplicidade |
| Cadastro e atualização automática da lista | Repositório grava; ViewModel recarrega a lista após salvar |
| Edição persistida após recarregar | Alteração é gravada no SQLite por ID |
| Cancelamento da exclusão | A confirmação existente não chama o método de exclusão quando cancelada |
| Exclusão individual | SQL remove apenas a linha com o ID selecionado |
| Quantidade zero e mínimo zero | “Sem estoque” |
| Quantidade abaixo do mínimo e maior que zero | “Estoque baixo” |
| Quantidade igual ao mínimo | “Estoque adequado” |

**Conferência automatizada:** `flutter pub get` terminou com sucesso; `dart analyze lib test` informou `No issues found!`; `flutter test --no-pub` passou em seis verificações de validação e situação do estoque; `flutter build web --no-pub` compilou o aplicativo. O ZIP continha um arquivo de teste vazio, que fazia `flutter test` falhar por não encontrar `main`; substituí por testes úteis. O comando `flutter analyze` apresentou uma falha interna do servidor LSP neste ambiente, então usei `dart analyze` para a análise estática. A compilação web imprimiu um aviso não bloqueante sobre a fonte CupertinoIcons. Os fluxos de cadastro, edição e exclusão ainda devem ser conferidos no Chrome.

## Executar no Chrome

Na pasta que contém `pubspec.yaml`, execute um comando por vez:

```sh
flutter pub get
flutter run -d chrome --web-port=8080
```

A pasta `web` já inclui `sqlite3.wasm` e `sqflite_sw.js`.
