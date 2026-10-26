# -*- encoding: utf-8 -*-
# stub: net-sftp 4.0.2 ruby lib

Gem::Specification.new do |s|
  s.name = "net-sftp".freeze
  s.version = "4.0.2".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jamis Buck".freeze, "Delano Mandelbaum".freeze, "Mikl\u00F3s Fazekas".freeze]
  s.bindir = "exe".freeze
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDeDCCAmCgAwIBAgIBATANBgkqhkiG9w0BAQsFADBBMQ8wDQYDVQQDDAZuZXRz\nc2gxGTAXBgoJkiaJk/IsZAEZFglzb2x1dGlvdXMxEzARBgoJkiaJk/IsZAEZFgNj\nb20wHhcNMjYxMDIyMDk1NDI1WhcNMjcxMDIyMDk1NDI1WjBBMQ8wDQYDVQQDDAZu\nZXRzc2gxGTAXBgoJkiaJk/IsZAEZFglzb2x1dGlvdXMxEzARBgoJkiaJk/IsZAEZ\nFgNjb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDGJ4TbZ9H+qZ08\npQfJhPJTHaDCyQvCsKTFrL5O9z3tllQ7B/zksMMM+qFBpNYu9HCcg4yBATacE/PB\nqVVyUrpr6lbH/XwoN5ljXm+bdCfmnjZvTCL2FTE6o+bcnaF0IsJyC0Q2B1fbWdXN\n6Off1ZWoUk6We2BIM1bn6QJLxBpGyYhvOPXsYoqSuzDf2SJDDsWFZ8kV5ON13Ohm\nJbBzn0oD8HF8FuYOewwsC0C1q4w7E5GtvHcQ5juweS7+RKsyDcVcVrLuNzoGRttS\nKP4yMn+TzaXijyjRg7gECfJr3TGASaA4bQsILFGG5dAWcwO4OMrZedR7SHj/o0Kf\n3gL7P0axAgMBAAGjezB5MAkGA1UdEwQCMAAwCwYDVR0PBAQDAgSwMB0GA1UdDgQW\nBBQF8qLA7Z4zg0SJGtUbv3eoQ8tjIzAfBgNVHREEGDAWgRRuZXRzc2hAc29sdXRp\nb3VzLmNvbTAfBgNVHRIEGDAWgRRuZXRzc2hAc29sdXRpb3VzLmNvbTANBgkqhkiG\n9w0BAQsFAAOCAQEAbVrRpiCFmHDMLNU+SCjpg43snWYksQOtejPPTEMdOc9cCmmv\nctJbaPIySLUgzwFbQDZStDPbLJmIujh0fm5dHp/sDJpvPZ3Mm3FfzWQMJqzBx4uk\nOMx00yJK8VeFrwUViE3zO5raWvw85dUybp25pgaKGW4AA5mJ/2UHqYLc4lefKFKK\n9xFsyYSciMEKyAsUNSNTJzPKUo2vn7TNF/pS0ZL+h8Qkr0A0F0ncfj7uM1kOWjO0\nmMdUtmMoVbjbik3hqkY/18G03c3PoFNpL38VLKuyyROYz1DaCqOaRju3sbOoirD+\npiQTZDCWxeKuX0Iuxq02uxkYHfoGB6In0y3OOQ==\n-----END CERTIFICATE-----\n".freeze]
  s.date = "2026-10-25"
  s.description = "A pure Ruby implementation of the SFTP client protocol".freeze
  s.email = ["net-ssh@solutious.com".freeze]
  s.extra_rdoc_files = ["LICENSE.txt".freeze, "README.rdoc".freeze]
  s.files = ["LICENSE.txt".freeze, "README.rdoc".freeze]
  s.homepage = "https://github.com/net-ssh/net-sftp".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.3.3".freeze
  s.summary = "A pure Ruby implementation of the SFTP client protocol.".freeze

  s.installed_by_version = "3.6.9".freeze

  s.specification_version = 3

  s.add_runtime_dependency(%q<net-ssh>.freeze, [">= 5.0.0".freeze, "< 9.0.0".freeze])
  s.add_development_dependency(%q<minitest>.freeze, [">= 5".freeze])
  s.add_development_dependency(%q<mocha>.freeze, [">= 0".freeze])
end
