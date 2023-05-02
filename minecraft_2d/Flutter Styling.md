# Styling widgets

## Padding Widget
Permite a inserção de estilos customizados.
- padding
  
exemplo:
```Dart
Padding(
    padding: EdgeInsets.all(10),
    child: Text(...)
)
```

## Container widget
aceita apenas um elemento *child*
tem largura flexivel, largura do filho, largura disponível e pode ser fixa se desejar
Permite a inserção de estilos customizados.
- margin
- padding
- decoration

margin e border utilizam o EdgeInsets,

### EdgeInsets
EdgeInsets possuem alguns metodos, dentre eles, 
- symmetric
  onde você pode definir a margin ou pagging vertical e/ou horizontal
  exemplo:

```dart
Container(
    margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertital: 10,
    )
    child: Text(...)
)
```
- all, define igualmente as 4 margins ou padings, exeplo:

```dart
Container(
    padding: EdgeInsets.all(10),
    child: Text(...)
)
```

### BoxDecoration
define estilos de bordas
exemplo:

```dart
Container(
    margin: ...
    padding: ...
    decoration: BoxDecoration(
        border: Border.all(
            color: Colors.black,
            width: 2
        )
    ),
    child: Text(...)
)
```

## Row e Column
aceita uma lista de elementos *children*
tem limitações de customização, apenas de posições e direcionamento
tem largura fixa, ocupa ou largura(Row) ou altura(Column) toda

## Criando e aplicando um tema
basta colocar a propriedade `theme` em no componente `MaterialApp`(neste caso, mas pode ser Cupertino também);

Abaixo setamos duas propriedades de tema:
PrimarySwatch, seria a paleta de cor baseada no roxo, poderiamos ter colocado a penas PrimaryColor, que seria apenas uma cor
e accentColot, seria a cor de destaque, apenas uma cor

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.green[900],
          secondary: Colors.blue[700], // Your accent color
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color?>(Colors.blue[700]),
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue[700],
        ),
      ),

      home: MyHomePage(),
    );
  }
}
```

## adicionando fonte


## Responsividade 
### MediaQuery
Para trabalhar com responsividade.

exemplo para pegar toda altura do dispositivo, desconsiderando a AppBar.
```dart
final double availableHight = MediaQuery.of(context).size.height -
        appbar.preferredSize.height -
        MediaQuery.of(context).padding.top;
```

### Reposonsive texts
Para halilitar acessibilidade de textos via configuração do aparelho

```dart
fontSize: 18 * MediaQuery.of(context).textScaleFactor,
```

## LayoutBuilder
retorna uma função builder passando o contexto do componente Pai, para questões de responsividade em relação ao objeto pai.
`contraints` é a propriedade que terá as dimensões do componente pai:
```dart
LayoutBuilder(
  builder: (ctx, constraints) {
    return Column(
      children: [
        Container(
          height: constraints.maxHeight * 0.15,
          child: FittedBox(
            child: Text('${value.toStringAsFixed(2)}'),
          ),
        ),
      ]
    )
  }
)
```
## Orientações suportadas
Para limitar a aplicação a apenas a certas orientações, basta colocar no componente principal da sua aplicação o `SystemChrome` da biblioteca `services.dart` 
```dart
class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    ); // orientação só retrato

    return MaterialApp(
      ...
    )
  }
}
```
### Trabalhando com Larguras maiores