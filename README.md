# movies_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Dev
1. Copiar el .env.template y renombrarlo a .env 
2. Cambiar las variables de entorno (The MovieDB) 


# Prod
Para cmabiar el nombre de la Aplicacion
```
<!-- ! DEBE SER PARTE DE DEV DEPENDENCIES -->
change_app_package_name <--- paquete
flutter pub run change_app_package_name:main com.leoVeloper.movies_app
```

Para Cambiar el icono de la aplicacion
```
dart run flutter_launcher_icons
```

Para Cambiar el Splash Screen
```
dart run flutter_native_splash:create
```

Adroid AAB
```
flutter build appbundle
```

Obtener sha-256 para deep-linking
```
cd android
./gradlew signingReport
copiar el sha y pegarlo en la app web
```
