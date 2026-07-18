# Good and Bad Tests

## Good Tests

Test one coherent behavior through a public interface. A good test names the outcome and remains valid when internals change.

```python
# GOOD: Tests observable behavior
def test_user_can_checkout_with_valid_cart(product, payment_method):
    cart = create_cart()
    cart.add(product)
    result = checkout(cart, payment_method)
    assert result.status == "confirmed"
```

## Bad Tests

Implementation-coupled tests mock internal collaborators, test private methods, assert call structure, or describe how instead of what. They fail when internals change without a behavior change.

```python
# BAD: Tests implementation details
def test_checkout_calls_payment_service_process(mocker, cart, payment):
    process = mocker.patch.object(payment_service, "process")
    checkout(cart, payment)
    process.assert_called_once_with(cart.total)
```

Tautological tests copy the production algorithm into the expected value. Use a simpler, independently justified oracle such as a specification, worked example, invariant, or known-good literal.

```python
# BAD: Expected value is recomputed the way the code computes it
def test_calculate_total_sums_line_items():
    items = [{"price": 10}, {"price": 5}]
    expected = sum(item["price"] for item in items)
    assert calculate_total(items) == expected


# GOOD: Expected value is an independent, known literal
def test_calculate_total_sums_line_items():
    assert calculate_total([{"price": 10}, {"price": 5}]) == 15
```
