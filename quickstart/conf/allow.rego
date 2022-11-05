package policy

import input
default allow := false

allow {
	input.certificate.URIs[_].Scheme == "spiffe"
}