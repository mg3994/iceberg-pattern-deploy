---
name: Adaptive Precision
colors:
  surface: '#fdf8fd'
  surface-dim: '#ddd9de'
  surface-bright: '#fdf8fd'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f7f2f8'
  surface-container: '#f1ecf2'
  surface-container-high: '#ebe7ec'
  surface-container-highest: '#e5e1e7'
  on-surface: '#1c1b1f'
  on-surface-variant: '#494551'
  inverse-surface: '#313034'
  inverse-on-surface: '#f4eff5'
  outline: '#7a7582'
  outline-variant: '#cbc4d2'
  surface-tint: '#6750a4'
  primary: '#4f378a'
  on-primary: '#ffffff'
  primary-container: '#6750a4'
  on-primary-container: '#e0d2ff'
  inverse-primary: '#cfbcff'
  secondary: '#625b71'
  on-secondary: '#ffffff'
  secondary-container: '#e8def9'
  on-secondary-container: '#686177'
  tertiary: '#633b48'
  on-tertiary: '#ffffff'
  tertiary-container: '#7d5260'
  on-tertiary-container: '#ffcbda'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e9ddff'
  primary-fixed-dim: '#cfbcff'
  on-primary-fixed: '#22005d'
  on-primary-fixed-variant: '#4f378a'
  secondary-fixed: '#e8def9'
  secondary-fixed-dim: '#ccc2dc'
  on-secondary-fixed: '#1e192b'
  on-secondary-fixed-variant: '#4a4358'
  tertiary-fixed: '#ffd9e3'
  tertiary-fixed-dim: '#eeb8c8'
  on-tertiary-fixed: '#31111d'
  on-tertiary-fixed-variant: '#633b48'
  background: '#fdf8fd'
  on-background: '#1c1b1f'
  surface-variant: '#e5e1e7'
typography:
  headline-lg:
    fontFamily: Hanken Grotesk
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
  headline-md:
    fontFamily: Hanken Grotesk
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
  title-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '500'
    lineHeight: 24px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
    letterSpacing: 0.5px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
    letterSpacing: 0.25px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.1px
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.5px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  margin-mobile: 1rem
  gutter-md: 1rem
  stack-sm: 0.5rem
  stack-md: 1rem
  stack-lg: 1.5rem
  touch-target-min: 48px
---

## Brand & Style
The design system is rooted in **Corporate Modernism** with a heavy influence from Material 3 principles. It prioritizes clarity, accessibility, and professional utility. The target audience includes power users and professionals who require a high degree of personalization without sacrificing systematic order.

The emotional response should be one of **trust and effortless control**. The UI utilizes a neutral foundation to allow dynamic accent colors to take center stage, ensuring the interface feels native to the user's personal preference while maintaining structural integrity through consistent spacing and refined geometry.

## Colors
The color system follows a dynamic mapping logic. The **Primary** color serves as the main interactive accent (buttons, active states, switches), while the **Neutral** palette handles surfaces, text, and borders.

- **Primary**: The signature accent. In a settings context, this is used for active toggles, selected segmented buttons, and primary actions.
- **Neutral**: Uses a "Neutral Variant" approach for secondary text and borders to reduce visual harshness.
- **Surfaces**: Use a subtle tint of the primary color in the background (Surface Channels) to create a cohesive, branded environment even in neutral states.

## Typography
The typography uses **Hanken Grotesk** for high-level headings to provide a sharp, contemporary character, while **Inter** is utilized for all functional text to ensure maximum legibility and accessibility.

Hierarchy is strictly maintained through weight and letter spacing. Labels for settings categories should use `label-sm` in all-caps with the specified letter spacing to create clear section breaks. Body text handles the bulk of the descriptive content, ensuring touch targets remain readable and clear.

## Layout & Spacing
The layout follows a **Fluid Grid** model optimized for mobile-first interaction.

- **Margins**: A standard 16px (1rem) margin is applied to the left and right of the screen.
- **Vertical Rhythm**: Elements are stacked using an 8px base grid. Settings items have a minimum height of 56px to ensure they exceed the 48px minimum touch target requirement.
- **Grouping**: Related settings are grouped into cards with 16px of internal padding and 24px of spacing between separate card groups.

## Elevation & Depth
This design system utilizes **Tonal Layering** combined with subtle shadows to define hierarchy.

- **Level 0 (Base)**: The background uses a flat, neutral-light color.
- **Level 1 (Cards)**: Settings cards use a slightly elevated surface with a soft, diffused shadow (4px blur, 2% opacity) or a subtle 1px border in a neutral-variant tone.
- **Level 2 (Modals/Overlays)**: Higher elevation with 8px-12px blur shadows to indicate temporary interaction states.
- **Interactive States**: Buttons utilize a tonal overlay (hover/pressed) rather than a shadow change to maintain a clean, flat aesthetic.

## Shapes
The shape language is defined by **Rounded** geometry.

- **Cards & Containers**: Use `rounded-lg` (16px) to create a friendly, modern container for settings groups.
- **Buttons & Inputs**: Use `rounded-md` (8px) for a more precise, functional look.
- **Color Swatches**: Strictly circular (50% radius) to differentiate them from functional buttons.
- **Selection Indicators**: Active states in segmented buttons use a nested `rounded-md` shape to create a "pill" within a container effect.

## Components
### Segmented Buttons
Used for switching between 2-3 discrete options (e.g., Light/Dark/System). The container has a subtle border, and the active segment is filled with the Primary color with high-contrast text.

### Color Swatches
Circular UI elements presented in a horizontal scroll or grid. The active swatch is indicated by a centered checkmark icon or a high-contrast outer ring with a 2px gap (donut effect).

### Settings Cards
A vertical list of items. Each item includes:
- **Leading Icon**: Optional, 24px size, centered in a 40px clear area.
- **Content**: Title (`body-lg`) and optional Description (`body-md` in secondary color).
- **Trailing Element**: Switches, radio buttons, or a chevron for navigation.
- **Dividers**: 1px height, inset to align with the text content (skipping the icon).

### Input Fields
Outlined style with `rounded-md` corners. Labels should be floating or positioned consistently above the field.

### Switches
Standard Material 3 toggle style, using the Primary color for the "On" state and a neutral-grey for "Off".