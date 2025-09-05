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
docker run -d --name gpt-cli -it \
  --volume gpt-cache:/tmp/shell_gpt \
  --env OPENAI_API_KEY \
  gpt-cli tail -f /dev/null
```


# sugestão de uso

config diff main \
| gpt "gere uma mensagem de commit para as alterações recebidas" \
#| sed '1,3d' \
| tee /dev/tty \
#| config commit -F -
