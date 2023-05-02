# Tratamento de erros

## Interceptando erros
Um exemplo de um consumo de uma api via POST:

```dart
Future<Transaction> save(Transaction transaction, String? password) async {
    final url = Uri.parse(baseUrl);
    final body = jsonEncode(transaction.toJson());

    final Response data = await httpClient.post(
      url,
      headers: {
        'Content-type': 'application/json',
        'password': password!,
      },
      body: body,
    );

    if (data.statusCode == 400) {
      throw HttpException(
          message: 'There was an error submitting transaction!');
    }

    if (data.statusCode == 401) {
      throw Exception('Authentication failed!');
    }

    final dynamic response = jsonDecode(data.body);
    return Transaction.fromJson(response);
  }
```
Note que a duas classes de Exceptions: `HttpException` e `Exception`
a `Exception` é a classe padrão do dart, que recebe uma mensagem via parametro posicional, essa classe é abstrata porém é instanciada uma implementação de `_Exception`.
a `HttpException` é uma classe customizada que implementa a classe abstrata `Execption`

código da classe customizada, onde o metodo `toString()` é sobrescrito da classe `Exception`:
```dart
class HttpException implements Exception {
  final String message;
  // final int statusCode;

  HttpException({required this.message});

  @override
  String toString() {
    return message;
  }
}
```
## tratando os erros
```dart
...
void _save(
    Transaction transactionCreated,
    String? password,
    BuildContext context,
  ) async {
    // await Future.delayed(const Duration(seconds: 1));
    try {
      await widget.transactionService.save(
        transactionCreated,
        password,
      );
      Navigator.pop(context);
    } on HttpException catch (e) {
      showDialog(
          context: context,
          builder: (ctxDialog) {
            return ResponseDialog(
              title: 'Failure',
              message: e.message,
              icon: Icons.warning,
              // buttonText: 'OK',
              colorIcon: Colors.red,
            );
          });
    } catch (error) {
      showDialog(
          context: context,
          builder: (ctxDialog) {
            return ResponseDialog(
              title: 'Failure',
              message: error.toString(),
              icon: Icons.warning,
              // buttonText: 'OK',
              colorIcon: Colors.red,
            );
          });
    } finally {
      // alguma coisa
    }
  }
  ...

  ou
  ```dart
  void _save(
    Transaction transactionCreated,
    String? password,
    BuildContext context,
  ) async {
      await widget.transactionService.save(
        transactionCreated,
        password,
      ).catchError((e) { // erro
      showDialog(
        context: context,
        builder: (ctxDialog) {
          return ResponseDialog(
            title: 'Failure',
            message: e.message,
            icon: Icons.warning,
            // buttonText: 'OK',
            colorIcon: Colors.red,
          );
        },
      );
    });
    //sucesso
    if (transaction != null) {
      await showDialog(
        context: context,
        builder: (ctxDialog) {
          return ResponseDialog(
            title: 'Success',
            message: 'Successful transaction',
            icon: Icons.check,
            // buttonText: 'OK',
            colorIcon: Colors.green,
          );
        },
      );
      Navigator.pop(context);
    }
  }
  ...
```
Como podemos observar podemos pegar erros específicos e dar tratativas diferentes para cada um
