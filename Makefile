tmp_datapath ?= /tmp/backuppc_data
tmp_configpath ?= /tmp/backuppc_config
containername ?= backuppctest
hostport ?= 8080

default:
	@echo Do not know what you wanted. Pass one of the following targets :
	@echo "   " \(kill\|start\|clean\|build\|logs\|run\|launch\|preserve\|shell\|enter\) 
	@echo 
	@echo You can also override the controlling variables  
	@echo Defaults: tmp_datapath=$(tmp_datapath) 
	@echo "         " tmp_configpath=$(tmp_configpath) 
	@echo "         " containername=$(containername) 
	@echo "         " hostport=$(hostport)
	@exit 0

kill:
	- sudo docker kill $(containername)
start: 
	- sudo docker start $(containername)

clean: kill
	- sudo docker rm $(containername)
	- sudo rm -rf $(tmp_configpath) $(tmp_datapath)

build: clean
	sudo docker build -t backuppc:latest .
	mkdir $(tmp_configpath) $(tmp_datapath)

logs:
	sudo docker logs $(containername)

launch: launch
	sudo docker run -d -v $(tmp_datapath):/var/lib/backuppc:z -v $(tmp_configpath):/etc/backuppc:z  -p $(hostport):80 --name $(containername) backuppc:latest

run: build launch

preserve: 
	sudo tar -zcvf ~/backuppc-$(containername).`date +%Y%m%d-%H%M%S`.tar.gz $(tmp_datapath) $(tmp_configpath)

shell: 
	sudo docker exec -it $(containername) bash

enter: start logs
	sudo docker exec -it $(containername) bash
