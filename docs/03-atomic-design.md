# Atomic Design

> [[02-architecture|← Arquitectura]] | [[docs/README|Índice]] | [[04-platform-channels|Siguiente: Platform Channels →]]

## Metodología

La UI se organiza siguiendo el sistema Atomic Design de Brad Frost. Todos los componentes de UI (átomos, moléculas, organismos, templates) viven en el package `packages/pinapp_material_ui/`. Solo las páginas (`lib/presentation/ui/pages/`) permanecen en root porque son las que conectan los BLoCs con los templates parametrizados.

```
packages/pinapp_material_ui/lib/ui/  →  atoms + molecules + organisms + templates
lib/presentation/ui/pages/          →  pages (conectan BLoCs → templates)
```

Los organismos y templates siguen el patrón de **Inversión de Dependencias**: no importan BLoCs ni manejan estado directamente. Reciben todos los datos y callbacks como parámetros desde las Pages.

### Átomos
Componentes más básicos, no se pueden descomponer más. Ubicación: `[[../packages/pinapp_material_ui/lib/ui/atoms/|packages/pinapp_material_ui/lib/ui/atoms/]]`.

- `[[../packages/pinapp_material_ui/lib/ui/atoms/pin_app_text.dart|PinAppText]]`: Texto con estilos de la app
- `[[../packages/pinapp_material_ui/lib/ui/atoms/pin_app_button.dart|PinAppButton]]`: Botón con estilos de la app
- `[[../packages/pinapp_material_ui/lib/ui/atoms/like_icon.dart|LikeIcon]]`: Icono de like
- `[[../packages/pinapp_material_ui/lib/ui/atoms/search_input.dart|SearchInput]]`: Campo de búsqueda
- `[[../packages/pinapp_material_ui/lib/ui/atoms/badge_count.dart|BadgeCount]]`: Badge de contador

### Moléculas
Combinaciones de átomos que forman componentes funcionales. Ubicación: `[[../packages/pinapp_material_ui/lib/ui/molecules/|packages/pinapp_material_ui/lib/ui/molecules/]]`.

- `[[../packages/pinapp_material_ui/lib/ui/molecules/post_card.dart|PostCard]]`: Card de post con título, body, y like button
- `[[../packages/pinapp_material_ui/lib/ui/molecules/search_bar.dart|PostSearchBar]]`: Barra de búsqueda con icono y campo
- `[[../packages/pinapp_material_ui/lib/ui/molecules/comment_tile.dart|CommentTile]]`: Tile de comentario con nombre, email, body
- `[[../packages/pinapp_material_ui/lib/ui/molecules/like_button.dart|LikeButton]]`: Botón de like con icono y contador

### Organismos
Secciones de UI que combinan moléculas. Ubicación: `[[../packages/pinapp_material_ui/lib/ui/organisms/|packages/pinapp_material_ui/lib/ui/organisms/]]`.

- `[[../packages/pinapp_material_ui/lib/ui/organisms/post_list.dart|PostList]]`: Lista de posts con scroll — recibe `List<PostItemData>`, `isLoading`, `errorMessage`, y callbacks
- `[[../packages/pinapp_material_ui/lib/ui/organisms/post_detail.dart|PostDetail]]`: Detalle de post con comentarios — recibe `List<CommentItemData>`, `commentsLoading`, `commentsError`, y callbacks

### Templates
Layouts de página que definen la estructura. Ubicación: `[[../packages/pinapp_material_ui/lib/ui/templates/|packages/pinapp_material_ui/lib/ui/templates/]]`.

- `[[../packages/pinapp_material_ui/lib/ui/templates/home_template.dart|HomeTemplate]]`: Layout de home (AppBar + SearchBar + PostList) — parametrizado con datos de posts
- `[[../packages/pinapp_material_ui/lib/ui/templates/detail_template.dart|DetailTemplate]]`: Layout de detalle (AppBar + PostDetail) — parametrizado con datos de post y comentarios

### Páginas
Pantallas completas que conectan BLoCs con templates parametrizados. Ubicación: `[[../lib/presentation/ui/pages/|lib/presentation/ui/pages/]]`.

- `[[../lib/presentation/ui/pages/home_page.dart|HomePage]]`: Página de listado — escucha `PostBloc`, mapea `PostState` a `PostItemData[]`, inyecta callbacks (`onLikeToggle`, `onPostTap`, `onRetry`)
- `[[../lib/presentation/ui/pages/detail_page.dart|DetailPage]]`: Página de detalle — escucha `PostBloc` + `CommentBloc`, mapea a `CommentItemData[]`, inyecta callbacks (`onLikeTap`, `onBackTap`)

## Reglas

1. **No saltos**: Un átomo no puede usar una molécula. Solo puede usar otros átomos.
2. **Composición**: Los componentes se componen, no heredan.
3. **Independencia**: Cada componente debe ser independiente y testeable.
4. **Reutilización**: Los átomos se reutilizan en múltiples moléculas.
5. **Inversión de Dependencias**: Organismos y templates no importan BLoCs. Reciben datos y callbacks desde las Pages.

## Ejemplo de Jerarquía

```
HomePage  (lib/presentation/ui/pages/)
├── postState → PostItemData[]
├── callbacks: onLikeToggle, onPostTap, onRetry
└── HomeTemplate  (packages/pinapp_material_ui/lib/ui/templates/)
    └── PostList  (packages/pinapp_material_ui/lib/ui/organisms/)
        └── PostCard  (packages/pinapp_material_ui/lib/ui/molecules/)
            ├── PinAppText  (packages/pinapp_material_ui/lib/ui/atoms/)
            ├── PinAppText  (packages/pinapp_material_ui/lib/ui/atoms/)
            └── LikeButton  (packages/pinapp_material_ui/lib/ui/molecules/)
                ├── LikeIcon  (packages/pinapp_material_ui/lib/ui/atoms/)
                └── PinAppText  (packages/pinapp_material_ui/lib/ui/atoms/)
```

---

## Referencias

- [[02-architecture|Arquitectura]]
- [[04-platform-channels|Platform Channels]]
- [[05-testing|Testing]]
- [[../lib/presentation/ui/|Código fuente de la UI (root)]]
- [[../packages/pinapp_material_ui/lib/ui/|Código fuente de UI kit (package)]]
