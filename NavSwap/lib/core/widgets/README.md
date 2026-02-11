# NavSwap UI Components Library

A comprehensive collection of modern, reusable UI components for the NavSwap battery swapping platform.

## Overview

This library provides a consistent design system with:
- Modern color palette optimized for battery swapping theme
- Smooth animations and transitions
- Glassmorphism effects
- Responsive and accessible components
- Loading and state management widgets

## Color Palette

### Primary Colors
- **Primary Blue**: `#0066FF` - Main brand color
- **Electric Green**: `#00D9A3` - Accent color for energy/battery theme
- **Purple**: `#7B61FF` - Secondary accent

### Status Colors
- **Success**: `#10B981` - Full battery, completed actions
- **Warning**: `#F59E0B` - Medium battery, alerts
- **Error**: `#EF4444` - Low battery, errors
- **Info**: `#3B82F6` - General information

## Components

### 1. Buttons (`custom_button.dart`)

**CustomButton** - A versatile button component with multiple styles

```dart
CustomButton(
  text: 'Get Started',
  onPressed: () {},
  buttonStyle: CustomButtonStyle.primary,
  icon: Icons.arrow_forward,
  isLoading: false,
)
```

**Styles:**
- `primary` - Gradient button with shadow
- `secondary` - Outlined button
- `text` - Text-only button
- `danger` - Red gradient for destructive actions

### 2. Cards (`custom_cards.dart`)

**GlassCard** - Modern card with glassmorphism effects

```dart
GlassCard(
  padding: EdgeInsets.all(16),
  elevation: 1,
  onTap: () {},
  child: YourWidget(),
)
```

**GradientCard** - Card with customizable gradient background

```dart
GradientCard(
  colors: [Color(0xFF0066FF), Color(0xFF00D9A3)],
  child: YourWidget(),
)
```

**ShimmerCard** - Animated loading placeholder

```dart
ShimmerCard(
  width: double.infinity,
  height: 100,
)
```

### 3. Text Fields (`custom_text_field.dart`)

**CustomTextField** - Modern input field with validation

```dart
CustomTextField(
  labelText: 'Phone Number',
  hintText: 'Enter your number',
  prefixIcon: Icons.phone,
  keyboardType: TextInputType.phone,
  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
)
```

**SearchTextField** - Dedicated search input

```dart
SearchTextField(
  hintText: 'Search stations...',
  onChanged: (value) => print(value),
)
```

### 4. Badges (`badges.dart`)

**StatusBadge** - Colored badges for status display

```dart
StatusBadge(
  label: 'Available',
  type: StatusBadgeType.success,
  icon: Icons.check_circle,
)
```

**BatteryIndicator** - Visual battery level display

```dart
BatteryIndicator(
  available: 8,
  total: 10,
  showLabel: true,
)
```

**AvailabilityIndicator** - Animated availability dot

```dart
AvailabilityIndicator(
  isAvailable: true,
  label: 'Open Now',
)
```

**DistanceBadge** - Distance display with location icon

```dart
DistanceBadge(
  distance: '2.5 km',
)
```

### 5. State Widgets (`states.dart`)

**LoadingIndicator** - Centered loading spinner

```dart
LoadingIndicator(
  message: 'Loading stations...',
  size: 48,
)
```

**EmptyState** - Empty state with icon and action

```dart
EmptyState(
  icon: Icons.battery_unknown,
  title: 'No stations found',
  subtitle: 'Try adjusting your search',
  actionLabel: 'Add Station',
  onAction: () {},
)
```

**ErrorState** - Error display with retry option

```dart
ErrorState(
  message: 'Failed to load data',
  onRetry: () {},
)
```

**SuccessState** - Success confirmation screen

```dart
SuccessState(
  title: 'Swap Completed!',
  subtitle: 'Your battery has been swapped successfully',
  actionLabel: 'Continue',
  onAction: () {},
)
```

**SkeletonLoader** - Shimmer loading list

```dart
SkeletonLoader(
  itemCount: 5,
  height: 80,
)
```

## Usage

### Import the library

```dart
import 'package:navswap_app/core/widgets/widgets.dart';
```

Or import specific components:

```dart
import 'package:navswap_app/core/widgets/custom_button.dart';
import 'package:navswap_app/core/widgets/badges.dart';
```

### Example: Building a Station Card

```dart
GlassCard(
  onTap: () => navigateToStation(),
  child: Row(
    children: [
      Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0066FF), Color(0xFF00D9A3)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.ev_station_rounded, color: Colors.white),
      ),
      SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Station Alpha', style: TextStyle(fontWeight: FontWeight.w700)),
            Row(
              children: [
                DistanceBadge(distance: '2.5 km'),
                SizedBox(width: 8),
                BatteryIndicator(available: 8, total: 10),
              ],
            ),
          ],
        ),
      ),
    ],
  ),
)
```

## Design Principles

### 1. Consistency
All components follow the same design language with consistent spacing, colors, and typography.

### 2. Accessibility
- Adequate touch targets (minimum 48x48)
- Clear visual feedback for interactions
- Proper contrast ratios for text

### 3. Performance
- Optimized animations
- Efficient widget rebuilding
- Lazy loading where appropriate

### 4. Responsiveness
- Flexible layouts
- Adaptive spacing
- Works across different screen sizes

## Theming

All colors are defined in `lib/core/theme/app_theme.dart`. Custom components automatically use theme colors but can be overridden if needed.

### Gradients

```dart
// Access theme gradients
AppTheme.primaryGradient
AppTheme.accentGradient
AppTheme.heroGradient
```

### Shadows

```dart
// Apply consistent shadows
AppTheme.softShadow
AppTheme.mediumShadow
AppTheme.heavyShadow
```

## Best Practices

1. **Use semantic naming**: Choose component variants that match their purpose
2. **Maintain consistency**: Use the same components throughout the app
3. **Avoid overriding**: Stick to theme colors unless there's a specific need
4. **Test interactions**: Ensure all interactive components have proper feedback
5. **Consider accessibility**: Always provide tooltips and semantic labels

## Animation Guidelines

- **Quick interactions**: 200-300ms
- **Page transitions**: 400-600ms
- **Loading states**: 1000-1500ms loops
- **Use easing curves**: `Curves.easeOut`, `Curves.easeInOut`

## Contributing

When adding new components:
1. Follow the existing component structure
2. Add comprehensive documentation
3. Include usage examples
4. Export in `widgets.dart`
5. Update this README

## Future Enhancements

- [ ] Dark mode support
- [ ] More animation variants
- [ ] Custom illustration components
- [ ] Data visualization widgets
- [ ] Map-specific components
- [ ] QR scanner UI components
