FROM golang:<go_version> as bd
RUN adduser --disabled-login appuser
WORKDIR /github.com/layer5io/meshery-<adapter>
ADD . .
RUN cd cmd; go build -ldflags="-w -s" -a -o /meshery-<adapter> .
RUN find . -name "*.go" -type f -delete; mv <adapter> /

FROM alpine
RUN apk --update add ca-certificates
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
COPY --from=bd /meshery-<adapter> /app/
COPY --from=bd /<adapter> /app/<adapter>
COPY --from=bd /etc/passwd /etc/passwd
USER appuser
WORKDIR /app
CMD ./meshery-<adapter>
