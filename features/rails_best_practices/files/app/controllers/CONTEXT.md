# Controllers

Controllers parse input, call one service, render a view. Nothing else.

## Rules

- No business logic. Call a service object in `app/services`. Never call repos or relations directly.
- Parameters: use `params.expect`. Never `params.require(...).permit(...)`.
- Responses: render Jbuilder views in `app/views`. Do not build JSON in the controller.
- Actions: RESTful only (`index`, `show`, `create`, `update`, `destroy`). A non-RESTful verb becomes a new resource and controller.
- Errors: map exceptions to responses with `rescue_from` in `ApplicationController`. No per-action `rescue`.
- Authentication and authorization: `before_action` filters only. Never inline in an action.
- Namespacing: versioned, e.g. `Api::V1::OrdersController`. Views mirror the namespace.

## Shared behavior

See `concerns/CONTEXT.md`.
