# Crashlytcs

Usado para Capturar erros que nós desenvolvedores não sabemos que tem na aplicação. registrando erros em tempo real da aplicação e gerando relatórios para o desenvolvedor.
Quando criar um projeto no Firebase, necessita deixar o O Analytics ativado para que o Crashlytics funcione.

## Configurando crashlytics

Antrar na aba crashlytics

## configurando na aplicação (java ou kotlin, IOS ou Unity)

Clicar em ativar o crashlytcs. já está escutando os erros porém precisamos confirar na aplicação

link para de como configurar em cada plataforma: https://firebase.google.com/docs/crashlytics/get-started


## instalando as dependencias

`flutter pub add firebase_core` 
`flutter pub add firebase_crashlytics`

no `main.dart`:

## implmentando
diz ao flutter para delegar para o Firebase Crashlytics cuidar do erro.

**por padrão o crashlytics captura erro de applicativo mas não de HTTP.**

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(const ByteBankApp());
}
```

## Implmentando captura de erros

Exemplo de uma função que faz um POST numa api retornando as Exceções
```dart
void _save(
    Transaction transactionCreated,
    String? password,
    BuildContext context,
  ) async {
    setState(() {
      _loading = true;
    });
    try {
      await widget.transactionService.save( //função que chama api
        transactionCreated,
        password,
      );
      await showSuccessDialog(context, message: 'Success Transaction');
      Navigator.pop(context);
    } on TimeoutException catch (e) {
      FirebaseCrashlytics.instance.setCustomKey('exception', e.toString());
      FirebaseCrashlytics.instance
          .setCustomKey('http-body', transactionCreated.toString());
      FirebaseCrashlytics.instance.setCustomKey('http-code', 'not present');
      FirebaseCrashlytics.instance.recordError(e, null);
      showErrorDialog(context, message: 'Timeout submitting transaction');
    } on HttpException catch (e) {
      FirebaseCrashlytics.instance.setCustomKey('exception', e.toString());
      FirebaseCrashlytics.instance
          .setCustomKey('http-body', transactionCreated.toString());
      FirebaseCrashlytics.instance.setCustomKey('http-code', e.statusCode!);
      FirebaseCrashlytics.instance.recordError(e, null);
      showErrorDialog(context, message: e.message);
    } catch (e) {
      FirebaseCrashlytics.instance.setCustomKey('exception', e.toString());
      FirebaseCrashlytics.instance
          .setCustomKey('http-body', transactionCreated.toString());
      FirebaseCrashlytics.instance.setCustomKey('http-code', 'not present');
      FirebaseCrashlytics.instance.recordError(e, null);
      showErrorDialog(context);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
```

## Modo debug
No `main.dart`:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FirebaseCrashlytics.instance.setUserIdentifier('rene123');
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }

  runApp(const ByteBankApp());
}
```
na implementação verificar se o crashlytics está habilitado:
```dart
void sendCrashalytics(error, String serviceInstanceString) {
  if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
    final bool isHttpException = error is HttpException; // HttpException é um erro customizado
    final int statusCode = isHttpException ? error.statusCode! : 0;
    final String message = isHttpException ? error.message : error.toString();

    FirebaseCrashlytics.instance.setCustomKey('exception', message);
    FirebaseCrashlytics.instance
        .setCustomKey('http-body', serviceInstanceString);
    FirebaseCrashlytics.instance.setCustomKey('http-code', statusCode);
    FirebaseCrashlytics.instance.recordError(error, null);
  }
}
```

## Zoned Error
Erro específicos de certo segmento, por exemplo erros de uma tela em específico
`runZonedGuarded(()async{ zona }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack))`

```dart
void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      FirebaseCrashlytics.instance.setUserIdentifier('rene123');
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }

    runApp(const ByteBankApp());
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}
```