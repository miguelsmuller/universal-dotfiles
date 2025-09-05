FROM python:3.11-slim

ENV OPENAI_API_KEY=bad_key

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN pip install shell-gpt

VOLUME ["/tmp/shell_gpt"]

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["sgpt"]
