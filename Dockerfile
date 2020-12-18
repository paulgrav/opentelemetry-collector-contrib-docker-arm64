FROM alpine:latest as certs
RUN apk --update add ca-certificates 
ADD https://github.com/open-telemetry/opentelemetry-collector-contrib/releases/download/v0.17.0/otelcontribcol_linux_arm64 /
RUN chmod 755 /otelcontribcol_linux_arm64

FROM scratch
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=certs /otelcontribcol_linux_arm64 /otelcontribcol
EXPOSE 55680 55679
ENTRYPOINT ["/otelcontribcol"]
CMD ["--config", "/etc/otel/config.yaml"]
