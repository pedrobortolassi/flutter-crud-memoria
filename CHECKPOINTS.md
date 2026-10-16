# Respostas dos checkpoints

## Checkpoint 1

**a) Por que um nome com três espaços precisa ser rejeitado?**
Porque espaços não identificam ninguém. Sem `trim()`, o campo pareceria preenchido, mas na prática o nome estaria vazio.

**b) O que o validator retorna quando o campo está correto?**
`null`. Qualquer `String` retornada é tratada como mensagem de erro.

**c) Diferença entre o controller e a chave do formulário?**
O `TextEditingController` lê e preenche o texto de um campo. A `GlobalKey<FormState>` dá acesso ao estado do `Form` inteiro, permitindo chamar `validate()` e `reset()` em todos os campos de uma vez.

## Checkpoint 2

| Entrada | Retorno de `validarPreco` |
|---|---|
| vazio | `Informe o preço.` |
| `abc` | `Digite um número válido.` |
| `0` | `O preço deve ser maior que zero.` |
| `-5` | `O preço deve ser maior que zero.` |
| `12,50` | `null` (válido, vira 12.5) |
| `NaN` | `Digite um número válido.` (`tryParse` aceita, mas `isFinite` é falso) |

O teclado numérico só facilita a digitação. O usuário ainda pode colar texto, usar um teclado físico ou digitar combinações inválidas, então a regra de negócio precisa estar no validador.

## Checkpoint 3

**Salvar:** o formulário cria um novo `Produto` e faz `pop` com ele. A tela de detalhes recebe esse objeto e faz `pop` repassando-o à tela principal, que substitui o item na mesma posição. A quantidade de produtos não muda.

**Cancelar:** o formulário faz `pop` sem resultado. Os detalhes recebem `null` e continuam abertos com o produto original.

**Por que `produtos[indice] = atualizado` e não `add()`?** `add()` acrescentaria um segundo registro e manteria o antigo, duplicando o produto. A edição precisa substituir.

**Por que o formulário não altera o objeto original durante a digitação?** Os atributos de `Produto` são `final` e o formulário trabalha só nos controllers. Assim, desistir da edição não deixa nenhuma alteração pela metade no registro original.

## Checkpoint 4

**`false` x `null` no diálogo:** `false` é a escolha explícita de cancelar pelo botão; `null` significa que o diálogo foi fechado sem nenhuma escolha (por exemplo, tocando fora dele). Os dois são diferentes de `true`, então nenhum autoriza a exclusão.

**Em qual tela a lista muda?** Só na tela principal, que é a dona da lista. As outras telas apenas recebem ou devolvem objetos.

**Por que o SnackBar do cadastro aparece depois do retorno?** Porque ele confirma uma operação que só é aplicada na tela principal, depois que o resultado foi recebido e adicionado à lista. Mostrar a mensagem antes poderia confirmar algo que ainda não aconteceu.
