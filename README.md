# Flutter Fake Store CRUD

Aplicación Flutter que implementa un CRUD completo sobre la API pública [Fake Store API](https://fakestoreapi.com/).  
La app incluye: lista con búsqueda y scroll infinito, detalle, formulario para crear/editar, eliminación, manejo de estados y validaciones.

---

## API usada
**Fake Store API** — provee endpoints de ejemplo para productos de una tienda:
- `GET /products` → lista de productos  
- `GET /products/{id}` → detalle  
- `POST /products` → crear  
- `PUT /products/{id}` → actualizar  
- `DELETE /products/{id}` → eliminar  

[Documentación oficial](https://fakestoreapi.com/docs)

---

## Estructura del proyecto
El código fuente se organiza en:
- `lib/models` → modelos de datos  
- `lib/services` → comunicación con la API  
- `lib/providers` → gestión del estado con Provider  
- `lib/screens` → pantallas principales (lista, detalle, formulario)  
- `lib/widgets` → componentes reutilizables  

---

##  Cómo ejecutar el proyecto

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/SantiagoVieira/Flutter_APPI_RESTful.git
   cd Flutter_APPI_RESTful

2. **Instalar dependencias**
    ```bash
    flutter pub get

3. **Ejecutar el proyecto**
    Abre el proyecto en VS Code o Android Studio
    Inicia un emulador (ejemplo: Medium Phone API 36.0)
    Abre el archivo lib/main.dart
    Inicia Debug (F5 en VS Code o botón "Run" en Android Studio)
