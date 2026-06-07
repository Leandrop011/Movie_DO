<div align="center">

<img src="assets/logo_app/logo1.png" alt="Movie DO" width="120"/>

# Movie DO

Aplicación móvil para explorar películas, ver trailers y descubrir los últimos estrenos, construida con Flutter.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![TMDB](https://img.shields.io/badge/API-TMDB-01B4E4?logo=themoviedatabase&logoColor=white)](https://www.themoviedb.org)

</div>

---

## Descripción

Movie DO es una aplicación móvil desarrollada con Flutter que permite a los usuarios explorar películas populares, próximos estrenos y las mejor valoradas. Consume la API de TMDB para obtener información actualizada, permite reproducir trailers directamente y ofrece accesos directos desde el launcher mediante Quick Actions.

## Funcionalidades

- Exploración de películas: populares, en cartelera y mejor valoradas (TMDB API)
- Reproducción de trailers integrada con YouTube Player
- Quick Actions: accesos directos desde el ícono de la app en el launcher
- Persistencia de sesión: recuerda la última película vista con SharedPreferences

## Tecnologías

| Categoría          | Tecnología                |
| ------------------ | ------------------------- |
| Framework          | Flutter                   |
| State Management   | Riverpod                  |
| Navegación         | GoRouter                  |
| API                | TMDB API                  |
| Video              | youtube_player_flutter    |
| Accesos directos   | quick_actions             |
| Persistencia local | shared_preferences        |

## Instalación

```bash
# 1. Clonar el repositorio
git clone https://github.com/Leandrop011/Movie_DO.git
cd Movie_DO

# 2. Instalar dependencias
flutter pub get

# 3. Configurar variables de entorno (ver sección Configuración)

# 4. Correr la app
flutter run
```

## Configuración (Dev)

1. Copiar el archivo `.env.template` y renombrarlo a `.env`
2. Reemplazar las variables de entorno con tus credenciales de [The Movie DB](https://www.themoviedb.org/settings/api)

```env
THE_MOVIEDB_KEY=tu_api_key_aqui
```

## Producción

Cambiar el nombre del paquete de la aplicación (debe estar en `dev_dependencies`):

```bash
flutter pub run change_app_package_name:main com.[nombre]_app
```

Generar el ícono de la aplicación:

```bash
dart run flutter_launcher_icons
```

Generar el Splash Screen:

```bash
dart run flutter_native_splash:create
```

Compilar el Android App Bundle (AAB) para publicar en Google Play:

```bash
flutter build appbundle
```

## Deep Linking

Obtener el SHA-256 necesario para configurar los deep links:

```bash
cd android
./gradlew signingReport
```

Copiar el SHA-256 generado y pegarlo en la app web para completar el proceso de deep linking.
