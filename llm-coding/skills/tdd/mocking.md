# When to Mock

Mock at **system boundaries** only:

- External APIs (payment, email, etc.)
- Databases (sometimes - prefer test DB)
- Time/randomness
- File system (sometimes)

Don't mock:

- Your own classes/modules
- Internal collaborators
- Anything you control

## Designing for Mockability

At system boundaries, design interfaces that are easy to mock:

**1. Use dependency injection**

Pass external dependencies in rather than creating them internally:

```python
# Easy to mock
def process_payment(order, payment_client):
    return payment_client.charge(order.total)


# Hard to mock
def process_payment(order):
    client = StripeClient(os.environ["STRIPE_KEY"])
    return client.charge(order.total)
```

**2. Prefer SDK-style interfaces over generic fetchers**

Create specific methods for each external operation instead of one generic method with conditional logic:

```python
# GOOD: Each method is independently mockable
class APIClient:
    def __init__(self, http_client):
        self.http_client = http_client

    def get_user(self, user_id):
        return self.http_client.get(f"/users/{user_id}")

    def get_orders(self, user_id):
        return self.http_client.get(f"/users/{user_id}/orders")

    def create_order(self, data):
        return self.http_client.post("/orders", json=data)


# BAD: Mocking requires conditional logic inside the mock
class APIClient:
    def __init__(self, http_client):
        self.http_client = http_client

    def fetch(self, endpoint, **options):
        return self.http_client.request(endpoint=endpoint, **options)
```

The SDK approach means:

- Each mock returns one specific shape
- No conditional logic in test setup
- Easier to see which endpoints a test exercises
- Type safety per endpoint
