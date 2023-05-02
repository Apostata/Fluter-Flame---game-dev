# Stream
É uma saquência de dados no qual os valores são gerados sob demanda  

Exemplo de Stream:

```dart
void main() {
  final intStream = Stream<int>.periodic( // tipo periodico de x em x tempos
    Duration(seconds:2), // de 2 em 2 segundos
    (indice) => indice + 1, // função callback
  ).take(10); // de 2 em 2 segundos 10 vezes
  
  intStream.listen((valor){
    print('O valor gerado é: $valor');
  });
}
```
exemplo de stream mais manual e infinita:
```dart
import 'dart:async';

void main() {
  
  final intStream = Stream<int>.multi((controller){
    int valor = 0;
    Timer.periodic(
      Duration(seconds:1),
      (_)=> controller.add(valor++)
    );
  });
  
  intStream.listen((valor){
    print('O valor gerado é: $valor');
  });
}
```
