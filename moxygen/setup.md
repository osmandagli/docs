# Moxygen

## Build

Clone the repo
```bash
git clone https://github.com/facebookexperimental/moxygen.git
cd moxygen
```

Download dependencies
```bash
./build/fbcode_builder/getdeps.py install-system-deps --recursive moxygen
sudo apt install g++ python3-dev -y
```

Set environment variables
```bash
eval $(./build/fbcode_builder/getdeps.py env --src-dir moxygen:. moxygen)
```

Before running the command below make sure that you have more than 50GB of space.
Build the moxygen.
scratch path is important because if not set, moxygen will be build under /tmp which will be deleted after a reboot.
```bash
./build/fbcode_builder/getdeps.py build moxygen --clean --scratch-path ~/moxygen_build --build-dir ~/moxygen_build/build --install-dir ~/moxygen_build
```

## Rebuild

To rebuild fully
```bash
./build/fbcode_builder/getdeps.py build moxygen --src-dir=.
```

Rebuild without dependencies
```bash
./build/fbcode_builder/getdeps.py build moxygen --src-dir=. --no-deps
```

## Get libraries

```bash
export LD_LIBRARY_PATH=$(find ~/moxygen_build/installed/ -name lib -type d |tr '\n' ':' | sed 's/:$//')
```

## Tests

### Test without relay

- Server (Terminal 1)

Create the server
```
mkfifo ~/Movies/fifo.flv 2>/dev/null
```

```
~/moxygen_build/bin/moqflvserver \
  --cert /WORKSPACE/moxygen/certs/certificate.pem \
  --key /WORKSPACE/moxygen/certs/certificate.key \
  --input_flv_file ~/Movies/fifo.flv \
  --port 9667 \
  --logging DBG1
```

- Receiver

Create the receiver
```
~/moxygen_build/bin/moqflvreceiverclient \
  --insecure \
  --connect_url "https://192.168.122.154:9667/moq-flv" \
  --track_namespace "flvstreamer" \
  --flv_outpath /home/moqt/Movies/received.flv \
  --logging DBG1
```

- Server (Terminal 2)

Feed the video
```
ffmpeg -re \
  -i /home/moqt/Movies/asian-commercial.flv  \
  -c:v libx264 -b:v 180k -g 60 -keyint_min 60 \
  -profile:v baseline -preset veryfast \
  -c:a aac -b:a 96k \
  -f flv ~/Movies/fifo.flv
```

### Test with relay in between

- Server (terminal 1)

```
~/moxygen_build/bin/moqrelayserver \
  --cert ~/moxygen/certs/certificate.pem \
  --key ~/moxygen/certs/certificate.key \
  --endpoint "/moq" \
  --port 4433 \
  --logging INFO
```

- Server (terminal 2)

```
mkfifo ~/Movies/fifo.flv 2>/dev/null

~/moxygen_build/bin/moqflvstreamerclient \
  --insecure \
  --connect_url "https://10.10.1.2:4433/moq" \
  --input_flv_file ~/Movies/fifo.flv \
  --logging INFO
```

- Receiver
```
~/moxygen_build/bin/moqflvreceiverclient \
  --insecure \
  --connect_url "https://10.10.2.2:4433/moq" \
  --track_namespace "flvstreamer" \
  --flv_outpath /home/moqt/Movies/received.flv \
  --logging INFO
```

- Server (terminal 3)
```
ffmpeg -re \
  -i ~/Movies/asian-commercial.flv \
  -c:v libx264 -b:v 180k -g 60 -keyint_min 60 \
  -profile:v baseline -preset veryfast \
  -c:a aac -b:a 96k \
  -f flv ~/Movies/fifo.flv
```

## Perf 

* P2P

Performance counter stats for

``` 
'./moqflvserver --input_flv_file /home/moqt/Movies/fifo.flv --insecure --port 9667':
```
            833.59 msec task-clock                #    0.013 CPUs utilized          
              4928      context-switches          #    5.912 K/sec                  
               273      cpu-migrations            #  327.499 /sec                   
               994      page-faults               #    1.192 K/sec                  
               994      minor-faults              #    1.192 K/sec                  

      62.078978073 seconds time elapsed

       0.570133000 seconds user
       0.320489000 seconds sys


### Perf commands

Measuring the P2P cpu-clock of P2P server

- Server (terminal 1)
```
perf record -e cpu-clock -g -o perf_p2p_proc.data \
  ~/moxygen_build/bin/moqflvserver \
  --cert /WORKSPACE/moxygen/certs/certificate.pem \
  --key /WORKSPACE/moxygen/certs/certificate.key \
  --input_flv_file ~/Movies/fifo.flv \
  --port 9667 \
  --logging DBG1
```

- Receiver
```
~/moxygen_build/bin/moqflvreceiverclient \
  --insecure \
  --connect_url "https://192.168.122.154:9667/moq-flv" \
  --track_namespace "flvstreamer" \
  --flv_outpath /home/moqt/Movies/received.flv \
  --logging DBG1
```

- Server (terminal 2)
```
ffmpeg -re \
  -i /home/moqt/Movies/asian-commercial.flv \
  -c:v libx264 -b:v 180k -g 60 -keyint_min 60 \
  -profile:v baseline -preset veryfast \
  -c:a aac -b:a 96k \
  -f flv ~/Movies/fifo.flv
```

-----

Measuring the cpu-clock of relay server and streamer

- Server (terminal 1)
```
perf record -e cpu-clock -g -o perf_relay_proc.data \
  ~/moxygen_build/bin/moqrelayserver \
  --cert /WORKSPACE/moxygen/certs/certificate.pem \
  --key /WORKSPACE/moxygen/certs/certificate.key \
  --endpoint "/moq" \
  --port 4433 \
  --logging DBG1
```

- Server (terminal 2)
```
perf record -e cpu-clock -g -o perf_streamer_proc.data \
  ~/moxygen_build/bin/moqflvstreamerclient \
  --insecure \
  --connect_url "https://localhost:4433/moq" \
  --input_flv_file ~/Movies/fifo.flv \
  --logging DBG1
```

- Receiver
```
~/moxygen_build/bin/moqflvreceiverclient \
  --insecure \
  --connect_url "https://192.168.122.154:4433/moq" \
  --track_namespace "flvstreamer" \
  --flv_outpath /home/moqt/Movies/received.flv \
  --logging DBG1
```

- Server (terminal 3)
```
ffmpeg -re \
  -i /home/moqt/Movies/asian-commercial.flv \
  -c:v libx264 -b:v 180k -g 60 -keyint_min 60 \
  -profile:v baseline -preset veryfast \
  -c:a aac -b:a 96k \
  -f flv ~/Movies/fifo.flv
```




1. pin the relay to a CPU 1 not 0
2. set flow director of NIC to send traffic to CPU 1 (ethtool)
3. MAX performance in CPU scaling (CPU Governor) and disable c states
4. Disable hyperthreading. 

median latency
throughput
jitter
drops

100gb NICs intel
intel cpu
stay at the same specs










