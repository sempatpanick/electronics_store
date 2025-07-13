# Cart Functionality Update

## Overview

Updated the cart functionality to treat products with different color/ram/variant/storage selections as separate items in the cart, rather than merging them into a single item.

## Changes Made

### 1. Cart Use Case (`lib/domain/usecases/cart_use_case.dart`)

- **Added `_generateCartItemKey()` method**: Creates a unique key for each product configuration based on product ID and selected options (variant, color, ram, storage)
- **Added `_findExistingCartItem()` method**: Finds existing cart items with the same configuration using the unique key
- **Updated `addToCart()` method**: Now checks for existing items with the same configuration instead of just the same product ID
- **Updated `updateCartItemQuantity()` method**: Now works with cart item IDs instead of product IDs
- **Added `removeCartItem()` method**: Removes specific cart items by their unique ID
- **Kept legacy methods**: `removeFromCart()` and `getCartItemByProductId()` for backward compatibility

### 2. Repository Layer

- **Updated `AppRepository` interface**: Added `removeCartItemById()` and `getCartItemById()` methods
- **Updated `AppRepositoryImpl`**: Implemented the new methods
- **Updated `LocalDataSource` interface**: Added new methods for cart item management
- **Updated `LocalDataSourceImpl`**: Implemented direct cart item removal by ID

### 3. Cart Cubit (`lib/presentation/pages/cart/controllers/cart_cubit.dart`)

- **Updated `removeFromCart()` method**: Now accepts cart item ID instead of product ID
- **Updated `updateQuantity()` method**: Now accepts cart item ID instead of product ID

### 4. Cart Content (`lib/presentation/pages/cart/contents/cart_content.dart`)

- **Updated cart item interactions**: Now passes cart item ID instead of product ID when calling cubit methods

## How It Works

### Before (Old Behavior)

- Products were identified only by their product ID
- Adding the same product with different configurations would update the quantity of the existing item
- All configurations of the same product were merged into one cart item

### After (New Behavior)

- Products are identified by a unique key: `productId:variant|color|ram|storage`
- Adding the same product with different configurations creates separate cart items
- Each configuration maintains its own quantity and can be managed independently

### Example

```
Product: iPhone 15 Pro (ID: "1")

Configuration 1: 128GB, Black, 8GB RAM
Configuration 2: 256GB, White, 12GB RAM

Old behavior: 1 cart item with quantity 2 (merged)
New behavior: 2 separate cart items, each with quantity 1
```

## Key Benefits

1. **Better User Experience**: Users can clearly see different product configurations separately
2. **Accurate Pricing**: Each configuration maintains its own price (e.g., 256GB vs 128GB)
3. **Independent Management**: Users can modify quantities or remove specific configurations
4. **Clear Cart Display**: Cart shows exactly what configurations were selected

## Backward Compatibility

- Legacy methods are preserved for any existing code that might depend on them
- The new functionality is additive and doesn't break existing features
- Cart items created before this update will continue to work normally

## Testing

A test file has been created (`test/cart_functionality_test.dart`) to verify:

- Products with different configurations are treated as separate items
- Same configurations are properly merged (quantity increases)
- Unique keys are generated correctly for different configurations

## Usage

The functionality works automatically when users:

1. Select different options (color, ram, storage, variant) on product detail pages
2. Add products to cart with different configurations
3. View their cart - each configuration appears as a separate line item
4. Modify quantities or remove specific configurations independently
