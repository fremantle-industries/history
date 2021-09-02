FROM nginx:1.20.1-alpine
CMD sh -c 'envsubst \
  "\$HISTORY_HOST \$WORKBENCH_HOST \$GRAFANA_HOST \$PROMETHEUS_HOST \$HTTP_PORT" \
  < /etc/nginx/templates/nginx.conf \
  > /etc/nginx/nginx.conf \
  && nginx -g "daemon off;"'
