https://github.com/TheR1D/shell_gpt

# faça o build
no mesmo diretório do Dockerfile, rode:

```
docker build -t gpt-cli .
```


# rode
exporte sua chave (uma vez por terminal):

```
export OPENAI_API_KEY="sua-chave-aqui"
```

e use o comando:

```
docker run --rm \
  --volume gpt-cache:/tmp/shell_gpt \
  --env OPENAI_API_KEY \
  gpt-cli "who is bill gates"
```

ou deixando ele como daemon

```
docker run -d --name gpt-cli-daemon \
  --volume gpt-cache:/tmp/shell_gpt \
  --env OPENAI_API_KEY \
  gpt-cli tail -f /dev/null
```

