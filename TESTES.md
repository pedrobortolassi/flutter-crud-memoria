# Testes

Preencher a coluna **Resultado observado** e marcar ✅ (passou) ou ❌ (falhou) ao executar cada versão.

## Tabela T1 a T14 (exemplo_secao6_produtos)

| Caso | Procedimento | Resultado esperado | Resultado observado | Status |
|---|---|---|---|---|
| T1 | Abrir o app pela primeira vez | Lista vazia e quantidade zero | | |
| T2 | Salvar com nome e preço vazios | Erros nos campos; formulário continua aberto | | |
| T3 | Nome só com espaços e preço 10 | Nome rejeitado | | |
| T4 | Nome Mouse e preço abc | Número inválido; sem cadastro | | |
| T5 | Nome Mouse e preço 0 ou -2 | Preço deve ser maior que zero | | |
| T6 | Nome Mouse e preço 12,50 | Produto na lista; quantidade um | | |
| T7 | Cadastrar sem descrição | Detalhes mostra *Sem descrição.* | | |
| T8 | Editar Mouse para Mouse USB e salvar | Mesmo registro atualizado; quantidade continua um | | |
| T9 | Editar nome e cancelar | Nome original preservado | | |
| T10 | Abrir cadastro e cancelar | Nenhum registro acrescentado | | |
| T11 | Pedir exclusão e cancelar | Lista e quantidade preservadas | | |
| T12 | Confirmar exclusão do último produto | Lista vazia; quantidade zero; mensagem de exclusão | | |
| T13 | Cadastrar três produtos e editar o segundo | Só o segundo registro alterado | | |
| T14 | Usar NaN ou Infinity como preço | Número inválido; sem cadastro | | |

## Testes por exercício

| Ex. | Entrada / ação | Resultado esperado | Observado | Status |
|---|---|---|---|---|
| 01 | Campo vazio | *Informe o nome.* | | |
| 01 | Dois espaços | *Informe o nome.* | | |
| 01 | `Al` | *O nome deve ter pelo menos três caracteres.* | | |
| 01 | `Ana` | *Olá, Ana!* | | |
| 02 | Confirmar Ana, apagar o nome e confirmar de novo | Erro no campo e saudação some | | |
| 02 | Provocar erro e tocar em Limpar | Campo, erro e saudação apagados | | |
| 02 | Confirmar `Al` depois de uma saudação válida | Saudação anterior some | | |
| 03 | Nome com 2 caracteres | Mensagem de mínimo de 3 | | |
| 03 | Descrição vazia | Aceita | | |
| 03 | Descrição com 120 caracteres | Aceita | | |
| 03 | Descrição com 121 caracteres | Rejeitada com a contagem atual | | |
| 04 | Cadastrar Mouse a 50; editar para Teclado a 100 e descartar | Mouse a 50 permanece | | |
| 04 | Abrir cadastro e cancelar | Quantidade não muda | | |
| 04 | Pedir exclusão e tocar em *Manter produto* | Item e contagem preservados | | |
| 05 | Quantidade vazia / `abc` / `-1` / `2.5` | Rejeitadas | | |
| 05 | Quantidade `0` | Aceita | | |
| 05 | Cadastrar com 3 e editar para 5 | Edição abre com 3; lista mostra 5 | | |
| 06 | Lista vazia | Total R$ 0.00 | | |
| 06 | A: 10 × 3 e B: 20 × 2 | Total R$ 70.00 | | |
| 06 | Excluir A | Total R$ 40.00 | | |
| 07 | Cadastrar Mouse e Teclado; tentar cadastrar `mouse` | *Já existe um produto com esse nome.* | | |
| 07 | Editar Mouse sem mudar o nome | Salva normalmente | | |
| 07 | Renomear Teclado para Mouse | Rejeitado; texto digitado continua no campo | | |
| 08 | Cadastrar Mouse, Teclado e Monitor; buscar `teclado` | Só Teclado; cadastrados 3, encontrados 1 | | |
| 08 | Com a busca ativa, editar o preço do Teclado | Só Teclado muda; Mouse igual | | |
| 08 | Buscar `xyz` | *Nenhum produto encontrado.* | | |
| 09 | Cadastrar 3 produtos (ids 1, 2, 3); excluir o 2; cadastrar outro | Novo produto recebe id 4 | | |
| 09 | Abrir cadastro e cancelar; cadastrar em seguida | Id não é pulado | | |
| 09 | Filtrar e editar o id 3 | Mantém id 3; nenhum outro muda | | |
| 10 | Total R$ 70; buscar só B | Total geral continua R$ 70.00 | | |
| 10 | Editar B com a busca ativa e limpar a busca | Só B alterado na lista completa | | |
| 10 | Excluir item filtrado | Só ele é removido; total recalculado | | |
