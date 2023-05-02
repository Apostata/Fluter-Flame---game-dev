# Flutter 

## instalanção
https://docs.flutter.dev/get-started/install
instalar o `android studio` : https://developer.android.com/studio

## Verificar instalação e setup do projeto
no terminal dentro da pasta do projeto : `flutter doctor`

## concordando com os termos de licensa do android (Android)
no terminal, na pasta do projeto: `flutter doctor --android-licenses`

## verificando se tem algum emulador
`flutter emulators`

## rodando emulador
`flutter emulators --lauch {ID_DO_EMULADOR}`

## rodando o projeto
`flutter run` 

## Suporte para desktop

### windows
instalar o Visual studio com o pacode `Desktop development with C++`
então:
rodar o comando no terminal, na pasta do projeto: `flutter config --enable-windows-desktop`
e
`flutter channel master`
`flutter upgrade`
`flutter config --enable-windows-uwp-desktop`

## Suporte para web
### Criar novo projeto com supporte para web
no terminal, na pasta do projeto: 
`flutter channel stable`
`flutter upgrade`

ao executar o comando `flutter devices`, você irá verificar que terá (se o chrome estiver instalado) o device em chome no edge da mesma forma

Executando em dev : `flutter run -d chrome` 
gerando build : `flutter build web` 

### Adicionando suport web a um projeto já existente
no terminal, na pasta do projeto: `flutter create .`

## HotReload
No curso da Alura o professor comenta em deixar função `main()` da seguinte forma, para que o `HotReload` funcione perfeitamente

```dart
void main() {
  runApp(const ByteBank());
}
```

## Error de minSdk version
Caso algum projeto esteja com erro de minSdk version, pode ser mudado:

_1. Na configuração local do projeto:_
   
   __1.1. no arquivo `android/local.properties`, colocar:__

    ```java
    ...
    flutter.minSdkVersion=21
    ...
    ```
   __1.2 no arquivo `android/app/build.gradle`. alterar__

    ```js
    ...
    defaultConfig {
      //de
      ...
        minSdkVersion flutter.minSdkVersion
      //para
        minSdkVersion localProperties.getProperty('flutter.minSdkVersion').toInteger()
        ...
    }
    ...
    ```
   _
_2. Na configuração global do flutter para todos projetos para usar a versão desejada_
mudar no arquivo `flutter-directory/packages/flutter_tools/gradle/flutter.gradle`

  ```java
  class FlutterExtension {
      /** Sets the compileSdkVersion used by default in Flutter app projects. */
      static int compileSdkVersion = 31

      /** Sets the minSdkVersion used by default in Flutter app projects. */
      static int minSdkVersion = 16 // mudar aqui

      /** Sets the targetSdkVersion used by default in Flutter app projects. */
      static int targetSdkVersion = 31
  ```
  change the value of the minSdkVersion from 16 to 20 or above, and do not disturb the code in build.gradle.