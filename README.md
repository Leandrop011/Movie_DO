# Movie DO

```
Aplicación móvil para explorar películas, ver trailers 
y descubrir los últimos estrenos, construida con Flutter.
```
![App](assets/logo_app/logo1.png)
![Logo App](assets/logo_app/logo_app_without_fount_with_words_white.png)

# Descripcion
```
Movie Do es una aplicación móvil desarrollada con Flutter que permite a los usuarios explorar películas populares, próximos estrenos y las mejor valoradas. Consume la API de TMDB para obtener información actualizada, permite reproducir trailers directamente, y ofrece accesos directos desde el launcher mediante Quick Actions.
```

# Funcionalidades
```
Exploración de películas — populares, en cartelera y mejor valoradas (TMDB API)
Reproducción de trailers — integración con YouTube Player
Quick Actions — accesos directos desde el ícono de la app en el launcher
Persistencia de sesión — recuerda la última película vista con SharedPreferences
```
# Tecnologias usadas
```
Framework - Flutter
State Management - Riverpod
Navegación - GoRouter
API - TMDB API
Video - youtube_player_flutter 
Quick - Actionsquick_actions
```

# Pasos
```
# 1. Clonar el repositorio
git clone https://github.com/Leandrop011/Movie_DO.git

# 2. Instalar dependencias
flutter pub get

# 3. Configurar variables de entorno

# 4. Correr la app
flutter run
```

# Dev
1. Copiar el .env.template y renombrarlo a .env 
2. Cambiar las variables de entorno (The MovieDB) 


# Prod
Cambiar el nombre de la Aplicacion
```
<!-- ! DEBE SER PARTE DE DEV DEPENDENCIES -->
change_app_package_name <--- paquete
flutter pub run change_app_package_name:main com.[name]_app
```

Cambiar el icono de la aplicacion
```
dart run flutter_launcher_icons
```

Cambiar el Splash Screen
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
copiar el sha y pegarlo en la app web, para el proceso de deeplinking
```


