`initState` runs multiple times primarily because the widget is being completely destroyed (**disposed**) and **recreated** from scratch, rather than just updating its existing state.

Several common architectural triggers cause this behavior, especially when working with advanced routers and shell layouts:

1. **Navigation and Branch Switching:** When you navigate away from a screen or switch tabs in a shell layout (like `KaiselBranchedShell`), the router often disposes of the old screen's widget tree to free up memory. When you return to that screen, Flutter instantiates a brand new widget object, which naturally triggers a fresh `initState`.
2. **Parent Widget Re-instantiation:** If a parent widget rebuilds and instantiates a new copy of your screen without a `const` constructor—or if its constructor parameters change—Flutter treats it as a completely new widget, tearing down the old state and creating a fresh one.
3. **Router Re-evaluation on State Changes:** Whenever a global state changes (like your BLoC emitting a new state or a theme update), the router configuration or page builder might re-evaluate the active route. If the builder constructs a new widget instance instead of reusing a cached one, the lifecycle restarts.

Using a static flag or handling side effects via BLoC listeners rather than UI lifecycle methods is typically how you prevent actions (like showing modals or firing analytics events) from duplicating every time a widget gets remounted.
