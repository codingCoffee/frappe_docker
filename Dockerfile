
# Frappe Bench
FROM alpine:edge
MAINTAINER developers@frappe.io

ENV LANG C.UTF-8

RUN apk add --update --no-cache build-base libffi-dev openssl-dev python-dev py-pip git su-exec nodejs yarn py-pip build-base python-dev py-pip jpeg-dev zlib-dev libxslt-dev libxml2-dev \
  && mkdir -p /home/frappe && adduser -h /home/frappe -D frappe

RUN git clone https://github.com/codingcoffee/bench.git /home/frappe/bench-repo -b docker \
  && pip install -e /home/frappe/bench-repo \
  && chown -R frappe:frappe /home/frappe/* \
  && ls
 
RUN cd /home/frappe \
  && su-exec frappe bench init frappe-bench --in-docker \
  && cd frappe-bench \
  && su-exec frappe bench get-app erpnext \
  && su-exec frappe bench new-site site.local \
  && su-exec frappe bench install-app erpnext

USER frappe
WORKDIR /home/frappe/frappe-bench/

CMD ["bench", "start"]
# todo install frappe using pip and check something is not instaaliing
