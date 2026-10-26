# -*- encoding: utf-8 -*-
# stub: net-scp 4.1.2 ruby lib

Gem::Specification.new do |s|
  s.name = "net-scp".freeze
  s.version = "4.1.2".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "changelog_uri" => "https://github.com/net-ssh/net-scp/blob/master/CHANGES.txt" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jamis Buck".freeze, "Delano Mandelbaum".freeze, "Mikl\u00F3s Fazekas".freeze]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDeDCCAmCgAwIBAgIBATANBgkqhkiG9w0BAQsFADBBMQ8wDQYDVQQDDAZuZXRz\nc2gxGTAXBgoJkiaJk/IsZAEZFglzb2x1dGlvdXMxEzARBgoJkiaJk/IsZAEZFgNj\nb20wHhcNMjYwNTE2MTYyMDUzWhcNMjcwNTE2MTYyMDUzWjBBMQ8wDQYDVQQDDAZu\nZXRzc2gxGTAXBgoJkiaJk/IsZAEZFglzb2x1dGlvdXMxEzARBgoJkiaJk/IsZAEZ\nFgNjb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDGJ4TbZ9H+qZ08\npQfJhPJTHaDCyQvCsKTFrL5O9z3tllQ7B/zksMMM+qFBpNYu9HCcg4yBATacE/PB\nqVVyUrpr6lbH/XwoN5ljXm+bdCfmnjZvTCL2FTE6o+bcnaF0IsJyC0Q2B1fbWdXN\n6Off1ZWoUk6We2BIM1bn6QJLxBpGyYhvOPXsYoqSuzDf2SJDDsWFZ8kV5ON13Ohm\nJbBzn0oD8HF8FuYOewwsC0C1q4w7E5GtvHcQ5juweS7+RKsyDcVcVrLuNzoGRttS\nKP4yMn+TzaXijyjRg7gECfJr3TGASaA4bQsILFGG5dAWcwO4OMrZedR7SHj/o0Kf\n3gL7P0axAgMBAAGjezB5MAkGA1UdEwQCMAAwCwYDVR0PBAQDAgSwMB0GA1UdDgQW\nBBQF8qLA7Z4zg0SJGtUbv3eoQ8tjIzAfBgNVHREEGDAWgRRuZXRzc2hAc29sdXRp\nb3VzLmNvbTAfBgNVHRIEGDAWgRRuZXRzc2hAc29sdXRpb3VzLmNvbTANBgkqhkiG\n9w0BAQsFAAOCAQEAVx/yCCX0ZPQ8TFeZe1T+OBEn3Co/AfjAmCdhstf1TF+Jziyx\ndFJ8m8mF4596gru87Mi8mvu+WbPsLlFMOf5LDUkAsgnlvJ+zqNL7jPjGmsh0KOHJ\n0dzPYnTeGcfyrp1AXNN3Z2jWlEInrnqvo376vOmejjTtmDVVlhPjITHQqLSXzRaQ\ne3M8fbJ+nupobti6jpXCYvH86KtpaxF66mwaynfdjzxQAVycV/ilKtL+sHH8zxlg\nvNiMFH5yLu/tlav4xh+HlYscWVdFQIvd7f/Uxa+Vip1Pi16wmhnrE15z/vDX921v\nhukBRIoCEAuUgNVBh+L/C8aETzbf/77WU3Si/w==\n-----END CERTIFICATE-----\n".freeze]
  s.date = "2026-10-25"
  s.description = "A pure Ruby implementation of the SCP client protocol".freeze
  s.email = ["net-ssh@solutious.com".freeze]
  s.extra_rdoc_files = ["LICENSE.txt".freeze, "README.md".freeze]
  s.files = ["LICENSE.txt".freeze, "README.md".freeze]
  s.homepage = "https://github.com/net-ssh/net-scp".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.3.3".freeze
  s.summary = "A pure Ruby implementation of the SCP client protocol.".freeze

  s.installed_by_version = "3.6.9".freeze

  s.specification_version = 3

  s.add_runtime_dependency(%q<net-ssh>.freeze, [">= 2.6.5".freeze, "< 9.0.0".freeze])
  s.add_development_dependency(%q<test-unit>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<mocha>.freeze, [">= 0".freeze])
end
