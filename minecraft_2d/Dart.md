# Dart
Linguagem usada pelo flutter

para usar a linguagem sem o flutter percisamos ter o sdk do flutter baixado e criar dentro da variavel de ambiente PATH um novo apontamento para o sdk do dart.
exemplo no windows: `C:\DEV\flutter\bin\cache\dart-sdk\bin`

## Vscode
usando o code Runner no vscode para rodar dart `(CTRL+AL+N)`

## Fundamentos

### Função main
Na linguagem Dart, assim como no c++ ou c, o programa precisa estrar dentro da função `main`
```dart
main(){
    print(
        'olá dart!'
    );
}
```
**NOTA: é possivel, como no exemplo acima, uma sentença ocupar mais de uma linha. o lint normalmente não permitirá**

também e possivel, assim como no javascript criar um bloco vazio:
```dart
main() {
  print('Olá Dart!');
  {
    print('fim!');
  }
}
```
### variaveis
Variveis tem seu tipo definido como int, double, bool, String e etc...
var é um chave especial que aceita o tipo por inferência, ou seja, quando é atribuido

- var é uma variavel que aceita o tipo por inferência, ou seja, quando é atribuido
```dart
var variavel = 1 // a partir desta atribuição agora variavel é do tipo int
```

### constantes
Assim como as variáveis as constantes também tem tipos, e assim como var aceitam tipo por inferência
final ou const
**const** é uma constante em tempo de compilação, os valores podem ser definidos em tempo de compilação
**final** é uma constante em tempo de execução, os valores são definidos em tempo de execução

```dart
const String teste = 'teste' //definida em tempo de compilação
final String? stdin.readLineSync() // definida em tempo de execução

const teste = 'teste' //definida em tempo de compilação por inferêcia
final stdin.readLineSync() // definida em tempo de execução por inferência, já que toda entrada ou é string ou nula
```

**constantes const podem receber outras const assim como final. mas const não recebe de final e vice versa**


### Tipos básicos
- numeros (int, double e num); 
```dart
int num1 = 1;
double num2 = 2.45;
num num3 = 1 ou 2.45 //aceita ambos pois é a classe pai de int e double
```
- string  (String)
```dart
String s1 = 'teste'
```
- boolean (bool)
```dart
bool isTrue = true;
```
- dynamic aceita qualquer tipo a qualquer hora
```dart
dynamic dyn = 1 ou 2.45 ou 'teste' ou true // aceita qualquer tipo e pode ser atribuido qualquer tipo a qualuer hora
```
### Lists ou Arrays, Maps e Sets
são variáveis que contem mais de um valor. Todas são do tipo genérics, (ou seja são tipos que aceitam tipos, pois contem mais de um valor).
os valores podem ter tipos iguais ou diferentes (recomendado que sejam iguais)
podem ser inferidos também

### Tipo Future
Para trabalhar com asícronismo, como a Promise do js
 Exemplo
 ```dart

 main(){
   futureSum(8, 4)
    .then((r1)=>print(r1));
    .catchError((error)=> print(error))
   int r2 = soma(7, 3);
   print(r2);
 }
```
 no caso acima o resultado será:
 10
 12

 ...ou

```dart
main() async {
   final somaFuturo = await futureSum(8, 4)
   int r2 = soma(7, 3);
   print(r2);
 }

int soma(int a, int b){
  return a + b;
}

Future<int> futureSum(int a, int b){
  return Future(()=> a + b);
}
 ```
no caso acima o resultado será um poco diferente
será:
12
10
pois com async await, ele vai esperar retornar a resposta do primeiro para continar a execução.
##### Lists
 - List(ou array) aceita um tipo Lista de outros tipos, aceita valore repetidos e possuem indice numérico
```dart
List<Object> aprovados = ['ana', 'carlos', 'daniel', 'rene', 23];
ou
List aprovados = ['ana', 'carlos', 'daniel', 'rene', 23];
ou
var aprovados = ['ana', 'carlos', 'daniel', 'rene', 23];

```
###### Métodos ou atributos uteis de list
lista.lenth = mostra o tamanho da list
lista.add(item) = adiciona item a lista
lista[idx] ou lista.elementAt(idx) = retorna apenas o elemento de de indice 'idx' na lista


##### Map
 - Map  aceita um tipo para chave e outro para valor, chave tem de ser única, caso tenha repetição pegará a ultima
```dart
Map<Object> telefones = {
  'Rene': '+55 (11) 998765432',
  'Erica': '+55 (11) 987654321',
  2: '+55 (11) 999999999',
  "oples": 0766,
};
ou
Map telefones = {
  'Rene': '+55 (11) 998765432',
  'Erica': '+55 (11) 987654321',
  2: '+55 (11) 999999999',
  "oples": 0766,
};
ou 
var telefones = {
  'Rene': '+55 (11) 998765432',
  'Erica': '+55 (11) 987654321',
  2: '+55 (11) 999999999',
  "oples": 0766,
};
```
###### Métodos ou atributos uteis de map
mapa.lenth = mostra o tamanho da list
mapa.keys = pega apenas as chaves
mapa.values = pega apenas os valores
mapa.entries = pega o item inteiro, com chave e valor

##### Set
 - Set  não tem indice, mas os valores tem de ser unicos (são como formato json, muito usado em js)
```dart
Set<Object> times = {'vasco', 'flamengo', 'palmeiras', 'corinthians', 123.432};
ou
Set times = {'vasco', 'flamengo', 'palmeiras', 'corinthians', 123.432};
ou 
var times = {'vasco', 'flamengo', 'palmeiras', 'corinthians', 123.432};
```

###### Métodos ou atributos uteis de set
conjunto.lenth = mostra o tamanho de conjunto
conjunto.add(item) = adiciona item a conjunto
conjunto.fold = é o reduce do conjunto
### Funções
por padrão recebem parametros do tipo dinâmico

#### Parametros opcionais
é possível determinar que uma função tenha parametros opcionais. No caso abaixo
dia é ogrigatório, enquanto que mes e ano são opcionais. Se não passado o valor de Mês será 1 enquanto que ano será 1970.
```dart
printDate(int dia, [int mes = 1, int ano = 1970]) {
  print('$dia/$mes/$ano');
}

main(){
  printDate(18, 03, 2021);
  printDate(18, 03);
  printDate(18);
}
```

#### Parametros nomeados
é  possível em Dart, passar os parametros em qualquer ordem, desde que sejam parametros nomeados.
No caso abaixo dia precisa ainda ser o primiero parametro da função, já mes e ano podem ser passdos em qualquer ordem, desde que sejam referenciados seus nomes:
```dart
printDate(int dia, {int mes = 1, int ano = 1970}) {
  print('$dia/$mes/$ano');
}

main(){
  printDate(1);
  printDate(20, mes: 10, ano: 2021);
  printDate(10, ano: 2020, mes: 22);
}

```

#### Funções genéricas
são funcões que aceitam diversos tipos:
```dart
E? segungoElementoV2<E>(List<E> lista) {
  return lista.length >= 2 ? lista[1] : null;
}

main() {
  var lista = [3, 6, 7, 12, 45, 78, 1];
  var lista2 = ['Rene', 'Erica', 'Helena', 'Diana'];
  var lista3 = [3.56];
  print(segungoElementoV2<String>(lista2));
  print(segungoElementoV2<int>(lista));
  print(segungoElementoV2<double>(lista3));
}
```

#### Função Filter(where)
função para fitrar uma lista:

```dart
bool Function(double) notasboasFn = (double nota) => nota >= 7;

main(){
  List<double> notas = [8.2, 7.1, 6.2, 4.4, 3.9, 8.8, 9.1, 5.1];
  Iterable<double> notasBoasFillter = notas.where(notasboasFn);
  Iterable<double> notasMelhoresFillter =
      notas.where((double nota) => nota >= 8.5);
  List<double> notasMelhoresFillterList =
      notas.where((double nota) => nota >= 8.5).toList();

  print(notasBoasFillter);
  print(notasMelhoresFillter);
  print(notasMelhoresFillterList);
}
```

#### Função Map
```dart
String Function(Map) pegaNomes = (Map aluno) => aluno['nome'];

main(){
  List<Map<String, Object>> alunos = [
    {'nome': 'Rene', 'nota': 9.9},
    {'nome': 'Erica', 'nota': 9.3},
    {'nome': 'Helena', 'nota': 8.7},
    {'nome': 'Diana', 'nota': 9.1},
    {'nome': 'Nina', 'nota': 7.6},
    {'nome': 'Fabio', 'nota': 6.8},
  ];
  Iterable<String> nomes = alunos.map(pegaNomes);
  Iterable<String> nomes2 = alunos.map(pegaNomes);
  Iterable<String> nomes3 = alunos.map((aluno) => (aluno['nome'] as String));
  print(nomes);
  print(nomes2);
  print(nomes3.toList());
}
```
#### Função Reduce e Fold
##### Reduce
Função feita para acumular conforme percorre a lista e/ou mudar o tipo da lista:

```dart

double somar(double acumulador, double elemento) {
  print('somar $acumulador com $elemento = ${acumulador + elemento}');
  return acumulador + elemento;
}

main(){
  List<double> notas = [7.3, 5.4, 7.7, 8.1, 5.5, 4.9, 9.1, 10.0];

  double total1 = notas.reduce(somar);
// ou
  double total2 = notas
      .reduce((double acumulador, double elemento) => acumulador + elemento);
  print(total1);
  print(total2);
}
```

##### Fold
Mesma coisa que o reduce porém é possível passar um valor inicial, exatamente como o reduce do javascript
recebe 2 parametros o primeiro é o valor inicial, no caso abaixo é o `0` e o segundo é a funcão, que por sua vez recebe 2 parameros também, o primeiro é o item resultante do reduce, o acumulado. e o segundo é o item da iteração atual.

```dart
 double get _weekSum {
    return groupTransactions.fold(0, (acu, tr) {
      return acu + tr['value'];
    });
  }
```
#### typedef 
  Um typedef, ou alias de tipo de função, dá a um tipo de função um nome que você pode usar ao declarar campos e tipos de retorno. Um typedef retém informações de tipo quando um tipo de função é atribuído a uma variável.

```dart
abstract class Teste {
  dynamic get param;
  Teste();
  void log() {
    print(param);
  }
}

class Teste1 extends Teste {
  @override
  final dynamic param;
  Teste1(this.param);
}

typedef TypeDefSample = Teste Function(dynamic valor);

void main() {
  TypeDefSample teste = (dynamic oples) {
    return Teste1(oples);
  };

// esse teste consiste em instanciar uma classe filha e ter o retorno com o tipo do pai
// permitindo assim algo similar a uma chamada dinâmica passando parametros

  teste.call(23).log(); //pode ser chamado com call ou sem
  teste('wewe').log();
```

### Classes
classes são modelos como um corola é um modelo de um carro,
atributos, metodos ou classes precedidos de '_' **são privados**, como exemplo a abaixo _velocidade, não são alcançaveis de fora da do **arquivo** onde foram criados, precisa de um getter and setter para isso.

```dart
class Carro {
  int _velocidade = 0;
  final int vMax;

  Carro([this.vMax = 150]) {}

  int get velocidade {
    //getter
    return this._velocidade;
  }

  void set velocidade(int novaVelocidade) {
    //setter só pode incrementar de 5 em 5
    bool detaValido = (_velocidade - novaVelocidade).abs() <= 5;
    if (detaValido && novaVelocidade >= 0) this._velocidade = novaVelocidade;
  }

  bool isLimit() {
    return _velocidade >= vMax;
  }

  int acelerar() {
    _velocidade = _velocidade + 5 > vMax ? vMax : _velocidade + 5;
    return _velocidade;
  }

  int frear() {
    _velocidade = _velocidade - 5 < 0 ? 0 : _velocidade - 5;
    return _velocidade;
  }
}

```
#### Cronstutores
construtor é a função inicial da classe, sempre que instancido um objeto nesta classe, ele executará a função de mesmo nome da classe.
```dart
class Carro {
  int _velocidade = 0;
  final int vMax;

  Carro([this.vMax = 150]) {} // construror
  ...
}
```

##### Construtor factory
Permite que você instancie subtipos(ou implementacões) desta classe, ou seja, usando o factory numa classe abstrata por exemplo, que não pode ser instanciada, este retornaria uma implementação da classe abstrata que pode ser instanciada

```dart
abstract class AuthService {
  ChatUser? get curretUser;
  Stream<ChatUser?> get userChanges;
  Future<void> signup(
    String name,
    String email,
    String password,
    dynamic image,
  );
  Future<void> login(
    String email,
    String password,
  );
  Future<void> logout();

  factory AuthService() {
    return AuthServiceMock();
  }
}

```

#### Getters and Setters
para atributos privados precisa-se usar getters e setters para manipulalos fora da classe
```dart
class Carro {
  int _velocidade = 0; //atributo privado
  final int vMax;

  ...

  int get velocidade {
    //getter de velocidade
    return this._velocidade;
  }

  void set velocidade(int novaVelocidade) {
    //setter de velocidade
    bool detaValido = (_velocidade - novaVelocidade).abs() <= 5;
    if (detaValido && novaVelocidade >= 0) this._velocidade = novaVelocidade;
  }
  ...
}
```

### Mixins
Mixin funciona como copiar e colar os metodos e propriedades dele para uma classe, dart apenas herda de uma única classe, mixins resolve este problema. Aparentemente classes podem ser usadas como mixins também.

```dart
class Carro {
  int _velocidade = 0;
  int acelerar(){
    _velocidade += 5;
    return _velocidade;
  }
  int frear(){
    _velocidade -= 5;
    return _velocidade;
  }
}

mixin Luxo{
  bool _arLigado = false;
  
  bool ligarAr(){
    _arLigado = true;
    return _arLigado;
  }
  
  bool desligarAr(){ 
    _arLigado= false;
    return _arLigado;
  }
}

mixin Esportivo{
  bool _turboLigado = false;
  
  ligarTubo(){
    _turboLigado = true;
  }
  
  desligarTurbo(){ 
    _turboLigado= false;
  }
}


class Ferrari extends Carro with Esportivo, Luxo{
  @override
  int acelerar(){
    if(_turboLigado){
      super.acelerar();
    }
    return super.acelerar();
  }
}
class Gol extends Carro{}

void main() {
  final c1 = Ferrari(); 
  print('---- Ferrari ----');
  print(c1.ligarAr());
  print(c1.acelerar());
  print('-- Ligar turbo --');
  c1.ligarTubo();
  print(c1.acelerar());
  print(c1.frear());
  print(c1.frear());
  print(c1.frear());
  
  final c2 = Gol();
  print('---- Gol ----');
  print(c2.acelerar());
  print(c2.acelerar());
  print(c2.frear());
  print(c2.frear());
}

```

### Composição
Exemplo:
```dart
import './modelo/venda.dart';
import 'modelo/cliente.dart';
import 'modelo/item_venda.dart';
import 'modelo/produto.dart';

main(List<String> args) {
  Venda venda = Venda(
      cliente: Cliente(
        nome: 'Rene Teste Dart',
        cpf: '123.456.789.01',
      ),
      itens: <ItemVenda>[
        ItemVenda(
            produto: Produto(
                codigo: 1234, nome: 'notebook', preco: 4000.00, desconto: 0.15),
            quantidade: 1),
        ItemVenda(
            produto: Produto(
                codigo: 2345, nome: 'monitor', preco: 700.00, desconto: 0.2),
            quantidade: 1),
        ItemVenda(
            produto: Produto(
              codigo: 3456,
              nome: 'mouse',
              preco: 30.00,
            ),
            quantidade: 2)
      ]);

  for (ItemVenda item in venda.itens) {
    print(
        '-cod:${item.produto.codigo} nome:${item.produto.nome} preco:${item.produto.preco}');
  }
  print('O valor total da venda é R\$${venda.valorTotal}');
}

```

### Cascade operator
funciona similar ao curring do javascript em questões de retorno da função

```dart
void main(){
  Lint<int> a = [1, 2, 3];
  a.add(4)
  a.add(5)
  a.add(6)

  // ou usando o cascade operator
  a.add(4)..add(5)..add(6)

}
```