# MyApp HTTP Client Demo

This demo application showcases how to perform HTTP requests to an API endpoint in Elixir using two different approaches:

1. **HTTPoison** – a popular, community-supported HTTP client.
2. **:httpc** – the built-in Erlang HTTP client (no extra library required).

It also demonstrates how to parse a relatively deep and complex JSON response and transform it into a list of predefined, compile-time structs.

---

## Overview

The solution is designed as a starting point or demo for building robust HTTP client modules in Elixir. It illustrates:

- **Making HTTP requests:** Two implementations show how you can use both an external library (HTTPoison) and the built-in Erlang client (`:httpc`).
- **JSON Parsing:** Using [Jason](https://github.com/michalmuskala/jason) to decode JSON and transform nested data into domain-specific structs.
- **Structs with `@enforce_keys`:** Defining compile-time structs (`MyApp.Item`, `MyApp.Detail`, and `MyApp.Metadata`) with enforced keys to ensure data integrity.
- **Error Handling:** Consistent and descriptive error messages for unexpected HTTP status codes and other error conditions.
- **Testing:** A comprehensive test suite using [ExUnit](https://hexdocs.pm/ex_unit/ExUnit.html) and [Bypass](https://github.com/PSPDFKit-labs/bypass) to simulate external API responses.

---

## Project Structure

- **`lib/my_app/item.ex`**
  Defines the domain-specific structs:
  - `MyApp.Metadata`
  - `MyApp.Detail`
  - `MyApp.Item`

  Using `@enforce_keys` ensures that every instance of these structs contains all necessary fields. This helps maintain data consistency throughout your application.

- **`lib/my_app/parser.ex`**
  Contains the parser logic that:
  - Decodes the JSON response using Jason.
  - Transforms nested maps into the defined structs.

  Separating the parsing logic from the HTTP client allows for better modularity and easier testing. The parser uses pattern matching and private helper functions to cleanly build the structs.

- **`lib/my_app/api_client.ex`**
  Implements two functions to fetch items:
  - `fetch_items/1`: Uses HTTPoison.
  - `fetch_items_httpc/1`: Uses Erlang's `:httpc`.

  This module illustrates two approaches for making HTTP requests. Both functions handle non-200 HTTP responses and errors gracefully by returning consistent error tuples, making it easier for the caller to handle unexpected scenarios.

- **`test/my_app/api_client_test.exs`**
  A realistic test suite using ExUnit and Bypass to simulate external HTTP responses.

  The tests cover both the happy path (successful API responses) and error scenarios. Bypass allows you to simulate various HTTP responses without hitting a real API, ensuring reliable and fast tests.

---

## Key Design Considerations

- **Modularity:**
  Each module has a clear responsibility. Domain models, parsing logic, and HTTP requests are separated, making the code easier to maintain and extend.

- **Error Handling:**
  Both HTTP client implementations handle errors explicitly. This includes handling unexpected HTTP status codes and network errors. Clear error messages facilitate debugging.

- **Testability:**
  By using Bypass and writing comprehensive tests, the solution ensures that the application behaves as expected even when interacting with an external API.

- **Flexibility:**
  Providing two different HTTP client approaches allows developers to choose the one that best fits their needs. It also serves as a learning tool to understand the trade-offs between using a third-party library and the built-in Erlang tools.

---

## Getting Started

### Prerequisites

- Elixir (>= 1.10)
- Erlang/OTP
- [Mix](https://hexdocs.pm/mix/Mix.html) (included with Elixir)

### Dependencies

This project depends on:

- [`httpoison`](https://github.com/edgurgel/httpoison) for HTTP requests.
- [`jason`](https://github.com/michalmuskala/jason) for JSON parsing.
- [`bypass`](https://github.com/PSPDFKit-labs/bypass) for testing (only required in the test environment).

To install the dependencies, run:

    mix deps.get

Additional dev tooling:

- [`mix test.watch`](https://github.com/lpil/mix-test.watch) to run the tests automatically.
- [`mix dialyzer`](https://github.com/jeremyjh/dialyxir) to run static analysis.
