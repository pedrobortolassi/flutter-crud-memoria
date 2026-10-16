# Flutter – Formulários validados e CRUD em memória

**Aluno:** Pedro Henrique Bortolassi da Silva  
**RA:** 202410001  
**Instituição:** Escola de Engenharia de Piracicaba (EEP)  
**Professor:** Clerivaldo Roccia

Atividade de aula invertida do capítulo *Formulários validados e CRUD em memória no Flutter*. O trabalho começa por um formulário simples com nome obrigatório e evolui até um gerenciador de produtos com cadastro, consulta, edição, exclusão, busca e identificador estável. Os dados ficam só em uma lista na memória.

## Como executar

Cada pasta tem um `main.dart` independente, com um único `main()`. Para rodar qualquer um:

```bash
flutter create formulario_nome      # ou produtos_memoria
cd formulario_nome
# substitua lib/main.dart pelo main.dart da pasta desejada
flutter run
```

Não é necessário alterar o `pubspec.yaml`: tudo usa somente Flutter e Dart, sem pacotes extras.

## Exemplos resolvidos

### exemplo_secao3_nome
Formulário com nome obrigatório usando `Form`, `TextFormField`, `GlobalKey<FormState>` e `validator`. A saudação só aparece depois de `validate()` retornar `true`.

### exemplo_secao6_produtos
CRUD em memória completo: tela principal com a lista, tela de detalhes e um único formulário reutilizado no cadastro e na edição. A exclusão pede confirmação com `showDialog<bool>()`.

## Exercícios

### exercicio01 – Nome válido e mensagem personalizada
O nome passa por `trim()` antes de qualquer verificação. Vazio mostra *Informe o nome.*; menos de três caracteres mostra *O nome deve ter pelo menos três caracteres.*

**Por que usar `trim()` antes do comprimento?** Sem ele, `" Al "` teria 4 caracteres e passaria na regra, mesmo tendo só duas letras de nome. Espaços nas extremidades não fazem parte do nome.

### exercicio02 – Limpar e evitar uma saudação antiga
O botão **Limpar** chama `controller.clear()` (apaga o texto), `FormState.reset()` (remove as mensagens de erro) e zera a saudação com `setState()`. Ao confirmar um nome inválido, a saudação anterior também é apagada, para não parecer que o dado inválido foi aceito.

### exercicio03 – Regras adicionais para o produto
Nome com pelo menos três caracteres e descrição opcional com no máximo 120 caracteres. Como cadastro e edição usam a mesma `TelaFormulario`, as regras valem automaticamente nas duas operações.

**Vantagem de um único formulário:** as regras ficam em um só lugar. Se uma regra mudar, não existe o risco de atualizar o cadastro e esquecer a edição.

### exercicio04 – Cancelamento sem efeitos colaterais
O comportamento já existia na versão base; aqui ele foi comprovado e os botões ficaram mais claros (**Cancelar cadastro**, **Descartar alterações** e **Manter produto** no diálogo).

**Como o `null` é tratado:**
- **Cadastro:** cancelar faz `Navigator.pop(context)` sem resultado. A tela principal recebe `null` e sai do método antes do `add()`.
- **Edição:** o formulário só mexe nos controllers; o `Produto` original nunca é alterado. Cancelar devolve `null` para os detalhes, que não fazem `pop` com resultado, e a tela principal não substitui nada.
- **Exclusão:** *Manter produto* devolve `false` e fechar o diálogo por fora devolve `null`. A remoção só acontece com `true`.

### exercicio05 – Quantidade em estoque
Novo atributo `quantidade` (inteiro, obrigatório, maior ou igual a zero) validado com `int.tryParse()`, que já devolve `null` para `abc` e para decimais como `2.5`. A quantidade é preenchida na edição e aparece na lista e nos detalhes.

### exercicio06 – Valor total do estoque
Cada produto tem `valorEmEstoque` (preço × quantidade). O total é calculado com um `for` que percorre a lista toda vez que a tela é reconstruída, então cadastrar, editar ou excluir já atualiza o valor.

**Por que um total fixado só no cadastro ficaria errado?** Porque editar o preço ou a quantidade, ou excluir um item, mudaria os produtos sem mudar o número guardado. Recalcular a partir da lista elimina essa diferença.

### exercicio07 – Impedir nomes repetidos
A tela principal envia ao formulário uma `List<String>` com os nomes dos **outros** produtos. A comparação usa `trim().toLowerCase()`, então `Mouse` e `mouse` são duplicados. Na edição, o próprio produto fica fora da lista, por isso salvar sem mudar o nome é permitido.

### exercicio08 – Buscar e editar o produto correto
Campo de busca que ignora maiúsculas e minúsculas, com contadores separados de *cadastrados* e *encontrados* e a mensagem *Nenhum produto encontrado.* A lista filtrada guarda referências aos mesmos objetos; ao editar ou excluir, a posição real é localizada com `produtos.indexOf(produto)`.

### exercicio09 – Identidade estável com id
Cada produto tem um `id` inteiro. O contador `proximoId` fica na tela principal, é enviado ao formulário no cadastro e só avança quando o cadastro é aceito (cancelar não consome id). Ele nunca diminui, então depois de excluir o id 2 o próximo cadastro recebe 4. A edição reaproveita o id original e a localização é feita com `indexWhere()`. Se o id não for encontrado, a operação para com um aviso e nunca acessa o índice `-1`.

### exercicio10 – Gerenciador de produtos integrado
Versão final com validação, quantidade, total do estoque, nomes únicos, busca e ids. O total geral sempre considera todos os produtos, mesmo com a busca ativa.

## Recursos da versão final

- Cadastro, consulta, edição e exclusão com o mesmo formulário para cadastro e edição
- Validação de nome, preço, quantidade e descrição
- Nomes únicos sem diferenciar maiúsculas e minúsculas
- Busca por nome com contadores de cadastrados e encontrados
- Valor por item e valor total do estoque
- Identificador estável por produto
- Confirmação antes de excluir e cancelamentos sem efeito nos dados

**Os dados não persistem:** a lista fica só na memória. Ao fechar ou reiniciar o app (incluindo *hot restart*), os produtos são perdidos.

## Falha encontrada e corrigida

Até o exercício 7, a tela principal editava e excluía pela **posição na lista** (`produtos[indice]`). Com a busca do exercício 8, a posição da lista visível deixa de ser a posição da lista original: cadastrando Mouse, Teclado e Monitor e buscando *Teclado*, ele aparece na posição 0, que na lista original é o Mouse. Editar por essa posição alteraria o Mouse. A correção foi passar o próprio objeto e localizar a posição real (primeiro com `indexOf()`, depois por `id` com `indexWhere()`).

## Persistência (questão para a correção)

Para manter os produtos depois de fechar o app, a lista precisaria ser gravada fora da memória, por exemplo em um arquivo local, em `shared_preferences` ou em um banco como SQLite. Isso exigiria converter cada `Produto` para um formato armazenável (como um `Map`/JSON), carregar os dados ao abrir o app, salvar após cada cadastro, edição e exclusão, e também guardar o `proximoId` para os ids continuarem únicos.

## Fluxo de dados (Validação, Devolução e Atualização da Lista)

Conforme os objetivos centrais do capítulo de estudo autônomo:

1. **Como validar com `Form` e `TextFormField`:**
   - O formulário é envolvido em um widget `Form` associado a uma `GlobalKey<FormState>()` declarada no `State`.
   - Cada campo (`TextFormField`) implementa a propriedade `validator: (valor) => ...`. A função retorna `null` se a regra for atendida, ou uma `String` com a mensagem de erro se a entrada for inválida (ex.: vazio após `trim()`, tamanho menor que 3, preço não numérico ou menor/igual a zero, quantidade inválida ou nome duplicado).
   - O botão *Salvar* chama `chave.currentState!.validate()`. O método executa todos os validadores; se algum falhar, ele exibe os erros na interface e o processo é interrompido antes de criar o modelo.

2. **Como devolver o objeto via navegação:**
   - Quando `validate()` retorna `true`, o formulário instancia um novo objeto imutável `Produto(...)` com os dados limpos dos controllers.
   - O retorno ocorre via `Navigator.pop(context, produto)`.
   - Se o usuário desistir ou tocar em *Cancelar*, chama-se `Navigator.pop(context)` sem parâmetro, devolvendo `null`. O mesmo ocorre na tela de detalhes: a edição devolve o `Produto` atualizado para os detalhes, que por sua vez o repassa para a tela principal (`Navigator.pop(context, atualizado)`).

3. **Como atualizar a lista na tela principal:**
   - A tela principal mantém a lista mestra `final List<Produto> produtos = []` em seu `State`.
   - Os métodos `cadastrar()`, `abrirDetalhes()` e `excluir()` são assíncronos (`async/await`).
   - Após o retorno da navegação e verificação de segurança (`if (!mounted || resultado == null) return;`), a lista é manipulada exclusivamente dentro de `setState()`:
     - **Cadastro:** `produtos.add(novo);` e avança o contador de id (`proximoId++`).
     - **Edição:** o item é localizado na lista original por seu identificador único estável através de `produtos.indexWhere((p) => p.id == atualizado.id)` e substituído via `produtos[indice] = atualizado;`.
     - **Exclusão:** exibe um diálogo de confirmação (`showDialog<bool>`). Se confirmado (`confirmou == true`), localiza o índice pelo `id` e remove com `produtos.removeAt(indice);`.

---

## Registro de dúvidas e desafios (Seção 11 do guia)

- **Desafio encontrado:** Edição de item com filtro de busca ativo alterava o registro errado na lista original.
- **Trecho relacionado:** `produtos[indice] = atualizado;` com `indice` obtido da lista filtrada `produtosVisiveis`.
- **Resultado esperado:** Ao filtrar por "Teclado" (posição 0 na lista visível) e alterar seu preço, apenas "Teclado" deveria mudar na lista mestre de produtos.
- **Resultado observado antes da correção:** O produto "Mouse" (posição 0 na lista mestra original) foi alterado indevidamente no lugar de "Teclado".
- **Solução implementada:** No Exercício 8, o item foi localizado pelo próprio objeto via `produtos.indexOf(produto)`. Nos Exercícios 9 e 10, cada produto recebeu um `id` estável que não muda na edição, localizando o registro original com precisão via `produtos.indexWhere((p) => p.id == atualizado.id)`.

---

## Outros arquivos

- [CHECKPOINTS.md](CHECKPOINTS.md) – respostas detalhadas dos quatro checkpoints (Seções 3, 4, 5, 6 e 10)
- [TESTES.md](TESTES.md) – registro completo das tabelas T1 a T14 e baterias de testes dos exercícios 01 a 10 com status e observações

## Referências

- Flutter. *Build a form with validation.* https://docs.flutter.dev/cookbook/forms/validation
- Flutter. *Return data from a screen.* https://docs.flutter.dev/cookbook/navigation/returning-data
- Flutter. *showDialog function.* https://api.flutter.dev/flutter/material/showDialog.html
