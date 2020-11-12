
CREDENTIALS := credent.json
# .DEFAULT_GOAL :=
URL := https://www.eclipse.org/downloads/download.php?file=/hono/hono-cli-1.4.0-exec.jar&r=1



ugh := Huh?
bar := $(ugh)
foo := $(bar)
# username := AZE

# Query the default goal.
ifeq ($(.DEFAULT_GOAL),)
  $(warning no default goal is set)
endif

$(username):
	echo "that"

all:
	echo $CREDENTIALS
	echo $(username)
	@echo "oui"kkk


bosch-iot-hub-device-registry.yml:
	curl -sLO https://docs.bosch-iot-suite.com/hub/spec/bosch-iot-hub-device-registry.yml


.PHONY: clean
clean:
	-rm bosch-iot-hub-device-registry.yml &2>/dev/null
	-rm -f *.o

CREDS := (username.cred password.cred)

all_cred:	CREDS
	@echo hi $(username)

foo: CREDS
	@echo Making $@ from $<

*.cred:
	$(eval username := $(shell jq -r '.tenant_management["username"]' credent.json))

.PHONY: get_hono
get_hono:
	curl -L -o hono-cli-exec.jar "$(URL)"

.PHONY: credentials
credentials:
	$(eval username := $(shell jq -r '.tenant_management["username"]' credent.json))
	$(eval password := $(shell jq -r '.tenant_management["password"]' credent.json))
	$(eval tenant_id := $(shell jq -r '.tenant_id' credent.json))

get_device_list: credentials
	@curl -u $(username):$(password) https://manage.bosch-iot-hub.com/registration/$(tenant_id)

messaging: credentials
	$(eval username := $(shell jq -r '.messaging["username"]' credent.json))
	$(eval password := $(shell jq -r '.messaging["password"]' credent.json))


connection: messaging
	java -jar hono-cli-exec.jar \
		--hono.client.host=messaging.bosch-iot-hub.com \
		--hono.client.port=5671 \
		--hono.client.tlsEnabled=true \
		--hono.client.username=$(username) \
		--hono.client.password=$(password) \
		--tenant.id=$(tenant_id) \
		--spring.profiles.active=receiver,telemetry
