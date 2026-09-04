# TuganeDesign

The shared design language behind [Auger](https://auger.tugane.com) and
[Vaultkit](https://github.com/tugane/Vaultkit). One palette, one set of components, so
every app looks and behaves like a sibling rather than a cousin.

## What is in it

- **`Palette`**. A complete set of surface, label, separator, accent and status colours,
  resolved explicitly for dark and light rather than borrowed from system semantics, and
  delivered through the SwiftUI environment. Includes darkened `*Text` variants, because
  vivid status colours fall to roughly 2:1 contrast as caption text on a light card.
- **`PillButton` / `LinkButton`**: the action vocabulary, with hover states and the
  pointing-hand cursor every clickable control in the language shows.
- **`card()` / `hoverFill()`**: the container surfaces.
- **`FieldLabel`, `SectionLabel`, `CheckBox`, `Chevron`, `Mascot`**: the small pieces.
- **`NoiseOverlay`**. The film grain that gives large flat surfaces some tooth.
- **`plural()`**. Because the language never ships "1 finding(s)".

## Use it

```swift
.package(url: "https://github.com/tugane/TuganeDesign.git", from: "0.1.0")
```

```swift
import TuganeDesign

@main struct MyApp: App {
    @AppStorage("theme") private var themeRaw = Theme.dark.rawValue
    private var theme: Theme { Theme(rawValue: themeRaw) ?? .dark }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.palette, theme.palette)
                .preferredColorScheme(theme.colorScheme)
                .overlay { NoiseOverlay() }
        }
        .windowStyle(.hiddenTitleBar)   // the language runs edge to edge
    }
}
```

Then read colours from the environment rather than hardcoding them:

```swift
@Environment(\.palette) private var p
...
Text(status).foregroundStyle(p.greenText)     // text variant: legible on light cards
PillButton(title: "Mount", role: .accent) { mount() }
```

## Conventions the components assume

- **Committed theming.** Apps carry their own light/dark toggle and pass the palette
  down; nothing reads `colorScheme` directly, so an in-app theme cannot disagree with
  what is drawn.
- **Explicit type.** Sizes are set in points, not semantic styles, so a card title is
  the same size in every app.
- **Pills never wrap.** A pill states an action and keeps its intrinsic width; the
  surrounding layout gives way.
- **Everything clickable shows the pointing hand.**

## Requirements

macOS 14+, Swift 5.9+.

## License

GPL-3.0-or-later. See [LICENSE](LICENSE) and [COPYRIGHT](COPYRIGHT).
