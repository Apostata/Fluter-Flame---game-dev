## Authenticação
```json
{
  "rules": {
    ".read": "auth != null",
    ".write": "auth != null",
  }
}
```
## instalando Firebase pra uso IOS, Android e web
Basta entrar no console criar um projeto no firebase para seu app e dentro do firebase criar 3 apps, um para cada plataforma, seguindo o passo a passo de instalação e configuração de dependências.

### nota IOS:
 Quem estiver passando pelo problema "CocoaPods's specs repository is too out-of-date to satisfy dependencies." durante o deploy para iOS é por conta que você precisa atualizar algumas questões do CocoaPods. Para fazer isso é bem simples.

Basta abrir a pasta "iOS" dentro do seu projeto no terminal. Ou seja, ter uma janela do terminal apontando para a pasta "iOS" dentro do seu projeto. Com isso feito, utilize o comando →

pod install --repo-update
Isso irá atualizar e instalar as dependências relacionadas ao CocoaPods necessárias.

### nota Android:
Evitar o limite de 64 K

```kotlin
android {
    defaultConfig {
        ...
        minSdk = 15
        targetSdk = 28
        multiDexEnabled = true
    }
    ...
}

dependencies {
    implementation("androidx.multidex:multidex:2.0.1")
}
```

### adicionando pacotes do firebase:
firebase_core: `flutter pub add firebase_core`
cloud_firestore : `flutter pub add cloud_firestore`
firebase_auth : `flutter pub add firebase_auth`



## inicializando a aplicação
```dart
...
import 'package:firebase_core/firebase_core.dart';

class AuthOrChat extends StatelessWidget {
  const AuthOrChat({Key? key}) : super(key: key);

  Future<void> init(BuildContext context) async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(context),
      builder: (fbctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        }
        return StreamBuilder(
          stream: AuthService().userChanges,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingPage();
            } else {
              return snapshot.hasData ? const ChatPage() : const AuthPage();
            }
          },
        );
      },
    );
  }
}

```