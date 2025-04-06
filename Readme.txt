Ferramenta:
* Este projeto foi desenvolvido utilizando a versão Community do Delphi 12 por ser a única grátis disponível.

Banco de dados:
* Para esta aplicação foi utilizado o Firebird, na versão 2.5 64 bits, no dialeto 3. Caso não possua esta versão, pode ser baixado neste link https://firebirdsql.org/en/firebird-2-5/#Win64
* Além do banco de dados, é necessário copiar o arquivo "fbclient.dll" para o diretório onde se encontra o executável, exemplo: C:\Projeto Dass\Projeto-teste\Win32\Debug, pois sem mesmo não irá funcionar. Este arquivo está disponível na junto aos arquivos do código fonte da aplicação.
* Não é necessário criar o banco através de script DDL, na própria aplicação já tem este recurso, logo abaixo explico nas funcionalidades. Caso quiser conferir a estrutura, o script se encontra junto aos arquivos do código fonte da aplicação. 

Funcionalidades:
* A aplicação possui um menu superior onde possui a opção "Conexão BD", onde possui duas opções internas, a primeira servindo para atribuir um banco de dados já existente, bastando apenas selecionar o mesmo que já irá ser armazenado em um arquivo INI e sendo utilizado posteriormente. A segunda opção irá criar o banco de dados e sua estrutura, no diretório onde se encontra o executável da aplicação e junto a isso irá configurar o diretório no arquivo INI.
* Já a opção "Funcionários" no menu, irá abrir a tela de consulta e cadastro dos funcionários, onde ambas as funcionalidades ficaram separadas em abas, mas utilizando a mesma tela. Nesta tela tem um menu lateral de botões, para inserir novos ou excluir algum, funcionando independente da aba que estiver posicionado, onde há um gerenciamento de abas. 
** Na primeira aba de consulta temos a opção de listagem de todos os funcionários cadastrados, bem como um recurso de filtragem, bastando selecionar por qual campo deseja ser filtrado e colocar a informação no campo abaixo, se der enter no campo da informação ou clicar no botão "Pesquisar" irá filtrar, para desfiltrar basta limpar o campo ou clicar no botão "Limpar filtros". Além disto, criei o recurso de duplo clique nos registros da grade, se feito isso, irá trocar de aba e posicionar no registro para facilitar uma possível edição do mesmo.
** Na segunda aba, a de cadastro, servirá tanto para inserções, quanto para edições, sempre sendo necessário clicar no botão "Salvar" ou dar enter no último campo para efetivação, onde há validação dos campos obrigatórios antes de salvar a alteração. Ainda nesta aba há o recurso dos botões de navegação, onde é possível navegar pelos registros. Por fim, ainda nesta aba há a opção de "Inserção sequencial", que é uma uma praticidade para múltiplos cadastros em sequência, onde nada mais fará do que ao salvar a inserção, já irá iniciar uma nova inserção, facilitando para não ser necessário ficar clicando no botão "Novo" toda vez.


Era isto.
