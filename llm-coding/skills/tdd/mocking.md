# When to Mock

Prefer real dependencies when they are cheap and deterministic. Substitute only **system boundaries**, such as:

- External APIs
- Databases when a test database is impractical
- Time/randomness
- File systems

Do not mock private methods or internal collaborators merely to assert call structure. An application-owned port may be faked when it represents an external, nondeterministic, or expensive boundary.

Inject boundary dependencies rather than constructing them internally:

```python
def process_payment(order, payment_client):
    return payment_client.charge(order.total)


def process_payment(order):
    client = StripeClient(os.environ["STRIPE_KEY"])
    return client.charge(order.total)
```
