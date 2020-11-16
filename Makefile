
CREDENTIALS := credent.json
URL := https://www.eclipse.org/downloads/download.php?file=/hono/hono-cli-1.4.0-exec.jar&r=1
HONO := hono-cli-exec.jar

all:
	@echo $(CREDENTIALS)

.PHONY: $(TENANT_ID.CRED) $(TENANT_MANAGEMENT.CRED) $(MESSAGING.CRED) mgt-% msg-%
MESSAGING.CRED: msg-username msg-password msg-port msg-host
TENANT_MANAGEMENT.CRED: mgt-username mgt-password

TENANT_ID.CRED:
	$(eval tenant_id := $(shell jq -r '.tenant_id' $(CREDENTIALS)))

mgt-%:
	$(eval $* = $(shell jq -r '.tenant_management["$*"]' $(CREDENTIALS)))

msg-%:
	$(eval $* = $(shell jq -r '.messaging["$*"]' $(CREDENTIALS)))

# Print the value of of variable
.PHONY: print-%
print-%: MESSAGING.CRED
	@echo $* is $($*)

$(HONO):
	curl -L -o $@ "$(URL)"

connection: $(HONO) TENANT_ID.CRED MESSAGING.CRED
	@java -jar $(HONO) \
		--hono.client.host=$(host) \
		--hono.client.port=$(port) \
		--hono.client.tlsEnabled=true \
		--hono.client.username=$(username) \
		--hono.client.password=$(password) \
		--tenant.id=$(tenant_id) \
		--spring.profiles.active=receiver,telemetry

bosch-iot-hub-device-registry.yml:
	curl -sLO https://docs.bosch-iot-suite.com/hub/spec/bosch-iot-hub-device-registry.yml

.PHONY: clean
clean:
	-rm bosch-iot-hub-device-registry.yml &2>/dev/null
	-rm -f *.o

foo: *.json
	@echo Making $@ from $<

get_device_list: TENANT_ID.CRED TENANT_MANAGEMENT.CRED
	@curl -u $(username):$(password) https://manage.bosch-iot-hub.com/registration/$(tenant_id)

# .PHONY: credentials
# credentials:
# 	$(eval username := $(shell jq -r '.tenant_management["username"]' $(CREDENTIALS)))
# 	$(eval password := $(shell jq -r '.tenant_management["password"]' $(CREDENTIALS)))
# 	$(eval tenant_id := $(shell jq -r '.tenant_id' $(CREDENTIALS)))
