FROM dhxgc/kc:23.0.3-c as builder

# Настройки по умолчанию (можно переопределить в композе)
ENV KC_HEALTH_ENABLED=true \
    KC_METRICS_ENABLED=true \
#    KC_DB=postgres \
    KC_HOSTNAME=kc.atom25.local \
    KC_HTTPS_PORT=8443
#    KC_DB_URL=jdbc:postgresql://cloud-infra.atom25.local:5432/kc_db \
#    KC_DB_USERNAME=kc_user \
#    KC_DB_PASSWORD=P@ssw0rdSkills

#ENV KC_HTTPS_CERTIFICATE_FILE=/opt/keycloak/conf/server.crt \
#    KC_HTTPS_CERTIFICATE_KEY_FILE=/opt/keycloak/conf/server.key

# Сборка Keycloak с "заглушкой" для сертификатов
RUN /opt/keycloak/bin/kc.sh build

# Финальный образ
FROM dhxgc/kc:23.0.3-c
COPY --from=builder /opt/keycloak/ /opt/keycloak/

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
