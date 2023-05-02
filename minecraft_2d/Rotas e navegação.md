# Navegação entre páginas ou telas

## Metodo simplório
No componente o qual terá um click ou um tap, importar a página para a qual ele erá direcionar, na função relacionada ao click ou tap chamar no navigator:

```dart
...
import '../pages/categories_food_page.dart';

class CategoryItem extends StatelessWidget {
  final Category category;

  const CategoryItem(this.category);

  void _selectCatetory(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return CategoriesFoodPage(); // também tem o cupertino page router
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectCatetory(context),
      borderRadius: BorderRadius.circular(15),
      splashColor: Theme.of(context).primaryColor,
      child: Container(
        ...
      ),
    );
  }
}

```

## Rotas nomeadas
Definidas no main.dart ou outro arquivo:
```dart
...

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FodApp',
      theme: ThemeData(
        ...
      ),
      routes: {
        '/': (ctx) => CategoryPage(),
        '/categories-food': (ctx) => CategoriesFoodPage(),
      },
    );
  }
}

```
no arquivo que chamará uma rota, este passa categoria como parametro para a página `categories-food`:

```dart
class CategoryItem extends StatelessWidget {
  final Category category;

  const CategoryItem(this.category);

void _selectCatetory(BuildContext context) {
    Navigator.of(context).pushNamed(
      '/categories-food',
      arguments: category,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectCatetory(context),
      borderRadius: BorderRadius.circular(15),
      splashColor: Theme.of(context).primaryColor,
      child: Container(
        ...
      ),
    );
  }
}
```
recebendo o parametro passado pela rota:

```dart
import 'package:flutter/material.dart';
import 'package:food_app/models/category.dart';

class CategoriesFoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final category = ModalRoute.of(context)!.settings.arguments as Category;//recebendo da rota

    return Scaffold(
      appBar: AppBar(
        title: Text(category.title),
      ),
      body: Center(
        child: Text('receitas por categoria:${category.id}'),
      ),
    );
  }
}

```
## Rotas dinâmicas
Criar um arquivo de rotas:
```dart
const PRODUCT_DETAIL = '/product-detail';
```

no main.dart. importa-lo e no componente `MyApp`, ou o nome que for dado ao componente inicial, adicionar a propriedade rotas e apontar cada rota para a sua página específica
```dart
...
import 'package:shop/pages/product_item_page.dart';
import './routes/routes.dart' as Routes;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop',
      theme: theme,
      home: ProductsPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        Routes.PRODUCT_DETAIL:(ctx)=> ProductDetailsPage()
      },
    );
  }
}
```

no componente che chamar a rota, utilizar o `Navigator.of().pushNamed`, passando a rota e os argumentos
```dart
...
import 'package:shop/models/product.dart';
import '../routes//routes.dart' as Routes;

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              Routes.PRODUCT_DETAIL,
              arguments: product,
            );
          },
        ),
        ...
      ),
    );
  }
}

```

na componente da página, utilizar o `ModalRoute.of()` para pegar os argumentos passados pela rota

**NOTA:neste caso está como o caractere `!` para garantir que sempre será passado o .settings.arguments**

```dart
...
import 'package:shop/models/product.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title)
      ),
    );
  }
}
```

## Rota 404 e tratativa de rotas específicas
caso o app não encontre a rota requerida, podemos definir uma rota 404 para ele, com o metoto `onUnknownRoute`. Caso queira tratar uma rota específica por exemplot '/xpto' e redireciona-la para a uma página específica, utiliza-se o metodo `onGenerateRoute`.

**NOTA: `onGenerateRoute` é chamado primeiro que `onUnknownRoute`**

```dart
...
import './pages/products_page.dart';
import 'package:shop/pages/product_item_page.dart';
import './routes/routes.dart' as Routes;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop',
      theme: theme,
      home: ProductsPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        Routes.PRODUCT_DETAIL:(ctx)=> ProductDetailsPage()
      },
      onGenerateRoute: (settings) {
        if(settings.name == '/xpto'){
          return MaterialPageRoute(builder: (_) => ProductsPage());
        }
      },
      onUnknownRoute: (settings){
        return MaterialPageRoute(builder: (_) => ProductsPage());
      },
    );
  }
}
```

## TabBar
Usando Navegação em abas no appBar(header)

```dart
import 'package:flutter/material.dart';
import 'package:food_app/pages/category.dart';
import './favorite_page.dart';

class TabsPage extends StatelessWidget {
  const TabsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Vamos cozinhar'),
          bottom: TabBar(
            overlayColor:
                MaterialStateProperty.all(Theme.of(context).primaryColorDark),
            tabs: [
              Tab(
                icon: Icon(Icons.category),
                text: 'Categorias',
              ),
              Tab(
                icon: Icon(Icons.star),
                text: 'Favoritos',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [CategoryPage(), FavoritePage()],
        ),
      ),
    );
  }
}

```

## Retornando parametros da rota
Ao navegar para o Formulário passa o callback da rota ao realizar a funcção

```dart
import 'package:alura_bytebank/pages/FormularioTransferenciaPage.dart';
import 'package:flutter/material.dart';
import '../components/ListaTransferencia.dart';

class ListaTransferenciaPage extends StatelessWidget {
  const ListaTransferenciaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferências'),
      ),
      body: const ListaTransferencia(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Future<dynamic> routeReturn = Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => const FormularioTransferenciaPage(),
            ),
          );
          routeReturn.then( //quando retornar o callback pegar a transferencia criada
            (transferencia) => debugPrint(transferencia.toString()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```
na página de criação da transferência ao criar a transferencia, navegar de volta para a tela de lista

```dart
import 'package:alura_bytebank/components/Inputs.dart';
import 'package:alura_bytebank/models/Transferencia.dart';
import 'package:flutter/material.dart';

class FormularioTransferencia extends StatelessWidget {
  final TextEditingController _controlardorNumeroConta =
      TextEditingController();
  final TextEditingController _controladorValor = TextEditingController();

  FormularioTransferencia({Key? key}) : super(key: key);

  void _criaTransferencia(BuildContext context) {
    final numeroConta = int.tryParse(_controlardorNumeroConta.text);
    final valor = double.tryParse(_controladorValor.text);
    if (numeroConta != null && valor != null) {
      final transferencia =
          Transferencia(numeroConta: numeroConta, valor: valor);
      Navigator.pop(context, transferencia); //navega de volta com a transferencia criada
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Input(_controlardorNumeroConta, 'Número da conta', '0000'),
        Input(_controladorValor, 'Valor', '0.0', icone: Icons.monetization_on),
        ElevatedButton(
          onPressed: () => _criaTransferencia(context),
          child: const Text('Confirmar'),
        )
      ],
    );
  }
}
```