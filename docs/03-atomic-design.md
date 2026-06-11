# Atomic Design

> [[02-architecture|← Arquitectura]] | [[docs/README|Índice]] | [[04-platform-channels|Siguiente: Platform Channels →]]

## Metodología

La UI se organiza siguiendo el sistema Atomic Design de Brad Frost. Esta organización se encuentra en `[[../lib/presentation/ui/|lib/presentation/ui/]]`.

### Átomos
Componentes más básicos, no se pueden descomponer más.

- `[[../lib/presentation/ui/atoms/pin_app_text.dart|PinAppText]]`: Texto con estilos de la app
- `[[../lib/presentation/ui/atoms/pin_app_button.dart|PinAppButton]]`: Botón con estilos de la app
- `[[../lib/presentation/ui/atoms/like_icon.dart|LikeIcon]]`: Icono de like
- `[[../lib/presentation/ui/atoms/search_input.dart|SearchInput]]`: Campo de búsqueda
- `[[../lib/presentation/ui/atoms/badge_count.dart|BadgeCount]]`: Badge de contador

### Moléculas
Combinaciones de átomos que forman componentes funcionales.

- `[[../lib/presentation/ui/molecules/post_card.dart|PostCard]]`: Card de post con título, body, y like button
- `[[../lib/presentation/ui/molecules/search_bar.dart|PostSearchBar]]`: Barra de búsqueda con icono y campo
- `[[../lib/presentation/ui/molecules/comment_tile.dart|CommentTile]]`: Tile de comentario con nombre, email, body
- `[[../lib/presentation/ui/molecules/like_button.dart|LikeButton]]`: Botón de like con icono y contador

### Organismos
Secciones de UI que combinan moléculas.

- `[[../lib/presentation/ui/organisms/post_list.dart|PostList]]`: Lista de posts con scroll
- `[[../lib/presentation/ui/organisms/post_detail.dart|PostDetail]]`: Detalle de post con comentarios

### Templates
Layouts de página que definen la estructura.

- `[[../lib/presentation/ui/templates/home_template.dart|HomeTemplate]]`: Layout de home (AppBar + lista)
- `[[../lib/presentation/ui/templates/detail_template.dart|DetailTemplate]]`: Layout de detalle (AppBar + contenido)

### Páginas
Pantallas completas que usan templates.

- `[[../lib/presentation/ui/pages/home_page.dart|HomePage]]`: Página de listado de posts
- `[[../lib/presentation/ui/pages/detail_page.dart|DetailPage]]`: Página de detalle de post

## Reglas

1. **No saltos**: Un átomo no puede usar una molécula. Solo puede usar otros átomos.
2. **Composición**: Los componentes se componen, no heredan.
3. **Independencia**: Cada componente debe ser independiente y testeable.
4. **Reutilización**: Los átomos se reutilizan en múltiples moléculas.

## Ejemplo de Jerarquía

```
HomePage
└── HomeTemplate
    └── PostList (Organismo)
        └── PostCard (Molécula)
            ├── PinAppText (Átomo)
            ├── PinAppText (Átomo)
            └── LikeButton (Molécula)
                ├── LikeIcon (Átomo)
                └── PinAppText (Átomo)
```

---

## Referencias

- [[02-architecture|Arquitectura]]
- [[04-platform-channels|Platform Channels]]
- [[05-testing|Testing]]
- [[../lib/presentation/ui/|Código fuente de la UI]]
