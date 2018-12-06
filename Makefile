default: matchbox.apply

secret=packet-secret.json

module_project=packet_project.project

.PHONY: project.apply
project.apply: $(secret) init
	terraform \
		apply \
		-var-file=$< \
		-target=$(module_project)

.PHONY: project.destroy
project.destroy: $(secret)
	terraform \
		destroy \
		-var-file=$< \
		-target=$(module_project)

module_elastic_ip=module.matchbox.packet_reserved_ip_block.matchbox

.PHONY: elastic_ip.apply
elastic_ip.apply: $(secret)
	terraform \
		apply \
		-var-file=$< \
		-target=$(module_elastic_ip)

.PHONY: elastic_ip.destroy
elastic_ip.destroy: $(secret)
	terraform \
		destroy \
		-var-file=$< \
		-target=$(module_elastic_ip)

matchbox_certs_dir=.matchbox

.PHONY: certificates.apply
certificates.apply: elastic_ip.apply
certificates.apply: export SAN=DNS.1:matchbox.example.com,IP.1:$(shell terraform output -module matchbox access_public_ipv4)
certificates.apply:
	./scripts/cert-gen.sh

.PHONY: certificates.destroy
certificates.destroy:
	rm -rf $(matchbox_certs_dir)/*

matchbox=module.matchbox

.PHONY: matchbox.apply
matchbox.apply: $(secret) certificates.apply
	terraform \
		apply \
		-var-file=$< \
		-target=$(matchbox)

.PHONY: matchbox.destroy
matchbox.destroy: $(secret)
	terraform \
		destroy \
		-var-file=$< \
		-target=$(matchbox)

.PHONY: init
init:
	terraform init

.PHONY: format
format:
	terraform fmt
