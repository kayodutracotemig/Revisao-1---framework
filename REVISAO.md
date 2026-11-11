# Revisão 1

Nome:
Turma:

| Teste | Resultado esperado | Resultado encontrado |
|---|---|---|
| Nome vazio/espaços | Recusar com mensagem | Implementado e coberto pelos testes automatizados |
| Quantidade negativa | Recusar com mensagem | Implementado e coberto pelos testes automatizados |
| Quantidade decimal | Recusar com mensagem | Implementado e coberto pelos testes automatizados |
| Nome repetido com maiúsculas/espaços | Recusar duplicidade | Implementado por normalização; execução manual pendente |
| Edição mantendo o próprio nome | Permitir | Consulta ignora o ID editado; execução manual pendente |
| Edição para o nome de outro material | Recusar duplicidade | Implementado; execução manual pendente |
| Cadastro com atualização automática | Novo item aparece na lista | ViewModel recarrega após salvar; execução manual pendente |
| Edição persistida após recarregar | Alteração permanece | Atualização por ID no SQLite; execução manual pendente |
| Cancelamento da exclusão | Registro permanece | A tela mantém confirmação; fluxo não executado manualmente |
| Exclusão individual | Outros registros permanecem | Exclusão filtrada pelo ID; execução manual pendente |
| Quantidade zero e mínimo zero | “Sem estoque” | Implementado e coberto pelos testes automatizados |
| Quantidade igual ao mínimo | “Estoque adequado” | Implementado e coberto pelos testes automatizados |

## Explique uma validação

Qual validação foi escolhida? Validação de quantidades inteiras não negativas.

Em qual arquivo e método ela foi implementada? `lib/utils/validadores.dart`, método `Validadores.quantidade`.

Por que esse local é adequado para essa responsabilidade? A regra fica centralizada e pode ser reutilizada pela tela e pelo ViewModel antes da persistência; assim, entradas inválidas são recusadas com mensagem sem depender do banco de dados.

Observação: também foi encontrado um conflito de dependência: `flutter_test` requer `path ^1.9.1`, enquanto o projeto fixava `path 1.9.0`. Atualizei o `pubspec.yaml` e `flutter pub get` terminou com sucesso. O ZIP trazia `.dart_tool/package_config.json` com caminhos de macOS, agora recriado para Windows. `dart analyze lib test` passou sem problemas; `flutter test --no-pub` passou em seis testes e `flutter build web --no-pub` compilou o aplicativo. A compilação mostrou apenas um aviso não bloqueante sobre a fonte CupertinoIcons. Os fluxos completos da interface ainda devem ser executados no Chrome.
