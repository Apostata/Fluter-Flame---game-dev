# Animação

## Tikers
são classes que chamam um callback para cada frame da animação. Por padrão o flutter tem 60 frames por segundo.


## Animação Manual
1. Adicionar o mixing to Tiker no componente `SingleTickerProviderStateMixin`, neste caso é apenas uma animação em um componente do tipo `stateFull` 
2. Criar um controler para a animação `AnimationController? _animationController;`
3. Criar uma variavel que conterá um valor a ser animado `Animation<Size>? _heightAnim;` 
4. configurar o controller da animação, no metodo `initState()`
5. 1. aparentemente necessário chamar o metodo `setState()` para inicializar a animação
6. leberar os listeners da animacão no metodo `dispose()` 
7. Adicionar a a Variavel com o valor a ser animado ao componente
8. Criar um handler para chamar as transições de estados da animação. neste caso o metoto `_switchAuthMode()`

**NOTA: `SingleTickerProviderStateMixin` é para quanto tem apenas um controler de animaçãp, caso tenha mais de um utilizar o `TickerProviderStateMixin`**


Exemplo de animação simples de altura:

```dart
import 'package:flutter/material.dart';
...
enum EAuthMode { Singup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  EAuthMode _authMode = EAuthMode.Login;
  ...
  AnimationController? _animationController;
  Animation<Size>? _heightAnim;


  ...

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 200,
        ));
    _heightAnim = Tween(
      begin: const Size(double.infinity, 320),
      end: const Size(double.infinity, 400),
    ).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.linear,
      ),
    );

    _heightAnim?.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController?.dispose();
  }

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = EAuthMode.Singup;
        _animationController?.forward();
      } else {
        _authMode = EAuthMode.Login;
        _animationController?.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      // height: _isLogin() ? 320 : 400,
      height: _heightAnim?.value.height ?? (_isLogin() ? 320 : 400),
      width: deviceSize.width * 0.75,
      constraints: const BoxConstraints(
        maxWidth: 375,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 10,
              offset: Offset(0, 4),
              spreadRadius: -1.0,
            )
          ]),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ...
                TextButton(
                  onPressed: () {
                    _switchAuthMode();
                  },
                  child: Text(_isLogin()
                      ? 'Não possui uma conta? Registre-se!'
                      : 'Já possui uma conta?'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

## AnimatedBuilder
Similar ao processo manual 

```dart
import 'package:flutter/material.dart';
...
enum EAuthMode { Singup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  EAuthMode _authMode = EAuthMode.Login;
  ...
  AnimationController? _animationController;
  Animation<Size>? _heightAnim;

  ...

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 200,
        ));
    _heightAnim = Tween(
      begin: const Size(double.infinity, 320),
      end: const Size(double.infinity, 400),
    ).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController?.dispose();
  }

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = EAuthMode.Singup;
        _animationController?.forward();
      } else {
        _authMode = EAuthMode.Login;
        _animationController?.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return AnimatedBuilder(
        animation: _heightAnim!,
        builder: (ctx, childForm) => 
          Container(
            // height: _isLogin() ? 320 : 400,
            height: _heightAnim?.value.height ?? (_isLogin() ? 320 : 400),
            width: deviceSize.width * 0.75,
            constraints: const BoxConstraints(
              maxWidth: 375,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                  spreadRadius: -1.0,
                )
              ],
            ),
            child: childForm
          ),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  ..
                  TextButton(
                    onPressed: () {
                      _switchAuthMode();
                    },
                    child: Text(_isLogin()
                        ? 'Não possui uma conta? Registre-se!'
                        : 'Já possui uma conta?'),
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }
}
```

## AnimatedContainer

```dart
import 'package:flutter/material.dart';
...
enum EAuthMode { Singup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  EAuthMode _authMode = EAuthMode.Login;
  ...
  AnimationController? _animationController;
  Animation<Size>? _heightAnim;

  ...

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = EAuthMode.Singup;
      } else {
        _authMode = EAuthMode.Login;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
      // height: _isLogin() ? 320 : 400,
      height: _isLogin() ? 320 : 400,
      width: deviceSize.width * 0.75,
      constraints: const BoxConstraints(
        maxWidth: 375,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 10,
            offset: Offset(0, 4),
            spreadRadius: -1.0,
          )
        ],
      ),
        child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  ...
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      _switchAuthMode();
                    },
                    child: Text(_isLogin()
                        ? 'Não possui uma conta? Registre-se!'
                        : 'Já possui uma conta?'),
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }
}
```

## Transição fadeIn em imagesns

```dart
  FadeInImage(
    placeholder: const AssetImage('assets/images/product-placeholder.png'), // imagem padrão até a imagem do produto ser carregada
    image: NetworkImage(
      product.imageUrl, //variavel que vem a imagem do produto
    ),
    fit: BoxFit.cover,
  ),
```

## Custom route trasition animation
Criar uma classe Customizada que extenda de `PageTransitionBuilder`, retornando o tipo de animação e os widget filho (child):

```dart
class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route, 
    BuildContext context, 
    Animation<double> animation, 
    Animation<double> secondaryAnimation, 
    Widget child
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
```

No arquivo onde está o tema da aplicação, mudar os builders do `pageTransitionTheme` da plataforma que queira mostrar a nova amimação

```dart
 import 'package:flutter/material.dart';
import 'package:shop/helpers/Custom_route_transition.dart';

final theme = ThemeData(
  backgroundColor: Colors.grey[200],
  colorScheme: ColorScheme
  .fromSwatch(
    primarySwatch: Colors.purple,
  )
  .copyWith(
    secondary: Colors.deepOrange,
  ),
  fontFamily: 'Lato',
  pageTransitionsTheme: PageTransitionsTheme(
    builders: {
      TargetPlatform.macOS: CustomPageTransitionBuilder(),
    }
  )
);


```