# Widgets ou componentes
Resumo geral da função dos componentes nativos do flutter

# Criando um Widget
```dart
class ListaTransferencia extends Widget{

  
  @override
  Element createElement() {
    // TODO: implement createElement
    throw UnimplementedError();
  }

```

# Lista de Widgets
## Configuração da App/Page
### APP
- MaterialApp / CupertinoApp
componente raiz

### Page
- scaffold/ CupertinoPageScaffold
Gerá um header, body e footer

## Layout
- Container
  atributos 
      child
      padding
      border
      margin
  tirando o child o resto é como no css na web

**NOTA: alguns componentes tem padding e outros não. Para aplicar o padding em componentes que não tenham, basta envolver o componente com o Widget Padding()**
- Row
- Column
- LayoutBuilder - Mais complexo, para pegar as dimensões do componente pai para considerar responsividade
### Filhos de Widgets de Layout
Funcionam apenas em conjunto com os widgets acima

- Flexible
- Expanded 
- FittedBox - faz com que o conteúdo se encaixe das dimensões do componente pai, seja verticalmente ou horizontalmente 

#### Felxible
- fit: Determina se o elemento vai se expandir para ocupar espaços vazios ou se reter ao tamanho definido ou do conteúdo.
    1. **Fit loose** FlexFit.loose = É o padrão. Ocupa o tamanho necessário só para exibir o elemento ou a lagura definida na propriedade width
    2. **fit tight** FlexFit.tight = Ocupa todo espaço restante na linha
- flex: em casos de mais de um elemento com a propriedade **fit: FlexFit.tight** determina qual a porção cada componente ocupará do espaço vazio.
  Exemplo1: se temos 2 componente, um com flex = 1 e outro com flex = 2, teremos que os espaços vazios serão divididos por 3(flex=1 + flex=2) e o elemento com flex=2 ocupará 2/3 do espaço e elemento com flex=1 ocupará 1/3. Ou seja se ambos fossem flex=2, então daria um total de 4 e cada um ocuparia 2/4, que seria a mesma coisa de dois elementos com flex=1 pois o 2/4 = 1/2, e cada elemento ocuparia metade dos espaços vazios. 
  Exemplo2: Usando um elemento com flex=3 e outro com flex=1, só que com fit=FlexFit.loose. O resultado é que como o elemento de flex=1 está com fit=loose ele ocupará só o tamanho definido nele ou tamanho de seu conteúdo, porém o elemento de flex=3 pegará 3/4 do tamanho, deixar um espaçamento em branco correspondente ao 1/4 do espaço

#### Expanded
Expanded é a mesma coisa que o flexible só que sem a propriedade fit, que já está setado como **tight** por padrão
## Containers
- Stack
camadas(aparentemente um posicionamento absoluto) elemento dentro de outro

- Card

### Filhos de Containers
 - Positioned: Filho de `Stack`, usado para definir o posicionamento dentro de `Stack`

## Elementos de repetição
#### Listas
- ListView - ja com overflow para fazer a rolagem da tela caso o conteúdo extrapole as dimensões do container
- GridView

#### Item de lista
- ListTile - O item repetido da de uma listView, já contém diversos atributos para ficar mais facil estruturar e estilizar um item de lista

## Elementos de Conteúdo
- Text
- Image
- Icon - um componente para inserção de icone
- CircleAvatar - uma componente já em formato circular para por conteúdo,


## IO
### Visiveis
- TextField - um input textual
- ElevatedButton - Um botão comun, com cor de fundo, texto e sombras
- TextButton - aparencia de link, só texto
- InkWell - Area para reconhecimento de toque, tem um feedback visual como uma bolha que cresce ao tocar ou clicar
- Switch - um botão do tipo switch trocar entre true ou false

### invisíveis
- GestureDetector
- Slivers(varias implementações) : Uma fatia é uma parte de uma área rolável que você pode definir para se comportar de uma maneira especial. Você pode usar Slivers(lascas) para obter efeitos de rolagem personalizados, como rolagem elástica.

## Widgets espefícos

### AppBar
Actions é onde colocamos ações como botões e outras ações.

```dart
AppBar(
  title: const Text('Minha loja'),
  actions: [
    PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (_) => [
            const PopupMenuItem(
              child: Text('Only Favourites'),
              value: FilterOptions.Favourites,
            ),
            const PopupMenuItem(
              child: Text('All'),
              value: FilterOptions.All,
            )
          ],
      onSelected: (FilterOptions value) {
        value == FilterOptions.Favourites
            ? provider.showFavourites()
            : provider.showAll();
      }
    )
  ],
)
```
### ScaffoldMeessenger
mostrar uma snackBar ao realizar uma ação

```dart
class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          ...
        ),
        footer: GridTileBar(
          ...
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () => {
              cart.addItem(product),
              ScaffoldMessenger.of(context).hideCurrentSnackBar(), //para caso ainda não tenha acabado a duração do snackbar anterior
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text('Produto "${product.name}" adicionado com sucesso!'),
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'DESFAZER',
                  onPressed: () {
                    cart.removeSingleItem(product.id);
                  },
                ),
              ))
            },
          ),
        ),
      ),
    );
  }
}

```

### showDialog
```dart
...
class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  const CartItemWidget(
    this.cartItem, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      ...
      ),
      confirmDismiss: (_) {
        return showDialog(
          context: context,
          builder: (modalCtx) => AlertDialog(
            title: const Text('Remover do carrinho?'),
            content: const Text('Realmente deseja remover o item do carrinho?'),
            actions: [
              TextButton(
                child: const Text('NÃO'),
                onPressed: () {
                  Navigator.of(modalCtx).pop(false);
                },
              ),
              TextButton(
                child: const Text('SIM'),
                onPressed: () {
                  Navigator.of(modalCtx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        ...
      },
    );
  }
}

```

### Dismissable

```dart
...
class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  const CartItemWidget(
    this.cartItem, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 15),
      ),
      child: Card(
        color: const Color.fromARGB(255, 255, 255, 255),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: ListTile(
          ...
        ),
      ),
      confirmDismiss: (_) {
        return showDialog(
          context: context,
          builder: (modalCtx) => AlertDialog(
            title: const Text('Remover do carrinho?'),
            content: const Text('Realmente deseja remover o item do carrinho?'),
            actions: [
              ...
            ],
          ),
        );
      },
      onDismissed: (_) {
        Provider.of<Cart>(
          context,
          listen: false,
        ).removeItems(cartItem.productId);
      },
    );
  }
}

```

### Refresh indicator
Somente Mobile, quando puxa a tela para baixo, executa a função passada para `onRefresh`

```dart
...

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool _isLoading = true;

...

  Future<void> _refreshOrders(BuildContext context){
    return Provider.of<Orders>(context, listen: false).getOrders();
  }

  @override
  Widget build(BuildContext context) {
    final Orders orders = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
            onRefresh: ()=>_refreshOrders(context),
            child: ListView.builder(
                itemCount: orders.items.length,
                itemBuilder: (builderContext, i) => OrderWidget(
                  order: orders.items[i],
                  key: ValueKey(orders.items[i].id),
                ),
              ),
          ),
      drawer: const AppDrawer(),
    );
  }
}

```

### FutureBuilder
Um builder baseado em uma conexão, podendo tratar os estados da conexão para exibir diferentes tipos de widgets, não necessita estar em um componente stateFull, pode receber um genérics e pode ter um dado inicial

```dart
...

FutureBuilder<List<Contact>>(
  initialData: const [],
  future: contactService.readContacts(),
  builder: (ctx, snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none: //future não executado
        break;
      case ConnectionState.waiting:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              Text('Loading...'),
            ],
          ),
        );
      case ConnectionState
          .active: // tem dado disponível mas não terminou a execuçao, como uma Stream
        break;
      case ConnectionState.done:
        final contacts = snapshot.data;
        return ListView.builder(
          itemCount: contacts?.length ?? 0,
          itemBuilder: (ctx, index) => ContactListItem(
            contact: contacts![index],
          ),
        );
    }
    return const Text('Unkonwn error');
  },
),
```


### PreferedSiziWidget
Umas das utilidades é para transformar um widget em AppBar por exemplo
este widget precisa implementar o get de `preferredSize`
```dart
import 'package:flutter/material.dart';

class ResultadoWidget extends StatelessWidget implements PreferredSizeWidget {
 ...

  @override
  Size get preferredSize => const Size.fromHeight(120);
}

```

### SafeArea
considera paddins e margens para mostrar o conteúdo de acordo com o sistema operacional. eliminando dobrepor informações dele


### ListView
Cria uma lista com rolagem automática, criar a partir de uma lista estática ou dinâmica
`ListView` para estáticos e `ListView.builder`  para dinâmicos, podendo também passar a direção do scroll para caso ultrapasse o tamanho da tela.

Estático:
```dart
ListView(
  scrollDirection: Axis.horizontal
  children: [
   ...
  ]
)
```

Dinâmico:
```dart
ListView.builder(
  children: [
    ItemTransferencia(
      Transferencia(valor: 100.23, numeroConta: 1000),
    ),
    ItemTransferencia(
      Transferencia(valor: 202.54, numeroConta: 1001),
    ),
  ]
)
```



### GridView
Monta um grid baseado numa lista
```dart

class TabuleiroWidget extends StatelessWidget {
  final Tabuleiro tabuleiro;
  final void Function(Campo) onOpen;
  final void Function(Campo) onToggleMarcacao;

  const TabuleiroWidget({
    Key? key, 
    required this.tabuleiro, 
    required this.onOpen, 
    required this.onToggleMarcacao,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: tabuleiro.colunas,
      children: tabuleiro.campos.map((campo) => 
        CampoWidget(
          campo: campo,
          onOpen: onOpen,
          onToggleMarcacao: onToggleMarcacao,
        ),
      ).toList(),
    );
  }
}

```

### InkWell 
é um componente que tem um Gesture detector, ou seja que é iterativo ao toque e implementa s animação padrão do material. Para alterar a cor do componente `InkWell` precisamos coloca-lo dentro de um widget `Material`, com a propriedade color

```dart
  Material(
    color: Theme.of(context).colorScheme.primary,
    child: InkWell(
      onTap: () {
       ...
      },
      child: Container(
        child: ...
      ),
    ),
  ),
```

### SingleChildScrollView
para adicionar rolagem tanto na horizontal ou vertical
```dart
SingleChildScrollView(
  scrollDirection: Axix.horizontal //ou vertical
  child:...
)
```