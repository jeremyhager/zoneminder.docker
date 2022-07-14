# syntax=docker/dockerfile:1

FROM ubuntu:22.04

RUN mkdir -p /app/
ADD bootstrap.sh /app/bootstrap.sh
RUN /app/bootstrap.sh