1. Build the image

```
docker build -t compilation .
```

2. Create a container

```
docker run -it -v $(pwd):/home/compilation --name docker_compilation compilation
```
 NOTE: this commmand will create a bind  between the current directory and the directory in /home/compilation, and the container name will be docker_compilation


3. Stop/restart the container

```
docker stop/start docker_compilation
```

4. Execute a command inside a container

```
docker exec -it docker_compilation <command>
```


