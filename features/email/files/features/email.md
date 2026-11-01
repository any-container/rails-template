---
always_on: false
depends_on: []
gems:
  - name: letter_opener
    version: "~> 1.10"
---
# Email

Shared outbound email. Every feature that sends mail builds its mailer on `ApplicationMailer` and sends with `deliver_later` or from its own job.

- `ApplicationMailer` sends from `EMAIL_SENDER_ADDRESS`, which has no default outside the test environment. Without it a mailer raises `ApplicationMailer::MissingSenderAddress` and sends nothing.
- Mail is never delivered in the request cycle. Mailers must be safe to retry.
- Development writes messages to `tmp/letter_opener/` with `letter_opener`. Production delivery is configured by the host.
- Spec helpers in `spec/support/email.rb`: `last_email`, `email_links(mail)`, `first_email_link(mail)`.
