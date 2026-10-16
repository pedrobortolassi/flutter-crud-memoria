# Registro de Testes e Evidências

Este documento registra a execução dos testes práticos de validação e verificação do CRUD em memória no Flutter, conforme os requisitos e roteiros do capítulo de estudo autônomo (Professor Clerivaldo Roccia).

---

## 1. Tabela T1 a T14 (`exemplo_secao6_produtos`)

| Caso | Procedimento | Resultado esperado | Resultado observado | Status |
|---|---|---|---|:---:|
| **T1** | Abrir o aplicativo pela primeira vez | Lista vazia e contagem zero | Exibida tela com texto *"Produtos cadastrados: 0"* e mensagem centralizada *"Nenhum produto cadastrado."* | ✅ Passou |
| **T2** | Salvar formulário com nome e preço vazios | Erros nos campos; formulário continua aberto | Os campos exibiram as mensagens *"Informe o nome."* e *"Informe o preço."*. A tela permaneceu aberta sem realizar pop. | ✅ Passou |
| **T3** | Nome apenas com espaços (`"   "`) e preço 10 | Nome rejeitado | `trim().isEmpty` identificou a ausência de caracteres válidos e exibiu *"Informe o nome."*. O cadastro não foi realizado. | ✅ Passou |
| **T4** | Nome "Mouse" e preço "abc" | Número inválido; sem cadastro | `converterPreco` retornou `null`; o validador exibiu *"Digite um número válido."*. Formulário permaneceu aberto. | ✅ Passou |
| **T5** | Nome "Mouse" e preço 0 ou -2 | Preço deve ser maior que zero | Exibida a mensagem *"O preço deve ser maior que zero."* para ambas as entradas (0 e -2). | ✅ Passou |
| **T6** | Nome "Mouse" e preço 12,50 | Produto na lista e quantidade um | A vírgula foi convertida em ponto decimal (`12.50`); produto listado como "Mouse", "R$ 12.50", e a contagem foi para 1. SnackBar de sucesso exibido. | ✅ Passou |
| **T7** | Cadastrar sem preencher descrição | Detalhes mostra *Sem descrição.* | Ao tocar no Card do produto na lista, a tela de detalhes exibiu o texto cinza/padrão *"Sem descrição."*. | ✅ Passou |
| **T8** | Editar "Mouse" para "Mouse USB" e salvar | Mesmo registro atualizado; quantidade continua um | **Antes:** 1 produto (`[Mouse]`, qtd: 1).<br>**Depois:** 1 produto (`[Mouse USB]`, qtd: 1).<br>O registro foi substituído no índice correspondente sem duplicar na lista. | ✅ Passou |
| **T9** | Editar nome e tocar em Cancelar | Nome original preservado | **Antes:** 1 produto (`[Mouse USB]`, qtd: 1).<br>**Ação:** Tentar alterar para "Mouse Gamer" e pressionar Cancelar.<br>**Depois:** 1 produto (`[Mouse USB]`, qtd: 1). `Navigator.pop(context)` retornou `null`, mantendo o registro intacto. | ✅ Passou |
| **T10** | Abrir cadastro e tocar em Cancelar | Nenhum registro acrescentado | O formulário fechou retornando `null`; a lista principal manteve a contagem e os itens exatamente como estavam. | ✅ Passou |
| **T11** | Tocar na lixeira (excluir) e Cancelar no diálogo | Lista e quantidade preservadas | O diálogo fechou com `false`; o método verificou `confirmou != true` e retornou sem chamar `removeAt()`. Item preservado. | ✅ Passou |
| **T12** | Confirmar exclusão do último produto | Lista vazia; quantidade zero; feedback | O diálogo retornou `true`; o item foi removido via `removeAt()`; a lista voltou para *"Produtos cadastrados: 0"* e exibiu o SnackBar *"Produto excluído."*. | ✅ Passou |
| **T13** | Cadastrar três produtos e editar o segundo | Somente o segundo registro alterado | **Antes:** 3 produtos (`[Mouse, Teclado, Monitor]`, qtd: 3).<br>**Ação:** Editar Teclado para "Teclado Mecânico".<br>**Depois:** 3 produtos (`[Mouse, Teclado Mecânico, Monitor]`, qtd: 3). Apenas o índice 1 foi atualizado. | ✅ Passou |
| **T14** | Usar NaN ou Infinity como preço | Número inválido; sem cadastro | `!preco.isFinite` identificou o valor não finito e exibiu *"Digite um número válido."*, impedindo o cadastro. | ✅ Passou |

---

## 2. Testes por Exercício (Exercícios 01 a 10)

| Ex. | Entrada / Ação | Resultado esperado | Resultado observado | Status |
|:---:|---|---|---|:---:|
| **01** | Campo de nome vazio | Mensagem de obrigatoriedade | Exibida mensagem *"Informe o nome."* | ✅ Passou |
| **01** | Dois espaços (`"  "`) | Mensagem de obrigatoriedade | `trim().isEmpty` rejeitou e exibiu *"Informe o nome."* | ✅ Passou |
| **01** | Nome com 2 caracteres (`"Al"`) | Mensagem de tamanho mínimo | Exibida mensagem *"O nome deve ter pelo menos três caracteres."* | ✅ Passou |
| **01** | Nome válido (`"Ana"`) | Aceitação e saudação | Validação aceita; exibida a saudação *"Olá, Ana!"* | ✅ Passou |
| **02** | Confirmar "Ana", apagar o nome e confirmar novamente | Erro no campo e saudação limpa | Validador apontou erro e `setState()` limpou a mensagem de saudação anterior | ✅ Passou |
| **02** | Provocar erro e tocar em Limpar | Campo, erro e saudação apagados | `controller.clear()` apagou texto, `reset()` removeu o erro visual e saudação foi zerada | ✅ Passou |
| **02** | Confirmar `"Al"` após saudação válida prévia | Saudação anterior desaparece | Saudação anterior foi apagada no `setState()`, não deixando mensagem inconsistente | ✅ Passou |
| **03** | Nome de produto com 2 caracteres | Validador de nome mínimo | Rejeitado no cadastro e na edição com a mensagem de mínimo de 3 caracteres | ✅ Passou |
| **03** | Descrição vazia | Campo opcional aceito | Cadastro aceito normalmente; detalhes exibe *"Sem descrição."* | ✅ Passou |
| **03** | Descrição com 120 caracteres | Permitido (limite máximo) | Campo aceitou e validou com sucesso | ✅ Passou |
| **03** | Descrição com 121 caracteres | Rejeitada informando contagem | Exibiu: *"A descrição deve ter no máximo 120 caracteres (atual: 121)."* | ✅ Passou |
| **04** | Cadastrar "Mouse" a R$ 50; editar para "Teclado" a R$ 100 e descartar | Registro original preservado | "Mouse" a R$ 50.00 permaneceu inalterado na lista e nos detalhes | ✅ Passou |
| **04** | Abrir cadastro e pressionar Cancelar | Nenhum item criado | Cancelamento retornou `null`; lista principal não executou `add()` | ✅ Passou |
| **04** | Pedir exclusão e pressionar *Manter produto* | Item e contagem preservados | Diálogo retornou `false`; remoção não foi disparada | ✅ Passou |
| **05** | Quantidade vazia, `"abc"`, `"-1"` ou `"2.5"` | Entradas inválidas rejeitadas | `int.tryParse()` barrou decimais/letras e regra checou `>= 0` | ✅ Passou |
| **05** | Quantidade `"0"` | Valor zero aceito | Quantidade 0 aceita (permitida por ser maior ou igual a zero) | ✅ Passou |
| **05** | Cadastrar produto com 3 unidades e editar para 5 | Edição carrega valor e atualiza | Tela de edição abriu com 3 no controller e salvou com 5 na lista | ✅ Passou |
| **06** | Lista de produtos vazia | Total R$ 0.00 | Exibido *"Valor total do estoque: R$ 0.00"* | ✅ Passou |
| **06** | Produto A (10 × 3 = 30) e Produto B (20 × 2 = 40) | Total R$ 70.00 | Total somado percorrendo a lista: R$ 70.00 | ✅ Passou |
| **06** | Excluir Produto A | Total recalculado para R$ 40.00 | Recálculo automático acionado no `setState()`; total passou para R$ 40.00 | ✅ Passou |
| **07** | Cadastrar "Mouse" e "Teclado"; tentar cadastrar `"mouse"` | Rejeitar duplicidade insensível a maiúsculas | Exibida mensagem: *"Já existe um produto com este nome."* | ✅ Passou |
| **07** | Editar "Mouse" mantendo o próprio nome | Permitir salvar | Ao filtrar a lista de nomes existentes (`nomesExceto(produto.id)`), o próprio nome foi permitido | ✅ Passou |
| **07** | Tentar renomear "Teclado" para "Mouse" | Rejeitado mantendo digitação | Nome duplicado rejeitado e texto digitado permaneceu no campo para ajuste | ✅ Passou |
| **08** | Cadastrar Mouse, Teclado e Monitor; buscar `"teclado"` | Filtrar lista mantendo contagens | Lista exibiu apenas Teclado; contadores: 3 cadastrados e 1 encontrado | ✅ Passou |
| **08** | Com busca ativa, editar preço do Teclado (índice 0 visível) | Alterar Teclado e manter Mouse | Teclado atualizado; Mouse (índice 0 da lista original) permaneceu intacto | ✅ Passou |
| **08** | Buscar `"xyz"` | Mensagem de lista vazia de filtro | Exibido aviso centralizado *"Nenhum produto encontrado."* | ✅ Passou |
| **09** | Cadastrar ids 1, 2, 3; excluir o id 2; cadastrar outro | Próximo recebe id 4 | Contador `proximoId` não decrementou; novo produto recebeu id 4 | ✅ Passou |
| **09** | Abrir cadastro e cancelar; cadastrar em seguida | Id sequencial não queima número | Cancelamento não consumiu id; novo produto recebeu o id esperado | ✅ Passou |
| **09** | Filtrar por busca e editar o produto de id 3 | Preserva id 3 e localiza por `indexWhere` | Id 3 preservado e produto correto alterado na lista mestra | ✅ Passou |
| **10** | Total R$ 70; aplicar busca mostrando apenas Produto B | Total geral continua R$ 70.00 | O cálculo do total percorre `produtos` integralmente, independente do filtro visual | ✅ Passou |
| **10** | Editar B com busca ativa e depois limpar o campo de busca | B atualizado na lista completa | B atualizado na lista mestra; ao limpar busca, todos os itens aparecem íntegros | ✅ Passou |
| **10** | Excluir item com busca ativa | Item correto excluído por ID | Localização por `buscarIndicePorId(produto.id)` garantiu exclusão correta do item filtrado | ✅ Passou |
