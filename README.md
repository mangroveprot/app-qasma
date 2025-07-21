## Basic Usage

### 1. Import the toast system

```dart
import 'custom_toast.dart';
```

### 2. Quick Methods (Most Common)

```dart
// Success toast
CustomToast.success(
  context: context,
  message: "Operation completed successfully!",
);

// Error toast
CustomToast.error(
  context: context,
  message: "Something went wrong!",
);

// Warning toast
CustomToast.warning(
  context: context,
  message: "This action cannot be undone!",
);

// Info toast
CustomToast.info(
  context: context,
  message: "New update available",
);
```

## Advanced Usage

### 3. Custom Positions

```dart
CustomToast.info(
  context: context,
  message: "Message",
  position: ToastPosition.topCenter,     // topRight, topCenter, center, bottomCenter, bottomRight
);
```

### 4. Custom Duration

```dart
CustomToast.success(
  context: context,
  message: "This stays for 10 seconds",
  duration: const Duration(seconds: 10),
);
```

### 5. With Action Button

```dart
CustomToast.warning(
  context: context,
  message: "File will be deleted",
  actionLabel: "UNDO",
  onAction: () {
    // Handle undo action
    print("Undo clicked!");
  },
);
```

### 6. Custom Settings

```dart
CustomToast.info(
  context: context,
  message: "Custom toast",
  showCloseButton: false,        // Hide close button
  duration: const Duration(seconds: 5),
  position: ToastPosition.center,
);
```

### 7. Using the Main show() Method

```dart
CustomToast.show(
  context,
  message: "Custom toast with heart icon",
  icon: Icons.favorite,          // Custom icon
  type: ToastType.success,       // Apply success styling
  position: ToastPosition.topRight,
  duration: const Duration(seconds: 4),
  actionLabel: "VIEW",
  onAction: () => print("Action pressed"),
  showCloseButton: true,
);
```

## Parameters Explanation

| Parameter         | Type            | Description                       | Default       |
| ----------------- | --------------- | --------------------------------- | ------------- |
| `context`         | `BuildContext`  | Required - Widget context         | -             |
| `message`         | `String`        | Required - Toast message          | -             |
| `icon`            | `IconData?`     | Custom icon (overrides type icon) | `null`        |
| `duration`        | `Duration`      | How long toast stays visible      | 3 seconds     |
| `position`        | `ToastPosition` | Where to show the toast           | `bottomRight` |
| `type`            | `ToastType?`    | Predefined styling                | `null`        |
| `actionLabel`     | `String?`       | Action button text                | `null`        |
| `onAction`        | `VoidCallback?` | Action button callback            | `null`        |
| `showCloseButton` | `bool`          | Show/hide close button            | `true`        |

## Toast Types & Colors

- **Info**: Blue background with info icon
- **Success**: Green background with check icon
- **Warning**: Orange background with warning icon
- **Error**: Red background with error icon
- **Default**: Gray background with custom/no icon

## Positions Available

- `ToastPosition.topRight` - Top right corner
- `ToastPosition.topCenter` - Top center (full width)
- `ToastPosition.center` - Screen center
- `ToastPosition.bottomCenter` - Bottom center (full width)
- `ToastPosition.bottomRight` - Bottom right corner (default)

## Best Practices

1. **Keep messages short** - Toasts auto-truncate after 2 lines
2. **Use appropriate types** - Match the type to the message context
3. **Don't overuse action buttons** - Only for important actions like "Undo"
4. **Consider position** - Bottom positions are less intrusive
5. **Test with multiple toasts** - System handles up to 4 toasts per position
