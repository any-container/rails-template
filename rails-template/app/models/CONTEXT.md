# Models Context

## Best Practices

- ActiveRecord callbacks are only to be used for simple validations.
- Do NOT use callbacks to call other classes.
- Do NOT use callbacks to trigger state changes in the same model.

## Models

| Model | Description |
| --- | --- |
| `ApplicationRecord` | Abstract base class for all models. |
| `Identity` | A person's identity: given name (optional), surname, user email, normalized email and user name. Emails and user name are unique. |
