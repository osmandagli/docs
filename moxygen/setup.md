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

Before running the command below, make sure that you have more than 50GB of space.
Build the moxygen.
Scratch path is important because if not set, moxygen will be built under /tmp, which will be deleted after a reboot.
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

### Testing with relay

Measuring the cpu-clock of the relay server and the streamer

- Relay
```
perf record -e cpu-clock -g -o ./data/perf_relay_proc.data \
  ~/moxygen_build/bin/moqrelayserver \
  --cert ~/moxygen/certs/certificate.pem \
  --key ~/moxygen/certs/certificate.key \
  --endpoint "/moq" \
  --port 4433 \
  --logging INFO
```

- Publisher (terminal 1)
```
perf record -e cpu-clock -g -o perf_streamer_proc.data \
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

- Publisher (terminal 2)
```
ffmpeg -re \
  -i ~/Movies/asian-commercial.flv \
  -c:v libx264 -b:v 180k -g 60 -keyint_min 60 \
  -profile:v baseline -preset veryfast \
  -c:a aac -b:a 96k \
  -f flv ~/Movies/fifo.flv
```


## Cloudlab settings

1. Pin the relay to a CPU 1, not 0
2. Set the flow director of NIC to send traffic to CPU 1 (ethtool)
3. MAX performance in CPU scaling (CPU Governor) and disable c states
4. Disable hyperthreading. 

median latency
throughput
jitter
drops

100gb NICs intel
intel cpu
stay at the same specs










